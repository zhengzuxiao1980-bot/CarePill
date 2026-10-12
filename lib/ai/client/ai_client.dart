import 'dart:async';

import 'package:dio/dio.dart';

import '../../core/app_constants.dart';
import '../../core/app_logger.dart';
import '../../core/cancellation.dart';
import '../../core/deepseek_defaults.dart';
import '../../core/exceptions.dart';
import 'ai_models.dart';

/// 对话客户端抽象（docs/04 §8 面向接口；未来非 OpenAI 协议新增实现即可）。
abstract interface class AiChatClient {
  Future<AiChatResult> chat(
    AiChatRequest request, {
    required AiClientConfig config,
  });
}

/// 视觉客户端抽象。
abstract interface class AiVisionClient {
  Future<AiChatResult> vision(
    AiChatRequest request, {
    required AiClientConfig config,
  });
}

/// OpenAI 兼容实现：直连用户配置的服务，不经任何中间服务器（docs/03 §1）。
class OpenAiCompatibleClient implements AiChatClient, AiVisionClient {
  OpenAiCompatibleClient({Dio? dio})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              connectTimeout: const Duration(seconds: 15),
              receiveTimeout: kAiRequestTimeout,
              responseType: ResponseType.json,
            ),
          );

  final Dio _dio;

  @override
  Future<AiChatResult> chat(
    AiChatRequest request, {
    required AiClientConfig config,
  }) => _send(request, config);

  @override
  Future<AiChatResult> vision(
    AiChatRequest request, {
    required AiClientConfig config,
  }) => _send(request, config);

  Future<AiChatResult> _send(
    AiChatRequest request,
    AiClientConfig config,
  ) async {
    request.cancellation?.check();
    final cancel = CancelToken();
    var finished = false;
    unawaited(
      request.cancellation?.whenCancelled.then((_) {
        if (!finished) cancel.cancel();
      }),
    );
    final body = request.toJson();
    body['model'] = config.modelId;
    if (DeepSeekDefaults.isOfficialEndpoint(config.baseUrl) &&
        DeepSeekDefaults.supportsThinkingToggle(config.modelId)) {
      // Current DeepSeek models enable thinking by default. CarePill uses
      // short replies and tool turns without replaying reasoning_content.
      body['thinking'] = {'type': 'disabled'};
    }
    if (request.temperature == null && config.temperature != null) {
      body['temperature'] = config.temperature;
    }
    if (request.maxTokens == null && config.maxTokens != null) {
      body['max_tokens'] = config.maxTokens;
    }

    AppLog.i(
      'AI 请求 → ${config.chatEndpoint} model=${config.modelId} '
      'messages=${request.messages.length} tools=${request.tools.length}',
    );
    // 不记录完整请求体：其中可能包含用药对话和图片 Base64。

    final Response<dynamic> response;
    try {
      response = await _dio.post<dynamic>(
        config.chatEndpoint,
        data: body,
        cancelToken: cancel,
        options: Options(
          headers: {
            'Authorization': 'Bearer ${config.apiKey}',
            'Content-Type': 'application/json',
          },
        ),
      );
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) throw const OperationCancelled();
      throw _mapDioError(e);
    } finally {
      finished = true;
    }

    final data = response.data;
    if (data is! Map<String, dynamic>) {
      throw AiException(
        AiErrorCode.protocol,
        cause: '响应不是 JSON 对象: ${response.data.runtimeType}',
      );
    }

    final choices = data['choices'];
    if (choices is! List || choices.isEmpty) {
      final errText = _serverErrorText(data);
      throw AiException(AiErrorCode.protocol, cause: errText);
    }
    final first = choices.first;
    if (first is! Map<String, dynamic>) {
      throw const AiException(AiErrorCode.protocol, cause: 'choices[0] 结构不符');
    }
    final messageJson = first['message'];
    if (messageJson is! Map<String, dynamic>) {
      throw const AiException(AiErrorCode.protocol, cause: '缺少 message');
    }
    final usage = data['usage'];
    final result = AiChatResult(
      message: AiProtocolMessage.fromResponseJson(messageJson),
      finishReason: first['finish_reason'] as String?,
      promptTokens: usage is Map<String, dynamic>
          ? (usage['prompt_tokens'] as num?)?.toInt()
          : null,
      completionTokens: usage is Map<String, dynamic>
          ? (usage['completion_tokens'] as num?)?.toInt()
          : null,
    );
    AppLog.i(
      'AI 响应 ← finish=${result.finishReason} '
      'toolCalls=${result.message.toolCalls.length}',
    );
    AppLog.d(
      'AI 响应文本（仅 Debug 控制台）：${AppLog.snippet(result.message.text, 200)}',
    );
    return result;
  }

  String _serverErrorText(Map<String, dynamic> data) {
    final error = data['error'];
    if (error is Map<String, dynamic>) {
      return '服务返回错误: ${error['message'] ?? error}';
    }
    return '服务返回错误: ${AppLog.snippet(data.toString(), 300)}';
  }

  NetworkException _mapDioError(DioException e) {
    final code = e.response?.statusCode;
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      return NetworkException(kind: NetworkErrorKind.timeout, cause: e);
    }
    if (e.type == DioExceptionType.connectionError) {
      return NetworkException(kind: NetworkErrorKind.connection, cause: e);
    }
    if (code != null) {
      // 把 HTTP 状态错误归一为 AiException（docs/03：给老人可懂的提示由 UI 翻译）。
      final serverText = e.response?.data is Map<String, dynamic>
          ? _serverErrorText(e.response!.data as Map<String, dynamic>)
          : 'HTTP $code';
      final lower = serverText.toLowerCase();
      final errorCode = code == 401 || code == 403
          ? AiErrorCode.authentication
          : code == 429
          ? AiErrorCode.rateLimited
          : RegExp(
              r'context.{0,30}(length|window|limit)|maximum context|too many tokens',
            ).hasMatch(lower)
          ? AiErrorCode.contextLength
          : (code == 400 || code == 422) &&
                RegExp(
                  r'(tools?|function.call).{0,50}(not supported|unsupported)|unsupported.{0,50}(tools?|function)',
                ).hasMatch(lower)
          ? AiErrorCode.capabilityMissing
          : AiErrorCode.protocol;
      final err = AiException(errorCode, cause: serverText);
      AppLog.w('AI 请求失败 HTTP $code: ${AppLog.snippet(serverText, 200)}');
      throw err;
    }
    return NetworkException(kind: NetworkErrorKind.unknown, cause: e);
  }
}

/// 对话客户端同时具备视觉能力时的取用（OpenAI 兼容实现二者皆实现）。
extension AiVisionClientLookup on AiChatClient {
  AiVisionClient get asVisionClient => this as AiVisionClient;
}
