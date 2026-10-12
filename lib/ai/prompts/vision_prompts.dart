import '../../core/exceptions.dart';
import '../../core/formatters.dart';
import '../../domain/models/enums.dart';
import '../../domain/models/medication_draft.dart';
import '../../domain/models/schedule.dart';
import '../client/ai_models.dart';

/// 视觉抽取 Prompt 与输出校验（docs/03 §6）。
abstract final class VisionPrompts {
  /// 系统指令：药品说明书/药盒结构化抽取。
  static const String system = '''
你是药品信息抽取器。从用户拍的药盒或说明书照片中抽取结构化信息。
规则：
1. 只输出一个 JSON 对象，不要输出任何别的文字，不要用代码块。
2. 照片模糊、拍不到关键信息时，输出 {"not_readable": true}，绝对不要猜。
3. 看不清的字段用 null，不要编造。
4. "usage_text" 必须原样保留照片上的用法用量文字。
5. 不确定哪一项准确的，把字段名（如 "name"、"times"）放进 "uncertain" 数组。

输出 JSON 结构：
{
  "not_readable": false,
  "medication": {
    "name": "药品名",
    "form": "tablet|capsule|liquid|patch|spray|injection|other",
    "spec": "规格，如 5mg×30片",
    "dose_unit": "片|粒|毫升|喷|支",
    "usage_text": "用法用量原文",
    "per_dose": 1,
    "times": [{"time": "08:00", "dose": 1, "meal": "before|with|after"}],
    "frequency_hint": "频次原文，如 每日两次",
    "notes": "注意事项原文",
    "uncertain": []
  }
}

完整示例：
{"not_readable": false, "medication": {"name": "苯磺酸氨氯地平片", "form": "tablet", "spec": "5mg×30片", "dose_unit": "片", "usage_text": "通常起始剂量为5mg，每日一次", "per_dose": 1, "times": [{"time": "08:00", "dose": 1, "meal": "after"}], "frequency_hint": "每日一次", "notes": "请遵医嘱", "uncertain": []}}''';

  /// 用户消息正文。
  static const String instruction =
      '请抽取这张药盒/说明书照片里的药品信息，按约定 JSON 输出。';

  /// 重试消息：附上次错误（docs/03 §6：解析失败重试 1 次）。
  static String retryInstruction(String error) =>
      '$instruction\n\n上一次输出有错：$error。请修正后重新只输出 JSON。';
}

/// 解析结果：不可读（模型如实报告）/ 成功。
sealed class VisionExtractResult {
  const VisionExtractResult();

  const factory VisionExtractResult.notReadable() = ExtractNotReadable;
  const factory VisionExtractResult.ok(MedicationDraftPayload payload) =
      ExtractParsed;
}

class ExtractNotReadable extends VisionExtractResult {
  const ExtractNotReadable() : super();
}

class ExtractParsed extends VisionExtractResult {
  const ExtractParsed(this.payload) : super();

  final MedicationDraftPayload payload;
}

/// 从原始文本解析（供 VisionService 与测试复用）。
///
/// 抛 [AiException(parse)]（输出不是 JSON / 缺对象）；时刻非法的字段直接丢弃。
VisionExtractResult parseVisionOutput(String rawText) {
  Map<String, dynamic> json;
  try {
    json = jsonDecodeSafe(rawText);
  } on FormatException {
    final extracted = extractJsonObject(rawText);
    if (extracted == null) {
      throw AiException(
        AiErrorCode.parse,
        cause: '输出不是 JSON：${rawText.length} 字',
      );
    }
    json = extracted;
  }

  if (json['not_readable'] == true) {
    return const ExtractNotReadable();
  }
  final med = json['medication'];
  if (med is! Map<String, dynamic>) {
    throw const AiException(AiErrorCode.parse, cause: '缺少 medication 对象');
  }
  // 字段级校验（docs/03 §6）：时刻 HH:mm、剂量为正数。
  final rawTimes = med['times'];
  final times = <TimeSlot>[];
  if (rawTimes is List) {
    for (final t in rawTimes) {
      if (t is! Map<String, dynamic>) {
        continue;
      }
      final time = t['time'];
      if (time is! String || !isValidHhMm(time)) {
        continue;
      }
      final doseRaw = t['dose'];
      final dose = doseRaw is num ? doseRaw.toDouble() : null;
      if (dose != null && dose <= 0) {
        continue;
      }
      times.add(
        TimeSlot(
          time: time,
          dose: dose,
          meal: MealRelation.tryFromJsonString(t['meal'] as String?),
        ),
      );
    }
  }
  final formText = med['form'];
  final payload = MedicationDraftPayload(
    name: med['name'] is String ? med['name'] as String : null,
    form: formText is String
        ? MedicationForm.values.where((f) => f.json == formText).firstOrNull
        : null,
    spec: med['spec'] is String ? med['spec'] as String : null,
    doseUnit: med['dose_unit'] is String ? med['dose_unit'] as String : null,
    usageText: med['usage_text'] is String ? med['usage_text'] as String : null,
    perDose: med['per_dose'] is num ? (med['per_dose'] as num).toDouble() : null,
    times: times,
    frequencyHint:
        med['frequency_hint'] is String ? med['frequency_hint'] as String : null,
    notes: med['notes'] is String ? med['notes'] as String : null,
    uncertain: (med['uncertain'] as List<dynamic>? ?? const [])
        .whereType<String>()
        .toList(),
  );
  return ExtractParsed(payload);
}
