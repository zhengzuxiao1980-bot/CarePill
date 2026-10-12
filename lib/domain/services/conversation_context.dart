import 'dart:convert';

import '../../ai/client/ai_models.dart';
import '../../core/exceptions.dart';

abstract interface class TokenEstimator {
  int count(String text);
}

/// Conservative estimate: CJK/punctuation cost two tokens each, Latin words use
/// UTF-8 bytes / 3; overhead is also counted. Providers may still reject a request.
class ConservativeTokenEstimator implements TokenEstimator {
  const ConservativeTokenEstimator();
  @override
  int count(String text) {
    var result = 0;
    final runs = RegExp(r'[\x00-\x7f]+|[^\x00-\x7f]').allMatches(text);
    for (final run in runs) {
      final s = run.group(0)!;
      result += s.codeUnitAt(0) > 127 ? 2 : (utf8.encode(s).length / 3).ceil();
    }
    return result;
  }
}

class ContextAssembly {
  ContextAssembly(this.messages, this.dropped);
  final List<AiProtocolMessage> messages;
  final int dropped;
}

class ConversationContext {
  const ConversationContext({
    this.estimator = const ConservativeTokenEstimator(),
  });
  final TokenEstimator estimator;
  int cost(List<AiProtocolMessage> messages, List<AiToolSchema> tools) =>
      estimator.count(
        jsonEncode({
          'messages': messages.map((m) => m.toRequestJson()).toList(),
          'tools': tools.map((t) => t.toOpenAiTool()).toList(),
        }),
      ) +
      32 * messages.length;

  ContextAssembly build({
    required List<AiProtocolMessage> prefix,
    required List<List<AiProtocolMessage>> history,
    required List<AiProtocolMessage> current,
    required List<AiToolSchema> tools,
    required AiClientConfig config,
    bool reduced = false,
    int? outputTokens,
  }) {
    final budget =
        config.contextWindowTokens -
        (outputTokens ?? config.maxTokens ?? 512) -
        1024;
    final limit = reduced ? (budget * .7).floor() : budget;
    // Only compact tool payloads, never the user's input or call/result IDs.
    // The persistent protocol transcript remains complete.
    final active = List<AiProtocolMessage>.of(current);
    for (
      var i = 0;
      i < active.length && cost([...prefix, ...active], tools) > limit;
      i++
    ) {
      final m = active[i];
      final jsonResult =
          i > 0 && m.role == AiRole.user && m.text.startsWith('[工具结果] ');
      if (m.role != AiRole.tool && !jsonResult) continue;
      Object? decoded;
      try {
        decoded = jsonDecode(
          jsonResult ? m.text.substring('[工具结果] '.length) : m.text,
        );
      } catch (_) {}
      final receipt = <String, dynamic>{
        if (decoded is Map)
          for (final key in [
            'ok',
            'error',
            'marked',
            'skipped',
            'saved',
            'forgotten',
            'task_id',
            'draft_id',
            'id',
          ])
            if (decoded.containsKey(key)) key: decoded[key],
        'truncated': true,
        'original_tokens': estimator.count(m.text),
        'query': {
          'tool': m.name,
          'instruction': 'Query again with a smaller limit or inspect the local operation receipt.',
        },
        if (decoded is Map)
          for (final e in decoded.entries)
            if (e.value is List)
              '${e.key}_total':
                  decoded['${e.key}_total'] ?? (e.value as List).length,
      };
      active[i] = AiProtocolMessage(
        role: m.role,
        name: m.name,
        toolCallId: m.toolCallId,
        content: '${jsonResult ? '[工具结果] ' : ''}${jsonEncode(receipt)}',
      );
    }
    if (cost([...prefix, ...active], tools) > limit) {
      throw const AiException(AiErrorCode.contextLength);
    }
    var start = history.length;
    var selected = <AiProtocolMessage>[];
    while (start > 0) {
      final candidate = [...history[start - 1], ...selected];
      if (cost([...prefix, ...candidate, ...active], tools) > limit) break;
      selected = candidate;
      start--;
    }
    return ContextAssembly([...prefix, ...selected, ...active], start);
  }

  String bounded(String text, int tokens) {
    if (estimator.count(text) <= tokens) return text;
    var low = 0, high = text.length;
    while (low < high) {
      final mid = (low + high + 1) ~/ 2;
      if (estimator.count(text.substring(0, mid)) <= tokens) {
        low = mid;
      } else {
        high = mid - 1;
      }
    }
    return '${text.substring(0, low)}…';
  }
}
