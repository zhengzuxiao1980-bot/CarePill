import 'package:care_pill/i18n/strings.g.dart';

import '../../ai/client/ai_client.dart';
import '../../ai/client/ai_models.dart';
import '../../core/cancellation.dart';
import '../../core/exceptions.dart';
import '../../data/repositories/model_config_repository.dart';
import '../../data/settings/app_settings.dart';
import '../../domain/models/ai_model_config.dart';

enum VisionCapability { unavailable, fallback, native }

/// 模型选择与连通性测试（docs/03 §2 多配置规则、§3 能力矩阵）。
class ModelSelectionService {
  ModelSelectionService({
    required ModelConfigRepository modelConfigRepository,
    required SettingsService settingsService,
  }) : _repo = modelConfigRepository,
       _settings = settingsService;

  final ModelConfigRepository _repo;
  final SettingsService _settings;

  /// 是否配置了任何可对话模型（AI 助手入口 gate，docs/03 §3）。
  Future<bool> hasChatModel() async => await resolveChat() != null;

  Future<VisionCapability> visionCapability() async {
    final resolution = await resolveVision();
    if (resolution == null) {
      return VisionCapability.unavailable;
    }
    return resolution.fallback
        ? VisionCapability.fallback
        : VisionCapability.native;
  }

  /// 解析对话模型配置：设置指定 → 对话默认 → 任意 canChat（docs/03 §2）。
  Future<AiClientConfig?> resolveChat() async {
    final configs = await _repo.list();
    final chatCapable = configs.where((c) => c.canChat).toList();
    if (chatCapable.isEmpty) {
      return null;
    }
    final preferredId = _settings.chatModelId;
    final chosen =
        chatCapable.where((c) => c.id == preferredId).firstOrNull ??
        chatCapable.where((c) => c.isChatDefault).firstOrNull ??
        chatCapable.first;
    for (final candidate in [
      chosen,
      ...chatCapable.where((c) => c.id != chosen.id),
    ]) {
      final key = await _repo.apiKeyOf(candidate.id);
      if (key != null && key.isNotEmpty) {
        return _toClientConfig(candidate, key);
      }
    }
    return null;
  }

  /// 解析视觉模型：优先标记 vision 的配置；没有则复用对话默认，
  /// [VisionResolution.fallback]=true（docs/03 §2：识别前提示可能不支持看图）。
  Future<VisionResolution?> resolveVision() async {
    final configs = await _repo.list();
    final visionCapable = configs.where((c) => c.canVision).toList();
    final preferredId = _settings.visionModelId;
    if (visionCapable.isNotEmpty) {
      final chosen =
          visionCapable.where((c) => c.id == preferredId).firstOrNull ??
          visionCapable.first;
      for (final candidate in [
        chosen,
        ...visionCapable.where((c) => c.id != chosen.id),
      ]) {
        final key = await _repo.apiKeyOf(candidate.id);
        if (key != null && key.isNotEmpty) {
          return VisionResolution(config: _toClientConfig(candidate, key));
        }
      }
    }
    // 复用对话默认。
    final chat = await resolveChat();
    if (chat == null) {
      return null;
    }
    return VisionResolution(config: chat, fallback: true);
  }

  AiClientConfig _toClientConfig(AiModelConfig c, String apiKey) =>
      AiClientConfig(
        baseUrl: c.baseUrl,
        apiKey: apiKey,
        modelId: c.modelId,
        temperature: c.temperature,
        maxTokens: c.maxTokens,
        contextWindowTokens: c.contextWindowTokens,
        supportsFunctionCalling: c.supportsFunctionCalling,
      );

  /// 连通性测试（docs/03 §2）：极小 chat 请求验证地址、密钥、模型名。
  Future<(bool, String)> testChat({
    required AiModelConfig config,
    required String apiKey,
    required AiChatClient client,
    CancellationSignal? cancellation,
  }) async {
    try {
      await client.chat(
        AiChatRequest(
          model: config.modelId,
          messages: const [
            AiProtocolMessage(role: AiRole.user, content: 'ping'),
          ],
          maxTokens: 1,
          cancellation: cancellation,
        ),
        config: _toClientConfig(config, apiKey),
      );
      return (true, tr.modelSelection.connected);
    } on AppException catch (e) {
      return (false, _errorHint(e));
    } catch (_) {
      return (false, tr.modelSetup.networkError);
    }
  }

  /// 视觉能力测试：1px 测试图（docs/03 §2 可选）。
  Future<(bool, String)> testVision({
    required AiModelConfig config,
    required String apiKey,
    required AiVisionClient client,
  }) async {
    try {
      await client.vision(
        AiChatRequest(
          model: config.modelId,
          messages: [
            const AiProtocolMessage(
              role: AiRole.user,
              contentParts: [
                AiContentPart.text('这是什么颜色？只答一个词。'),
                AiContentPart.imageUrl(
                  'data:image/png;base64,'
                  'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR4'
                  'nGNgYGBgAAAABQABh6FO1AAAAABJRU5ErkJggg==',
                ),
              ],
            ),
          ],
          maxTokens: 8,
        ),
        config: _toClientConfig(config, apiKey),
      );
      return (true, tr.modelSelection.visionReady);
    } on AppException catch (e) {
      return (false, _errorHint(e));
    } catch (e) {
      return (false, tr.modelSelection.visionFailed(arg1: (e).toString()));
    }
  }

  String _errorHint(AppException e) => switch (e) {
    NetworkException(:final kind) => switch (kind) {
      NetworkErrorKind.timeout => tr.modelSetup.timeoutError,
      _ => tr.modelSetup.networkError,
    },
    AiException(:final code) => switch (code) {
      AiErrorCode.authentication => tr.modelSetup.authError,
      AiErrorCode.rateLimited => tr.modelSetup.quotaError,
      _ => tr.modelSetup.configError,
    },
    _ => tr.modelSetup.configError,
  };
}

/// 视觉解析结果（含 fallback 提示）。
class VisionResolution {
  const VisionResolution({required this.config, this.fallback = false});

  final AiClientConfig config;

  /// true = 复用了对话模型，识别前 UI 应提示"当前模型可能不支持看图"。
  final bool fallback;
}

extension _FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
