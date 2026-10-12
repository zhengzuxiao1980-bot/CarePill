import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../ai/client/ai_client.dart';
import '../ai/tools/tool_registry.dart';
import '../core/app_logger.dart';
import '../data/backup/backup_service.dart';
import '../data/db/app_database.dart';
import '../data/repositories/agent_store.dart';
import '../data/repositories/chat_repository.dart';
import '../data/repositories/dose_task_repository.dart';
import '../data/repositories/draft_repository.dart';
import '../data/repositories/medication_repository.dart';
import '../data/repositories/model_config_repository.dart';
import '../data/settings/app_settings.dart';
import '../data/settings/key_value_store.dart';
import '../domain/models/enums.dart';
import '../domain/models/medication_draft.dart';
import '../domain/services/agent_service.dart';
import '../domain/services/dose_service.dart';
import '../domain/services/medication_service.dart';
import '../domain/services/memory_service.dart';
import '../domain/services/model_selection.dart';
import '../domain/services/reminder_scheduler.dart';
import '../domain/services/speech_service.dart';
import '../domain/services/vision_service.dart';
import '../platform/device_channel.dart';
import '../platform/local_notification_gateway.dart';
import '../platform/secure_storage.dart';
import '../platform/system_speech.dart';
import 'router.dart';

// ============ 基础设施层（docs/04 §8：App 级单例，测试用 override） ============

/// SharedPreferences 需要在 main() 里先初始化再注入。
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('main() 中通过 overrides 注入');
});

final keyValueStoreProvider = Provider<KeyValueStore>((ref) {
  return SharedPreferencesStore(ref.watch(sharedPreferencesProvider));
});

final secureStoreProvider = Provider<SecureKeyValueStore>((ref) {
  return SecureStorageAdapter(const FlutterSecureStorage());
});

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase.open();
  ref.onDispose(db.close);
  return db;
});

final settingsServiceProvider = Provider<SettingsService>((ref) {
  return SettingsService(ref.watch(keyValueStoreProvider));
});

// ============ 仓库层 ============

final medicationRepositoryProvider = Provider<MedicationRepository>((ref) {
  return DriftMedicationRepository(ref.watch(appDatabaseProvider));
});

final doseTaskRepositoryProvider = Provider<DoseTaskRepository>((ref) {
  return DriftDoseTaskRepository(ref.watch(appDatabaseProvider));
});

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  return DriftChatRepository(ref.watch(appDatabaseProvider));
});
final agentStoreProvider = Provider<AgentStore>(
  (ref) => DriftAgentStore(ref.watch(appDatabaseProvider)),
);
final memoryServiceProvider = Provider<MemoryService>(
  (ref) => MemoryService(ref.watch(agentStoreProvider)),
);

final modelConfigRepositoryProvider = Provider<ModelConfigRepository>((ref) {
  return DriftModelConfigRepository(
    ref.watch(appDatabaseProvider),
    ref.watch(secureStoreProvider),
  );
});

final draftRepositoryProvider = Provider<DraftRepository>((ref) {
  return DriftDraftRepository(ref.watch(appDatabaseProvider));
});

// ============ 领域服务层 ============

final doseServiceProvider = Provider<DoseService>((ref) {
  return DoseService(
    taskRepository: ref.watch(doseTaskRepositoryProvider),
    medicationRepository: ref.watch(medicationRepositoryProvider),
  );
});

final medicationServiceProvider = Provider<MedicationService>((ref) {
  return MedicationService(
    medicationRepository: ref.watch(medicationRepositoryProvider),
    taskRepository: ref.watch(doseTaskRepositoryProvider),
  );
});

final reminderGatewayProvider = Provider<ReminderGateway>((ref) {
  return LocalNotificationGateway(
    onNotificationTap: (payload) {
      // 通知点击 → 深链（docs/06 §6），路由在 background 层处理。
      AppLog.i('通知点击 payload=$payload');
      handleReminderPayload(payload);
    },
  );
});

final reminderSchedulerProvider = Provider<ReminderScheduler>((ref) {
  final settings = ref.watch(settingsServiceProvider);
  return ReminderScheduler(
    doseService: ref.watch(doseServiceProvider),
    gateway: ref.watch(reminderGatewayProvider),
    settingsOf: () => ReminderSettings(
      reminderLeadMinutes: settings.reminderLeadMinutes,
      escalationCount: settings.escalationCount,
      escalationIntervalMinutes: settings.escalationIntervalMinutes,
      gracePeriodMinutes: settings.gracePeriodMinutes,
    ),
  );
});

final aiClientProvider = Provider<AiChatClient>((ref) {
  return OpenAiCompatibleClient();
});

final modelSelectionProvider = Provider<ModelSelectionService>((ref) {
  return ModelSelectionService(
    modelConfigRepository: ref.watch(modelConfigRepositoryProvider),
    settingsService: ref.watch(settingsServiceProvider),
  );
});

final draftRepositoryForToolsProvider = Provider<DraftRepository>((ref) {
  return ref.watch(draftRepositoryProvider);
});

final toolRegistryProvider = Provider<ToolRegistry>((ref) {
  final drafts = ref.watch(draftRepositoryForToolsProvider);
  return ToolRegistry(
    memories: ref.watch(memoryServiceProvider),
    discardDraft: (id) async {
      final draft = await drafts.get(id);
      if (draft == null || draft.status != DraftStatus.pending) {
        throw StateError('undo_conflict');
      }
      await drafts.setStatus(id, DraftStatus.discarded);
    },
    doseService: ref.watch(doseServiceProvider),
    medicationService: ref.watch(medicationServiceProvider),
    draftSaver: (payload) async {
      final draft = MedicationDraft(
        id: const Uuid().v4(),
        source: DraftSource.chat,
        payload: payload,
        status: DraftStatus.pending,
        createdAt: DateTime.now(),
      );
      await drafts.save(draft);
      return DraftUpsert(draftId: draft.id);
    },
  );
});

final agentServiceProvider = Provider<AgentService>((ref) {
  return AgentService(
    store: ref.watch(agentStoreProvider),
    chatClient: ref.watch(aiClientProvider),
    modelSelection: ref.watch(modelSelectionProvider),
    toolRegistry: ref.watch(toolRegistryProvider),
    chatRepository: ref.watch(chatRepositoryProvider),
    doseService: ref.watch(doseServiceProvider),
  );
});

/// OpenAI 兼容客户端同时实现视觉接口（docs/03 §1）。
final visionServiceProvider = Provider<VisionService>((ref) {
  final client = ref.watch(aiClientProvider);
  return VisionService(
    visionClient: client.asVisionClient,
    modelSelection: ref.watch(modelSelectionProvider),
    draftRepository: ref.watch(draftRepositoryProvider),
  );
});

final speechServiceProvider = Provider<SpeechService>((ref) {
  return SystemSpeechService(settings: ref.watch(settingsServiceProvider));
});

final backupServiceProvider = Provider<BackupService>((ref) {
  return BackupService(
    agentStore: ref.watch(agentStoreProvider),
    contextCutoff: () async =>
        (await ref.read(chatRepositoryProvider).recent(limit: 1))
            .firstOrNull
            ?.sequence ??
        0,
    medicationRepository: ref.watch(medicationRepositoryProvider),
    doseTaskRepository: ref.watch(doseTaskRepositoryProvider),
    modelConfigRepository: ref.watch(modelConfigRepositoryProvider),
    kv: ref.watch(keyValueStoreProvider),
    transaction: <T>(action) =>
        ref.watch(appDatabaseProvider).transaction(action),
  );
});

// ============ 控制器层 ============

/// 字号档位：切档即重建主题（docs/07 §1 全局"字"按钮）。
class FontTierNotifier extends Notifier<int> {
  @override
  int build() => ref.watch(settingsServiceProvider).fontTier;

  Future<void> setTier(int tier) async {
    final clamped = tier.clamp(0, 2);
    await ref.read(settingsServiceProvider).setFontTier(clamped);
    state = clamped;
  }

  /// "字"按钮：标准 → 大 → 特大 → 标准。
  Future<void> cycle() => setTier((state + 1) % 3);
}

final fontTierProvider = NotifierProvider<FontTierNotifier, int>(
  FontTierNotifier.new,
);

final speechSettingsProvider = Provider<Future<void> Function(SpeechIssue)>(
  (ref) =>
      (issue) => DeviceInfoChannel.openSpeechSettings(
        permission: issue == SpeechIssue.permissionDenied,
      ),
);
