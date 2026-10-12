import 'dart:async';
import 'dart:convert';

import 'package:uuid/uuid.dart';

import '../../ai/client/ai_client.dart';
import '../../ai/client/ai_models.dart';
import '../../ai/prompts/app_prompts.dart';
import '../../ai/tools/rule_intent.dart';
import '../../ai/tools/tool_registry.dart';
import '../../core/app_constants.dart';
import '../../core/app_logger.dart';
import '../../core/cancellation.dart';
import '../../core/exceptions.dart';
import '../../core/formatters.dart';
import '../../data/repositories/agent_store.dart';
import '../../data/repositories/chat_repository.dart';
import '../../i18n/strings.g.dart';
import '../models/chat_message.dart';
import '../models/enums.dart';
import '../models/view_models.dart';
import 'conversation_context.dart';
import 'dose_service.dart';
import 'memory_service.dart';
import 'model_selection.dart';

enum AgentToolMode { native, jsonProtocol }

class AgentProgress {
  const AgentProgress({required this.turnId, this.write});
  final String turnId;
  final AgentWriteEvent? write;
}

class AgentTurnResult {
  const AgentTurnResult({
    required this.reply,
    this.writes = const [],
    this.createdDraftId,
    this.usedFallbackIntent = false,
    this.error,
    this.turnId,
    this.draftIds = const [],
  });
  final String reply;
  final List<AgentWriteEvent> writes;
  final String? createdDraftId;
  final List<String> draftIds;
  final bool usedFallbackIntent;
  final Object? error;
  final String? turnId;
}

class AgentService {
  AgentService({
    required AiChatClient chatClient,
    required ModelSelectionService modelSelection,
    required ToolRegistry toolRegistry,
    required ChatRepository chatRepository,
    required DoseService doseService,
    AgentStore? store,
    DateTime Function()? clock,
    ConversationContext context = const ConversationContext(),
  }) : _client = chatClient,
       _selection = modelSelection,
       _tools = toolRegistry,
       _chat = chatRepository,
       _dose = doseService,
       _store = store ?? InMemoryAgentStore(),
       _now = clock ?? DateTime.now,
       _context = context;
  final AiChatClient _client;
  final ModelSelectionService _selection;
  final ToolRegistry _tools;
  final ChatRepository _chat;
  final DoseService _dose;
  final AgentStore _store;
  final DateTime Function() _now;
  final ConversationContext _context;
  CancellationSignal? _active;

  Future<void> _check(int generation, CancellationSignal signal) async {
    signal.check();
    if ((await _store.context())['generation'] != generation) {
      throw const OperationCancelled();
    }
  }

  Future<void> clearHistory() async {
    _active?.cancel();
    await _store.transaction(() async {
      await _store.resetContext();
      await _chat.clearAll();
      for (final t in await _store.list('turn')) {
        await _store.remove('turn:${t['id']}');
      }
    });
  }

  Future<List<AgentWriteEvent>> writesFor(String turnId) async {
    final revision = (await _store.context())['dataRevision'] ?? 0;
    final records = (await _store.list('operation')).where(
      (r) =>
          r['turnId'] == turnId &&
          r['undone'] != true &&
          (r['dataRevision'] ?? 0) == revision,
    );
    return records.map(_event).toList();
  }

  AgentWriteEvent _event(Map<String, dynamic> r) => AgentWriteEvent(
    kind: r['kind'] as String,
    taskId: r['target'] as String,
    summary: r['summary'] as String,
    operationId: r['id'] as String,
  );

  Future<void> undoWrite(AgentWriteEvent event) async {
    if (event.operationId == null) throw StateError('undo_conflict');
    await _store.transaction(() async {
      final r = await _store.get(event.operationId!);
      if (r == null || r['undone'] == true) return;
      if ((r['dataRevision'] ?? 0) !=
          ((await _store.context())['dataRevision'] ?? 0)) {
        throw StateError('undo_conflict');
      }
      await _tools.undo(
        r['tool'] as String,
        r['target'] as String,
        r['before'] as Map<String, dynamic>?,
        r['after'] as Map<String, dynamic>?,
      );
      r['undone'] = true;
      await _store.put(event.operationId!, 'operation', r);
    });
  }

  Future<AgentTurnResult> handleUserInput(
    String text, {
    String? turnId,
    CancellationSignal? cancellation,
    Future<void> Function(AgentProgress)? onProgress,
  }) async {
    if (_active != null && !_active!.isCancelled) {
      throw StateError('agent_busy');
    }
    if (text.trim().isEmpty) throw const ValidationException('text');
    final signal = cancellation ?? CancellationSignal();
    _active = signal;
    final id = turnId ?? const Uuid().v4();
    final writes = <AgentWriteEvent>[];
    var reply = '';
    var fallback = false;
    Map<String, dynamic>? turn;
    int? generation;
    Future<void> notify([AgentWriteEvent? write]) async {
      try {
        await onProgress?.call(AgentProgress(turnId: id, write: write));
      } catch (e) {
        AppLog.w('Agent progress delivery failed: ${e.runtimeType}');
      }
    }

    try {
      final config = await _selection.resolveChat();
      if (config == null) throw const AiException(AiErrorCode.notConfigured);
      signal.check();
      final meta = await _store.context();
      generation = meta['generation'] as int;
      turn = await _store.get('turn:$id');
      if (turn != null && turn['generation'] != generation) {
        throw const OperationCancelled();
      }
      if (turn == null) {
        await _store.transaction(() async {
          await _check(generation!, signal);
          await _chat.append(
            ChatMessage(
              id: 'u:$id',
              sessionId: await _chat.activeSessionId(),
              role: ChatRole.user,
              content: text.trim(),
              createdAt: _now(),
            ),
          );
          final all = await _chat.recent(limit: 100000);
          final message = all.firstWhere((m) => m.id == 'u:$id');
          turn = {
            'id': id,
            'generation': generation,
            'text': text.trim(),
            'sequence': message.sequence > 0 ? message.sequence : all.length,
            'status': 'running',
            'messages': [
              AiProtocolMessage(
                role: AiRole.user,
                content: text.trim(),
              ).toRequestJson(),
            ],
          };
          await _store.put('turn:$id', 'turn', turn!);
        });
      } else {
        text = turn['text'] as String;
      }
      writes.addAll(await writesFor(id));
      await notify();
      if (turn!['status'] == 'completed') {
        return _result(turn!['reply'] as String, writes, id);
      }
      var mode = config.supportsFunctionCalling
          ? AgentToolMode.native
          : AgentToolMode.jsonProtocol;
      final current = (turn!['messages'] as List)
          .map(
            (m) => AiProtocolMessage.fromResponseJson(
              Map<String, dynamic>.from(m as Map),
            ),
          )
          .toList();
      final groups = await _history(id);
      final initialMeta = await _store.context();
      final uncovered = groups
          .where((g) => g.sequence > (initialMeta['covered'] as int? ?? 0))
          .toList();
      final dropped = _context
          .build(
            prefix: await _prefix(mode, text, turnId: id),
            history: uncovered.map((g) => g.messages).toList(),
            current: current,
            tools: mode == AgentToolMode.native ? _toolSchemas() : [],
            config: config,
          )
          .dropped;
      final summarized = await _summarize(
        groups,
        config,
        generation,
        signal,
        minimumDropped: dropped,
      );
      var reduced = false, jsonFailures = 0, toolCount = 0;
      var modelCalls = summarized ? 1 : 0;
      while (modelCalls < kAgentMaxRounds) {
        await _check(generation, signal);
        final schemas = mode == AgentToolMode.native
            ? _toolSchemas()
            : <AiToolSchema>[];
        final beforeRequest = await _store.context();
        final history = (await _history(id))
            .where((g) => g.sequence > (beforeRequest['covered'] as int? ?? 0))
            .map((g) => g.messages)
            .toList();
        final prefix = await _prefix(mode, text, turnId: id);
        final built = _context.build(
          prefix: prefix,
          history: history,
          current: current,
          tools: schemas,
          config: config,
          reduced: reduced,
        );
        final AiChatResult result;
        try {
          modelCalls++;
          result = await _client.chat(
            AiChatRequest(
              model: config.modelId,
              messages: List.of(built.messages),
              tools: schemas,
              temperature: config.temperature,
              maxTokens: config.maxTokens ?? 512,
              cancellation: signal,
            ),
            config: config,
          );
        } on AiException catch (e) {
          if (e.code == AiErrorCode.capabilityMissing &&
              mode == AgentToolMode.native &&
              current.length == 1) {
            mode = AgentToolMode.jsonProtocol;
            continue;
          }
          if (e.code == AiErrorCode.contextLength && !reduced) {
            reduced = true;
            continue;
          }
          rethrow;
        }
        await _check(generation, signal);
        if ((await _store.context())['memoryRevision'] !=
            beforeRequest['memoryRevision']) {
          continue;
        }
        final m = result.message;
        if (m.toolCalls.isNotEmpty) {
          // Append every result even when the limit is reached, keeping protocol pairs valid.
          current.add(m);
          for (final call in m.toolCalls) {
            ToolOutcome outcome;
            Map<String, dynamic> args = {};
            try {
              args = jsonDecodeSafe(call.argumentsJson);
            } catch (_) {
              current.add(
                AiProtocolMessage(
                  role: AiRole.tool,
                  toolCallId: call.id,
                  name: call.name,
                  content: jsonEncode({
                    'ok': false,
                    'error': tr.agentV2.invalidArgs,
                  }),
                ),
              );
              continue;
            }
            if (toolCount++ >= 10) {
              outcome = ToolOutcome(
                ok: false,
                data: {'error': tr.agentService.tryLater},
              );
            } else {
              outcome = await _execute(
                call.name,
                args,
                id,
                generation,
                signal,
                text,
                writes,
                notify,
              );
            }
            current.add(
              AiProtocolMessage(
                role: AiRole.tool,
                toolCallId: call.id,
                name: call.name,
                content: jsonEncode({
                  'ok': outcome.ok,
                  ..._boundedData(outcome.data, args),
                }),
              ),
            );
          }
        } else {
          if (result.finishReason == 'length') {
            throw const AiException(AiErrorCode.contextLength);
          }
          final content = m.text.trim();
          final parsed = mode == AgentToolMode.jsonProtocol
              ? extractJsonObject(content)
              : null;
          if (parsed != null && parsed['tool'] is String) {
            final raw = parsed['args'];
            final outcome = raw != null && raw is! Map<String, dynamic>
                ? ToolOutcome(
                    ok: false,
                    data: {'error': tr.agentV2.invalidArgs},
                  )
                : toolCount++ >= 10
                ? ToolOutcome(
                    ok: false,
                    data: {'error': tr.agentService.tryLater},
                  )
                : await _execute(
                    parsed['tool'] as String,
                    raw as Map<String, dynamic>? ?? {},
                    id,
                    generation,
                    signal,
                    text,
                    writes,
                    notify,
                  );
            current.add(
              AiProtocolMessage(role: AiRole.assistant, content: content),
            );
            current.add(
              AiProtocolMessage(
                role: AiRole.user,
                content:
                    '[工具结果] ${jsonEncode({'ok': outcome.ok, ..._boundedData(outcome.data, raw is Map<String, dynamic> ? raw : {})})}',
              ),
            );
          } else if (mode == AgentToolMode.jsonProtocol &&
              (content.contains('{') || content.contains('"tool"'))) {
            jsonFailures++;
            if (jsonFailures >= 2) break;
            current.add(
              AiProtocolMessage(role: AiRole.assistant, content: content),
            );
            current.add(
              const AiProtocolMessage(
                role: AiRole.user,
                content: 'Invalid tool JSON. Use {"tool":"name","args":{}} or answer normally.',
              ),
            );
          } else {
            reply = content.isEmpty ? tr.agentService.tryLater : content;
            break;
          }
        }
        turn!['messages'] = current.map((m) => m.toRequestJson()).toList();
        await _saveTurn(turn!, generation, signal);
        if (toolCount >= 10) break;
      }
      if (reply.isEmpty &&
          writes.isEmpty &&
          toolCount == 0 &&
          modelCalls < kAgentMaxRounds) {
        final intent = RuleIntentMatcher.match(
          text,
          medicationNames: (await _dose.todayViews())
              .map((v) => v.medicationName)
              .toList(),
          clock: _now,
        );
        if (intent != null) {
          fallback = true;
          final outcome = await _execute(
            intent.tool,
            intent.args,
            id,
            generation,
            signal,
            text,
            writes,
            notify,
          );
          if (!outcome.ok) {
            reply =
                outcome.data['error']?.toString() ??
                tr.agentService.notUnderstood;
          } else {
            reply = cannedReplyForTool(intent.tool, outcome.data);
            if (modelCalls < kAgentMaxRounds) {
              try {
                modelCalls++;
                final polished = await _client.chat(
                  AiChatRequest(
                    model: config.modelId,
                    messages: _context
                        .build(
                          prefix: await _prefix(mode, text, turnId: id),
                          history: [],
                          current: [
                            AiProtocolMessage(
                              role: AiRole.user,
                              content: jsonEncode(
                                _boundedData(outcome.data, intent.args),
                              ),
                            ),
                          ],
                          tools: [],
                          config: config,
                          outputTokens: 150,
                        )
                        .messages,
                    maxTokens: 150,
                    cancellation: signal,
                  ),
                  config: config,
                );
                if (polished.message.text.trim().isNotEmpty) {
                  reply = polished.message.text.trim();
                }
              } catch (_) {
                signal.check();
              }
            }
          }
        }
      }
      if (reply.isEmpty) {
        reply = writes.isNotEmpty
            ? tr.agentV2.committed
            : tr.agentService.notUnderstood;
      }
      await _store.transaction(() async {
        await _check(generation!, signal);
        await _chat.append(
          ChatMessage(
            id: 'a:$id',
            sessionId: await _chat.activeSessionId(),
            role: ChatRole.assistant,
            content: reply,
            toolPayload: jsonEncode(
              writes
                  .map(
                    (w) => {
                      'kind': w.kind,
                      'taskId': w.taskId,
                      'summary': w.summary,
                      'operationId': w.operationId,
                    },
                  )
                  .toList(),
            ),
            createdAt: _now(),
          ),
        );
        turn!['messages'] = [
          ...current.map((m) => m.toRequestJson()),
          AiProtocolMessage(
            role: AiRole.assistant,
            content: reply,
          ).toRequestJson(),
        ];
        turn!['reply'] = reply;
        turn!['status'] = 'completed';
        await _store.put('turn:$id', 'turn', turn!);
        await _check(generation!, signal);
      });
      return _result(reply, writes, id, fallback: fallback);
    } on OperationCancelled {
      if (turn != null && generation != null) {
        await _store.transaction(() async {
          if ((await _store.context())['generation'] == generation) {
            turn!['status'] = 'cancelled';
            await _store.put('turn:$id', 'turn', turn!);
          }
        });
      }
      return _result(
        tr.agentV2.cancelled,
        writes,
        id,
        error: const OperationCancelled(),
      );
    } catch (e) {
      if (turn != null && generation != null) {
        turn!['status'] = 'failed';
        try {
          await _saveTurn(turn!, generation, signal);
        } on OperationCancelled {
          /* discarded generation */
        }
      }
      if (turn == null) rethrow;
      return _result(
        writes.isNotEmpty ? tr.agentV2.committed : '',
        writes,
        id,
        error: e,
      );
    } finally {
      if (identical(_active, signal)) _active = null;
    }
  }

  AgentTurnResult _result(
    String reply,
    List<AgentWriteEvent> writes,
    String id, {
    Object? error,
    bool fallback = false,
  }) {
    final drafts = writes
        .where((w) => w.kind == 'draft')
        .map((w) => w.taskId)
        .toList();
    return AgentTurnResult(
      reply: reply,
      writes: List.of(writes),
      turnId: id,
      error: error,
      usedFallbackIntent: fallback,
      draftIds: drafts,
      createdDraftId: drafts.firstOrNull,
    );
  }

  Future<void> _saveTurn(
    Map<String, dynamic> turn,
    int generation,
    CancellationSignal signal,
  ) => _store.transaction(() async {
    await _check(generation, signal);
    await _store.put('turn:${turn['id']}', 'turn', turn);
  });

  Future<ToolOutcome> _execute(
    String name,
    Map<String, dynamic> args,
    String turnId,
    int generation,
    CancellationSignal signal,
    String userText,
    List<AgentWriteEvent> writes,
    Future<void> Function([AgentWriteEvent?]) notify,
  ) async {
    await _check(generation, signal);
    if (!_tools.isWrite(name)) {
      return _tools
          .execute(name, args, userText: userText, sourceMessageId: 'u:$turnId')
          .timeout(
            kToolTimeout,
            onTimeout: () => ToolOutcome(
              ok: false,
              data: {'error': tr.agentService.tryLater},
            ),
          );
    }
    final outcome = await _store.transaction(() async {
      await _check(generation, signal);
      // Resolve only after checking the original request: after a successful dose
      // write, resolving the same drug name again could select a different task.
      final prior = (await _store.list('operation'))
          .where(
            (r) =>
                r['turnId'] == turnId &&
                r['tool'] == name &&
                r['arguments'] != null &&
                _canonical(r['arguments']) == _canonical(args),
          )
          .firstOrNull;
      if (prior != null) return _replayed(prior);
      final resolved = await _tools.resolveWriteArguments(name, args);
      final keyArgs =
          (name == 'mark_dose_taken' || name == 'skip_dose') &&
              resolved['task_id'] != null
          ? {'task_id': resolved['task_id']}
          : resolved;
      final key = 'op:$turnId:$name:${_canonical(keyArgs)}';
      final existing = await _store.get(key);
      if (existing != null) return _replayed(existing);
      final before = await _tools.snapshot(name, resolved);
      final result = await _tools.execute(
        name,
        resolved,
        userText: userText,
        sourceMessageId: 'u:$turnId',
      );
      await _check(generation, signal);
      if (result.ok && result.writeEvent != null) {
        final w = result.writeEvent!;
        final after = await _tools.snapshot(name, {
          ...resolved,
          if (w.kind == 'memory') 'id': w.taskId,
        });
        final record = <String, dynamic>{
          'id': key,
          'dataRevision': (await _store.context())['dataRevision'] ?? 0,
          'turnId': turnId,
          'tool': name,
          'arguments': args,
          'resolvedArguments': resolved,
          'target': w.taskId,
          'kind': w.kind,
          'summary': w.summary,
          'data': result.data,
          'before': before,
          'after': after,
          'undone': false,
        };
        await _store.put(key, 'operation', record);
        await _check(generation, signal);
        return ToolOutcome(
          ok: true,
          data: result.data,
          writeEvent: _event(record),
        );
      }
      return result;
    });
    final event = outcome.writeEvent;
    if (event != null &&
        !writes.any((w) => w.operationId == event.operationId)) {
      writes.add(event);
      await notify(event);
    }
    return outcome;
  }

  ToolOutcome _replayed(Map<String, dynamic> record) => record['undone'] == true
      ? ToolOutcome(
          ok: false,
          data: {'error': tr.agentV2.undoConflict, 'undone': true},
        )
      : ToolOutcome(
          ok: true,
          data: Map<String, dynamic>.from(record['data'] as Map),
          writeEvent: _event(record),
        );

  String _canonical(Object? value) {
    Object? sort(Object? v) => v is Map
        ? {
            for (final k in v.keys.map((e) => e.toString()).toList()..sort())
              k: sort(v[k]),
          }
        : v is List
        ? v.map(sort).toList()
        : v;
    return jsonEncode(sort(value));
  }

  Map<String, dynamic> _boundedData(
    Map<String, dynamic> data,
    Map<String, dynamic> args,
  ) {
    final offset = (args['offset'] is int ? args['offset'] as int : 0).clamp(
      0,
      100000,
    );
    final limit = (args['limit'] is int ? args['limit'] as int : 20).clamp(
      1,
      50,
    );
    Object? bound(Object? value, {bool top = false}) {
      if (value is List) return value.take(limit).map(bound).toList();
      if (value is Map) {
        final result = <String, dynamic>{};
        var truncated = false;
        for (final e in value.entries) {
          if (e.value is List) {
            final list = e.value as List;
            final from = top ? offset : 0;
            result[e.key.toString()] = list
                .skip(from)
                .take(limit)
                .map(bound)
                .toList();
            result['${e.key}_total'] = list.length;
            if (from > 0 || from + limit < list.length) truncated = true;
            if (from + limit < list.length) {
              result['next_offset'] = from + limit;
            }
          } else if (e.value is String &&
              _context.estimator.count(e.value as String) > 768) {
            result[e.key.toString()] = _context.bounded(e.value as String, 768);
            result['${e.key}_original_tokens'] = _context.estimator.count(
              e.value as String,
            );
            truncated = true;
          } else {
            result[e.key.toString()] = bound(e.value);
          }
        }
        if (truncated) {
          result['truncated'] = true;
          result['query'] = 'Repeat this read tool with offset/limit; complete data is available in the app.';
        }
        return result;
      }
      return value;
    }

    return bound(data, top: true) as Map<String, dynamic>;
  }

  List<AiToolSchema> _toolSchemas() => _tools.specs
      .map(
        (s) => AiToolSchema(
          name: s.name,
          description: s.description,
          parameters: {
            ...s.schema,
            'properties': {
              ...s.parameters,
              if (!s.write) ...{
                'offset': {'type': 'integer'},
                'limit': {'type': 'integer'},
              },
            },
          },
        ),
      )
      .toList();

  Future<List<AiProtocolMessage>> _prefix(
    AgentToolMode mode,
    String text, {
    String? turnId,
  }) async {
    final now = _now();
    final views = await _dose.todayViews();
    final summary = views.isEmpty
        ? tr.agentService.noSchedule
        : views
              .map(
                (v) =>
                    '${v.task.scheduledDate} ${friendlyTime(v.task.scheduledTime)} ${v.medicationName}（${v.task.status.label}）',
              )
              .join('；');
    final meta = await _store.context();
    final memories = await (_tools.memories ?? MemoryService(_store)).search(
      text,
    );
    final included = <Map<String, dynamic>>[];
    for (final m in memories) {
      final v = {
        'id': m['id'],
        'content': m['content'],
        'source': 'user_reported',
      };
      if (_context.estimator.count(jsonEncode([...included, v])) <= 1024) {
        included.add(v);
      }
    }
    final receipts = turnId == null
        ? <Map<String, dynamic>>[]
        : (await _store.list('operation'))
              .where((r) => r['turnId'] == turnId)
              .map(
                (r) => {
                  'tool': r['tool'],
                  'target': r['target'],
                  'undone': r['undone'],
                  'result': _boundedData(
                    Map<String, dynamic>.from(r['data'] as Map),
                    {},
                  ),
                },
              )
              .toList();
    return [
      AiProtocolMessage(
        role: AiRole.system,
        content: AppPrompts.buildSystemPrompt(
          nowText: now.toIso8601String(),
          todaySummary: _context.bounded(summary, 768),
          tools: _tools.specs,
          jsonProtocol: mode == AgentToolMode.jsonProtocol,
        ),
      ),
      AiProtocolMessage(
        role: AiRole.system,
        content:
            AppPrompts.contextData(
              jsonEncode(included),
              meta['summary'] as String? ?? '',
            ) +
            (receipts.isEmpty
                ? ''
                : '\n本轮已提交的操作收据（不要重复写入；undone 表示已经撤销）：${jsonEncode(receipts)}'),
      ),
    ];
  }

  Future<List<_HistoryGroup>> _history(String currentId) async {
    final meta = await _store.context();
    final cutoff = meta['cutoff'] as int? ?? 0;
    final suppressed = Set<String>.from(meta['suppressed'] as List? ?? []);
    final rows = await _chat.recent(limit: 100000);
    final turns = await _store.list('turn');
    final managed = turns.map((t) => 'u:${t['id']}').toSet();
    final groups = <_HistoryGroup>[];
    List<AiProtocolMessage>? legacy;
    var legacySequence = 0;
    for (var i = 0; i < rows.length; i++) {
      final m = rows[i], seq = m.sequence > 0 ? m.sequence : i + 1;
      if (seq <= cutoff || suppressed.contains(m.id)) {
        legacy = null;
        continue;
      }
      if (managed.contains(m.id) || m.id.startsWith('a:')) continue;
      if (m.role == ChatRole.user) {
        legacy = [AiProtocolMessage(role: AiRole.user, content: m.content)];
        legacySequence = seq;
      } else if (m.role == ChatRole.assistant && legacy != null) {
        groups.add(
          _HistoryGroup(legacySequence, [
            ...legacy,
            AiProtocolMessage(role: AiRole.assistant, content: m.content),
          ]),
        );
        legacy = null;
      }
    }
    for (final t in turns) {
      final seq = t['sequence'] as int;
      if (t['id'] == currentId ||
          t['status'] != 'completed' ||
          seq <= cutoff ||
          suppressed.contains('u:${t['id']}')) {
        continue;
      }
      groups.add(
        _HistoryGroup(
          seq,
          (t['messages'] as List)
              .map(
                (m) => AiProtocolMessage.fromResponseJson(
                  Map<String, dynamic>.from(m as Map),
                ),
              )
              .toList(),
        ),
      );
    }
    groups.sort((a, b) => a.sequence.compareTo(b.sequence));
    return groups;
  }

  Future<bool> _summarize(
    List<_HistoryGroup> groups,
    AiClientConfig config,
    int generation,
    CancellationSignal parent, {
    int minimumDropped = 0,
  }) async {
    final meta = await _store.context();
    final uncovered = groups
        .where((g) => g.sequence > (meta['covered'] as int? ?? 0))
        .toList();
    final count = (uncovered.length - 8).clamp(
      minimumDropped,
      uncovered.length,
    );
    if (count <= 0) return false;
    final candidates = uncovered.take(count).toList();
    final batch = <_HistoryGroup>[];
    for (final group in candidates) {
      final candidate = [...batch, group];
      final messages = [
        AiProtocolMessage(
          role: AiRole.user,
          content: AppPrompts.summaryPrompt(
            meta['summary'] as String? ?? '',
            jsonEncode(
              candidate
                  .map((g) => g.messages.map((m) => m.toRequestJson()).toList())
                  .toList(),
            ),
          ),
        ),
      ];
      if (_context.cost(messages, []) >
          config.contextWindowTokens - 768 - 1024) {
        break;
      }
      batch.add(group);
    }
    if (batch.isEmpty) return false;
    final signal = CancellationSignal();
    unawaited(parent.whenCancelled.then((_) => signal.cancel()));
    try {
      final result = await _client
          .chat(
            AiChatRequest(
              model: config.modelId,
              maxTokens: 768,
              cancellation: signal,
              messages: [
                AiProtocolMessage(
                  role: AiRole.user,
                  content: AppPrompts.summaryPrompt(
                    meta['summary'] as String? ?? '',
                    jsonEncode(
                      batch
                          .map(
                            (g) => g.messages
                                .map((m) => m.toRequestJson())
                                .toList(),
                          )
                          .toList(),
                    ),
                  ),
                ),
              ],
            ),
            config: config,
          )
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              signal.cancel();
              throw const AiException(AiErrorCode.protocol);
            },
          );
      await _check(generation, parent);
      if (result.message.text.trim().isEmpty ||
          result.message.toolCalls.isNotEmpty ||
          result.finishReason == 'length') {
        return true;
      }
      await _store.transaction(() async {
        final latest = await _store.context();
        await _check(generation, parent);
        if (latest['memoryRevision'] != meta['memoryRevision']) return;
        latest['summary'] = _context.bounded(result.message.text.trim(), 768);
        latest['covered'] = batch.last.sequence;
        await _store.put('context', 'context', latest);
      });
    } catch (e) {
      parent.check();
      AppLog.w('Conversation summary deferred: ${e.runtimeType}');
    }
    return true;
  }

  Future<String> weeklyReport({int days = 7}) async {
    final config = await _selection.resolveChat();
    if (config == null) throw const AiException(AiErrorCode.notConfigured);
    final stats = await _dose.adherence(days: days);
    final result = await _client.chat(
      AiChatRequest(
        model: config.modelId,
        messages: _context
            .build(
              prefix: [],
              history: [],
              tools: [],
              config: config,
              outputTokens: 300,
              current: [
                AiProtocolMessage(
                  role: AiRole.user,
                  content: AppPrompts.weeklyReportPrompt(
                    statsText: stats.toFriendlyText(),
                    nowText: _now().toIso8601String(),
                  ),
                ),
              ],
            )
            .messages,
        maxTokens: 300,
      ),
      config: config,
    );
    return result.message.text.trim();
  }
}

class _HistoryGroup {
  _HistoryGroup(this.sequence, this.messages);
  final int sequence;
  final List<AiProtocolMessage> messages;
}
