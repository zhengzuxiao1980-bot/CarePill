import '../../core/app_constants.dart';
import '../../core/formatters.dart';
import '../../data/repositories/medication_repository.dart';
import '../models/dose_task.dart';
import '../models/enums.dart';
import '../models/schedule.dart';

/// 任务展开：把"计划（重复规则）"展开成"当天任务实例"（docs/05 §1）。
///
/// 纯函数、无 IO——是回归测试的安全网（docs/04 §6 测试策略）。
abstract final class TaskExpander {
  /// 展开某一天的全部任务。规则不生效（频率不符/暂停/超出疗程）返回空。
  static List<DoseTask> expandForDate({
    required List<MedicationSchedulePair> pairs,
    required DateTime date,
  }) {
    final tasks = <DoseTask>[];
    for (final pair in pairs) {
      final schedule = pair.schedule;
      if (!schedule.appliesOn(date)) {
        continue;
      }
      for (final slot in schedule.times) {
        if (!isValidHhMm(slot.time)) {
          // 脏数据不进任务表（录入侧已校验，这里兜底）。
          continue;
        }
        tasks.add(
          DoseTask(
            id: doseTaskId(schedule.id, date, slot.time),
            scheduleId: schedule.id,
            medicationId: pair.medication.id,
            scheduledDate: date.isoDate,
            scheduledTime: slot.time,
            plannedDose: slot.effectiveDose,
            status: DoseStatus.pending,
          ),
        );
      }
    }
    return tasks;
  }

  /// 未来 [days] 天（含今天）逐日展开。
  static List<DoseTask> expandRange({
    required List<MedicationSchedulePair> pairs,
    required DateTime from,
    int days = kExpansionDays,
  }) {
    final all = <DoseTask>[];
    for (var i = 0; i < days; i++) {
      all.addAll(expandForDate(pairs: pairs, date: from.add(Duration(days: i))));
    }
    return all;
  }
}

/// 任务 ID：确定性的 `{scheduleId}|{date}|{time}`，保证展开幂等（docs/05）。
String doseTaskId(String scheduleId, DateTime date, String time) =>
    '$scheduleId|${date.isoDate}|$time';

/// 按需药即时任务 ID（打卡时生成，时刻为打卡时间）。
String asNeededTaskId(String scheduleId, DateTime at) =>
    '$scheduleId|${at.isoDate}|${at.hhMm}';
