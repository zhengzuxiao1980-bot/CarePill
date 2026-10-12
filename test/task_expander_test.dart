import 'package:care_pill/core/formatters.dart';
import 'package:care_pill/data/repositories/medication_repository.dart';
import 'package:care_pill/domain/models/dose_task.dart';
import 'package:care_pill/domain/models/enums.dart';
import 'package:care_pill/domain/models/medication.dart';
import 'package:care_pill/domain/models/schedule.dart';
import 'package:care_pill/domain/services/task_expander.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final monday = DateTime(2026, 9, 28); // 周一
  final med = Medication(
    id: 'med-1',
    name: '降压药',
    form: MedicationForm.tablet,
    doseUnit: '片',
    source: MedicationSource.manual,
    status: MedicationStatus.active,
    createdAt: monday,
    updatedAt: monday,
  );

  MedicationSchedulePair pair(MedicationSchedule schedule) =>
      MedicationSchedulePair(medication: med, schedule: schedule);

  group('TaskExpander（docs/05 §1 计划→任务展开）', () {
    test('每天两个时刻 → 一天两条任务，ID 确定性', () {
      final schedule = MedicationSchedule(
        id: 'sch-1',
        medicationId: med.id,
        frequencyType: FrequencyType.daily,
        times: const [
          TimeSlot(time: '08:00', dose: 1),
          TimeSlot(time: '20:00', dose: 1),
        ],
        startDate: '2026-09-01',
        status: ScheduleStatus.active,
        createdAt: monday,
      );
      final tasks = TaskExpander.expandForDate(
        pairs: [pair(schedule)],
        date: monday,
      );
      expect(tasks, hasLength(2));
      expect(tasks[0].id, 'sch-1|2026-09-28|08:00');
      expect(tasks[1].scheduledTime, '20:00');
      expect(tasks.every((t) => t.status == DoseStatus.pending), isTrue);
    });

    test('指定星期：一三五在周二不展开', () {
      final schedule = MedicationSchedule(
        id: 'sch-week',
        medicationId: med.id,
        frequencyType: FrequencyType.weekdays,
        weekdays: const [1, 3, 5],
        times: const [TimeSlot(time: '09:00')],
        startDate: '2026-09-01',
        status: ScheduleStatus.active,
        createdAt: monday,
      );
      expect(
        TaskExpander.expandForDate(
          pairs: [pair(schedule)],
          date: monday, // 周一
        ),
        isNotEmpty,
      );
      expect(
        TaskExpander.expandForDate(
          pairs: [pair(schedule)],
          date: monday.add(const Duration(days: 1)), // 周二
        ),
        isEmpty,
      );
      expect(
        TaskExpander.expandForDate(
          pairs: [pair(schedule)],
          date: monday.add(const Duration(days: 2)), // 周三
        ),
        isNotEmpty,
      );
    });

    test('隔 N 天：锚点起算，跨月边界正确（docs/09 Q2 数据示例）', () {
      final schedule = MedicationSchedule(
        id: 'sch-interval',
        medicationId: med.id,
        frequencyType: FrequencyType.intervalDays,
        intervalDays: 2,
        anchorDate: '2026-09-28',
        times: const [TimeSlot(time: '08:00')],
        startDate: '2026-09-28',
        status: ScheduleStatus.active,
        createdAt: monday,
      );
      // 9/28、9/30、10/2 展开；9/29、10/1 不展开。
      expect(
        TaskExpander.expandForDate(pairs: [pair(schedule)], date: DateTime(2026, 9, 28)),
        isNotEmpty,
      );
      expect(
        TaskExpander.expandForDate(pairs: [pair(schedule)], date: DateTime(2026, 9, 29)),
        isEmpty,
      );
      expect(
        TaskExpander.expandForDate(pairs: [pair(schedule)], date: DateTime(2026, 9, 30)),
        isNotEmpty,
      );
      expect(
        TaskExpander.expandForDate(pairs: [pair(schedule)], date: DateTime(2026, 10, 1)),
        isEmpty,
      );
      expect(
        TaskExpander.expandForDate(pairs: [pair(schedule)], date: DateTime(2026, 10, 2)),
        isNotEmpty,
      );
    });

    test('按需药不进提醒队列（不展开）', () {
      final schedule = MedicationSchedule(
        id: 'sch-asneeded',
        medicationId: med.id,
        frequencyType: FrequencyType.asNeeded,
        times: const [],
        startDate: '2026-09-01',
        status: ScheduleStatus.active,
        createdAt: monday,
      );
      expect(
        TaskExpander.expandForDate(pairs: [pair(schedule)], date: monday),
        isEmpty,
      );
    });

    test('暂停 / 疗程结束 / 未到开始日 都不展开', () {
      final paused = MedicationSchedule(
        id: 's1',
        medicationId: med.id,
        frequencyType: FrequencyType.daily,
        times: const [TimeSlot(time: '08:00')],
        startDate: '2026-09-01',
        status: ScheduleStatus.paused,
        createdAt: monday,
      );
      final notStarted = MedicationSchedule(
        id: 's2',
        medicationId: med.id,
        frequencyType: FrequencyType.daily,
        times: const [TimeSlot(time: '08:00')],
        startDate: '2026-10-01',
        status: ScheduleStatus.active,
        createdAt: monday,
      );
      final ended = MedicationSchedule(
        id: 's3',
        medicationId: med.id,
        frequencyType: FrequencyType.daily,
        times: const [TimeSlot(time: '08:00')],
        startDate: '2026-09-01',
        endDate: '2026-09-27',
        status: ScheduleStatus.active,
        createdAt: monday,
      );
      expect(
        TaskExpander.expandForDate(pairs: [pair(paused)], date: monday),
        isEmpty,
      );
      expect(
        TaskExpander.expandForDate(pairs: [pair(notStarted)], date: monday),
        isEmpty,
      );
      expect(
        TaskExpander.expandForDate(pairs: [pair(ended)], date: monday),
        isEmpty,
      );
    });

    test('expandRange 覆盖未来 7 天（含今天）', () {
      final schedule = MedicationSchedule(
        id: 'sch-range',
        medicationId: med.id,
        frequencyType: FrequencyType.daily,
        times: const [TimeSlot(time: '08:00')],
        startDate: '2026-09-01',
        status: ScheduleStatus.active,
        createdAt: monday,
      );
      final tasks = TaskExpander.expandRange(
        pairs: [pair(schedule)],
        from: monday,
      );
      expect(tasks, hasLength(7));
      expect(tasks.last.scheduledDate, monday.add(const Duration(days: 6)).isoDate);
    });
  });

  group('状态机（docs/05 §2）', () {
    test('pending 可打卡/可跳过', () {
      expect(DoseStatus.pending.allows(DoseAction.take), isTrue);
      expect(DoseStatus.pending.allows(DoseAction.skip), isTrue);
      expect(DoseStatus.pending.allows(DoseAction.undo), isFalse);
    });
    test('taken/skipped 只能撤销', () {
      expect(DoseStatus.taken.allows(DoseAction.undo), isTrue);
      expect(DoseStatus.taken.allows(DoseAction.take), isFalse);
      expect(DoseStatus.skipped.allows(DoseAction.undo), isTrue);
      expect(DoseStatus.skipped.allows(DoseAction.skip), isFalse);
    });
    test('missed 只能补记为 taken', () {
      expect(DoseStatus.missed.allows(DoseAction.take), isTrue);
      expect(DoseStatus.missed.allows(DoseAction.undo), isFalse);
      expect(DoseStatus.missed.allows(DoseAction.skip), isFalse);
      expect(
        DoseStatus.missed.transition(DoseAction.take),
        DoseStatus.taken,
      );
    });
  });
}
