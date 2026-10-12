import 'dart:convert';

import 'package:care_pill/ai/client/ai_client.dart';
import 'package:care_pill/ai/client/ai_models.dart';
import 'package:care_pill/data/repositories/chat_repository.dart';
import 'package:care_pill/data/repositories/dose_task_repository.dart';
import 'package:care_pill/data/repositories/draft_repository.dart';
import 'package:care_pill/data/repositories/medication_repository.dart';
import 'package:care_pill/data/repositories/model_config_repository.dart';
import 'package:care_pill/domain/models/ai_model_config.dart';
import 'package:care_pill/domain/models/chat_message.dart';
import 'package:care_pill/domain/models/dose_task.dart';
import 'package:care_pill/domain/models/enums.dart';
import 'package:care_pill/domain/models/medication.dart';
import 'package:care_pill/domain/models/medication_draft.dart';
import 'package:care_pill/domain/models/schedule.dart';
import 'package:care_pill/domain/services/reminder_scheduler.dart';
import 'package:care_pill/domain/services/speech_service.dart';

/// 内存版药品仓库（领域层单测的 fake，docs/04 §8）。
class InMemoryMedicationRepository implements MedicationRepository {
  final Map<String, Medication> meds = {};
  final Map<String, MedicationSchedule> schedules = {};

  @override
  Future<List<Medication>> listAll({bool includeArchived = true}) async {
    final list = meds.values.toList()
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
    if (includeArchived) {
      return list;
    }
    return list.where((m) => m.status == MedicationStatus.active).toList();
  }

  @override
  Future<Medication?> get(String id) async => meds[id];

  @override
  Future<void> save(Medication medication) async =>
      meds[medication.id] = medication;

  @override
  Future<void> setStatus(String id, MedicationStatus status) async {
    final m = meds[id];
    if (m != null) {
      meds[id] = m.copyWith(status: status);
    }
  }

  @override
  Future<List<MedicationSchedule>> schedulesFor(String medicationId) async =>
      schedules.values.where((s) => s.medicationId == medicationId).toList();

  @override
  Future<List<MedicationSchedule>> allSchedules() async =>
      schedules.values.toList();

  @override
  Future<void> saveSchedule(MedicationSchedule schedule) async =>
      schedules[schedule.id] = schedule;

  @override
  Future<void> deleteSchedule(String id) async => schedules.remove(id);

  @override
  Future<List<MedicationSchedulePair>> activePairs() async {
    final result = <MedicationSchedulePair>[];
    for (final s in schedules.values) {
      final m = meds[s.medicationId];
      if (m != null && m.status == MedicationStatus.active) {
        result.add(MedicationSchedulePair(medication: m, schedule: s));
      }
    }
    return result;
  }

  @override
  Future<void> createWithSchedules(
    Medication medication,
    List<MedicationSchedule> medicationSchedules,
  ) async {
    meds[medication.id] = medication;
    for (final s in medicationSchedules) {
      schedules[s.id] = s;
    }
  }

  @override
  Future<void> clearAll() async {
    schedules.clear();
    meds.clear();
  }
}

/// 内存版任务仓库。
class InMemoryDoseTaskRepository implements DoseTaskRepository {
  final Map<String, DoseTask> tasks = {};

  @override
  Future<void> upsertMissing(List<DoseTask> incoming) async {
    for (final t in incoming) {
      tasks.putIfAbsent(t.id, () => t);
    }
  }

  @override
  Future<DoseTask?> get(String id) async => tasks[id];

  @override
  Future<List<DoseTask>> tasksForDate(String isoDate) async =>
      tasks.values.where((t) => t.scheduledDate == isoDate).toList()
        ..sort((a, b) => a.scheduledTime.compareTo(b.scheduledTime));

  @override
  Future<List<DoseTask>> tasksBetween(String startIso, String endIso) async =>
      tasks.values
          .where(
            (t) =>
                t.scheduledDate.compareTo(startIso) >= 0 &&
                t.scheduledDate.compareTo(endIso) <= 0,
          )
          .toList()
        ..sort(
          (a, b) => (a.scheduledDate + a.scheduledTime).compareTo(
            b.scheduledDate + b.scheduledTime,
          ),
        );

  @override
  Future<List<DoseTask>> tasksForSchedule(
    String scheduleId, {
    required String fromDateIso,
  }) async => tasks.values
      .where(
        (t) =>
            t.scheduleId == scheduleId &&
            t.scheduledDate.compareTo(fromDateIso) >= 0,
      )
      .toList();

  @override
  Future<void> update(DoseTask task) async {
    tasks[task.id] = task;
  }

  @override
  Future<int> deleteStaleForSchedule(
    String scheduleId,
    String fromDateIso,
    Set<String> keepIds,
  ) async {
    final stale = tasks.values
        .where(
          (t) =>
              t.scheduleId == scheduleId &&
              t.scheduledDate.compareTo(fromDateIso) >= 0 &&
              t.isPending &&
              !keepIds.contains(t.id),
        )
        .map((t) => t.id)
        .toList();
    for (final id in stale) {
      tasks.remove(id);
    }
    return stale.length;
  }

  @override
  Future<void> clearAll() async => tasks.clear();
}

/// 内存版对话仓库。
class InMemoryChatRepository implements ChatRepository {
  final List<ChatMessage> messages = [];
  int seq = 0;

  @override
  Future<String> activeSessionId() async => 'main';

  @override
  Future<void> append(ChatMessage message) async {
    if (messages.any((m) => m.id == message.id)) return;
    messages.add(message.copyWith(sequence: ++seq));
  }

  @override
  Future<List<ChatMessage>> recent({int limit = 40}) async {
    final recent = messages.length <= limit
        ? List.of(messages)
        : messages.sublist(messages.length - limit);
    return recent;
  }

  @override
  Future<void> clearAll() async => messages.clear();
}

/// 内存版模型配置仓库（密钥存内存 map）。
class InMemoryModelConfigRepository implements ModelConfigRepository {
  final Map<String, AiModelConfig> configs = {};
  final Map<String, String> keys = {};

  @override
  Future<List<AiModelConfig>> list() async => configs.values.toList();

  @override
  Future<AiModelConfig?> get(String id) async => configs[id];

  @override
  Future<void> save(AiModelConfig config, {String? apiKey}) async {
    configs[config.id] = config;
    if (apiKey != null) {
      if (apiKey.isEmpty) {
        keys.remove(config.id);
      } else {
        keys[config.id] = apiKey;
      }
    }
    if (config.isChatDefault) {
      await setChatDefault(config.id);
    }
  }

  @override
  Future<void> delete(String id) async {
    configs.remove(id);
    keys.remove(id);
  }

  @override
  Future<String?> apiKeyOf(String id) async => keys[id];

  @override
  Future<void> setChatDefault(String id) async {
    for (final entry in configs.entries) {
      configs[entry.key] = entry.value.copyWith(isChatDefault: entry.key == id);
    }
  }
}

/// 内存版草稿仓库。
class InMemoryDraftRepository implements DraftRepository {
  final Map<String, MedicationDraft> drafts = {};

  @override
  Future<void> save(MedicationDraft draft) async => drafts[draft.id] = draft;

  @override
  Future<MedicationDraft?> get(String id) async => drafts[id];

  @override
  Future<List<MedicationDraft>> pending() async =>
      drafts.values.where((d) => d.status == DraftStatus.pending).toList();

  @override
  Future<void> setStatus(String id, DraftStatus status) async {
    final d = drafts[id];
    if (d != null) {
      drafts[id] = d.copyWith(status: status);
    }
  }
}

/// fake 通知网关：记录调用，不碰插件。
class FakeReminderGateway implements ReminderGateway {
  final List<ReminderPlanItem> scheduled = [];
  final List<int> cancelled = [];
  int cancelAllCount = 0;
  int showNowCount = 0;
  bool notificationsGranted = true;
  bool exactGranted = true;

  @override
  Future<void> schedule(ReminderPlanItem item) async => scheduled.add(item);

  @override
  Future<void> cancel(int id) async => cancelled.add(id);

  @override
  Future<void> cancelAllScheduled() async => cancelAllCount++;

  @override
  Future<bool> notificationsEnabled() async => notificationsGranted;

  @override
  Future<bool> exactAlarmsEnabled() async => exactGranted;

  @override
  Future<bool> requestPermissions() async => notificationsGranted;

  @override
  Future<void> showNow({
    required int id,
    required String title,
    required String body,
    required String payload,
    required bool fullScreen,
  }) async => showNowCount++;
}

/// fake 语音服务。
class FakeSpeechService implements SpeechService {
  final List<String> spoken = [];

  @override
  Future<SpeechPlaybackResult> speak(
    String text, {
    SpeechOwner owner = SpeechOwner.assistant,
  }) async {
    spoken.add(text);
    return const SpeechPlaybackResult(PlaybackStatus.completed);
  }

  @override
  Future<void> stopSpeak({SpeechOwner? owner}) async {}
  @override
  Future<SpeechAvailability> startListening({
    void Function(String)? onPartial,
    void Function()? onLimit,
    void Function(SpeechIssue)? onIssue,
  }) async => const SpeechAvailability(issue: SpeechIssue.unavailable);
  @override
  Future<SpeechResult> finishListening() async =>
      const SpeechResult(issue: SpeechIssue.noSpeech);
  @override
  Future<void> cancelListening() async {}

  @override
  Future<bool> isListeningAvailable() async => false;

  @override
  Future<String?> listen({
    void Function(String partial)? onPartial,
    Duration timeout = const Duration(seconds: 8),
  }) async => null;

  @override
  Future<void> stopListening() async {}
}

/// fake 对话客户端：按脚本返回（docs/04 §6：录制的假响应做回归）。
class FakeChatClient implements AiChatClient, AiVisionClient {
  FakeChatClient(this.responses);

  final List<AiChatResult> responses;
  final List<AiChatRequest> requests = [];
  Object? throwOnCall;

  @override
  Future<AiChatResult> chat(
    AiChatRequest request, {
    required AiClientConfig config,
  }) async {
    requests.add(
      AiChatRequest(
        model: request.model,
        messages: List.unmodifiable(
          request.messages.map(
            (m) => AiProtocolMessage.fromResponseJson(m.toRequestJson()),
          ),
        ),
        tools: List.unmodifiable(request.tools),
        temperature: request.temperature,
        maxTokens: request.maxTokens,
        responseFormatJsonObject: request.responseFormatJsonObject,
      ),
    );
    if (throwOnCall != null) {
      throw throwOnCall!;
    }
    if (responses.isEmpty) {
      throw StateError('FakeChatClient 脚本用尽');
    }
    return responses.removeAt(0);
  }

  @override
  Future<AiChatResult> vision(
    AiChatRequest request, {
    required AiClientConfig config,
  }) => chat(request, config: config);
}

/// 构造一条纯文本响应。
AiChatResult textResult(String text) => AiChatResult(
  message: AiProtocolMessage(role: AiRole.assistant, content: text),
  finishReason: 'stop',
);

/// 构造一条带工具调用的响应。
AiChatResult toolCallResult(
  String callId,
  String name,
  Map<String, dynamic> args,
) => AiChatResult(
  message: AiProtocolMessage(
    role: AiRole.assistant,
    toolCalls: [
      AiToolCall(id: callId, name: name, argumentsJson: jsonEncode(args)),
    ],
  ),
  finishReason: 'tool_calls',
);
