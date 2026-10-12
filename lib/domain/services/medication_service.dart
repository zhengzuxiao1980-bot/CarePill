import 'package:uuid/uuid.dart';

import '../../core/formatters.dart';
import '../../data/repositories/dose_task_repository.dart';
import '../../data/repositories/medication_repository.dart';
import '../models/dose_task.dart';
import '../models/enums.dart';
import '../models/medication.dart';
import '../models/medication_draft.dart';
import '../models/schedule.dart';
import '../models/view_models.dart';
import 'task_expander.dart';

/// 药品与计划领域服务（docs/02 F1/F2）。
///
/// 停用不物理删除（保留历史完整性）；删除计划时联动清理未来任务。
class MedicationService {
  MedicationService({
    required MedicationRepository medicationRepository,
    required DoseTaskRepository taskRepository,
    DateTime Function()? clock,
  })  : _meds = medicationRepository,
        _tasks = taskRepository,
        _now = clock ?? DateTime.now;

  static const Uuid _uuid = Uuid();

  final MedicationRepository _meds;
  final DoseTaskRepository _tasks;
  final DateTime Function() _now;

  /// 手动建卡（docs/07 分步表单的提交点）。
  Future<Medication> createManual({
    required String name,
    required MedicationForm form,
    required String doseUnit,
    String? spec,
    String? notes,
    MedicationSource source = MedicationSource.manual,
    List<ScheduleDraftInput> scheduleInputs = const [],
  }) async {
    final now = _now();
    final medication = Medication(
      id: _uuid.v4(),
      name: name.trim(),
      form: form,
      spec: spec?.trim(),
      doseUnit: doseUnit.trim(),
      notes: notes?.trim(),
      source: source,
      status: MedicationStatus.active,
      createdAt: now,
      updatedAt: now,
    );
    await _meds.createWithSchedules(
      medication,
      scheduleInputs.map((input) => input.build(medication.id, now: now)).toList(),
    );
    return medication;
  }

  /// 从草稿建卡（docs/03 §6：草稿经用户确认后才入库）。
  ///
  /// 草稿里有时刻则自动建一条"每天"计划并预填；无时刻只建卡。
  Future<Medication> createFromDraft(
    MedicationDraft draft, {
    MedicationDraftPayload? overrides,
    required bool withSchedule,
  }) async {
    final payload = overrides ?? draft.payload;
    final now = _now();
    final medication = Medication(
      id: _uuid.v4(),
      name: (payload.name ?? '').trim(),
      form: payload.form ?? MedicationForm.tablet,
      spec: payload.spec,
      doseUnit: payload.doseUnit ?? '片',
      notes: payload.usageText ?? payload.notes,
      photoPath: draft.photoPath,
      source: draft.source == DraftSource.photo
          ? MedicationSource.aiPhoto
          : MedicationSource.manual,
      aiExtractJson: draft.payload.toJson().toString(),
      status: MedicationStatus.active,
      createdAt: now,
      updatedAt: now,
    );
    final schedules = <MedicationSchedule>[];
    if (withSchedule && payload.times.isNotEmpty) {
      schedules.add(
        MedicationSchedule(
          id: _uuid.v4(),
          medicationId: medication.id,
          frequencyType: FrequencyType.daily,
          times: payload.times,
          startDate: now.dateOnly.isoDate,
          status: ScheduleStatus.active,
          createdAt: now,
        ),
      );
    } else if (!withSchedule) {
      // 不设提醒也要有一条按需计划，"今天吃了"才能记录。
      schedules.add(_asNeededSchedule(medication.id, now));
    }
    await _meds.createWithSchedules(medication, schedules);
    return medication;
  }

  MedicationSchedule _asNeededSchedule(String medicationId, DateTime now) =>
      MedicationSchedule(
        id: _uuid.v4(),
        medicationId: medicationId,
        frequencyType: FrequencyType.asNeeded,
        times: const [],
        startDate: now.dateOnly.isoDate,
        status: ScheduleStatus.active,
        createdAt: now,
      );

  /// 更新药品基础字段（不含状态）。
  Future<void> save(Medication medication) async {
    await _meds.save(
      medication.copyWith(updatedAt: _now()),
    );
  }

  /// 停用（二次确认由 UI 负责；级联提示会影响历史统计，docs/02 F1）。
  Future<void> archive(String id) =>
      _meds.setStatus(id, MedicationStatus.archived);

  Future<void> restore(String id) =>
      _meds.setStatus(id, MedicationStatus.active);

  Future<Medication?> get(String id) => _meds.get(id);

  Future<List<MedicationSchedule>> schedulesOf(String medicationId) =>
      _meds.schedulesFor(medicationId);

  /// 新增 / 更新计划。
  Future<void> saveSchedule(MedicationSchedule schedule) =>
      _meds.saveSchedule(schedule);

  /// 暂停 / 恢复（住院、外出，docs/02 F2）。暂停后当天起不再展开。
  Future<void> setScheduleStatus(String id, ScheduleStatus status) async {
    final schedules = await _meds.allSchedules();
    for (final s in schedules) {
      if (s.id == id) {
        await _meds.saveSchedule(s.copyWith(status: status));
        return;
      }
    }
  }

  /// 删除计划：清理该计划未来的待服任务（终态记录保留）。
  Future<void> deleteSchedule(String id) async {
    final now = _now();
    await _tasks.deleteStaleForSchedule(id, now.dateOnly.isoDate, {});
    await _meds.deleteSchedule(id);
  }

  /// 药箱列表（docs/02 F1：按"下一次服药时间"排序，最紧急排最前）。
  Future<List<MedicationCardView>> cards() async {
    final meds =
        await _meds.listAll(includeArchived: false);
    final now = _now();
    final pairs = await _meds.activePairs();
    final cards = <MedicationCardView>[];
    for (final med in meds) {
      final medSchedules =
          pairs.where((p) => p.medication.id == med.id).map((p) => p.schedule);
      final upcoming = TaskExpander.expandRange(
        pairs: medSchedules
            .map((s) => MedicationSchedulePair(medication: med, schedule: s))
            .toList(),
        from: now,
        days: 14,
      );
      DateTime? nextAt;
      for (final t in upcoming) {
        final at = t.scheduledDateTime;
        if (at.isAfter(now)) {
          nextAt = at;
          break;
        }
      }
      cards.add(
        MedicationCardView(
          medication: med,
          schedules: medSchedules.toList(),
          nextPlannedAt: nextAt,
          nextDoseSummary: nextAt == null
              ? null
              : '${friendlyDate(nextAt, now: now)} ${friendlyTime(nextAt.hhMm)}',
        ),
      );
    }
    cards.sort((a, b) {
      final aTime = a.nextPlannedAt;
      final bTime = b.nextPlannedAt;
      if (aTime == null && bTime == null) {
        return a.medication.name.compareTo(b.medication.name);
      }
      if (aTime == null) {
        return 1;
      }
      if (bTime == null) {
        return -1;
      }
      return aTime.compareTo(bTime);
    });
    return cards;
  }

  /// 药品详情（含计划）。
  Future<(Medication, List<MedicationSchedule>)?> detail(String id) async {
    final med = await _meds.get(id);
    if (med == null) {
      return null;
    }
    return (med, await _meds.schedulesFor(id));
  }

  /// 名称模糊匹配（AI 工具 get_medication_detail / 打卡兜底用）。
  Future<Medication?> findByName(String name) async {
    final query = name.trim();
    if (query.isEmpty) {
      return null;
    }
    final meds = await _meds.listAll(includeArchived: false);
    for (final m in meds) {
      if (m.name == query) {
        return m;
      }
    }
    for (final m in meds) {
      if (m.name.contains(query) || query.contains(m.name)) {
        return m;
      }
    }
    return null;
  }

  /// 是否存在任何在用药品（首次引导判断）。
  Future<bool> hasAnyActive() async {
    final meds = await _meds.listAll(includeArchived: false);
    return meds.isNotEmpty;
  }

  /// 为无计划药品补一条按需计划（建卡时勾"不定时间"的兜底）。
  Future<void> ensureAsNeededSchedule(String medicationId) async {
    final schedules = await _meds.schedulesFor(medicationId);
    final has = schedules.any(
      (s) => s.frequencyType == FrequencyType.asNeeded,
    );
    if (!has) {
      await _meds.saveSchedule(_asNeededSchedule(medicationId, _now()));
    }
  }
}

/// 计划构建辅助：表单与草稿确认页共用。
class ScheduleDraftInput {
  const ScheduleDraftInput({
    required this.frequencyType,
    this.weekdays,
    this.intervalDays,
    this.times = const [],
    this.mealRelation,
  });

  final FrequencyType frequencyType;
  final List<int>? weekdays;
  final int? intervalDays;
  final List<TimeSlot> times;
  final MealRelation? mealRelation;

  MedicationSchedule build(String medicationId, {DateTime? now}) {
    final createdAt = now ?? DateTime.now();
    return MedicationSchedule(
      id: const Uuid().v4(),
      medicationId: medicationId,
      frequencyType: frequencyType,
      weekdays: weekdays,
      intervalDays: intervalDays,
      anchorDate:
          frequencyType == FrequencyType.intervalDays ? createdAt.isoDate : null,
      times: times,
      mealRelation: mealRelation,
      startDate: createdAt.dateOnly.isoDate,
      status: ScheduleStatus.active,
      createdAt: createdAt,
    );
  }
}
