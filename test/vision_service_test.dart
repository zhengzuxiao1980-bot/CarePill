import 'dart:typed_data';

import 'package:care_pill/ai/client/ai_models.dart';
import 'package:care_pill/ai/prompts/vision_prompts.dart';
import 'package:care_pill/core/exceptions.dart';
import 'package:care_pill/data/settings/app_settings.dart';
import 'package:care_pill/data/settings/key_value_store.dart';
import 'package:care_pill/domain/models/ai_model_config.dart';
import 'package:care_pill/domain/models/enums.dart';
import 'package:care_pill/domain/services/model_selection.dart';
import 'package:care_pill/domain/services/vision_service.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fakes/fakes.dart';

void main() {
  group('视觉抽取解析（docs/03 §6 输出契约）', () {
    test('合法输出 → 字段齐全', () {
      final result = parseVisionOutput('''
{"not_readable": false, "medication": {"name": "苯磺酸氨氯地平片", "form": "tablet",
 "spec": "5mg×30片", "dose_unit": "片", "usage_text": "每日一次，一次5mg",
 "per_dose": 1, "times": [{"time": "08:00", "dose": 1, "meal": "after"}],
 "frequency_hint": "每日一次", "notes": "请遵医嘱", "uncertain": ["spec"]}}''');
      final parsed = result as ExtractParsed;
      expect(parsed.payload.name, '苯磺酸氨氯地平片');
      expect(parsed.payload.form, MedicationForm.tablet);
      expect(parsed.payload.times, hasLength(1));
      expect(parsed.payload.times.first.meal, MealRelation.after);
      expect(parsed.payload.uncertain, contains('spec'));
      // usage_text 原样保留（幻觉防护 2）。
      expect(parsed.payload.usageText, '每日一次，一次5mg');
    });

    test('not_readable → 如实报告而不是猜', () {
      final result = parseVisionOutput('{"not_readable": true}');
      expect(result, isA<ExtractNotReadable>());
    });

    test('包了 markdown 代码块也能解析', () {
      final result = parseVisionOutput(
        '```json\n{"not_readable": false, "medication": {"name": "阿司匹林"}}\n```',
      );
      expect((result as ExtractParsed).payload.name, '阿司匹林');
    });

    test('文本混说明时提取第一个 JSON 对象', () {
      final result = parseVisionOutput(
        '好的，识别结果如下：{"not_readable": false, "medication": {"name": "布洛芬"}} 请核对。',
      );
      expect((result as ExtractParsed).payload.name, '布洛芬');
    });

    test('非法时刻被丢弃（字段级校验）', () {
      final result = parseVisionOutput(
        '{"not_readable": false, "medication": {"name": "X", "times": '
        '[{"time": "25:00"}, {"time": "08:00"}, {"time": "abc"}]}}',
      );
      expect((result as ExtractParsed).payload.times.map((t) => t.time), ['08:00']);
    });

    test('完全不是 JSON → AiException(parse)', () {
      expect(
        () => parseVisionOutput('我看不清这张图'),
        throwsA(isA<AiException>()),
      );
    });

    test('缺 medication 对象 → AiException(parse)', () {
      expect(
        () => parseVisionOutput('{"not_readable": false}'),
        throwsA(isA<AiException>()),
      );
    });
  });

  group('VisionService 流程', () {
    test('成功 → 草稿落库（pending，绝不直接生效）', () async {
      final draftRepo = InMemoryDraftRepository();
      final modelRepo = InMemoryModelConfigRepository();
      final now = DateTime(2026, 9, 28);
      await modelRepo.save(
        AiModelConfig(
          id: 'cfg-v',
          name: '视觉模型',
          baseUrl: 'https://example.com/v1',
          modelId: 'vision-model',
          supportsVision: true,
          usage: ModelUsage.vision,
          createdAt: now,
        ),
        apiKey: 'sk-v',
      );
      final client = FakeChatClient([
        AiChatResult(
          message: AiProtocolMessage(
            role: AiRole.assistant,
            content:
                '{"not_readable": false, "medication": {"name": "降压药", "times": [{"time": "08:00", "dose": 1}]}}',
          ),
        ),
      ]);
      final service = VisionService(
        visionClient: client,
        modelSelection: ModelSelectionService(
          modelConfigRepository: modelRepo,
          settingsService: SettingsServiceForTest(),
        ),
        draftRepository: draftRepo,
      );
      final outcome = await service.extractFromImage(
        jpegBytes: Uint8List.fromList([1, 2, 3]),
        photoPath: '/tmp/x.jpg',
      );
      expect(outcome, isA<VisionSuccess>());
      final draft = (outcome as VisionSuccess).draft;
      expect(draft.status, DraftStatus.pending);
      expect(draft.source, DraftSource.photo);
      expect(draft.payload.name, '降压药');
      expect(await draftRepo.pending(), hasLength(1));
    });

    test('模型报告不可读 → VisionNotReadable', () async {
      final service = VisionService(
        visionClient: FakeChatClient([
          AiChatResult(
            message: AiProtocolMessage(
              role: AiRole.assistant,
              content: '{"not_readable": true}',
            ),
          ),
        ]),
        modelSelection: ModelSelectionService(
          modelConfigRepository: _oneVisionModelRepo(),
          settingsService: SettingsServiceForTest(),
        ),
        draftRepository: InMemoryDraftRepository(),
      );
      final outcome =
          await service.extractFromImage(jpegBytes: Uint8List.fromList([1]));
      expect(outcome, isA<VisionNotReadable>());
    });

    test('解析失败重试一次后仍失败 → VisionFailure', () async {
      final client = FakeChatClient([
        AiChatResult(
          message: AiProtocolMessage(role: AiRole.assistant, content: '乱输出'),
        ),
        AiChatResult(
          message: AiProtocolMessage(role: AiRole.assistant, content: '还是乱输出'),
        ),
      ]);
      final service = VisionService(
        visionClient: client,
        modelSelection: ModelSelectionService(
          modelConfigRepository: _oneVisionModelRepo(),
          settingsService: SettingsServiceForTest(),
        ),
        draftRepository: InMemoryDraftRepository(),
      );
      final outcome = await service.extractFromImage(jpegBytes: Uint8List.fromList([1]));
      expect(outcome, isA<VisionFailure>());
      expect(client.requests.length, 2); // 首次 + 附错误重试 1 次
      // 重试消息带上次错误（docs/03 §6）。
      final retryText = client.requests[1].messages.last.content ?? '';
      expect(retryText, contains('上一次输出有错'));
    });

    test('prompt 含 JSON 契约与完整示例', () {
      expect(VisionPrompts.system, contains('not_readable'));
      expect(VisionPrompts.system, contains('usage_text'));
      expect(VisionPrompts.system, contains('uncertain'));
      expect(VisionPrompts.system, contains('"time": "08:00"'));
    });
  });
}

InMemoryModelConfigRepository _oneVisionModelRepo() {
  final repo = InMemoryModelConfigRepository();
  repo.save(
    AiModelConfig(
      id: 'cfg-v',
      name: '视觉模型',
      baseUrl: 'https://example.com/v1',
      modelId: 'vision-model',
      supportsVision: true,
      usage: ModelUsage.both,
      createdAt: DateTime(2026, 9, 28),
    ),
    apiKey: 'sk-v',
  );
  return repo;
}

class SettingsServiceForTest extends SettingsService {
  SettingsServiceForTest() : super(InMemoryKeyValueStore());
}
