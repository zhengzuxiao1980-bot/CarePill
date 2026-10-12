// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_model_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AiModelConfig _$AiModelConfigFromJson(
  Map<String, dynamic> json,
) => _AiModelConfig(
  id: json['id'] as String,
  name: json['name'] as String,
  baseUrl: json['baseUrl'] as String,
  modelId: json['modelId'] as String,
  supportsChat: json['supportsChat'] as bool? ?? true,
  supportsVision: json['supportsVision'] as bool? ?? false,
  supportsFunctionCalling: json['supportsFunctionCalling'] as bool? ?? false,
  temperature: (json['temperature'] as num?)?.toDouble(),
  maxTokens: (json['maxTokens'] as num?)?.toInt(),
  contextWindowTokens: (json['contextWindowTokens'] as num?)?.toInt() ?? 8192,
  usage: $enumDecode(_$ModelUsageEnumMap, json['usage']),
  isChatDefault: json['isChatDefault'] as bool? ?? false,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$AiModelConfigToJson(_AiModelConfig instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'baseUrl': instance.baseUrl,
      'modelId': instance.modelId,
      'supportsChat': instance.supportsChat,
      'supportsVision': instance.supportsVision,
      'supportsFunctionCalling': instance.supportsFunctionCalling,
      'temperature': instance.temperature,
      'maxTokens': instance.maxTokens,
      'contextWindowTokens': instance.contextWindowTokens,
      'usage': _$ModelUsageEnumMap[instance.usage]!,
      'isChatDefault': instance.isChatDefault,
      'createdAt': instance.createdAt.toIso8601String(),
    };

const _$ModelUsageEnumMap = {
  ModelUsage.chat: 'chat',
  ModelUsage.vision: 'vision',
  ModelUsage.both: 'both',
};
