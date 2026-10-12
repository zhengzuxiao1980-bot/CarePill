import 'package:freezed_annotation/freezed_annotation.dart';

import '../../core/exceptions.dart';
import '../../core/formatters.dart';
import 'enums.dart';

part 'schedule.freezed.dart';
part 'schedule.g.dart';

/// 计划内的一个时刻：时间 + 本次剂量 + 餐前/餐中/餐后（docs/05）。
///
/// 存储格式（times_json 数组元素）：
/// `{"time":"08:00","dose":1.0,"meal":"after"}`
@freezed
sealed class TimeSlot with _$TimeSlot {
  const factory TimeSlot({
    /// HH:mm。
    @JsonKey(name: 'time') required String time,

    @JsonKey(name: 'dose', includeIfNull: false) double? dose,

    @JsonKey(name: 'meal', includeIfNull: false)
    MealRelation? meal,
  }) = _TimeSlot;

  factory TimeSlot.fromJson(Map<String, dynamic> json) =>
      _$TimeSlotFromJson(json);
}

extension TimeSlotX on TimeSlot {
  double get effectiveDose => dose ?? 1.0;

  /// 字段级校验（docs/03 §6：时刻 HH:mm、剂量为正数）。
  void validate() {
    if (!isValidHhMm(time)) {
      throw ValidationException('time', cause: '非法时刻: $time');
    }
    final d = dose;
    if (d != null && d <= 0) {
      throw ValidationException('dose', cause: '剂量必须为正数: $d');
    }
  }
}

/// 用药计划（docs/05 §2 medication_schedules 表）。
///
/// 建模决策（docs/09 Q2）：**单计划多时刻**——一个药品的多个时刻放在同一条
/// 计划的 times 里；规则永久不变更，改计划 = 新的任务展开（ADR-001）。
@freezed
sealed class MedicationSchedule with _$MedicationSchedule {
  const factory MedicationSchedule({
    required String id,
    required String medicationId,

    required FrequencyType frequencyType,

    /// frequencyType=weekdays 时用，如 [1,3,5]（周一=1）。
    List<int>? weekdays,

    /// 隔 N 天，配 anchorDate 计算。
    int? intervalDays,

    /// 间隔计算锚点（ISO 日期）。
    String? anchorDate,

    /// 时刻数组；as_needed 为空。
    @Default([])
    @JsonKey(name: 'times')
    List<TimeSlot> times,

    /// 计划级默认餐前/餐中/餐后（时刻级未指定时生效）。
    MealRelation? mealRelation,

    /// 生效起始日（ISO 日期）。
    required String startDate,

    /// 疗程结束（可空=长期）。
    String? endDate,

    required ScheduleStatus status,
    required DateTime createdAt,
  }) = _MedicationSchedule;

  factory MedicationSchedule.fromJson(Map<String, dynamic> json) =>
      _$MedicationScheduleFromJson(json);
}

extension MedicationScheduleX on MedicationSchedule {
  /// 该计划在 [date] 当天是否生效（频率 + 起止日期）。
  ///
  /// 纯函数，是任务展开（docs/05 §1）的核心；as_needed 不进提醒队列。
  bool appliesOn(DateTime date) {
    if (status != ScheduleStatus.active) {
      return false;
    }
    final start = parseIsoDate(startDate);
    if (date.isBefore(start)) {
      return false;
    }
    final end = endDate;
    if (end != null && date.isAfter(parseIsoDate(end))) {
      return false;
    }
    return switch (frequencyType) {
      FrequencyType.asNeeded => false,
      FrequencyType.daily => true,
      FrequencyType.weekdays =>
        weekdays != null && weekdays!.contains(date.weekdayMonday1),
      FrequencyType.intervalDays => _matchesInterval(date),
    };
  }

  bool _matchesInterval(DateTime date) {
    final n = intervalDays;
    if (n == null || n <= 0 || anchorDate == null) {
      return false;
    }
    final anchor = parseIsoDate(anchorDate!);
    final diff = date.difference(anchor.dateOnly).inDays;
    if (diff < 0) {
      return false;
    }
    return diff % n == 0;
  }
}
