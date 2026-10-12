import 'package:freezed_annotation/freezed_annotation.dart';

import 'enums.dart';

part 'chat_message.freezed.dart';

/// AI 对话消息（docs/05 §2 chat_messages 表）。
///
/// v1 单会话；tool 角色消息保留 tool_name/tool_payload 留痕，
/// 便于"AI 帮我打卡了什么"可回溯（docs/03 §4）。
@freezed
sealed class ChatMessage with _$ChatMessage {
  const factory ChatMessage({
    required String id,
    required String sessionId,
    required ChatRole role,
    required String content,
    String? toolName,
    String? toolPayload,
    required DateTime createdAt,
    @Default(0) int sequence,
  }) = _ChatMessage;
}
