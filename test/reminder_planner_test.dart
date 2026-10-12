import 'package:care_pill/core/app_constants.dart';
import 'package:care_pill/domain/models/dose_task.dart';
import 'package:care_pill/domain/models/enums.dart';
import 'package:care_pill/domain/services/dose_service.dart';
import 'package:care_pill/domain/services/reminder_scheduler.dart';
import 'package:care_pill/domain/services/task_expander.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fakes/fakes.dart';

void main() {
  final now = DateTime(2026, 9, 28, 10, 0);

  List<DoseTask> sampleTasks(DateTime base) {
    const scheduleId = 'sch-1';
    String iso(DateTime d) =>
        '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
    return [
      for (var d = 0; d < 7; d++)
        DoseTask(
          id: doseTaskId(scheduleId, base.add(Duration(days: d)), '08:00'),
          scheduleId: scheduleId,
          medicationId: 'med-1',
          scheduledDate: iso(base.add(Duration(days: d))),
          scheduledTime: '08:00',
          plannedDose: 1,
          status: DoseStatus.pending,
        ),
    ];
  }

  ReminderScheduler buildScheduler({
    required FakeReminderGateway gateway,
    List<DoseTask> pending = const [],
    ReminderSettings settings = const ReminderSettings(),
  }) {
    return ReminderScheduler(
      doseService: _StubDoseService(pending),
      gateway: gateway,
      settingsOf: () => settings,
      clock: () => now,
    );
  }

  group('提醒计划（docs/06 §2/§3）', () {
    test('每天一条主提醒 + 48h 视野内注册升级提醒', () {
      final gateway = FakeReminderGateway();
      final scheduler = buildScheduler(
        gateway: gateway,
        pending: sampleTasks(now),
        settings: const ReminderSettings(
          reminderLeadMinutes: 0,
          escalationCount: 3,
          escalationIntervalMinutes: 15,
          gracePeriodMinutes: 60,
        ),
      );
      final plan = scheduler.planReminders(sampleTasks(now));
      // 今天 08:00 已过点（now=10:00，超 2 分钟）不再注册；
      // 剩 6 天主提醒。
      final mains = plan.where((p) => p.title == '该吃药了').toList();
      expect(mains, hasLength(6));
      // 只有 48h 视野内的（明天、后天）注册升级提醒。
      final escalations = plan.where((p) => p.title == '还没记上呢').toList();
      expect(escalations, hasLength(2 * kDefaultEscalationCount));
      // 首组未过点的是明天 08:00 → 升级在 08:15。
      final tomorrow = now.add(const Duration(days: 1));
      expect(
        escalations.first.at,
        DateTime(tomorrow.year, tomorrow.month, tomorrow.day, 8, 15),
      );
    });

    test('同一分钟多任务合并为一条提醒（docs/06 §6 提醒风暴）', () {
      final gateway = FakeReminderGateway();
      final scheduler = buildScheduler(
        gateway: gateway,
        settings: const ReminderSettings(),
      );
      final tasks = sampleTasks(now);
      final tomorrow = now.add(const Duration(days: 1));
      final iso =
          '${tomorrow.year.toString().padLeft(4, '0')}-${tomorrow.month.toString().padLeft(2, '0')}-${tomorrow.day.toString().padLeft(2, '0')}';
      tasks.add(
        DoseTask(
          id: doseTaskId('sch-2', tomorrow, '08:00'),
          scheduleId: 'sch-2',
          medicationId: 'med-2',
          scheduledDate: iso,
          scheduledTime: '08:00',
          plannedDose: 1,
          status: DoseStatus.pending,
        ),
      );
      final plan = scheduler.planReminders(tasks);
      // 明天 08:00 两个药同分钟 → 合并为一条主提醒。
      final merged = plan
          .where((p) => p.title == '该吃药了')
          .where((p) => p.body.contains('2 种'))
          .toList();
      expect(merged, hasLength(1));
    });

    test('取消一组任务 = 主提醒 + 全部升级提醒的 ID', () {
      final gateway = FakeReminderGateway();
      final scheduler = buildScheduler(
        gateway: gateway,
        settings: const ReminderSettings(escalationCount: 3),
      );
      final ids = scheduler.reminderIdsForTasks([
        doseTaskId('sch-1', now, '08:00'),
      ]);
      expect(ids, hasLength(4));
    });

    test('提醒 ID 稳定可复现（取消依赖它）', () {
      expect(
        mainReminderId('2026-09-28 08:00'),
        mainReminderId('2026-09-28 08:00'),
      );
      expect(
        mainReminderId('2026-09-28 08:00'),
        isNot(mainReminderId('2026-09-28 20:00')),
      );
    });

    test('syncUpcoming：取消旧的再注册新的', () async {
      final gateway = FakeReminderGateway();
      final scheduler = buildScheduler(
        gateway: gateway,
        pending: sampleTasks(now),
      );
      await scheduler.syncUpcoming();
      expect(gateway.cancelAllCount, 1);
      expect(gateway.scheduled, isNotEmpty);
    });

    test('提醒测试：立即通知', () async {
      final gateway = FakeReminderGateway();
      final scheduler = buildScheduler(gateway: gateway);
      await scheduler.fireTestReminder();
      expect(gateway.showNowCount, 1);
    });

    test('payload 携带任务列表（点通知回显全屏页）', () {
      final gateway = FakeReminderGateway();
      final scheduler = buildScheduler(
        gateway: gateway,
        pending: sampleTasks(now),
      );
      final plan = scheduler.planReminders(sampleTasks(now));
      expect(plan.first.payload, contains('taskIds'));
    });
  });
}

/// ReminderScheduler 只调 pendingTasksWithinDays；
/// 其余成员对本测试无意义，抛错即代表意外调用。
class _StubDoseService implements DoseService {
  _StubDoseService(this._pending);

  final List<DoseTask> _pending;

  @override
  Future<List<DoseTask>> pendingTasksWithinDays(int days) async => _pending;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
