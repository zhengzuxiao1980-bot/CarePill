import 'package:drift/drift.dart';

import '../../domain/models/dose_task.dart';
import '../../domain/models/enums.dart';
import '../db/app_database.dart';

abstract class DoseTaskRepository {
  /// 幂等插入：已存在的任务（含已打卡/已跳过等终态）不动。
  Future<void> upsertMissing(List<DoseTask> tasks);

  Future<DoseTask?> get(String id);

  Future<List<DoseTask>> tasksForDate(String isoDate);

  /// [endIso] 含当天。
  Future<List<DoseTask>> tasksBetween(String startIso, String endIso);

  Future<List<DoseTask>> tasksForSchedule(
    String scheduleId, {
    required String fromDateIso,
  });

  Future<void> update(DoseTask task);

  /// 删除某计划自 [fromDateIso] 起的、ID 不在 [keepIds] 内的任务（规则变更后
  /// 清理过期展开结果；终态任务通过 keepIds 保护）。
  Future<int> deleteStaleForSchedule(
    String scheduleId,
    String fromDateIso,
    Set<String> keepIds,
  );

  /// 清空任务表（仅导入备份时使用）。
  Future<void> clearAll();
}

class DriftDoseTaskRepository implements DoseTaskRepository {
  DriftDoseTaskRepository(this._db);

  final AppDatabase _db;

  static DoseTask rowToTask(DoseTaskRow r) => DoseTask(
        id: r.id,
        scheduleId: r.scheduleId,
        medicationId: r.medicationId,
        scheduledDate: r.scheduledDate,
        scheduledTime: r.scheduledTime,
        plannedDose: r.plannedDose,
        status: DoseStatus.values.firstWhere(
          (e) => e.json == r.status,
          orElse: () => DoseStatus.pending,
        ),
        takenAt: r.takenAt,
        markSource: r.markSource == null
            ? null
            : MarkSource.values.firstWhere(
                (e) => e.json == r.markSource,
                orElse: () => MarkSource.tap,
              ),
        note: r.note,
      );

  @override
  Future<void> upsertMissing(List<DoseTask> tasks) async {
    if (tasks.isEmpty) {
      return;
    }
    await _db.batch((batch) {
      for (final t in tasks) {
        batch.insert(
          _db.doseTasks,
          DoseTasksCompanion.insert(
            id: t.id,
            scheduleId: t.scheduleId,
            medicationId: t.medicationId,
            scheduledDate: t.scheduledDate,
            scheduledTime: t.scheduledTime,
            plannedDose: t.plannedDose,
            status: t.status.json,
            takenAt: Value(t.takenAt),
            markSource: Value(t.markSource?.json),
            note: Value(t.note),
          ),
          mode: InsertMode.insertOrIgnore,
        );
      }
    });
  }

  @override
  Future<DoseTask?> get(String id) async {
    final row =
        await (_db.select(_db.doseTasks)..where((t) => t.id.equals(id)))
            .getSingleOrNull();
    return row == null ? null : rowToTask(row);
  }

  @override
  Future<List<DoseTask>> tasksForDate(String isoDate) async {
    final rows = await (_db.select(_db.doseTasks)
          ..where((t) => t.scheduledDate.equals(isoDate))
          ..orderBy([
            (t) => OrderingTerm.asc(t.scheduledTime),
          ]))
        .get();
    return rows.map(rowToTask).toList();
  }

  @override
  Future<List<DoseTask>> tasksBetween(String startIso, String endIso) async {
    final rows = await (_db.select(_db.doseTasks)
          ..where((t) =>
              t.scheduledDate.isBiggerOrEqualValue(startIso) &
              t.scheduledDate.isSmallerOrEqualValue(endIso))
          ..orderBy([
            (t) => OrderingTerm.asc(t.scheduledDate),
            (t) => OrderingTerm.asc(t.scheduledTime),
          ]))
        .get();
    return rows.map(rowToTask).toList();
  }

  @override
  Future<List<DoseTask>> tasksForSchedule(
    String scheduleId, {
    required String fromDateIso,
  }) async {
    final rows = await (_db.select(_db.doseTasks)
          ..where((t) =>
              t.scheduleId.equals(scheduleId) &
              t.scheduledDate.isBiggerOrEqualValue(fromDateIso)))
        .get();
    return rows.map(rowToTask).toList();
  }

  @override
  Future<void> update(DoseTask task) {
    return (_db.update(_db.doseTasks)..where((t) => t.id.equals(task.id)))
        .write(DoseTasksCompanion(
      status: Value(task.status.json),
      takenAt: Value(task.takenAt),
      markSource: Value(task.markSource?.json),
      note: Value(task.note),
      plannedDose: Value(task.plannedDose),
    ));
  }

  @override
  Future<int> deleteStaleForSchedule(
    String scheduleId,
    String fromDateIso,
    Set<String> keepIds,
  ) async {
    final existing = await tasksForSchedule(
      scheduleId,
      fromDateIso: fromDateIso,
    );
    var deleted = 0;
    for (final t in existing) {
      // 规则变更只能清理尚未处理的未来任务；已服/跳过/漏服记录属于历史，
      // 必须保留，避免编辑计划破坏统计与 AI 查询。
      if (t.isPending && !keepIds.contains(t.id)) {
        deleted += await (_db.delete(_db.doseTasks)
              ..where((d) => d.id.equals(t.id)))
            .go();
      }
    }
    return deleted;
  }

  @override
  Future<void> clearAll() => _db.delete(_db.doseTasks).go();
}
