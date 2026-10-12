import 'package:care_pill/i18n/strings.g.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../core/app_logger.dart';
import '../../domain/models/ai_model_config.dart';
import '../../domain/models/enums.dart';
import '../../domain/models/view_models.dart';
import '../../domain/services/model_selection.dart';
import '../providers.dart';
import 'settings_controller.dart';

/// 模型配置列表项 + 测试状态。
class ModelListController extends AsyncNotifier<List<ModelConfigView>> {
  final Map<String, (bool, String)> _testResults = {};
  @override
  Future<List<ModelConfigView>> build() async {
    final repo = ref.watch(modelConfigRepositoryProvider);
    final configs = await repo.list();
    final views = <ModelConfigView>[];
    for (final c in configs) {
      final key = await repo.apiKeyOf(c.id);
      views.add(
        ModelConfigView(
          config: c,
          hasKey: key != null && key.isNotEmpty,
          lastTestOk: _testResults[c.id]?.$1,
          lastTestMessage: _testResults[c.id]?.$2,
        ),
      );
    }
    return views;
  }

  /// 新增或更新。[apiKey] 为 null 表示不改密钥；空串删除。
  Future<void> saveConfig({
    String? id,
    required String name,
    required String baseUrl,
    required String modelId,
    required bool supportsVision,
    required bool supportsFunctionCalling,
    required ModelUsage usage,
    required bool isChatDefault,
    bool? supportsChat,
    double? temperature,
    int? maxTokens,
    int contextWindowTokens = 8192,
    String? apiKey,
    (bool, String)? testResult,
  }) async {
    final repo = ref.read(modelConfigRepositoryProvider);
    final now = DateTime.now();
    var configId = id ?? const Uuid().v4();
    AiModelConfig? existing;
    if (id != null) {
      existing = await repo.get(id);
    }
    final config = AiModelConfig(
      id: configId,
      name: name.trim(),
      baseUrl: baseUrl.trim(),
      modelId: modelId.trim(),
      supportsChat: supportsChat ?? usage != ModelUsage.vision,
      supportsVision: supportsVision,
      supportsFunctionCalling: supportsFunctionCalling,
      temperature: temperature,
      maxTokens: maxTokens,
      contextWindowTokens: contextWindowTokens,
      usage: usage,
      isChatDefault: isChatDefault,
      createdAt: existing?.createdAt ?? now,
    );
    config.validateBudget();
    await repo.save(config, apiKey: apiKey);
    if (isChatDefault || existing?.isChatDefault == true) {
      // 默认对话模型 id 同步到设置（docs/03 §2）。
      await ref
          .read(settingsControllerProvider.notifier)
          .setChatModelId(isChatDefault ? configId : null);
    }
    configId = config.id;
    AppLog.i('模型配置已保存 id=$configId name=${config.name}');
    _testResults.remove(configId);
    if (testResult != null) _testResults[configId] = testResult;
    ref.invalidate(hasChatModelProvider);
    ref.invalidate(visionCapabilityProvider);
    ref.invalidateSelf();
  }

  Future<void> deleteConfig(String id) async {
    await ref.read(modelConfigRepositoryProvider).delete(id);
    await ref.read(settingsControllerProvider.notifier).setChatModelId(null);
    _testResults.remove(id);
    ref.invalidate(hasChatModelProvider);
    ref.invalidate(visionCapabilityProvider);
    ref.invalidateSelf();
  }

  /// 连通性测试（docs/03 §2）：返回 (是否成功, 提示文案)。
  Future<(bool, String)> testConfig(String id) async {
    final repo = ref.read(modelConfigRepositoryProvider);
    final config = await repo.get(id);
    if (config == null) {
      return (false, tr.modelsController.missingConfig);
    }
    final key = await repo.apiKeyOf(id);
    if (key == null || key.isEmpty) {
      return (false, tr.modelsController.missingKey);
    }
    final (ok, message) = await ref
        .read(modelSelectionProvider)
        .testChat(
          config: config,
          apiKey: key,
          client: ref.read(aiClientProvider),
        );
    AppLog.i('模型连通性测试 id=$id ok=$ok');
    _testResults[id] = (ok, message);
    final current = state.value;
    if (current != null) {
      state = AsyncData([
        for (final view in current)
          if (view.config.id == id)
            ModelConfigView(
              config: view.config,
              hasKey: view.hasKey,
              lastTestOk: ok,
              lastTestMessage: message,
            )
          else
            view,
      ]);
    }
    return (ok, message);
  }

  /// 切换"对话默认"。
  Future<void> setDefault(String id) async {
    await ref.read(modelConfigRepositoryProvider).setChatDefault(id);
    await ref.read(settingsControllerProvider.notifier).setChatModelId(id);
    ref.invalidateSelf();
  }
}

final modelListControllerProvider =
    AsyncNotifierProvider<ModelListController, List<ModelConfigView>>(
      ModelListController.new,
    );

/// 是否配置了可用的对话模型（AI 入口 gate，docs/03 §3）。
final hasChatModelProvider = FutureProvider<bool>((ref) async {
  final config = await ref.watch(modelSelectionProvider).resolveChat();
  return config != null;
});

final visionCapabilityProvider = FutureProvider<VisionCapability>((ref) async {
  return ref.watch(modelSelectionProvider).visionCapability();
});
