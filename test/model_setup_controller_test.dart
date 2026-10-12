import 'dart:async';

import 'package:care_pill/ai/client/ai_client.dart';
import 'package:care_pill/ai/client/ai_models.dart';
import 'package:care_pill/application/controllers/model_setup_controller.dart';
import 'package:care_pill/application/controllers/models_controller.dart';
import 'package:care_pill/application/providers.dart';
import 'package:care_pill/core/exceptions.dart';
import 'package:care_pill/data/settings/key_value_store.dart';
import 'package:care_pill/domain/models/ai_model_config.dart';
import 'package:care_pill/domain/models/ai_provider_preset.dart';
import 'package:care_pill/domain/models/enums.dart';
import 'package:care_pill/i18n/strings.g.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fakes/fakes.dart';

class _Client implements AiChatClient {
  Object? error;
  Completer<AiChatResult>? pending;
  final requests = <AiChatRequest>[];
  final configs = <AiClientConfig>[];
  @override
  Future<AiChatResult> chat(
    AiChatRequest request, {
    required AiClientConfig config,
  }) async {
    requests.add(request);
    configs.add(config);
    if (error != null) throw error!;
    return pending?.future ??
        Future.value(
          const AiChatResult(
            message: AiProtocolMessage(role: AiRole.assistant, content: 'ok'),
          ),
        );
  }
}

void main() {
  late InMemoryModelConfigRepository repo;
  late _Client client;
  late ProviderContainer container;
  final existing = AiModelConfig(
    id: 'old',
    name: 'Family AI',
    baseUrl: 'https://api.deepseek.com/v1',
    modelId: 'deepseek-chat',
    usage: ModelUsage.chat,
    temperature: 0.3,
    maxTokens: null,
    contextWindowTokens: 16000,
    createdAt: DateTime(2024, 1, 2),
  );

  setUp(() {
    repo = InMemoryModelConfigRepository();
    client = _Client();
    container = ProviderContainer(
      overrides: [
        modelConfigRepositoryProvider.overrideWithValue(repo),
        keyValueStoreProvider.overrideWithValue(InMemoryKeyValueStore()),
        aiClientProvider.overrideWithValue(client),
      ],
    );
  });
  tearDown(() => container.dispose());

  Future<ModelSetupController> start([String? id]) async {
    container.listen(modelSetupProvider(id), (_, _) {});
    await Future<void>.delayed(Duration.zero);
    await container.pump();
    return container.read(modelSetupProvider(id).notifier);
  }

  void configure(ModelSetupController controller) {
    controller.selectProvider(AiProviderPreset.byId(AiProviderId.deepseek));
    controller.update(key: 'test-key');
    for (var i = 0; i < 3; i++) {
      expect(controller.next(), isNull);
    }
  }

  test('Every preset belongs to one provider; matching is exact, unknown endpoints stay custom', () {
    expect(AiProviderPreset.all.where((p) => !p.isAdvanced).length, 5);
    expect(
      AiProviderPreset.identify('https://api.deepseek.com/v1/').id,
      AiProviderId.deepseek,
    );
    expect(
      AiProviderPreset.identify('https://api.deepseek.com.evil.test').id,
      AiProviderId.custom,
    );
    expect(
      AiProviderPreset.identify('http://192.168.1.25:11434/v1').id,
      AiProviderId.ollama,
    );
    for (final preset in AiProviderPreset.all.where((p) => !p.isAdvanced)) {
      expect(AiProviderPreset.identify(preset.baseUrl).id, preset.id);
      expect(Uri.parse(preset.keysUrl!).scheme, 'https');
    }
  });

  test(
    'Draft connection test sends only ping; nothing is persisted before save',
    () async {
      final c = await start();
      configure(c);
      await c.testConnection();
      expect(repo.configs, isEmpty);
      expect(repo.keys, isEmpty);
      expect(client.requests.single.messages.single.content, 'ping');
      expect(client.requests.single.maxTokens, 1);
      expect(client.configs.single.apiKey, 'test-key');
      expect(container.read(modelSetupProvider(null)).testResult?.$1, isTrue);
      expect(await c.save(), isTrue);
      final saved = repo.configs.values.single;
      expect(saved.supportsVision, isTrue);
      expect(saved.supportsFunctionCalling, isTrue);
      expect(saved.usage, ModelUsage.both);
      final views = await container.read(modelListControllerProvider.future);
      expect(views.single.lastTestOk, isTrue);
    },
  );

  test('Skipping test saves without claiming connectivity', () async {
    final c = await start();
    configure(c);
    expect(await c.save(), isTrue);
    expect(client.requests, isEmpty);
    final views = await container.read(modelListControllerProvider.future);
    expect(views.single.lastTestOk, isNull);
  });

  for (final (error, hint) in <(Object, String Function())>[
    (
      const AiException(
        AiErrorCode.authentication,
        cause: 'secret-server-data',
      ),
      () => tr.modelSetup.authError,
    ),
    (
      const NetworkException(kind: NetworkErrorKind.timeout),
      () => tr.modelSetup.timeoutError,
    ),
    (
      const NetworkException(kind: NetworkErrorKind.connection),
      () => tr.modelSetup.networkError,
    ),
    (
      const AiException(AiErrorCode.rateLimited),
      () => tr.modelSetup.quotaError,
    ),
    (const AiException(AiErrorCode.protocol), () => tr.modelSetup.configError),
  ]) {
    test('Failed test $error explains recovery and permits saving', () async {
      final c = await start();
      configure(c);
      client.error = error;
      await c.testConnection();
      expect(container.read(modelSetupProvider(null)).testResult, (
        false,
        hint(),
      ));
      expect(repo.configs, isEmpty);
      expect(await c.save(), isTrue);
      expect(
        (await container.read(modelListControllerProvider.future))
            .single
            .lastTestOk,
        isFalse,
      );
    });
  }

  test('Editing preserves ID, creation date, temperature, optional output and stored key', () async {
    await repo.save(existing, apiKey: 'retained-secret');
    final c = await start('old');
    expect(container.read(modelSetupProvider('old')).hasStoredKey, isTrue);
    expect(container.read(modelSetupProvider('old')).key, isEmpty);
    expect(await c.save(), isTrue);
    expect(repo.configs['old'], existing);
    expect(repo.keys['old'], 'retained-secret');
    c.update(key: 'replacement');
    await c.save();
    expect(repo.keys['old'], 'replacement');
  });

  test('Retired model upgrade preserves service address, custom name and stored key', () async {
    await repo.save(existing, apiKey: 'retained-secret');
    final c = await start('old');
    c.selectModel(AiProviderPreset.all.first.models.first);
    expect(repo.configs['old']!.modelId, 'deepseek-chat');
    await c.testConnection();
    expect(client.configs.single.apiKey, 'retained-secret');
    await c.save();
    expect(repo.configs['old']!.modelId, 'deepseek-flash');
    expect(repo.configs['old']!.name, existing.name);
    expect(repo.configs['old']!.baseUrl, existing.baseUrl);
    expect(repo.keys['old'], 'retained-secret');
  });

  test(
    'Changing provider drops old credentials and resets model capabilities',
    () async {
      await repo.save(existing, apiKey: 'retained-secret');
      final c = await start('old');
      c.selectProvider(AiProviderPreset.byId(AiProviderId.qwen));
      expect(container.read(modelSetupProvider('old')).hasStoredKey, isFalse);
      expect(c.validate(1), tr.modelSetup.enterKey);
      await c.testConnection();
      expect(client.requests, isEmpty);
      c.update(key: 'qwen-key');
      await c.testConnection();
      expect(client.configs.single.apiKey, 'qwen-key');
      expect(
        container.read(modelSetupProvider('old')).config.supportsVision,
        isFalse,
      );
    },
  );

  test(
    'Changing URL drops entered and stored keys, even if the user changes back',
    () async {
      await repo.save(existing, apiKey: 'retained-secret');
      final c = await start('old');
      c.update(key: 'new-secret');
      c.update(baseUrl: 'https://example.com/v1');
      c.update(baseUrl: existing.baseUrl);
      expect(c.validate(1), tr.modelSetup.enterKey);
      expect(await c.save(), isFalse);
      expect(repo.keys['old'], 'retained-secret');
    },
  );

  test('Unknown model is conservative and changing model invalidates a successful test', () async {
    final c = await start();
    configure(c);
    await c.testConnection();
    c.back();
    c.update(modelId: 'custom-model');
    final state = container.read(modelSetupProvider(null));
    expect(state.testResult, isNull);
    expect(state.config.supportsVision, isFalse);
    expect(state.config.supportsFunctionCalling, isFalse);
    expect(state.config.name, 'custom-model');
    expect(state.key, 'test-key');
  });

  test(
    'Local Ollama needs no typed key; custom names and URL are kept',
    () async {
      final c = await start();
      c.selectProvider(AiProviderPreset.byId(AiProviderId.ollama));
      c.update(baseUrl: 'http://192.168.1.10:11434/v1', name: 'Home AI');
      expect(c.validate(3), isNull);
      await c.testConnection();
      expect(client.configs.single.apiKey, 'ollama');
      await c.save();
      expect(repo.keys.values.single, 'ollama');
      expect(repo.configs.values.single.name, 'Home AI');
    },
  );

  test('URL and token validation rejects malformed values without network or persistence', () async {
    final c = await start();
    configure(c);
    c.update(baseUrl: 'not a url');
    expect(c.validate(3), tr.modelSetup.invalidUrl);
    c.update(baseUrl: 'https://example.com/v1');
    c.update(key: 'new-key', maxTokens: 'oops');
    expect(c.validate(3), tr.modelSetup.invalidBudget);
    c.update(maxTokens: '9000');
    expect(c.validate(3), tr.modelSetup.invalidBudget);
    expect(await c.save(), isFalse);
    expect(repo.configs, isEmpty);
  });

  test('Duplicate testing and saves during testing are prevented; back cancels stale response', () async {
    final c = await start();
    configure(c);
    client.pending = Completer<AiChatResult>();
    final running = c.testConnection();
    await c.testConnection();
    expect(client.requests.length, 1);
    expect(await c.save(), isFalse);
    c.back();
    expect(client.requests.single.cancellation!.isCancelled, isTrue);
    client.pending!.complete(
      const AiChatResult(
        message: AiProtocolMessage(role: AiRole.assistant, content: 'ok'),
      ),
    );
    await running;
    expect(container.read(modelSetupProvider(null)).testResult, isNull);
    expect(container.read(modelSetupProvider(null)).testing, isFalse);
  });

  test(
    'Leaving route cancels pending test and ignores its completion',
    () async {
      final c = await start();
      configure(c);
      client.pending = Completer<AiChatResult>();
      final running = c.testConnection();
      container.invalidate(modelSetupProvider(null));
      expect(client.requests.single.cancellation!.isCancelled, isTrue);
      client.pending!.complete(
        const AiChatResult(
          message: AiProtocolMessage(role: AiRole.assistant, content: 'ok'),
        ),
      );
      await running;
      expect(repo.configs, isEmpty);
    },
  );

  test(
    'Missing configuration finishes loading with a recoverable error',
    () async {
      await start('missing');
      final state = container.read(modelSetupProvider('missing'));
      expect(state.loading, isFalse);
      expect(state.loadError, tr.modelsController.missingConfig);
    },
  );
}
