import 'package:care_pill/i18n/strings.g.dart';
import 'package:timezone/timezone.dart' as tz;

import '../../core/app_constants.dart';
import '../../core/app_logger.dart';
import '../models/dose_task.dart';
import 'dose_service.dart';

/// 通知网关抽象：ReminderScheduler 只认接口，不碰插件
/// （docs/04 §8 面向接口；系统实现在 platform 层，测试用 fake）。
abstract interface class ReminderGateway {
  /// 注册一条本地提醒（[at] 为本地墙钟时间）。
  Future<void> schedule(ReminderPlanItem item);

  Future<void> cancel(int id);

  /// 取消本应用全部已注册提醒（重排前的清场）。
  Future<void> cancelAllScheduled();

  Future<bool> notificationsEnabled();
  Future<bool> exactAlarmsEnabled();
  Future<bool> requestPermissions();

  /// 立即弹一条通知（提醒测试用，docs/06 §4）。
  Future<void> showNow({
    required int id,
    required String title,
    required String body,
    required String payload,
    required bool fullScreen,
  });
}

/// 一条提醒计划（纯数据，便于测试与留痕）。
class ReminderPlanItem {
  const ReminderPlanItem({
    required this.id,
    required this.at,
    required this.title,
    required this.body,
    required this.payload,
    required this.fullScreen,
    required this.withSound,
  });

  final int id;
  final DateTime at;
  final String title;
  final String body;

  /// JSON 字符串：{"taskIds": [...]}
  final String payload;
  final bool fullScreen;
  final bool withSound;
}

/// 提醒编排服务（docs/06）。
///
/// **不做业务判断**：状态机、漏服都在 DoseService；这里只负责
/// "把 DoseService 展开出的任务按时通知出去"（docs/04 §2 要点）。
///
/// 触发源（docs/06 §1）：
/// 1. 每日展开（由系统闹钟在 0 点后调 [dailyExpand]）；
/// 2. 规则变更（增删改计划/打卡撤销后调 [syncUpcoming]）；
/// 3. 重启补偿（插件 BootReceiver 恢复闹钟 + 下次打开 App 时的启动补偿）；
/// 4. App 启动补偿（[onAppStart]，保证打开过 App 状态就不会错）。
class ReminderScheduler {
  ReminderScheduler({
    required DoseService doseService,
    required ReminderGateway gateway,
    required ReminderSettings Function() settingsOf,
    DateTime Function()? clock,
  }) : _dose = doseService,
       _gateway = gateway,
       _settingsOf = settingsOf,
       _now = clock ?? DateTime.now;

  final DoseService _dose;
  final ReminderGateway _gateway;
  final ReminderSettings Function() _settingsOf;
  final DateTime Function() _now;

  ReminderSettings get _settings => _settingsOf();

  /// App 启动补偿：展开 + 补判定 + 重排（docs/06 §1 第 4 触发源）。
  Future<void> onAppStart() async {
    await _dose.expandTasks();
    final missed = await _dose.applyMissedSweep(
      graceMinutes: _settings.gracePeriodMinutes,
    );
    if (missed > 0) {
      AppLog.i('启动补偿：漏服判定标记 $missed 条');
    }
    await syncUpcoming();
  }

  /// 每日展开触发源（0 点后由闹钟调用）。
  Future<void> dailyExpand() => onAppStart();

  /// 规则变更触发源：重排未来提醒。
  Future<void> syncUpcoming() async {
    final pending = await _dose.pendingTasksWithinDays(kExpansionDays);
    final plan = planReminders(pending);
    AppLog.i('提醒重排：取消旧提醒，注册 ${plan.length} 条');
    await _gateway.cancelAllScheduled();
    for (final item in plan) {
      await _gateway.schedule(item);
    }
  }

  /// 计划、药品或导入数据发生变化后的统一入口。
  /// 先让任务表与当前规则一致，再重排通知，避免新增/编辑后必须重启 App。
  Future<void> refreshAfterDataChange() async {
    await _dose.expandTasks();
    await syncUpcoming();
  }

  /// 打卡后取消该任务的后续提醒（docs/04 §4.1）。
  Future<void> cancelForTasks(Iterable<String> taskIds) async {
    final ids = reminderIdsForTasks(taskIds.toList());
    for (final id in ids) {
      await _gateway.cancel(id);
    }
  }

  /// 稍后再提醒（全屏提醒页"等会儿再提醒"）。
  Future<void> snooze({
    required List<String> taskIds,
    required List<String> medicationNames,
    int? minutes,
  }) async {
    // 当前提醒组已由用户明确选择稍后再提醒，先取消原主提醒和升级提醒，
    // 避免旧闹钟与 snooze 同时触发。
    await cancelForTasks(taskIds);
    final at = _now().add(
      Duration(minutes: minutes ?? _settings.escalationIntervalMinutes),
    );
    final item = ReminderPlanItem(
      id: stableHash(
        'snooze|${taskIds.join(',')}|${at.millisecondsSinceEpoch}',
      ),
      at: at,
      title: tr.reminderScheduler.dueTitle,
      body: tr.reminderScheduler.snoozedBody(
        arg1: (medicationNames.join('、')).toString(),
      ),
      payload: '{"taskIds": ${taskIdsToJson(taskIds)}}',
      fullScreen: true,
      withSound: true,
    );
    await _gateway.schedule(item);
  }

  /// 提醒测试（docs/06 §4：子女配置完当场验证"到点真的会响"）。
  Future<void> fireTestReminder({int delaySeconds = 5}) async {
    await _gateway.showNow(
      id: kTestReminderNotificationId,
      title: tr.reminderScheduler.testTitle,
      body: tr.reminderScheduler.testBody,
      payload: '{"taskIds": []}',
      fullScreen: false,
    );
    AppLog.i('提醒测试：立即通知已发（${delaySeconds}s 后无横幅说明被 ROM 拦截）');
  }

  /// 纯函数：为待服任务生成提醒计划（docs/06 §2/§3）。
  ///
  /// - 同一分钟的多任务合并为一条提醒（docs/06 §6 提醒风暴）；
  /// - 主提醒在到点前 [leadMinutes] 分钟；
  /// - 升级提醒：到点后每 [escalationIntervalMinutes] 分钟一次，共
  ///   [escalationCount] 次；仅对接下来 48h 内的任务注册（每日展开会续上）。
  List<ReminderPlanItem> planReminders(List<DoseTask> pendingTasks) {
    final now = _now();
    final items = <ReminderPlanItem>[];

    // 按 (date, time) 分组。
    final groups = <String, List<DoseTask>>{};
    for (final t in pendingTasks) {
      (groups['${t.scheduledDate} ${t.scheduledTime}'] ??= []).add(t);
    }

    for (final group in groups.entries) {
      final tasks = group.value;
      final scheduledAt = tasks.first.scheduledDateTime;
      final ids = tasks.map((t) => t.id).toList();

      // 已过点的组不再注册（刚过点的 2 分钟内仍补一条，防止漏掉）。
      if (scheduledAt.isBefore(now.subtract(const Duration(minutes: 2)))) {
        continue;
      }

      final mainAt = scheduledAt.subtract(
        Duration(minutes: _settings.reminderLeadMinutes),
      );

      final body = tr.reminderScheduler.dueBody(
        arg1: (tasks.length).toString(),
      );
      items.add(
        ReminderPlanItem(
          id: mainReminderId(group.key),
          at: mainAt.isBefore(now)
              ? now.add(const Duration(seconds: 10))
              : mainAt,
          title: tr.reminderScheduler.dueTitle,
          body: body,
          payload: '{"taskIds": ${taskIdsToJson(ids)}}',
          fullScreen: true,
          withSound: true,
        ),
      );

      final inHorizon = scheduledAt.isBefore(
        now.add(const Duration(hours: kEscalationRegistrationHorizonHours)),
      );
      if (!inHorizon || _settings.escalationCount <= 0) {
        continue;
      }
      for (var i = 1; i <= _settings.escalationCount; i++) {
        final at = scheduledAt.add(
          Duration(minutes: _settings.escalationIntervalMinutes * i),
        );
        if (at.isBefore(now)) {
          continue;
        }
        items.add(
          ReminderPlanItem(
            id: escalationReminderId(group.key, i),
            at: at,
            title: tr.reminderScheduler.unrecordedTitle,
            body: tr.reminderScheduler.unrecordedBody(
              arg1: (tasks.length).toString(),
            ),
            payload: '{"taskIds": ${taskIdsToJson(ids)}}',
            fullScreen: true,
            withSound: true,
          ),
        );
      }
    }
    items.sort((a, b) => a.at.compareTo(b.at));
    return items;
  }

  /// 一组任务（同分钟）对应的全部提醒 ID（取消用）。
  List<int> reminderIdsForTasks(List<String> taskIds) {
    // 通过 payload 无法反查（gateway 不留 payload 索引），改为按组键取消：
    // task id 格式 scheduleId|date|time，同组共享 date+time。
    final groupKeys = <String>{};
    for (final id in taskIds) {
      final parts = id.split('|');
      if (parts.length == 3) {
        groupKeys.add('${parts[1]} ${parts[2]}');
      }
    }
    final ids = <int>[];
    for (final key in groupKeys) {
      ids.add(mainReminderId(key));
      for (var i = 1; i <= _settings.escalationCount; i++) {
        ids.add(escalationReminderId(key, i));
      }
    }
    return ids;
  }
}

/// 提醒相关设置快照（从 SettingsService 取好后传入，服务不直接依赖设置层）。
class ReminderSettings {
  const ReminderSettings({
    this.reminderLeadMinutes = kDefaultReminderLeadMinutes,
    this.escalationCount = kDefaultEscalationCount,
    this.escalationIntervalMinutes = kDefaultEscalationIntervalMinutes,
    this.gracePeriodMinutes = kDefaultGracePeriodMinutes,
  });

  final int reminderLeadMinutes;
  final int escalationCount;
  final int escalationIntervalMinutes;
  final int gracePeriodMinutes;
}

/// 稳定哈希（FNV-1a 32 位）：通知 ID 需要可复现才能取消。
int stableHash(String input) {
  var hash = 0x811c9dc5;
  for (final code in input.codeUnits) {
    hash ^= code & 0xff;
    hash = (hash * 0x01000193) & 0xFFFFFFFF;
    hash ^= (code >> 8) & 0xff;
    hash = (hash * 0x01000193) & 0xFFFFFFFF;
  }
  return hash & 0x7FFFFFFF; // Android 通知 ID 用正数。
}

int mainReminderId(String groupKey) => stableHash('main|$groupKey');

int escalationReminderId(String groupKey, int round) =>
    stableHash('esc|$round|$groupKey');

String taskIdsToJson(List<String> ids) =>
    '[${ids.map((e) => '"$e"').join(',')}]';

/// 把本地时间转 TZDateTime（平台网关用；timezone 纯 Dart，可进 domain 辅助）。
tz.TZDateTime toTz(DateTime local) {
  final location = tz.getLocation(local.timeZoneName);
  return tz.TZDateTime.from(local, location);
}
