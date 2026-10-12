import 'package:drift/drift.dart';

import '../../domain/models/chat_message.dart';
import '../../domain/models/enums.dart';
import '../db/app_database.dart';

abstract class ChatRepository {
  /// v1 单会话；不存在则创建（docs/05：保留 session 便于"新对话"）。
  Future<String> activeSessionId();

  Future<void> append(ChatMessage message);

  /// 最近 [limit] 条，按稳定消息序号正序返回。
  Future<List<ChatMessage>> recent({int limit = 40});

  /// 一键清空（docs/03 §10：对话历史仅存本地，可清空）。
  Future<void> clearAll();
}

class DriftChatRepository implements ChatRepository {
  DriftChatRepository(this._db);

  final AppDatabase _db;
  static const String _sessionId = 'main';

  @override
  Future<String> activeSessionId() async {
    final row = await (_db.select(
      _db.chatSessions,
    )..where((s) => s.id.equals(_sessionId))).getSingleOrNull();
    if (row == null) {
      await _db
          .into(_db.chatSessions)
          .insertOnConflictUpdate(
            ChatSessionsCompanion.insert(
              id: _sessionId,
              createdAt: DateTime.now().millisecondsSinceEpoch,
            ),
          );
    }
    return _sessionId;
  }

  @override
  Future<void> append(ChatMessage message) => _db.transaction(() async {
    final existing = await (_db.select(
      _db.chatMessages,
    )..where((m) => m.id.equals(message.id))).getSingleOrNull();
    if (existing != null) return;
    final row = await _db
        .customSelect(
          'SELECT COALESCE(MAX(sequence), 0) + 1 AS next FROM chat_messages',
        )
        .getSingle();
    await _db
        .into(_db.chatMessages)
        .insert(
          ChatMessagesCompanion.insert(
            sequence: Value(row.read<int>('next')),
            id: message.id,
            sessionId: message.sessionId,
            role: message.role.json,
            content: message.content,
            toolName: Value(message.toolName),
            toolPayload: Value(message.toolPayload),
            createdAt: message.createdAt.millisecondsSinceEpoch,
          ),
        );
  });

  @override
  Future<List<ChatMessage>> recent({int limit = 40}) async {
    final sessionId = await activeSessionId();
    final rows =
        await (_db.select(_db.chatMessages)
              ..where((m) => m.sessionId.equals(sessionId))
              ..orderBy([(m) => OrderingTerm.desc(m.sequence)])
              ..limit(limit))
            .get();
    return rows.reversed.map(_rowToMessage).toList();
  }

  ChatMessage _rowToMessage(ChatMessageRow r) => ChatMessage(
    id: r.id,
    sessionId: r.sessionId,
    role: ChatRole.values.firstWhere(
      (e) => e.json == r.role,
      orElse: () => ChatRole.user,
    ),
    content: r.content,
    toolName: r.toolName,
    toolPayload: r.toolPayload,
    createdAt: DateTime.fromMillisecondsSinceEpoch(r.createdAt),
    sequence: r.sequence,
  );

  @override
  Future<void> clearAll() async {
    final sessionId = await activeSessionId();
    await (_db.delete(
      _db.chatMessages,
    )..where((m) => m.sessionId.equals(sessionId))).go();
    // 保留会话壳，消息清空即可。
  }
}
