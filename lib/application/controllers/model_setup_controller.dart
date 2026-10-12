import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../core/cancellation.dart';
import '../../domain/models/ai_model_config.dart';
import '../../domain/models/ai_provider_preset.dart';
import '../../domain/models/enums.dart';
import '../../i18n/strings.g.dart';
import '../providers.dart';
import 'models_controller.dart';

class ModelSetupState {
  const ModelSetupState({
    required this.config,
    this.provider,
    this.step = 0,
    this.loading = false,
    this.loadError,
    this.key = '',
    this.hasStoredKey = false,
    this.maxTokens = '512',
    this.contextWindow = '8192',
    this.testing = false,
    this.saving = false,
    this.testResult,
  });
  final AiModelConfig config;
  final AiProviderPreset? provider;
  final int step;
  final bool loading;
  final String? loadError;
  final String key;
  final bool hasStoredKey;
  final String maxTokens;
  final String contextWindow;
  final bool testing;
  final bool saving;
  final (bool, String)? testResult;
  bool get busy => testing || saving;

  ModelSetupState copyWith({
    AiModelConfig? config,
    AiProviderPreset? provider,
    int? step,
    bool? loading,
    String? loadError,
    String? key,
    bool? hasStoredKey,
    String? maxTokens,
    String? contextWindow,
    bool? testing,
    bool? saving,
    (bool, String)? testResult,
    bool clearTest = false,
  }) => ModelSetupState(
    config: config ?? this.config,
    provider: provider ?? this.provider,
    step: step ?? this.step,
    loading: loading ?? this.loading,
    loadError: loadError ?? this.loadError,
    key: key ?? this.key,
    hasStoredKey: hasStoredKey ?? this.hasStoredKey,
    maxTokens: maxTokens ?? this.maxTokens,
    contextWindow: contextWindow ?? this.contextWindow,
    testing: testing ?? this.testing,
    saving: saving ?? this.saving,
    testResult: clearTest ? null : testResult ?? this.testResult,
  );
}

final modelSetupProvider = NotifierProvider.autoDispose
    .family<ModelSetupController, ModelSetupState, String?>(
      ModelSetupController.new,
    );

class ModelSetupController extends Notifier<ModelSetupState> {
  ModelSetupController(this.configId);
  final String? configId;
  String? _storedKey;
  bool _nameEdited = false;
  bool _disposed = false;
  CancellationSignal? _testCancellation;

  @override
  ModelSetupState build() {
    ref.onDispose(() {
      _disposed = true;
      _storedKey = null;
      _testCancellation?.cancel();
    });
    if (configId != null) unawaited(Future<void>.microtask(_load));
    return ModelSetupState(
      loading: configId != null,
      config: AiModelConfig(
        id: configId ?? const Uuid().v4(),
        name: '',
        baseUrl: '',
        modelId: '',
        usage: ModelUsage.chat,
        maxTokens: 512,
        createdAt: DateTime.now(),
      ),
    );
  }

  Future<void> _load() async {
    try {
      final repo = ref.read(modelConfigRepositoryProvider);
      final config = await repo.get(configId!);
      final key = config == null ? null : await repo.apiKeyOf(configId!);
      if (_disposed) return;
      if (config == null) {
        state = state.copyWith(
          loading: false,
          loadError: tr.modelsController.missingConfig,
        );
        return;
      }
      _storedKey = key;
      _nameEdited = true;
      state = ModelSetupState(
        config: config,
        provider: AiProviderPreset.identify(config.baseUrl),
        hasStoredKey: key != null && key.isNotEmpty,
        maxTokens: config.maxTokens?.toString() ?? '',
        contextWindow: config.contextWindowTokens.toString(),
      );
    } catch (_) {
      if (!_disposed) {
        state = state.copyWith(
          loading: false,
          loadError: tr.modelSetup.loadFailed,
        );
      }
    }
  }

  void selectProvider(AiProviderPreset provider) {
    if (state.busy || state.provider?.id == provider.id) return;
    _storedKey = null;
    final model = provider.models.firstOrNull;
    state = state.copyWith(
      provider: provider,
      key: '',
      hasStoredKey: false,
      clearTest: true,
      config: state.config.copyWith(
        baseUrl: provider.baseUrl,
        modelId: model?.id ?? '',
        name: _nameEdited ? state.config.name : model?.name ?? '',
        supportsChat: true,
        supportsVision: model?.vision ?? false,
        supportsFunctionCalling: model?.tools ?? false,
        usage: model?.vision == true ? ModelUsage.both : ModelUsage.chat,
      ),
    );
  }

  void selectModel(AiModelPreset model) {
    update(modelId: model.id);
  }

  void update({
    String? name,
    String? baseUrl,
    String? key,
    String? modelId,
    String? maxTokens,
    String? contextWindow,
    ModelUsage? usage,
    bool? vision,
    bool? tools,
    bool? isDefault,
  }) {
    if (state.busy) return;
    if (name != null) _nameEdited = true;
    final changedAddress =
        baseUrl != null &&
        normalizeEndpoint(baseUrl) != normalizeEndpoint(state.config.baseUrl);
    if (changedAddress) _storedKey = null;
    final model = modelId == null
        ? null
        : state.provider?.models
              .where((m) => m.id == modelId.trim())
              .firstOrNull;
    var config = state.config.copyWith(
      name:
          name ??
          (!_nameEdited && modelId != null
              ? model?.name ?? modelId
              : state.config.name),
      baseUrl: baseUrl ?? state.config.baseUrl,
      modelId: modelId ?? state.config.modelId,
      supportsVision:
          vision ??
          (modelId != null
              ? model?.vision ?? false
              : state.config.supportsVision),
      supportsFunctionCalling:
          tools ??
          (modelId != null
              ? model?.tools ?? false
              : state.config.supportsFunctionCalling),
      usage:
          usage ??
          (modelId != null
              ? (model?.vision == true ? ModelUsage.both : ModelUsage.chat)
              : state.config.usage),
      isChatDefault: isDefault ?? state.config.isChatDefault,
    );
    // Keep purpose and capabilities consistent for both known and custom models.
    if (vision == true && config.usage == ModelUsage.chat) {
      config = config.copyWith(usage: ModelUsage.both);
    }
    if (vision == false) config = config.copyWith(usage: ModelUsage.chat);
    if (usage != null) {
      config = config.copyWith(supportsVision: usage != ModelUsage.chat);
    }
    config = config.copyWith(
      supportsChat: usage != null || modelId != null || vision != null
          ? config.usage != ModelUsage.vision
          : config.supportsChat,
      isChatDefault: config.usage == ModelUsage.vision
          ? false
          : config.isChatDefault,
    );
    state = state.copyWith(
      config: config,
      key: changedAddress ? '' : key,
      hasStoredKey: changedAddress ? false : null,
      maxTokens: maxTokens,
      contextWindow: contextWindow,
      clearTest: true,
    );
  }

  String? validate(int step) {
    if (state.provider == null) return tr.modelSetup.chooseProvider;
    if (step < 1) return null;
    final uri = Uri.tryParse(state.config.baseUrl.trim());
    if (uri == null ||
        !const ['https', 'http'].contains(uri.scheme) ||
        uri.host.isEmpty ||
        uri.userInfo.isNotEmpty ||
        uri.hasQuery ||
        uri.hasFragment ||
        state.config.baseUrl.contains(RegExp(r'\s'))) {
      return tr.modelSetup.invalidUrl;
    }
    if (_effectiveKey.isEmpty) return tr.modelSetup.enterKey;
    if (step < 2) return null;
    if (state.config.name.trim().isEmpty ||
        state.config.modelId.trim().isEmpty) {
      return tr.modelEdit.requiredFields;
    }
    final window = int.tryParse(state.contextWindow.trim());
    final output = state.maxTokens.trim().isEmpty
        ? null
        : int.tryParse(state.maxTokens.trim());
    if (window == null ||
        window < 2048 ||
        (state.maxTokens.trim().isNotEmpty && (output == null || output < 1)) ||
        window < (output ?? 512) + 2048) {
      return tr.modelSetup.invalidBudget;
    }
    return null;
  }

  String get _effectiveKey => state.key.trim().isNotEmpty
      ? state.key.trim()
      : _storedKey ?? (state.provider?.isLocal == true ? 'ollama' : '');

  String? next() {
    final error = validate(state.step);
    if (error == null && !state.busy && state.step < 3) {
      state = state.copyWith(step: state.step + 1);
    }
    return error;
  }

  void back() {
    if (state.saving || state.step == 0) return;
    _testCancellation?.cancel();
    state = state.copyWith(step: state.step - 1, testing: false);
  }

  AiModelConfig get _config => state.config.copyWith(
    name: state.config.name.trim(),
    baseUrl: normalizeEndpoint(state.config.baseUrl),
    modelId: state.config.modelId.trim(),
    maxTokens: int.tryParse(state.maxTokens.trim()),
    contextWindowTokens: int.parse(state.contextWindow.trim()),
  );

  Future<void> testConnection() async {
    if (state.busy || validate(3) != null) return;
    final cancellation = CancellationSignal();
    _testCancellation = cancellation;
    final service = ref.read(modelSelectionProvider);
    final client = ref.read(aiClientProvider);
    final config = _config;
    final key = _effectiveKey;
    state = state.copyWith(testing: true, clearTest: true);
    final result = await service.testChat(
      config: config,
      apiKey: key,
      client: client,
      cancellation: cancellation,
    );
    if (_disposed || cancellation.isCancelled) return;
    state = state.copyWith(testing: false, testResult: result);
  }

  Future<bool> save() async {
    if (state.busy || validate(3) != null) return false;
    final config = _config;
    final key = _effectiveKey;
    final retainKey = state.key.trim().isEmpty && state.hasStoredKey;
    final result = state.testResult;
    state = state.copyWith(saving: true);
    try {
      await ref
          .read(modelListControllerProvider.notifier)
          .saveConfig(
            id: config.id,
            name: config.name,
            baseUrl: config.baseUrl,
            modelId: config.modelId,
            supportsVision: config.supportsVision,
            supportsChat: config.supportsChat,
            supportsFunctionCalling: config.supportsFunctionCalling,
            usage: config.usage,
            isChatDefault: config.isChatDefault,
            temperature: config.temperature,
            maxTokens: config.maxTokens,
            contextWindowTokens: config.contextWindowTokens,
            apiKey: retainKey ? null : key,
            testResult: result,
          );
      return true;
    } finally {
      if (!_disposed) state = state.copyWith(saving: false);
    }
  }
}
