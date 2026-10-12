import 'dart:async';

import 'package:care_pill/ai/client/ai_client.dart';
import 'package:care_pill/ai/client/ai_models.dart';
import 'package:care_pill/ai/tools/tool_registry.dart';
import 'package:care_pill/data/repositories/agent_store.dart';
import 'package:care_pill/data/settings/app_settings.dart';
import 'package:care_pill/data/settings/key_value_store.dart';
import 'package:care_pill/domain/models/ai_model_config.dart';
import 'package:care_pill/domain/models/enums.dart';
import 'package:care_pill/domain/models/medication_draft.dart';
import 'package:care_pill/domain/models/schedule.dart';
import 'package:care_pill/domain/services/agent_service.dart';
import 'package:care_pill/domain/services/dose_service.dart';
import 'package:care_pill/domain/services/medication_service.dart';
import 'package:care_pill/domain/services/memory_service.dart';
import 'package:care_pill/domain/services/model_selection.dart';

import 'fakes.dart';

class ScriptedClient implements AiChatClient {
  ScriptedClient(this.script);
  final List<Object> script;
  final requests = <AiChatRequest>[];
  FutureOr<AiChatResult> Function(AiChatRequest)? responder;
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
        maxTokens: request.maxTokens,
      ),
    );
    if (responder != null) return responder!(request);
    final value = script.removeAt(0);
    if (value is AiChatResult) return value;
    if (value is Future<AiChatResult>) return value;
    throw value;
  }
}

class AgentFixture {
  final now = DateTime(2026, 10, 7, 10);
  final meds = InMemoryMedicationRepository();
  final tasks = InMemoryDoseTaskRepository();
  final chats = InMemoryChatRepository();
  final models = InMemoryModelConfigRepository();
  final drafts = InMemoryDraftRepository();
  final AgentStore store;
  final settings = SettingsService(InMemoryKeyValueStore());
  late final DoseService dose;
  late final MedicationService medication;
  late final MemoryService memory;
  late final ToolRegistry tools;
  AgentFixture({AgentStore? store}) : store = store ?? InMemoryAgentStore();
  Future<void> initialize({bool native = true}) async {
    dose = DoseService(
      taskRepository: tasks,
      medicationRepository: meds,
      clock: () => now,
    );
    medication = MedicationService(
      medicationRepository: meds,
      taskRepository: tasks,
      clock: () => now,
    );
    memory = MemoryService(store);
    tools = ToolRegistry(
      doseService: dose,
      medicationService: medication,
      memories: memory,
      draftSaver: (payload) async {
        final id = 'draft-${drafts.drafts.length}';
        await drafts.save(
          MedicationDraft(
            id: id,
            source: DraftSource.chat,
            payload: payload,
            status: DraftStatus.pending,
            createdAt: now,
          ),
        );
        return DraftUpsert(draftId: id);
      },
    );
    await models.save(
      AiModelConfig(
        id: 'model',
        name: 'Fixture',
        baseUrl: 'https://example.test/v1',
        modelId: 'test',
        usage: ModelUsage.chat,
        supportsFunctionCalling: native,
        createdAt: now,
      ),
      apiKey: 'test-key',
    );
    await medication.createManual(
      name: '测试药',
      form: MedicationForm.tablet,
      doseUnit: '片',
      scheduleInputs: [
        ScheduleDraftInput(
          frequencyType: FrequencyType.daily,
          times: const [
            TimeSlot(time: '08:00', dose: 1),
            TimeSlot(time: '20:00', dose: 1),
          ],
        ),
      ],
    );
    await dose.expandTasks();
  }

  AgentService agent(AiChatClient client) => AgentService(
    chatClient: client,
    modelSelection: ModelSelectionService(
      modelConfigRepository: models,
      settingsService: settings,
    ),
    toolRegistry: tools,
    chatRepository: chats,
    doseService: dose,
    store: store,
    clock: () => now,
  );
  Future<String> taskId() async =>
      (await tasks.tasksForDate('2026-10-07')).first.id;
}
