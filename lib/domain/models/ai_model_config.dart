import 'package:freezed_annotation/freezed_annotation.dart';

import '../../core/exceptions.dart';
import 'enums.dart';

part 'ai_model_config.freezed.dart';
part 'ai_model_config.g.dart';

/// 用户自配的 OpenAI 兼容模型配置（docs/03 §2）。
///
/// **apiKey 不在本实体内**：以 id 为键存 flutter_secure_storage，
/// 绝不入库明文、导出默认剥离（docs/03 §10）。
@freezed
sealed class AiModelConfig with _$AiModelConfig {
  const factory AiModelConfig({
    required String id,
    required String name,
    required String baseUrl,
    required String modelId,
    @Default(true) bool supportsChat,
    @Default(false) bool supportsVision,
    @Default(false) bool supportsFunctionCalling,
    double? temperature,
    int? maxTokens,
    @Default(8192) int contextWindowTokens,

    /// 用途：对话 / 看图 / 双用（允许同一配置承担多用途）。
    required ModelUsage usage,

    /// 是否为"对话默认"配置；拍照识别优先用标记 vision 的配置。
    @Default(false) bool isChatDefault,
    required DateTime createdAt,
  }) = _AiModelConfig;

  factory AiModelConfig.fromJson(Map<String, dynamic> json) =>
      _$AiModelConfigFromJson(json);
}

extension AiModelConfigX on AiModelConfig {
  void validateBudget() {
    if (contextWindowTokens < 2048 || (maxTokens != null && maxTokens! <= 0)) {
      throw const ValidationException('contextWindowTokens');
    }
  }

  /// 该配置能否承担对话。
  bool get canChat =>
      supportsChat && (usage == ModelUsage.chat || usage == ModelUsage.both);

  /// 该配置能否承担看图。
  bool get canVision =>
      supportsVision &&
      (usage == ModelUsage.vision || usage == ModelUsage.both);
}
