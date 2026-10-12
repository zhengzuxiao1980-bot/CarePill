import '../../core/deepseek_defaults.dart';

enum AiProviderId { deepseek, qwen, kimi, glm, openrouter, ollama, custom }

class AiModelPreset {
  const AiModelPreset(
    this.id,
    this.name, {
    this.vision = false,
    this.tools = false,
  });
  final String id;
  final String name;
  final bool vision;
  final bool tools;
}

class AiProviderPreset {
  const AiProviderPreset(this.id, this.baseUrl, this.models, {this.keysUrl});
  final AiProviderId id;
  final String baseUrl;
  final String? keysUrl;
  final List<AiModelPreset> models;
  bool get isLocal => id == AiProviderId.ollama;
  bool get isAdvanced => isLocal || id == AiProviderId.custom;

  static const all = [
    AiProviderPreset(AiProviderId.deepseek, DeepSeekDefaults.baseUrl, [
      AiModelPreset(
        DeepSeekDefaults.flashModel,
        'DeepSeek Flash',
        vision: true,
        tools: true,
      ),
      AiModelPreset(DeepSeekDefaults.proModel, 'DeepSeek Pro', tools: true),
    ], keysUrl: DeepSeekDefaults.apiKeysUrl),
    AiProviderPreset(
      AiProviderId.qwen,
      'https://dashscope.aliyuncs.com/compatible-mode/v1',
      [AiModelPreset('qwen-plus', 'Qwen Plus', tools: true)],
      keysUrl: 'https://bailian.console.aliyun.com/',
    ),
    AiProviderPreset(AiProviderId.kimi, 'https://api.moonshot.cn/v1', [
      AiModelPreset('moonshot-v1-8k', 'Moonshot V1 8K', tools: true),
    ], keysUrl: 'https://platform.moonshot.cn/console/api-keys'),
    AiProviderPreset(AiProviderId.glm, 'https://open.bigmodel.cn/api/paas/v4', [
      AiModelPreset('glm-4-flash', 'GLM 4 Flash', tools: true),
    ], keysUrl: 'https://open.bigmodel.cn/usercenter/proj-mgmt/apikeys'),
    AiProviderPreset(AiProviderId.openrouter, 'https://openrouter.ai/api/v1', [
      AiModelPreset(
        'openai/gpt-4o-mini',
        'GPT-4o mini',
        vision: true,
        tools: true,
      ),
    ], keysUrl: 'https://openrouter.ai/settings/keys'),
    AiProviderPreset(AiProviderId.ollama, 'http://127.0.0.1:11434/v1', [
      AiModelPreset('qwen2.5:7b', 'Qwen 2.5 7B'),
    ]),
    AiProviderPreset(AiProviderId.custom, '', []),
  ];

  static AiProviderPreset byId(AiProviderId id) =>
      all.firstWhere((p) => p.id == id);

  static AiProviderPreset identify(String url) {
    if (DeepSeekDefaults.isOfficialEndpoint(url)) return all.first;
    for (final preset in all.where((p) => !p.isAdvanced)) {
      if (normalizeEndpoint(url) == normalizeEndpoint(preset.baseUrl)) {
        return preset;
      }
    }
    final uri = Uri.tryParse(url);
    if (uri != null &&
        uri.port == 11434 &&
        uri.path.replaceAll(RegExp(r'/+$'), '') == '/v1') {
      return byId(AiProviderId.ollama);
    }
    return byId(AiProviderId.custom);
  }
}

String normalizeEndpoint(String url) =>
    url.trim().replaceAll(RegExp(r'/+$'), '');
