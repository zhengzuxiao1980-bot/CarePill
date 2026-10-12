import 'dart:convert';

import 'package:drift/drift.dart';

import '../../domain/models/enums.dart';
import '../../domain/models/medication.dart';
import '../../domain/models/schedule.dart';
import '../db/app_database.dart';
import '../db/upsert.dart';

/// (药品, 计划) 组合，任务展开的输入。
class MedicationSchedulePair {
  const MedicationSchedulePair({required this.medication, required this.schedule});

  final Medication medication;
  final MedicationSchedule schedule;
}

abstract class MedicationRepository {
  Future<List<Medication>> listAll({bool includeArchived = true});
  Future<Medication?> get(String id);
  Future<void> save(Medication medication);
  Future<void> setStatus(String id, MedicationStatus status);
  Future<List<MedicationSchedule>> schedulesFor(String medicationId);
  Future<List<MedicationSchedule>> allSchedules();
  Future<void> saveSchedule(MedicationSchedule schedule);
  Future<void> deleteSchedule(String id);
  Future<List<MedicationSchedulePair>> activePairs();
  Future<void> createWithSchedules(
    Medication medication,
    List<MedicationSchedule> schedules,
  );

  /// 清空药品与计划（仅导入备份时使用）。
  Future<void> clearAll();
}

/// Drift 实现（docs/05 表结构与领域模型互转集中在此层）。
class DriftMedicationRepository implements MedicationRepository {
  DriftMedicationRepository(this._db);

  final AppDatabase _db;

  static Medication rowToMedication(MedicationRow r) => Medication(
        id: r.id,
        name: r.name,
        form: MedicationForm.values.firstWhere(
          (e) => e.json == r.form,
          orElse: () => MedicationForm.other,
        ),
        spec: r.spec,
        doseUnit: r.doseUnit,
        notes: r.notes,
        photoPath: r.photoPath,
        source: MedicationSource.values.firstWhere(
          (e) => e.json == r.source,
          orElse: () => MedicationSource.manual,
        ),
        aiExtractJson: r.aiExtractJson,
        status: MedicationStatus.values.firstWhere(
          (e) => e.json == r.status,
          orElse: () => MedicationStatus.active,
        ),
        createdAt: DateTime.fromMillisecondsSinceEpoch(r.createdAt),
        updatedAt: DateTime.fromMillisecondsSinceEpoch(r.updatedAt),
      );

  static MedicationSchedule rowToSchedule(ScheduleRow r) {
    final weekdays = r.weekdays;
    final times = (jsonDecode(r.timesJson) as List<dynamic>)
        .map((e) => TimeSlot.fromJson(e as Map<String, dynamic>))
        .toList();
    return MedicationSchedule(
      id: r.id,
      medicationId: r.medicationId,
      frequencyType: FrequencyType.values.firstWhere(
        (e) => e.json == r.frequencyType,
        orElse: () => FrequencyType.daily,
      ),
      weekdays: weekdays
          ?.split(',')
          .map(int.parse)
          .toList(),
      intervalDays: r.intervalDays,
      anchorDate: r.anchorDate,
      times: times,
      mealRelation: r.mealRelation == null
          ? null
          : MealRelation.values.firstWhere(
              (e) => e.json == r.mealRelation,
              orElse: () => MealRelation.after,
            ),
      startDate: r.startDate,
      endDate: r.endDate,
      status: ScheduleStatus.values.firstWhere(
        (e) => e.json == r.status,
        orElse: () => ScheduleStatus.active,
      ),
      createdAt: DateTime.fromMillisecondsSinceEpoch(r.createdAt),
    );
  }

  static String scheduleToTimesJson(MedicationSchedule s) =>
      jsonEncode(s.times.map((t) => t.toJson()).toList());

  @override
  Future<List<Medication>> listAll({bool includeArchived = true}) async {
    final query = _db.select(_db.medications)
      ..orderBy([(u) => OrderingTerm(expression: u.createdAt)]);
    final rows = await query.get();
    final result = rows.map(rowToMedication).toList();
    if (includeArchived) {
      return result;
    }
    return result.where((m) => m.status == MedicationStatus.active).toList();
  }

  @override
  Future<Medication?> get(String id) async {
    final row =
        await (_db.select(_db.medications)..where((u) => u.id.equals(id)))
            .getSingleOrNull();
    return row == null ? null : rowToMedication(row);
  }

  @override
  Future<void> save(Medication medication) {
    return _db.into(_db.medications).insertOrUpdate(
          MedicationsCompanion.insert(
            id: medication.id,
            name: medication.name,
            form: medication.form.json,
            spec: Value(medication.spec),
            doseUnit: medication.doseUnit,
            notes: Value(medication.notes),
            photoPath: Value(medication.photoPath),
            source: medication.source.json,
            aiExtractJson: Value(medication.aiExtractJson),
            status: medication.status.json,
            createdAt: medication.createdAt.millisecondsSinceEpoch,
            updatedAt: medication.updatedAt.millisecondsSinceEpoch,
          ),
        );
  }

  @override
  Future<void> setStatus(String id, MedicationStatus status) {
    return (_db.update(_db.medications)..where((u) => u.id.equals(id))).write(
      MedicationsCompanion(
        status: Value(status.json),
        updatedAt: Value(DateTime.now().millisecondsSinceEpoch),
      ),
    );
  }

  @override
  Future<List<MedicationSchedule>> schedulesFor(String medicationId) async {
    final rows = await (_db.select(_db.medicationSchedules)
          ..where((s) => s.medicationId.equals(medicationId)))
        .get();
    return rows.map(rowToSchedule).toList();
  }

  @override
  Future<List<MedicationSchedule>> allSchedules() async {
    final rows = await _db.select(_db.medicationSchedules).get();
    return rows.map(rowToSchedule).toList();
  }

  @override
  Future<void> saveSchedule(MedicationSchedule schedule) {
    return _db.into(_db.medicationSchedules).insertOrUpdate(
          MedicationSchedulesCompanion.insert(
            id: schedule.id,
            medicationId: schedule.medicationId,
            frequencyType: schedule.frequencyType.json,
            weekdays: Value(schedule.weekdays?.join(',')),
            intervalDays: Value(schedule.intervalDays),
            anchorDate: Value(schedule.anchorDate),
            timesJson: scheduleToTimesJson(schedule),
            mealRelation: Value(schedule.mealRelation?.json),
            startDate: schedule.startDate,
            endDate: Value(schedule.endDate),
            status: schedule.status.json,
            createdAt: schedule.createdAt.millisecondsSinceEpoch,
          ),
        );
  }

  @override
  Future<void> deleteSchedule(String id) {
    return (_db.delete(_db.medicationSchedules)..where((s) => s.id.equals(id)))
        .go();
  }

  @override
  Future<List<MedicationSchedulePair>> activePairs() async {
    final meds = await listAll(includeArchived: false);
    final medById = {for (final m in meds) m.id: m};
    final schedules = await allSchedules();
    final pairs = <MedicationSchedulePair>[];
    for (final s in schedules) {
      final med = medById[s.medicationId];
      if (med != null) {
        pairs.add(
          MedicationSchedulePair(medication: med, schedule: s),
        );
      }
    }
    return pairs;
  }

  @override
  Future<void> createWithSchedules(
    Medication medication,
    List<MedicationSchedule> schedules,
  ) {
    return _db.transaction(() async {
      await save(medication);
      for (final s in schedules) {
        await saveSchedule(s);
      }
    });
  }

  @override
  Future<void> clearAll() {
    return _db.transaction(() async {
      await _db.delete(_db.medicationSchedules).go();
      await _db.delete(_db.medications).go();
    });
  }
}
