/// Verified against https://api-docs.deepseek.com/quick_start/pricing
/// and https://api-docs.deepseek.com/guides/thinking_mode on 2026-10-07.
abstract final class DeepSeekDefaults {
  static const baseUrl = 'https://api.deepseek.com';
  static const flashModel = 'deepseek-flash';
  static const proModel = 'deepseek-v4-pro';
  static const apiKeysUrl = 'https://platform.deepseek.com/api_keys';

  static bool isOfficialEndpoint(String baseUrl) {
    final uri = Uri.tryParse(baseUrl.trim());
    return uri != null &&
        uri.scheme == 'https' &&
        uri.host == 'api.deepseek.com' &&
        const {'', '/', '/v1', '/v1/'}.contains(uri.path);
  }

  static bool isRetiredModel(String modelId) =>
      const {'deepseek-chat', 'deepseek-reasoner'}.contains(modelId);

  static bool supportsThinkingToggle(String modelId) => const {
    flashModel,
    proModel,
    // Still accepted aliases, now served by Flash 4.1.
    'deepseek-v4-flash',
    'deepseek-v4-flash-vision-exp',
  }.contains(modelId);
}
