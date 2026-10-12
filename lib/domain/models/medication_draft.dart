import 'package:freezed_annotation/freezed_annotation.dart';

import 'enums.dart';
import 'schedule.dart';

part 'medication_draft.freezed.dart';
part 'medication_draft.g.dart';

/// 识别/对话产生的药品草稿结构（docs/03 §6 抽取目标字段）。
///
/// 一切识别结果只是草稿；确认页是强制步骤，绝不经确认直接写入（docs/03 §6）。
@freezed
sealed class MedicationDraftPayload with _$MedicationDraftPayload {
  const factory MedicationDraftPayload({
    @JsonKey(name: 'name') String? name,

    @JsonKey(name: 'form')
    MedicationForm? form,

    @JsonKey(name: 'spec') String? spec,

    @JsonKey(name: 'dose_unit') String? doseUnit,

    /// 用法用量原文——必须原样保留并在确认页展示，供对照原图核对。
    @JsonKey(name: 'usage_text') String? usageText,

    @JsonKey(name: 'per_dose') double? perDose,

    @JsonKey(name: 'times') @Default([]) List<TimeSlot> times,

    /// 频次原文，如"每日两次"。
    @JsonKey(name: 'frequency_hint') String? frequencyHint,

    /// 注意事项原文。
    @JsonKey(name: 'notes') String? notes,

    /// 置信存疑字段名列表，确认页高亮"请核对"（docs/03 §6）。
    @JsonKey(name: 'uncertain') @Default([]) List<String> uncertain,
  }) = _MedicationDraftPayload;

  factory MedicationDraftPayload.fromJson(Map<String, dynamic> json) =>
      _$MedicationDraftPayloadFromJson(json);
}

/// 视觉模型的抽取输出契约（docs/03 §6）。
///
/// 照片拍不清时要求模型输出 `{"not_readable": true}` 而不是猜。
@freezed
sealed class VisionExtractResult with _$VisionExtractResult {
  const factory VisionExtractResult({
    @JsonKey(name: 'not_readable') @Default(false) bool notReadable,
    @JsonKey(name: 'medication') MedicationDraftPayload? medication,
  }) = _VisionExtractResult;

  factory VisionExtractResult.fromJson(Map<String, dynamic> json) =>
      _$VisionExtractResultFromJson(json);
}

/// 草稿箱实体（docs/05 §2 medication_drafts 表）。
@freezed
sealed class MedicationDraft with _$MedicationDraft {
  const factory MedicationDraft({
    required String id,
    required DraftSource source,
    required MedicationDraftPayload payload,
    String? photoPath,
    required DraftStatus status,
    required DateTime createdAt,
  }) = _MedicationDraft;
}
