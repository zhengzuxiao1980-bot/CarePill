import 'package:care_pill/core/formatters.dart';
import 'package:care_pill/domain/models/dose_task.dart';
import 'package:care_pill/domain/models/enums.dart';
import 'package:care_pill/domain/models/medication.dart';
import 'package:care_pill/domain/models/schedule.dart';
import 'package:care_pill/domain/models/stats.dart';
import 'package:care_pill/domain/services/dose_service.dart';
import 'package:care_pill/domain/services/task_expander.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fakes/fakes.dart';

void main() {
  late InMemoryMedicationRepository medRepo;
  late InMemoryDoseTaskRepository taskRepo;
  late DoseService service;
  late DateTime now;

  // 统一基准：2026-09-28（周一）10:00。
  DateTime fixedNow() => DateTime(2026, 9, 28, 10, 0);

  Medication med({
    String id = 'med-1',
    String name = '降压药',
  }) =>
      Medication(
        id: id,
        name: name,
        form: MedicationForm.tablet,
        doseUnit: '片',
        source: MedicationSource.manual,
        status: MedicationStatus.active,
        createdAt: fixedNow(),
        updatedAt: fixedNow(),
      );

  MedicationSchedule dailySchedule({
    String id = 'sch-1',
    String medicationId = 'med-1',
    List<TimeSlot> times = const [TimeSlot(time: '08:00', dose: 1)],
  }) =>
      MedicationSchedule(
        id: id,
        medicationId: medicationId,
        frequencyType: FrequencyType.daily,
        times: times,
        startDate: '2026-09-01',
        status: ScheduleStatus.active,
        createdAt: fixedNow(),
      );

  setUp(() async {
    now = fixedNow();
    medRepo = InMemoryMedicationRepository();
    taskRepo = InMemoryDoseTaskRepository();
    await medRepo.save(med());
    await medRepo.saveSchedule(dailySchedule());
    service = DoseService(
      taskRepository: taskRepo,
      medicationRepository: medRepo,
      clock: () => now,
    );
  });

  group('任务展开与幂等', () {
    test('展开 7 天：每天 1 条；重跑不产生重复', () async {
      final report1 = await service.expandTasks();
      expect(report1.created, 7);
      final today = await taskRepo.tasksForDate(now.dateOnly.isoDate);
      expect(today, hasLength(1));
      expect(today.first.scheduledTime, '08:00');

      final report2 = await service.expandTasks();
      expect(report2.created, 7); // upsertMissing 不覆盖已有
      expect((await taskRepo.tasksForDate(now.dateOnly.isoDate)).length, 1);
    });

    test('已打卡的终态任务在重展开后保留（docs/05 §4 安全网）', () async {
      await service.expandTasks();
      final taskId = doseTaskId('sch-1', now, '08:00');
      await service.markTaken(taskId, at: now);

      await service.expandTasks(); // 规则没变；即使重跑也不丢
      final task = await taskRepo.get(taskId);
      expect(task!.isTaken, isTrue);
    });

    test('规则变更后清理过期展开结果', () async {
      await service.expandTasks();
      // 改成 09:00。
      await medRepo.saveSchedule(
        dailySchedule(times: const [TimeSlot(time: '09:00', dose: 1)]),
      );
      await service.expandTasks();
      final today = await taskRepo.tasksForDate(now.dateOnly.isoDate);
      expect(today.map((t) => t.scheduledTime), ['09:00']);
    });
  });

  group('状态机与打卡（docs/06 §3）', () {
    test('按点打卡 → taken，来源保留', () async {
      await service.expandTasks();
      // 10:00 打卡 08:00 的药 → 在 60 分钟宽限期外？8 点+60=9 点 < 10 点，
      // 应判 catch_up。
      final taskId = doseTaskId('sch-1', now, '08:00');
      final updated = await service.markTaken(taskId, at: now);
      expect(updated.isTaken, isTrue);
      expect(updated.isCatchUp, isTrue); // 超过宽限期
    });

    test('宽限期内打卡 = 按点吃', () async {
      await service.expandTasks();
      now = DateTime(2026, 9, 28, 8, 30); // 真正在 8:30 打卡
      final taskId = doseTaskId('sch-1', now, '08:00');
      final updated = await service.markTaken(taskId, at: now);
      expect(updated.isCatchUp, isFalse);
      expect(updated.markSource, MarkSource.tap);
    });

    test('漏服判定：过宽限期 pending → missed；补记为 catch_up', () async {
      await service.expandTasks();
      now = now.add(const Duration(hours: 3)); // 13:00
      final marked = await service.applyMissedSweep(graceMinutes: 60);
      expect(marked, 1);
      final taskId = doseTaskId('sch-1', now, '08:00');
      var task = await taskRepo.get(taskId);
      expect(task!.isMissed, isTrue);

      final caught = await service.markTaken(taskId, at: now);
      expect(caught.isTaken, isTrue);
      expect(caught.markSource, MarkSource.catchUp);

      task = await taskRepo.get(taskId);
      expect(task!.isCatchUp, isTrue);
    });

    test('跨天补记昨天的 → catch_up', () async {
      await service.expandTasks();
      final yesterday = now.subtract(const Duration(days: 1));
      // 展开昨天的任务（模拟昨天已生成）。
      await taskRepo.upsertMissing(
        TaskExpander.expandForDate(
          pairs: await medRepo.activePairs(),
          date: yesterday,
        ),
      );
      final yTaskId = doseTaskId('sch-1', yesterday, '08:00');
      final updated = await service.markTaken(
        yTaskId,
        at: now, // 今天补记
      );
      expect(updated.isCatchUp, isTrue);
    });

    test('撤销：taken → pending，清空打卡痕迹', () async {
      await service.expandTasks();
      now = DateTime(2026, 9, 28, 8, 5);
      final taskId = doseTaskId('sch-1', now, '08:00');
      await service.markTaken(taskId, at: now);
      final undone = await service.undo(taskId);
      expect(undone.isPending, isTrue);
      expect(undone.takenAt, isNull);
      expect(undone.markSource, isNull);
    });

    test('跳过与撤销', () async {
      await service.expandTasks();
      final taskId = doseTaskId('sch-1', now, '08:00');
      final skipped = await service.skip(taskId, reason: '副作用');
      expect(skipped.isSkipped, isTrue);
      expect(skipped.note, '副作用');
      final undone = await service.undo(taskId);
      expect(undone.isPending, isTrue);
    });

    test('对 taken 再打卡被状态机拒绝', () async {
      await service.expandTasks();
      now = DateTime(2026, 9, 28, 8, 5);
      final taskId = doseTaskId('sch-1', now, '08:00');
      await service.markTaken(taskId, at: now);
      expect(
        () => service.markTaken(taskId, at: now),
        throwsStateError,
      );
    });

    test('按需药打卡生成当天已服记录', () async {
      await medRepo.save(med(id: 'med-2', name: '止痛药'));
      await medRepo.saveSchedule(
        MedicationSchedule(
          id: 'sch-2',
          medicationId: 'med-2',
          frequencyType: FrequencyType.asNeeded,
          times: const [],
          startDate: '2026-09-01',
          status: ScheduleStatus.active,
          createdAt: fixedNow(),
        ),
      );
      final task = await service.logAsNeeded('med-2', dose: 1);
      expect(task.isTaken, isTrue);
      expect(task.scheduledDate, now.dateOnly.isoDate);
    });
  });

  group('统计（docs/02 F9）', () {
    test('依从率口径：已服/（应服-跳过）', () async {
      await service.expandTasks();
      await service.markTaken(
        doseTaskId('sch-1', now, '08:00'),
        at: DateTime(2026, 9, 28, 8, 5),
      );
      // 今天 08:00 打卡；再加一条昨天 missed。
      final yesterday = now.subtract(const Duration(days: 1));
      await taskRepo.upsertMissing(
        TaskExpander.expandForDate(
          pairs: await medRepo.activePairs(),
          date: yesterday,
        ),
      );
      final yId = doseTaskId('sch-1', yesterday, '08:00');
      final yTask = await taskRepo.get(yId);
      await taskRepo.update(yTask!.copyWith(status: DoseStatus.missed));

      final stats = await service.adherence(days: 7);
      expect(stats.expected, 2);
      expect(stats.taken, 1);
      expect(stats.missed, 1);
      expect(stats.rate, closeTo(0.5, 0.001));
    });

    test('日历健康：绿/红/黄/灰', () async {
      await service.expandTasks();
      final taskId = doseTaskId('sch-1', now, '08:00');
      await service.markTaken(taskId, at: DateTime(2026, 9, 28, 8, 5));
      final calendar = await service.calendar(days: 3);
      final today = calendar.last;
      expect(today.health, DayHealth.allTaken);

      // 昨天无任务 → none。
      expect(calendar.first.health, DayHealth.none);
    });
  });

  group('nextPending', () {
    test('返回最近的待服任务', () async {
      await medRepo.saveSchedule(
        dailySchedule(id: 'sch-1', times: const [
          TimeSlot(time: '08:00', dose: 1),
          TimeSlot(time: '12:00', dose: 1),
        ]),
      );
      await service.expandTasks();
      final next = await service.nextPending();
      expect(next, isNotNull);
      // 10:00 时：8 点已过（还没打卡，pending），12 点未到 → 应返回 12 点。
      expect(next!.task.scheduledTime, '12:00');
    });
  });
}
