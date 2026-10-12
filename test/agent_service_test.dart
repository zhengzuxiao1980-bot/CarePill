import 'package:care_pill/ai/client/ai_models.dart';
import 'package:care_pill/ai/tools/rule_intent.dart';
import 'package:care_pill/ai/tools/tool_registry.dart';
import 'package:care_pill/core/exceptions.dart';
import 'package:care_pill/core/formatters.dart';
import 'package:care_pill/data/settings/app_settings.dart';
import 'package:care_pill/data/settings/key_value_store.dart';
import 'package:care_pill/domain/models/ai_model_config.dart';
import 'package:care_pill/domain/models/dose_task.dart';
import 'package:care_pill/domain/models/enums.dart';
import 'package:care_pill/domain/models/medication_draft.dart';
import 'package:care_pill/domain/models/schedule.dart';
import 'package:care_pill/domain/services/agent_service.dart';
import 'package:care_pill/domain/services/dose_service.dart';
import 'package:care_pill/domain/services/medication_service.dart';
import 'package:care_pill/domain/services/model_selection.dart';
import 'package:care_pill/domain/services/task_expander.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fakes/fakes.dart';

void main() {
  final now = DateTime(2026, 9, 28, 10, 0);

  late InMemoryMedicationRepository medRepo;
  late InMemoryDoseTaskRepository taskRepo;
  late InMemoryChatRepository chatRepo;
  late InMemoryModelConfigRepository modelRepo;
  late InMemoryDraftRepository draftRepo;
  late DoseService dose;
  late MedicationService meds;
  late ToolRegistry tools;
  late SettingsService settings;
  late String scheduleId;
  int draftSeq = 0;

  setUp(() async {
    medRepo = InMemoryMedicationRepository();
    taskRepo = InMemoryDoseTaskRepository();
    chatRepo = InMemoryChatRepository();
    modelRepo = InMemoryModelConfigRepository();
    draftRepo = InMemoryDraftRepository();
    settings = SettingsService(InMemoryKeyValueStore());

    await modelRepo.save(
      AiModelConfig(
        id: 'cfg-1',
        name: '测试模型',
        baseUrl: 'https://example.com/v1',
        modelId: 'test-model',
        supportsChat: true,
        supportsFunctionCalling: true,
        usage: ModelUsage.chat,
        isChatDefault: true,
        createdAt: now,
      ),
      apiKey: 'sk-test',
    );

    meds = MedicationService(
      medicationRepository: medRepo,
      taskRepository: taskRepo,
      clock: () => now,
    );
    dose = DoseService(
      taskRepository: taskRepo,
      medicationRepository: medRepo,
      clock: () => now,
    );
    tools = ToolRegistry(
      doseService: dose,
      medicationService: meds,
      draftSaver: (payload) async {
        final draft = MedicationDraft(
          id: 'draft-test-${draftSeq++}',
          source: DraftSource.chat,
          payload: payload,
          status: DraftStatus.pending,
          createdAt: now,
        );
        await draftRepo.save(draft);
        return DraftUpsert(draftId: draft.id);
      },
    );

    // 造数据：降压药 每天 8:00/20:00，今天 8 点已服。
    await meds.createManual(
      name: '降压药',
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
    scheduleId = (await medRepo.allSchedules()).first.id;
    await dose.expandTasks();
    await dose.markTaken(
      doseTaskId(scheduleId, now, '08:00'),
      at: DateTime(2026, 9, 28, 8, 5),
    );
  });

  AgentService buildAgent(FakeChatClient client) {
    return AgentService(
      chatClient: client,
      modelSelection: ModelSelectionService(
        modelConfigRepository: modelRepo,
        settingsService: settings,
      ),
      toolRegistry: tools,
      chatRepository: chatRepo,
      doseService: dose,
      clock: () => now,
    );
  }

  group('Agent 执行环（docs/03 §4）', () {
    test('原生函数调用：问"今天吃没吃药" → 查询工具 → 自然语言回答', () async {
      final client = FakeChatClient([
        toolCallResult('call-1', 'get_dose_status', {}),
        textResult('吃过了：早上的降压药 8 点 5 分吃的。晚上 8 点的还没到点，到时候我提醒您。'),
      ]);
      final agent = buildAgent(client);
      final result = await agent.handleUserInput('我今天吃药了吗');

      expect(result.reply, contains('降压药'));
      // 第一轮请求带原生工具表。
      expect(client.requests.first.tools, isNotEmpty);
      // 第二轮（工具结果回传）是 tool 角色消息。
      final second = client.requests[1].messages;
      expect(
        second.any((m) => m.role == AiRole.tool && m.toolCallId == 'call-1'),
        isTrue,
      );
      // 对话已留痕：user + assistant。
      expect(chatRepo.messages.length, 2);
      expect(chatRepo.messages.last.role, ChatRole.assistant);
    });

    test('AI 代办打卡：写工具执行 + 返回可撤销事件', () async {
      final client = FakeChatClient([
        toolCallResult('call-1', 'mark_dose_taken', {
          'task_id': doseTaskId(scheduleId, now, '20:00'),
          'note': '刚才吃的',
        }),
        textResult('记上了！降压药，晚上 8 点，1 片。'),
      ]);
      final agent = buildAgent(client);
      final result = await agent.handleUserInput('帮我记上刚吃过降压药了');

      expect(result.writes, hasLength(1));
      expect(result.writes.first.kind, 'taken');
      // 20:00 的任务已变 taken（10 点代办，超宽限期 → catch_up）。
      final task = await taskRepo.get(doseTaskId(scheduleId, now, '20:00'));
      expect(task!.isTaken, isTrue);
      expect(task.markSource, MarkSource.ai);
    });

    test('写工具限制：只能改当天与昨天', () async {
      final registry = tools;
      final outcome = await registry.execute('mark_dose_taken', {
        'task_id': doseTaskId(
          scheduleId,
          now.subtract(const Duration(days: 3)),
          '08:00',
        ),
      });
      expect(outcome.ok, isFalse);
      expect(outcome.data['error'], contains('只能记今天和昨天'));
    });
  });

  group('降级链（docs/03 §5）', () {
    test('未勾选函数调用 → JSON 协议模式（无原生工具表）', () async {
      final config = await modelRepo.get('cfg-1');
      await modelRepo.save(config!.copyWith(supportsFunctionCalling: false));

      final client = FakeChatClient([
        // 模型输出 JSON 协议的工具调用。
        AiChatResult(
          message: AiProtocolMessage(
            role: AiRole.assistant,
            content: '{"tool": "get_next_dose", "args": {}}',
          ),
        ),
        textResult('下一顿是晚上 8 点的降压药，1 片，到时候我提醒您。'),
      ]);
      final agent = buildAgent(client);
      final result = await agent.handleUserInput('下一个吃什么');

      expect(result.reply, contains('降压药'));
      // 第一轮不带原生 tools。
      expect(client.requests.first.tools, isEmpty);
      // 第二轮带 [工具结果] 的用户消息。
      final secondMessages = client.requests[1].messages;
      expect(
        secondMessages.any((m) => (m.content ?? '').contains('[工具结果]')),
        isTrue,
      );
    });

    test('勾选了函数调用但服务报协议错 → 自动落 JSON 协议并重试', () async {
      final client = FakeChatClient([
        AiChatResult(message: const AiProtocolMessage(role: AiRole.assistant)),
      ]);
      client.throwOnCall = const AiException(
        AiErrorCode.capabilityMissing,
        cause: 'tools not supported',
      );

      final agent = buildAgent(client);
      // 抛错时两次都是 throwOnCall → 期待 handleUserInput 抛出（重试也失败）。
      final result = await agent.handleUserInput('今天吃了吗');
      expect(result.error, isA<AiException>());
      expect(result.turnId, isNotNull);
      // 至少发起了两轮请求（原生失败后降级重试了一次）。
      expect(client.requests.length, greaterThanOrEqualTo(2));
    });

    test('JSON 协议也不奏效 → 规则意图兜底', () async {
      final config = await modelRepo.get('cfg-1');
      await modelRepo.save(config!.copyWith(supportsFunctionCalling: false));

      final client = FakeChatClient([
        // 模型两次都想调工具但输出坏 JSON。
        textResult('好的 {"tool": "get_next_dose"'),
        textResult('{"tool": "get_next_dose",'),
        textResult('下一顿是晚上 8 点的降压药，1 片，到时候我提醒您。'),
      ]);
      final agent = buildAgent(client);
      final result = await agent.handleUserInput('下一个吃什么');
      expect(result.usedFallbackIntent, isTrue);
      expect(result.reply, contains('降压药'));
    });
  });

  group('规则意图匹配（本地，无模型）', () {
    test('吃没吃 → get_dose_status', () {
      final intent = RuleIntentMatcher.match('我今天吃药了吗');
      expect(intent!.tool, 'get_dose_status');
    });
    test('下一个 → get_next_dose', () {
      final intent = RuleIntentMatcher.match('接下来该吃什么药');
      expect(intent!.tool, 'get_next_dose');
    });
    test('记一下+药名+时间 → mark_dose_taken', () {
      final intent = RuleIntentMatcher.match(
        '帮我记上早上 8 点吃过降压药了',
        medicationNames: const ['降压药'],
      );
      expect(intent!.tool, 'mark_dose_taken');
      expect(intent.args['medication_name'], '降压药');
      // "早上 8 点"→ 今天 08:00（时间无关断言，跨午夜也成立）。
      expect(intent.args['when'], '${DateTime.now().isoDate} 08:00');
    });
    test('急症识别', () {
      expect(RuleIntentMatcher.isEmergency('我胸口疼'), isTrue);
      expect(RuleIntentMatcher.isEmergency('今天天气不错'), isFalse);
    });
    test('医疗建议边界', () {
      expect(RuleIntentMatcher.isMedicalAdviceQuestion('这药能停吗'), isTrue);
    });
  });

  group('安全边界与配置缺失', () {
    test('无可用模型 → notConfigured（入口应引导，docs/03 §3）', () async {
      await modelRepo.delete('cfg-1');
      final agent = buildAgent(FakeChatClient([]));
      await expectLater(
        agent.handleUserInput('今天吃了吗'),
        throwsA(
          isA<AiException>().having(
            (e) => e.code,
            'code',
            AiErrorCode.notConfigured,
          ),
        ),
      );
    });
  });
}
