import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/app_logger.dart';
import '../../core/cancellation.dart';
import '../../domain/models/chat_message.dart';
import '../../domain/models/view_models.dart';
import '../../i18n/strings.g.dart';
import '../providers.dart';
import 'memory_controller.dart';
import 'today_controller.dart';

class AssistantState {
  const AssistantState({
    required this.messages,
    this.busy = false,
    this.error,
    this.lastWrites = const [],
    this.lastDraftId,
    this.retryTurnId,
    this.reply = '',
    this.notice = '',
    this.hasEarlier = false,
  });
  final List<ChatMessage> messages;
  final bool busy;
  final Object? error;
  final List<AgentWriteEvent> lastWrites;
  final String? lastDraftId;
  final String? retryTurnId;
  final String reply;
  final String notice;
  final bool hasEarlier;
  AssistantState copyWithState({
    bool? busy,
    Object? error,
    List<AgentWriteEvent>? lastWrites,
    String? lastDraftId,
  }) => AssistantState(
    messages: messages,
    busy: busy ?? this.busy,
    error: error,
    lastWrites: lastWrites ?? this.lastWrites,
    lastDraftId: lastDraftId ?? this.lastDraftId,
    retryTurnId: retryTurnId,
    reply: reply,
    notice: notice,
    hasEarlier: hasEarlier,
  );
}

class AssistantController extends AsyncNotifier<AssistantState> {
  int _limit = 40, _epoch = 0;
  String? _activeTurn;
  @override
  Future<AssistantState> build() async => _read();
  Future<AssistantState> _read({
    bool busy = false,
    Object? error,
    String? retry,
    String reply = '',
    String notice = '',
  }) async {
    final history = await ref
        .read(chatRepositoryProvider)
        .recent(limit: _limit + 1);
    final writes = <AgentWriteEvent>[];
    final meta = await ref.read(agentStoreProvider).context();
    final turns = (await ref.read(agentStoreProvider).list('turn'))
        .where((t) => t['generation'] == meta['generation'])
        .toList();
    turns.sort(
      (a, b) => (b['sequence'] as int).compareTo(a['sequence'] as int),
    );
    final latest = turns.firstOrNull;
    if (!busy &&
        retry == null &&
        latest != null &&
        (latest['status'] == 'failed' ||
            latest['status'] == 'running' ||
            latest['status'] == 'cancelled')) {
      retry = latest['id'] as String;
    }
    for (final message in history.where((m) => m.id.startsWith('u:'))) {
      for (final event
          in await ref
              .read(agentServiceProvider)
              .writesFor(message.id.substring(2))) {
        if (!writes.any((w) => w.operationId == event.operationId)) {
          writes.add(event);
        }
      }
    }
    for (final m in history) {
      if (m.toolPayload == null) continue;
      try {
        final records = jsonDecode(m.toolPayload!);
        if (records is List) {
          for (final raw in records) {
            if (raw is! Map || raw['operationId'] is! String) continue;
            final r = await ref
                .read(agentStoreProvider)
                .get(raw['operationId'] as String);
            if (r != null &&
                (r['dataRevision'] ?? 0) == (meta['dataRevision'] ?? 0) &&
                r['undone'] != true &&
                !writes.any((w) => w.operationId == r['id'])) {
              writes.add(
                AgentWriteEvent(
                  kind: r['kind'] as String,
                  taskId: r['target'] as String,
                  summary: r['summary'] as String,
                  operationId: r['id'] as String,
                ),
              );
            }
          }
        }
      } catch (e) {
        AppLog.w('Unreadable legacy operation metadata: ${e.runtimeType}');
      }
    }
    if (_activeTurn != null) {
      for (final w
          in await ref.read(agentServiceProvider).writesFor(_activeTurn!)) {
        if (!writes.any((e) => e.operationId == w.operationId)) writes.add(w);
      }
    }
    return AssistantState(
      messages: history.length > _limit ? history.sublist(1) : history,
      busy: busy,
      error: error,
      lastWrites: writes,
      lastDraftId: writes.where((w) => w.kind == 'draft').firstOrNull?.taskId,
      retryTurnId: retry,
      reply: reply,
      notice: notice,
      hasEarlier: history.length > _limit,
    );
  }

  Future<void> loadEarlier() async {
    final epoch = _epoch;
    _limit += 40;
    final next = await _read();
    if (ref.mounted && epoch == _epoch) state = AsyncData(next);
  }

  Future<bool> send(String text, {String? turnId}) async {
    if (text.trim().isEmpty || state.value == null || state.value!.busy) {
      return false;
    }
    final epoch = _epoch;
    var syncNotice = '';
    state = AsyncData(state.value!.copyWithState(busy: true));
    try {
      final result = await ref
          .read(agentServiceProvider)
          .handleUserInput(
            text,
            turnId: turnId,
            onProgress: (event) async {
              if (event.write?.kind == 'memory') {
                ref.invalidate(memoryControllerProvider);
              }
              if (ref.mounted && epoch == _epoch) {
                _activeTurn = event.turnId;
                final next = await _read(busy: true, notice: syncNotice);
                if (ref.mounted && epoch == _epoch) state = AsyncData(next);
              }
              // A committed action must still synchronize even when chat was cleared.
              if (event.write != null &&
                  event.write!.kind != 'memory' &&
                  event.write!.kind != 'draft') {
                ref.invalidate(todayControllerProvider);
                try {
                  await ref.read(reminderSchedulerProvider).syncUpcoming();
                } catch (e) {
                  syncNotice = tr.agentV2.syncFailed;
                  AppLog.w(
                    'Committed dose reminder sync pending: ${e.runtimeType}',
                  );
                }
              }
              if (!ref.mounted || epoch != _epoch) return;
              _activeTurn = event.turnId;
              final next = await _read(busy: true, notice: syncNotice);
              if (ref.mounted && epoch == _epoch) state = AsyncData(next);
            },
          );
      if (!ref.mounted || epoch != _epoch) return false;
      final next = await _read(
        error: result.error is OperationCancelled ? null : result.error,
        retry: result.error != null && result.error is! OperationCancelled
            ? result.turnId
            : null,
        reply: result.reply,
        notice: syncNotice.isNotEmpty
            ? syncNotice
            : result.error != null && result.writes.isNotEmpty
            ? tr.agentV2.committed
            : '',
      );
      if (!ref.mounted || epoch != _epoch) return false;
      state = AsyncData(next);
      return result.error == null || result.writes.isNotEmpty;
    } catch (e, st) {
      AppLog.e('Assistant failed', e, st);
      if (ref.mounted && epoch == _epoch) {
        final next = await _read(error: e);
        if (ref.mounted && epoch == _epoch) state = AsyncData(next);
      }
      return false;
    }
  }

  Future<bool> retry() async {
    final id = state.value?.retryTurnId;
    if (id == null) return false;
    final record = await ref.read(agentStoreProvider).get('turn:$id');
    return record == null ? false : send(record['text'] as String, turnId: id);
  }

  Future<void> undoWrite(AgentWriteEvent event) async {
    final epoch = _epoch;
    try {
      await ref.read(agentServiceProvider).undoWrite(event);
    } catch (_) {
      if (ref.mounted) {
        final next = await _read(
          busy: state.value?.busy ?? false,
          notice: tr.agentV2.undoConflict,
        );
        if (ref.mounted && epoch == _epoch) state = AsyncData(next);
      }
      return;
    }
    var notice = '';
    if (event.kind == 'memory') ref.invalidate(memoryControllerProvider);
    if (event.kind != 'memory' && event.kind != 'draft') {
      ref.invalidate(todayControllerProvider);
      try {
        await ref.read(reminderSchedulerProvider).syncUpcoming();
      } catch (_) {
        notice = tr.agentV2.syncFailed;
      }
    }
    if (ref.mounted && epoch == _epoch) {
      final next = await _read(
        busy: state.value?.busy ?? false,
        notice: notice,
      );
      if (ref.mounted && epoch == _epoch) state = AsyncData(next);
    }
  }

  Future<void> clearHistory() async {
    final epoch = ++_epoch;
    await ref.read(agentServiceProvider).clearHistory();
    if (!ref.mounted || epoch != _epoch) return;
    _activeTurn = null;
    final next = await _read();
    if (ref.mounted && epoch == _epoch) state = AsyncData(next);
  }
}

final assistantControllerProvider =
    AsyncNotifierProvider<AssistantController, AssistantState>(
      AssistantController.new,
    );
