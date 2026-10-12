import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/formatters.dart';
import '../../domain/models/dose_task.dart';
import '../../domain/models/enums.dart';
import '../../domain/models/view_models.dart';
import '../providers.dart';

/// 今日页控制器（docs/07：回答"现在该干什么？"）。
class TodayController extends AsyncNotifier<TodayView> {
  @override
  Future<TodayView> build() async {
    final dose = ref.watch(doseServiceProvider);
    final views = await dose.todayViews();
    return TodayView(
      date: DateTime.now().dateOnly,
      tasks: views,
      pendingCount: views.where((v) => v.task.isPending).length,
      missedCount: views.where((v) => v.task.isMissed).length,
      takenCount: views.where((v) => v.task.isTaken).length,
    );
  }

  /// 打卡（含撤销用的摘要文案）。返回 null=成功。
  Future<String?> markTaken(
    String taskId, {
    MarkSource source = MarkSource.tap,
    DateTime? at,
    String? note,
  }) async {
    try {
      await ref.read(doseServiceProvider).markTaken(
        taskId,
        source: source,
        at: at,
        note: note,
      );
      await ref.read(reminderSchedulerProvider).syncUpcoming();
      _refreshRelated();
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> skip(String taskId) async {
    try {
      await ref.read(doseServiceProvider).skip(taskId);
      await ref.read(reminderSchedulerProvider).syncUpcoming();
      _refreshRelated();
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> undo(String taskId) async {
    try {
      await ref.read(doseServiceProvider).undo(taskId);
      await ref.read(reminderSchedulerProvider).syncUpcoming();
      _refreshRelated();
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  /// 按需药打卡。
  Future<String?> logAsNeeded(String medicationId, {String? note}) async {
    try {
      await ref.read(doseServiceProvider).logAsNeeded(
            medicationId,
            note: note,
          );
      _refreshRelated();
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  void _refreshRelated() {
    ref.invalidateSelf();
    ref.invalidate(cabinetControllerProvider);
  }
}

final todayControllerProvider =
    AsyncNotifierProvider<TodayController, TodayView>(
  TodayController.new,
);

/// 药箱页控制器。
class CabinetController extends AsyncNotifier<List<MedicationCardView>> {
  @override
  Future<List<MedicationCardView>> build() async {
    return ref.watch(medicationServiceProvider).cards();
  }

  Future<void> archive(String id) async {
    await ref.read(medicationServiceProvider).archive(id);
    await ref.read(reminderSchedulerProvider).syncUpcoming();
    ref.invalidateSelf();
  }
}

final cabinetControllerProvider =
    AsyncNotifierProvider<CabinetController, List<MedicationCardView>>(
  CabinetController.new,
);
