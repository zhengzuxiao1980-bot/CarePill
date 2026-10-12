import 'dart:async';
import 'dart:convert';

import 'package:care_pill/ai/client/ai_models.dart';
import 'package:care_pill/core/exceptions.dart';
import 'package:care_pill/domain/models/dose_task.dart';
import 'package:care_pill/domain/models/enums.dart';
import 'package:care_pill/domain/services/conversation_context.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fakes/agent_fixture.dart';
import 'fakes/fakes.dart';

void main() {
  late AgentFixture f;
  setUp(() async {
    f = AgentFixture();
    await f.initialize();
  });
  test(
    'multi-turn order and restart: each user input appears exactly once',
    () async {
      final c = ScriptedClient([
        textResult('answer one'),
        textResult('answer two'),
        textResult('answer three'),
      ]);
      await f.agent(c).handleUserInput('question one');
      await f.agent(c).handleUserInput('question two');
      await f.agent(c).handleUserInput('question three');
      expect(
        c.requests.last.messages
            .where((m) => m.role != AiRole.system)
            .map((m) => m.text),
        [
          'question one',
          'answer one',
          'question two',
          'answer two',
          'question three',
        ],
      );
      expect(f.chats.messages.map((m) => m.sequence), [1, 2, 3, 4, 5, 6]);
    },
  );
  test('committed write survives network failure, retries reuse operation and user', () async {
    final id = await f.taskId();
    final c = ScriptedClient([
      toolCallResult('a', 'mark_dose_taken', {'task_id': id}),
      const NetworkException(kind: NetworkErrorKind.connection),
      textResult('done'),
    ]);
    final agent = f.agent(c);
    final events = <String>[];
    final result = await agent.handleUserInput(
      '帮我记上',
      onProgress: (p) async {
        if (p.write != null) events.add(p.write!.taskId);
      },
    );
    expect(result.error, isA<NetworkException>());
    expect(events, [id]);
    expect((await f.tasks.get(id))!.isTaken, isTrue);
    final recovered = await f
        .agent(c)
        .handleUserInput('ignored', turnId: result.turnId);
    expect(recovered.error, isNull);
    expect(recovered.writes, hasLength(1));
    expect(
      f.chats.messages.where((m) => m.role == ChatRole.user),
      hasLength(1),
    );
    final repeated = await agent.handleUserInput(
      'ignored',
      turnId: result.turnId,
    );
    expect(repeated.reply, 'done');
    expect(c.requests, hasLength(3));
  });
  test('duplicate native tool calls execute once; undo restores previous state and detects later changes', () async {
    final id = await f.taskId();
    final c = ScriptedClient([
      toolCallResult('a', 'mark_dose_taken', {'task_id': id}),
      toolCallResult('b', 'mark_dose_taken', {'task_id': id}),
      textResult('done'),
    ]);
    final agent = f.agent(c);
    final result = await agent.handleUserInput('帮我记上');
    expect(result.writes, hasLength(1));
    await agent.undoWrite(result.writes.single);
    expect((await f.tasks.get(id))!.isPending, isTrue);
    final next = await f
        .agent(
          ScriptedClient([
            toolCallResult('c', 'mark_dose_taken', {'task_id': id}),
            textResult('ok'),
          ]),
        )
        .handleUserInput('帮我记上');
    await f.tasks.update((await f.tasks.get(id))!.copyWith(note: 'later edit'));
    await expectLater(agent.undoWrite(next.writes.single), throwsStateError);
  });
  test('clear cancels late responses but preserves explicit memory and committed records', () async {
    await f.memory.save('喜欢简短回答');
    final pending = Completer<AiChatResult>(), started = Completer<void>();
    final c = ScriptedClient([pending.future]);
    final agent = f.agent(c);
    final future = agent.handleUserInput(
      'hello',
      onProgress: (_) async {
        if (!started.isCompleted) started.complete();
      },
    );
    await started.future;
    await agent.clearHistory();
    pending.complete(textResult('late'));
    await future;
    expect(f.chats.messages, isEmpty);
    expect(await f.memory.all(), hasLength(1));
    expect(await f.store.list('turn'), isEmpty);
  });
  test('same-name multi-dose selection is ambiguous until schedule date/time specified', () async {
    final ambiguous = await f.tools.execute('mark_dose_taken', {
      'medication_name': '测试药',
      'when': '2026-10-07 08:05',
    });
    expect(ambiguous.ok, isFalse);
    final exact = await f.tools.execute('mark_dose_taken', {
      'medication_name': '测试药',
      'scheduled_date': '2026-10-07',
      'scheduled_time': '08:00',
      'when': '2026-10-07 08:05',
    });
    expect(exact.ok, isTrue);
    final rows = await f.tasks.tasksForDate('2026-10-07');
    expect(rows.where((t) => t.isTaken).single.scheduledTime, '08:00');
    expect(
      rows.where((t) => t.scheduledTime == '20:00').single.isPending,
      isTrue,
    );
  });
  test('invalid tool types are recoverable and do not write', () async {
    final c = ScriptedClient([
      toolCallResult('bad', 'mark_dose_taken', {'task_id': 42}),
      textResult('please clarify'),
    ]);
    final result = await f.agent(c).handleUserInput('记一下');
    expect(result.error, isNull);
    expect(result.writes, isEmpty);
    final response = c.requests.last.messages.last;
    expect((jsonDecode(response.text) as Map<String, dynamic>)['ok'], isFalse);
  });
  test(
    'native and JSON draft results both retain review links after restart',
    () async {
      for (final native in [true, false]) {
        final local = AgentFixture();
        await local.initialize(native: native);
        final args = {
          'draft': {'name': '示例新药'},
        };
        final c = ScriptedClient([
          native
              ? toolCallResult('d', 'create_medication_draft', args)
              : textResult(
                  jsonEncode({'tool': 'create_medication_draft', 'args': args}),
                ),
          textResult('review'),
        ]);
        final result = await local.agent(c).handleUserInput('帮我记录这个新药');
        expect(result.draftIds, ['draft-0']);
        expect(
          (await local.agent(c).writesFor(result.turnId!)).single.taskId,
          'draft-0',
        );
      }
    },
  );
  test('ordinary statements cannot create memory; explicit requests can, forget suppresses source', () async {
    final denied = await f.tools.execute(
      'save_memory',
      {'content': '喜欢短句'},
      userText: '我喜欢短句',
      sourceMessageId: 'u:source',
    );
    expect(denied.ok, isFalse);
    expect(await f.memory.all(), isEmpty);
    final saved = await f.tools.execute(
      'save_memory',
      {'content': '喜欢短句'},
      userText: '请记住我喜欢短句',
      sourceMessageId: 'u:source',
    );
    expect(saved.ok, isTrue);
    final memory = (await f.memory.all()).single;
    await f.memory.delete(memory['id'] as String);
    expect(
      (await f.store.context())['suppressed'],
      containsAll(['u:source', 'a:source']),
    );
    expect((await f.store.context())['summary'], '');
  });
  test(
    'long conversations create durable summary and maintain bounded requests',
    () async {
      final c = ScriptedClient([])
        ..responder = (request) => textResult(
          request.messages.first.text.startsWith('将下面')
              ? '摘要：用户讨论旅行和家庭安排。'
              : '回答',
        );
      final agent = f.agent(c);
      for (var i = 0; i < 15; i++) {
        final r = await agent.handleUserInput('第 $i 轮继续讨论');
        expect(r.error, isNull);
      }
      expect((await f.store.context())['covered'] as int, greaterThan(0));
      expect((await f.store.context())['summary'], contains('摘要'));
      const context = ConversationContext();
      for (final request in c.requests) {
        expect(context.cost(request.messages, request.tools), lessThan(8192));
      }
    },
  );
  test('oversized current input is kept locally without calling model or silently truncating', () async {
    final c = ScriptedClient([]);
    final input = List.filled(10000, '内容').join();
    final result = await f.agent(c).handleUserInput(input);
    expect(
      result.error,
      isA<AiException>().having(
        (e) => e.code,
        'code',
        AiErrorCode.contextLength,
      ),
    );
    expect(f.chats.messages.single.content, input);
    expect(c.requests, isEmpty);
  });
  test('clear allows a new turn before an old response arrives', () async {
    final pending = Completer<AiChatResult>(), started = Completer<void>();
    var calls = 0;
    final client = ScriptedClient([])
      ..responder = (_) {
        if (calls++ == 0) {
          started.complete();
          return pending.future;
        }
        return textResult('new answer');
      };
    final agent = f.agent(client);
    final old = agent.handleUserInput('old input');
    await started.future;
    await agent.clearHistory();
    final next = await agent.handleUserInput('new input');
    expect(next.error, isNull);
    pending.complete(textResult('discarded'));
    await old;
    expect(f.chats.messages.map((m) => m.content), ['new input', 'new answer']);
  });
  test(
    'memory edit discards in-flight model tool requests based on old memory',
    () async {
      final memory = await f.memory.save('喜欢短句');
      final pending = Completer<AiChatResult>(), started = Completer<void>();
      var calls = 0;
      final client = ScriptedClient([])
        ..responder = (_) {
          if (calls++ == 0) {
            started.complete();
            return pending.future;
          }
          return textResult('new preference');
        };
      final future = f.agent(client).handleUserInput('我的偏好');
      await started.future;
      await f.memory.save('喜欢详细说明', id: memory['id'] as String);
      pending.complete(
        toolCallResult('stale', 'mark_dose_taken', {
          'task_id': await f.taskId(),
        }),
      );
      final result = await future;
      expect(result.writes, isEmpty);
      expect(result.reply, 'new preference');
      expect(
        client.requests.last.messages.map((m) => m.text).join(),
        contains('喜欢详细说明'),
      );
    },
  );
  test(
    'context rejection retries once without replaying a committed write',
    () async {
      final id = await f.taskId();
      final client = ScriptedClient([
        toolCallResult('a', 'mark_dose_taken', {'task_id': id}),
        const AiException(AiErrorCode.contextLength),
        textResult('done'),
      ]);
      final result = await f.agent(client).handleUserInput('记上这次');
      expect(result.error, isNull);
      expect(result.writes, hasLength(1));
      expect(await f.store.list('operation'), hasLength(1));
      expect(client.requests, hasLength(3));
    },
  );
  test(
    'crash before protocol checkpoint still exposes committed receipt on retry',
    () async {
      final id = await f.taskId();
      final client = ScriptedClient([
        toolCallResult('a', 'mark_dose_taken', {'task_id': id}),
        const NetworkException(kind: NetworkErrorKind.connection),
        textResult('recovered'),
      ]);
      final result = await f.agent(client).handleUserInput('记上');
      final turn = (await f.store.get('turn:${result.turnId}'))!;
      turn['messages'] = [(turn['messages'] as List).first];
      await f.store.put('turn:${result.turnId}', 'turn', turn);
      await f.agent(client).handleUserInput('ignored', turnId: result.turnId);
      expect(
        client.requests.last.messages.map((m) => m.text).join(),
        contains(id),
      );
      expect(await f.store.list('operation'), hasLength(1));
    },
  );
  test(
    'ambiguous memory deletion cannot use an arbitrary model-selected ID',
    () async {
      final first = await f.memory.save('喜欢短句');
      await f.memory.save('喜欢中文');
      final result = await f.tools.execute(
        'forget_memory',
        {'id': first['id']},
        userText: '请忘记我的偏好',
        sourceMessageId: 'u:test',
      );
      expect(result.ok, isFalse);
      expect(await f.memory.all(), hasLength(2));
    },
  );
  test('summary failure leaves cursor intact and is retried later', () async {
    var attempts = 0;
    final client = ScriptedClient([])
      ..responder = (r) {
        if (r.messages.first.text.startsWith('将下面')) {
          attempts++;
          throw const NetworkException(kind: NetworkErrorKind.timeout);
        }
        return textResult('answer');
      };
    for (var i = 0; i < 12; i++) {
      expect(
        (await f.agent(client).handleUserInput('question $i')).error,
        isNull,
      );
    }
    expect(attempts, greaterThan(1));
    expect((await f.store.context())['covered'], 0);
  });
  test(
    'large tool payload compaction preserves JSON, IDs and current input',
    () {
      const context = ConversationContext();
      const input = AiProtocolMessage(
        role: AiRole.user,
        content: 'current input',
      );
      final current = [
        input,
        const AiProtocolMessage(
          role: AiRole.assistant,
          toolCalls: [
            AiToolCall(id: 'call', name: 'query', argumentsJson: '{}'),
          ],
        ),
        AiProtocolMessage(
          role: AiRole.tool,
          toolCallId: 'call',
          name: 'query',
          content: jsonEncode({
            'ok': true,
            'items': List.filled(200, 'long result'),
          }),
        ),
      ];
      final built = context.build(
        prefix: [],
        history: [],
        current: current,
        tools: [],
        config: const AiClientConfig(
          baseUrl: '',
          apiKey: '',
          modelId: '',
          contextWindowTokens: 2048,
        ),
      );
      expect(built.messages.first.text, 'current input');
      expect(built.messages.last.toolCallId, 'call');
      final compact =
          jsonDecode(built.messages.last.text) as Map<String, dynamic>;
      expect(compact['truncated'], isTrue);
      expect(compact['items_total'], 200);
      expect(context.cost(built.messages, []), lessThanOrEqualTo(512));
      expect(
        (jsonDecode(current.last.text) as Map<String, dynamic>)['items'],
        hasLength(200),
      );
    },
  );
  test(
    'clearing during summary generation rejects the late summary and answer',
    () async {
      final pending = Completer<AiChatResult>(), started = Completer<void>();
      final client = ScriptedClient([])
        ..responder = (request) {
          if (request.messages.first.text.startsWith('将下面')) {
            started.complete();
            return pending.future;
          }
          return textResult('answer');
        };
      final agent = f.agent(client);
      for (var i = 0; i < 9; i++) {
        await agent.handleUserInput('question $i');
      }
      final turn = agent.handleUserInput('trigger summary');
      await started.future;
      await agent.clearHistory();
      pending.complete(textResult('obsolete summary'));
      await turn;
      expect(f.chats.messages, isEmpty);
      expect((await f.store.context())['summary'], '');
      expect((await f.store.context())['covered'], 0);
    },
  );
  test(
    'summary timeout keeps cursor and allows the conversation to finish',
    () async {
      final pending = Completer<AiChatResult>();
      final client = ScriptedClient([])
        ..responder = (request) => request.messages.first.text.startsWith('将下面')
            ? pending.future
            : textResult('answer');
      final agent = f.agent(client);
      for (var i = 0; i < 9; i++) {
        await agent.handleUserInput('question $i');
      }
      final result = await agent.handleUserInput('trigger summary');
      expect(result.error, isNull);
      expect((await f.store.context())['covered'], 0);
      pending.complete(textResult('too late'));
      await Future<void>.delayed(Duration.zero);
      expect((await f.store.context())['summary'], '');
    },
  );
}
