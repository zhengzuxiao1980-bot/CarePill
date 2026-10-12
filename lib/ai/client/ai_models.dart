/// OpenAI 兼容协议的数据结构（docs/04：AIClient 与业务零耦合，只认协议）。
///
/// 解析手写、容忍各家实现的差异（缺字段、content 为 null 等）；
/// 工具参数/草稿等嵌套业务结构仍走 freezed（docs/04 §1 JSON 模型选型）。
library;

import 'dart:convert';

import '../../core/cancellation.dart';

/// 请求消息角色。
enum AiRole { system, user, assistant, tool }

String aiRoleText(AiRole r) => switch (r) {
  AiRole.system => 'system',
  AiRole.user => 'user',
  AiRole.assistant => 'assistant',
  AiRole.tool => 'tool',
};

/// 多模态内容片段（视觉请求用）。
class AiContentPart {
  const AiContentPart.text(this.text) : type = 'text', imageUrl = null;

  const AiContentPart.imageUrl(this.imageUrl) : type = 'image_url', text = null;

  final String type;
  final String? text;

  /// data URL（base64）。
  final String? imageUrl;

  Map<String, dynamic> toJson() => switch (type) {
    'text' => {'type': 'text', 'text': text},
    _ => {
      'type': 'image_url',
      'image_url': {'url': imageUrl},
    },
  };
}

/// 模型返回的工具调用。
class AiToolCall {
  const AiToolCall({
    required this.id,
    required this.name,
    required this.argumentsJson,
  });

  final String id;
  final String name;

  /// 原始 JSON 字符串（各家均为字符串）。
  final String argumentsJson;

  Map<String, dynamic> toRequestJson() => {
    'id': id,
    'type': 'function',
    'function': {'name': name, 'arguments': argumentsJson},
  };

  /// 解析参数；失败返回空 Map（由调用方决定降级）。
  Map<String, dynamic> parseArguments() {
    try {
      final decoded = jsonDecodeSafe(argumentsJson);
      return decoded;
    } catch (_) {
      return {};
    }
  }
}

/// JSON 解析容错：去掉 markdown 代码围栏后再解。
Map<String, dynamic> jsonDecodeSafe(String raw) {
  var text = raw.trim();
  final fence = RegExp(r'^```(?:json)?\s*([\s\S]*?)\s*```$').firstMatch(text);
  if (fence != null) {
    text = fence.group(1)!.trim();
  }
  final decoded = const JsonDecoder().convert(text);
  if (decoded is Map<String, dynamic>) {
    return decoded;
  }
  throw const FormatException('不是 JSON 对象');
}

/// 从任意文本中提取第一个平衡的 JSON 对象（降级协议输出常混有说明文字）。
Map<String, dynamic>? extractJsonObject(String text) {
  final start = text.indexOf('{');
  if (start < 0) {
    return null;
  }
  var depth = 0;
  var inString = false;
  var escape = false;
  for (var i = start; i < text.length; i++) {
    final ch = text[i];
    if (escape) {
      escape = false;
      continue;
    }
    switch (ch) {
      case '\\':
        if (inString) {
          escape = true;
        }
      case '"':
        inString = !inString;
      case '{':
        if (!inString) {
          depth++;
        }
      case '}':
        if (!inString) {
          depth--;
          if (depth == 0) {
            final candidate = text.substring(start, i + 1);
            try {
              final decoded = const JsonDecoder().convert(candidate);
              if (decoded is Map<String, dynamic>) {
                return decoded;
              }
            } catch (_) {
              return null;
            }
          }
        }
    }
  }
  return null;
}

/// 协议消息。
class AiProtocolMessage {
  const AiProtocolMessage({
    required this.role,
    this.content,
    this.contentParts = const [],
    this.toolCalls = const [],
    this.toolCallId,
    this.name,
  });

  final AiRole role;

  /// 文本内容；工具调用消息可能为 null。
  final String? content;

  final List<AiContentPart> contentParts;
  final List<AiToolCall> toolCalls;

  /// tool 角色消息回传时携带。
  final String? toolCallId;
  final String? name;

  /// 用户可读文本（content 为空时拼接文本片段）。
  String get text =>
      content ?? contentParts.map((p) => p.text ?? '').join('\n').trim();

  Map<String, dynamic> toRequestJson() {
    final json = <String, dynamic>{'role': aiRoleText(role)};
    if (contentParts.isNotEmpty) {
      json['content'] = [
        if (content != null) {'type': 'text', 'text': content},
        ...contentParts.map((p) => p.toJson()),
      ];
    } else {
      json['content'] = content;
    }
    if (toolCalls.isNotEmpty) {
      json['tool_calls'] = toolCalls.map((c) => c.toRequestJson()).toList();
    }
    if (toolCallId != null) {
      json['tool_call_id'] = toolCallId;
    }
    if (name != null) {
      json['name'] = name;
    }
    return json;
  }

  /// 容忍式解析服务端返回的 message。
  static AiProtocolMessage fromResponseJson(Map<String, dynamic> json) {
    final roleText = (json['role'] as String?) ?? 'assistant';
    final role = AiRole.values.firstWhere(
      (r) => aiRoleText(r) == roleText,
      orElse: () => AiRole.assistant,
    );
    final content = json['content'];
    String? contentText;
    if (content is String) {
      contentText = content;
    } else if (content is List) {
      // 部分实现返回 parts 数组。
      final buffer = StringBuffer();
      for (final part in content) {
        if (part is Map<String, dynamic> && part['text'] is String) {
          buffer.write(part['text'] as String);
        }
      }
      contentText = buffer.toString();
    }
    final calls = <AiToolCall>[];
    final rawCalls = json['tool_calls'];
    if (rawCalls is List) {
      for (final c in rawCalls) {
        if (c is! Map<String, dynamic>) {
          continue;
        }
        final fn = c['function'];
        if (fn is! Map<String, dynamic>) {
          continue;
        }
        calls.add(
          AiToolCall(
            id: (c['id'] as String?) ?? 'call_${calls.length}',
            name: (fn['name'] as String?) ?? '',
            argumentsJson: (fn['arguments'] as String?) ?? '{}',
          ),
        );
      }
    }
    return AiProtocolMessage(
      role: role,
      content: (contentText == null || contentText.isEmpty)
          ? null
          : contentText,
      toolCalls: calls,
      toolCallId: json['tool_call_id'] as String?,
      name: json['name'] as String?,
    );
  }
}

/// 工具 schema（JSON Schema，docs/03 §4）。
class AiToolSchema {
  const AiToolSchema({
    required this.name,
    required this.description,
    required this.parameters,
  });

  final String name;
  final String description;
  final Map<String, dynamic> parameters;

  Map<String, dynamic> toOpenAiTool() => {
    'type': 'function',
    'function': {
      'name': name,
      'description': description,
      'parameters': parameters,
    },
  };
}

/// 一次对话请求。
class AiChatRequest {
  const AiChatRequest({
    required this.model,
    required this.messages,
    this.tools = const [],
    this.temperature,
    this.maxTokens,
    this.responseFormatJsonObject = false,
    this.cancellation,
  });

  final String model;
  final List<AiProtocolMessage> messages;
  final List<AiToolSchema> tools;
  final double? temperature;
  final int? maxTokens;

  /// 要求服务端强制 JSON 输出（部分兼容服务支持；失败时调用方降级重试）。
  final bool responseFormatJsonObject;
  final CancellationSignal? cancellation;

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'model': model,
      'messages': messages.map((m) => m.toRequestJson()).toList(),
    };
    if (tools.isNotEmpty) {
      json['tools'] = tools.map((t) => t.toOpenAiTool()).toList();
      json['tool_choice'] = 'auto';
    }
    if (temperature != null) {
      json['temperature'] = temperature;
    }
    if (maxTokens != null) {
      json['max_tokens'] = maxTokens;
    }
    if (responseFormatJsonObject) {
      json['response_format'] = {'type': 'json_object'};
    }
    return json;
  }
}

/// 一次对话结果。
class AiChatResult {
  const AiChatResult({
    required this.message,
    this.finishReason,
    this.promptTokens,
    this.completionTokens,
  });

  final AiProtocolMessage message;
  final String? finishReason;
  final int? promptTokens;
  final int? completionTokens;
}

/// 调用配置（由调用方从模型配置 + 密钥组装后传入，docs/04 §2）。
class AiClientConfig {
  const AiClientConfig({
    required this.baseUrl,
    required this.apiKey,
    required this.modelId,
    this.temperature,
    this.maxTokens,
    this.supportsFunctionCalling = false,
    this.contextWindowTokens = 8192,
  });

  /// 如 `https://api.deepseek.com`；路径按服务商要求填写。
  final String baseUrl;
  final String apiKey;
  final String modelId;
  final double? temperature;
  final int? maxTokens;

  /// 模型配置勾选的"支持函数调用"能力（决定 Agent 降级链起点，docs/03 §5）。
  final bool supportsFunctionCalling;
  final int contextWindowTokens;

  String get chatEndpoint {
    final base = baseUrl.endsWith('/')
        ? baseUrl.substring(0, baseUrl.length - 1)
        : baseUrl;
    return '$base/chat/completions';
  }
}
