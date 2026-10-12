import '../../core/app_constants.dart';
import '../../core/formatters.dart';
import '../../data/repositories/dose_task_repository.dart';
import '../../data/repositories/medication_repository.dart';
import '../models/dose_task.dart';
import '../models/enums.dart';
import '../models/medication.dart';
import '../models/schedule.dart';
import '../models/stats.dart';
import '../models/view_models.dart';
import 'task_expander.dart';

/// 服药打卡与任务领域服务（docs/04 §2：唯一业务逻辑所在）。
///
/// UI 打卡、通知打卡、AI 代办全部走同一份规则（docs/04 §7 依赖规则）。
/// ReminderScheduler 不做业务判断——漏服与状态机都在这里。
class DoseService {
  DoseService({
    required DoseTaskRepository taskRepository,
    required MedicationRepository medicationRepository,
    DateTime Function()? clock,
  }) : _tasks = taskRepository,
       _meds = medicationRepository,
       _now = clock ?? DateTime.now;

  final DoseTaskRepository _tasks;
  final MedicationRepository _meds;
  final DateTime Function() _now;

  /// 当前业务时间。工具层与任务层共用同一个可注入时钟，避免测试或跨日时
  /// 一边按固定日期查任务、另一边却使用系统日期。
  DateTime get now => _now();

  /// 展开未来 [days] 天任务并清理规则变更后的过期展开结果。
  ///
  /// 幂等：可随时重跑；已打卡/已跳过等终态任务不受影响（docs/05 §4）。
  Future<ExpansionReport> expandTasks({int days = kExpansionDays}) async {
    final now = _now();
    final today = now.dateOnly;
    final pairs = await _meds.activePairs();
    final planned = TaskExpander.expandRange(
      pairs: pairs,
      from: today,
      days: days,
    );
    await _tasks.upsertMissing(planned);

    // 规则变更清理：删除今天起所有失效计划的待服任务；终态历史由仓库保护。
    var removed = 0;
    final bySchedule = <String, Set<String>>{};
    for (final t in planned) {
      (bySchedule[t.scheduleId] ??= {}).add(t.id);
    }
    final allSchedules = await _meds.allSchedules();
    for (final scheduleId in allSchedules.map((s) => s.id)) {
      removed += await _tasks.deleteStaleForSchedule(
        scheduleId,
        today.isoDate,
        bySchedule[scheduleId] ?? const <String>{},
      );
    }
    return ExpansionReport(created: planned.length, removed: removed);
  }

  /// 漏服判定（docs/06 §3）：宽限期结束后仍 pending → missed。
  ///
  /// 由"每日补偿检查 + App 启动补偿"执行，不要求 App 活着。
  Future<int> applyMissedSweep({int? graceMinutes}) async {
    final now = _now();
    final grace = graceMinutes ?? kDefaultGracePeriodMinutes;
    // 覆盖今天与昨天（跨天打开 App 也要补判定）。
    final from = now.subtract(const Duration(days: 1)).dateOnly.isoDate;
    final range = await _tasks.tasksBetween(from, now.dateOnly.isoDate);
    var marked = 0;
    for (final task in range) {
      if (!task.isPending) {
        continue;
      }
      final deadline = task.scheduledDateTime.add(Duration(minutes: grace));
      if (now.isAfter(deadline)) {
        await _tasks.update(task.copyWith(status: DoseStatus.missed));
        marked++;
      }
    }
    return marked;
  }

  Future<Map<String, Medication>> _medicationMap() async {
    final meds = await _meds.listAll(includeArchived: true);
    return {for (final m in meds) m.id: m};
  }

  Future<Map<String, MedicationSchedule>> _scheduleMap() async {
    final schedules = await _meds.allSchedules();
    return {for (final s in schedules) s.id: s};
  }

  Future<List<DoseTaskView>> _buildViews(List<DoseTask> tasks) async {
    final meds = await _medicationMap();
    final schedules = await _scheduleMap();
    final views = <DoseTaskView>[];
    for (final task in tasks) {
      final med = meds[task.medicationId];
      if (med == null) {
        continue;
      }
      final schedule = schedules[task.scheduleId];
      TimeSlot? slot;
      if (schedule != null) {
        for (final s in schedule.times) {
          if (s.time == task.scheduledTime) {
            slot = s;
            break;
          }
        }
      }
      final meal = slot?.meal ?? schedule?.mealRelation;
      views.add(
        DoseTaskView(
          task: task,
          medicationName: med.name,
          doseUnit: med.doseUnit,
          form: med.form,
          meal: meal,
          asNeeded: schedule?.frequencyType == FrequencyType.asNeeded,
        ),
      );
    }
    views.sort(
      (a, b) => a.task.scheduledDateTime.compareTo(b.task.scheduledDateTime),
    );
    return views;
  }

  Future<List<DoseTaskView>> viewsForDate(DateTime date) async {
    final tasks = await _tasks.tasksForDate(date.dateOnly.isoDate);
    return _buildViews(tasks);
  }

  Future<List<DoseTaskView>> todayViews() => viewsForDate(_now());

  /// 最近一次待服任务（含已过点但未过宽限期的，docs/02 F5）。
  Future<DoseTaskView?> nextPending() async {
    final views = await todayViews();
    final pending = views.where((v) => v.task.isPending).toList();
    if (pending.isEmpty) {
      return null;
    }
    final now = _now();
    for (final v in pending) {
      if (v.task.scheduledDateTime.isAfter(now)) {
        return v;
      }
    }
    return pending.last;
  }

  /// 待服与漏服任务（提醒注册用）。
  Future<List<DoseTask>> pendingTasksWithinDays(int days) async {
    final now = _now();
    final activeScheduleIds = (await _meds.allSchedules())
        .where((s) => s.status == ScheduleStatus.active)
        .map((s) => s.id)
        .toSet();
    final activeMedicationIds = (await _meds.listAll(includeArchived: false))
        .map((m) => m.id)
        .toSet();
    final tasks = await _tasks.tasksBetween(
      now.dateOnly.isoDate,
      now.add(Duration(days: days - 1)).dateOnly.isoDate,
    );
    return tasks
        .where(
          (t) =>
              t.isPending &&
              activeScheduleIds.contains(t.scheduleId) &&
              activeMedicationIds.contains(t.medicationId),
        )
        .toList();
  }

  /// 打卡：待服→已服（漏服可补记，标记 catch_up，docs/06 §3）。
  ///
  /// [at] 支持补记时间；[note] 记录"刚才吃的"等备注。
  Future<DoseTask> markTaken(
    String taskId, {
    MarkSource source = MarkSource.tap,
    DateTime? at,
    String? note,
  }) async {
    final task = await _require(taskId);
    final target = task.status.transition(DoseAction.take);
    if (target == null) {
      throw StateError('任务 ${task.id} 当前状态 ${task.status.label} 不允许打卡');
    }
    final now = _now();
    final when = at ?? now;
    final effectiveSource = _effectiveSource(task, when, source);
    final updated = task.copyWith(
      status: target,
      takenAt: when.millisecondsSinceEpoch,
      markSource: effectiveSource,
      note: note,
    );
    await _tasks.update(updated);
    return updated;
  }

  Future<Map<String, dynamic>> taskSnapshot(String id) async {
    final t = await _require(id);
    return {
      'id': t.id,
      'status': t.status.json,
      'takenAt': t.takenAt,
      'markSource': t.markSource?.json,
      'note': t.note,
      'scheduleId': t.scheduleId,
      'medicationId': t.medicationId,
      'scheduledDate': t.scheduledDate,
      'scheduledTime': t.scheduledTime,
      'plannedDose': t.plannedDose,
    };
  }

  Future<void> restoreSnapshot(
    Map<String, dynamic> before,
    Map<String, dynamic> expected,
  ) async {
    final id = before['id'] as String;
    final current = await taskSnapshot(id);
    if (current.length != expected.length ||
        current.keys.any((k) => current[k] != expected[k])) {
      throw StateError('undo_conflict');
    }
    final task = await _require(id);
    await _tasks.update(
      task.copyWith(
        status: DoseStatus.values.firstWhere((s) => s.json == before['status']),
        takenAt: before['takenAt'] as int?,
        markSource: before['markSource'] == null
            ? null
            : MarkSource.values.firstWhere(
                (s) => s.json == before['markSource'],
              ),
        note: before['note'] as String?,
      ),
    );
  }

  /// 按点吃还是补记：超过宽限期或跨天补记 → catch_up（docs/06 §3）。
  MarkSource _effectiveSource(DoseTask task, DateTime when, MarkSource source) {
    if (source == MarkSource.catchUp) {
      return source;
    }
    final isCatchUp =
        task.isMissed ||
        !when.isSameDate(task.scheduledDateTime) ||
        when.isAfter(
          task.scheduledDateTime.add(
            Duration(minutes: kDefaultGracePeriodMinutes),
          ),
        );
    return isCatchUp ? MarkSource.catchUp : source;
  }

  /// 跳过：今天不吃了（docs/06 全屏提醒按钮）。
  Future<DoseTask> skip(String taskId, {String? reason}) async {
    final task = await _require(taskId);
    final target = task.status.transition(DoseAction.skip);
    if (target == null) {
      throw StateError('任务 ${task.id} 当前状态不允许跳过');
    }
    final updated = _copyWithStatus(
      task,
      status: target,
      note: reason ?? task.note,
    );
    await _tasks.update(updated);
    return updated;
  }

  /// 撤销：已服/已跳过 → 待服（docs/01 §5 容错：一切可撤销）。
  Future<DoseTask> undo(String taskId) async {
    final task = await _require(taskId);
    final target = task.status.transition(DoseAction.undo);
    if (target == null) {
      throw StateError('任务 ${task.id} 当前状态不允许撤销');
    }
    final updated = _copyWithStatus(task, status: target, resetMark: true);
    await _tasks.update(updated);
    return updated;
  }

  /// copyWith 无法把可空字段显式置 null，需要"清空打卡痕迹"时整体重建。
  DoseTask _copyWithStatus(
    DoseTask task, {
    required DoseStatus status,
    String? note,
    bool resetMark = false,
  }) => DoseTask(
    id: task.id,
    scheduleId: task.scheduleId,
    medicationId: task.medicationId,
    scheduledDate: task.scheduledDate,
    scheduledTime: task.scheduledTime,
    plannedDose: task.plannedDose,
    status: status,
    takenAt: resetMark ? null : task.takenAt,
    markSource: resetMark ? null : task.markSource,
    note: resetMark ? null : (note ?? task.note),
  );

  /// 按需药打卡：不进提醒队列，只在打卡时可选（docs/02 F2）。
  /// 在当天时间轴上生成一条"已服"记录。
  Future<DoseTask> logAsNeeded(
    String medicationId, {
    double? dose,
    String? note,
  }) async {
    final schedules = await _meds.schedulesFor(medicationId);
    final asNeeded = schedules.where(
      (s) => s.frequencyType == FrequencyType.asNeeded,
    );
    final now = _now();
    var schedule = asNeeded.isEmpty ? null : asNeeded.first;
    if (schedule == null) {
      // 没有按需计划就补一条（建卡时一般已生成）。
      schedule = MedicationSchedule(
        id: '${medicationId.substring(0, 8)}-asneeded',
        medicationId: medicationId,
        frequencyType: FrequencyType.asNeeded,
        times: const [],
        startDate: now.dateOnly.isoDate,
        status: ScheduleStatus.active,
        createdAt: now,
      );
      await _meds.saveSchedule(schedule);
    }
    final task = DoseTask(
      id: asNeededTaskId(schedule.id, now),
      scheduleId: schedule.id,
      medicationId: medicationId,
      scheduledDate: now.dateOnly.isoDate,
      scheduledTime: now.hhMm,
      plannedDose: dose ?? 1,
      status: DoseStatus.taken,
      takenAt: now.millisecondsSinceEpoch,
      markSource: MarkSource.tap,
      note: note,
    );
    await _tasks.upsertMissing([task]);
    return task;
  }

  Future<DoseTask> _require(String taskId) async {
    final task = await _tasks.get(taskId);
    if (task == null) {
      throw StateError('任务不存在: $taskId');
    }
    return task;
  }

  /// 近 [days] 天依从统计（口径见 AdherenceStats）。
  Future<AdherenceStats> adherence({int days = 7}) async {
    final now = _now();
    final start = now.subtract(Duration(days: days - 1)).dateOnly;
    final tasks = await _tasks.tasksBetween(
      start.isoDate,
      now.dateOnly.isoDate,
    );
    var taken = 0;
    var missed = 0;
    var skipped = 0;
    for (final t in tasks) {
      switch (t.status) {
        case DoseStatus.taken:
          taken++;
        case DoseStatus.missed:
          missed++;
        case DoseStatus.skipped:
          skipped++;
        case DoseStatus.pending:
          break;
      }
    }
    return AdherenceStats(
      days: days,
      expected: tasks.length - skipped,
      taken: taken,
      missed: missed,
      skipped: skipped,
    );
  }

  /// 统计页日历数据（绿=全服 黄=有跳过 红=有漏服，docs/02 F9）。
  Future<List<DayHealthEntry>> calendar({int days = 30}) async {
    final now = _now();
    final start = now.subtract(Duration(days: days - 1)).dateOnly;
    final tasks = await _tasks.tasksBetween(
      start.isoDate,
      now.dateOnly.isoDate,
    );
    final byDate = <String, List<DoseTask>>{};
    for (final t in tasks) {
      (byDate[t.scheduledDate] ??= []).add(t);
    }
    final entries = <DayHealthEntry>[];
    for (var i = 0; i < days; i++) {
      final date = start.add(Duration(days: i));
      final iso = date.isoDate;
      final list = byDate[iso] ?? const [];
      var taken = 0;
      var missed = 0;
      var skipped = 0;
      for (final t in list) {
        switch (t.status) {
          case DoseStatus.taken:
            taken++;
          case DoseStatus.missed:
            missed++;
          case DoseStatus.skipped:
            skipped++;
          case DoseStatus.pending:
            break;
        }
      }
      entries.add(
        DayHealthEntry(
          date: date,
          health: computeDayHealth(
            total: list.length,
            taken: taken,
            missed: missed,
            skipped: skipped,
          ),
          total: list.length,
          done: taken,
        ),
      );
    }
    return entries;
  }
}

class ExpansionReport {
  const ExpansionReport({required this.created, required this.removed});

  final int created;
  final int removed;
}
