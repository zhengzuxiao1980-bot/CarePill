import 'package:freezed_annotation/freezed_annotation.dart';

import 'enums.dart';

part 'medication.freezed.dart';

/// 药品（docs/05 §2 medications 表）。
///
/// 停用走 status=archived，不物理删除，保留历史统计完整性。
@freezed
sealed class Medication with _$Medication {
  const factory Medication({
    required String id,
    required String name,

    required MedicationForm form,

    /// 规格，如 "5mg×30片"。
    String? spec,

    /// 打卡剂量单位：片/粒/毫升/喷/支。
    required String doseUnit,

    /// 备注（医嘱原文等）。
    String? notes,

    /// 药盒照片（本地文件路径）。
    String? photoPath,

    required MedicationSource source,

    /// AI 识别原始输出（纠错与回溯用）。
    String? aiExtractJson,

    required MedicationStatus status,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Medication;
}
