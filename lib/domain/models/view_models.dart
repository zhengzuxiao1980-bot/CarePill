/// 展示层视图模型（普通不可变类，聚合实体与派生信息）。
library;

import 'ai_model_config.dart';
import 'dose_task.dart';
import 'enums.dart';
import 'medication.dart';
import 'schedule.dart';

/// 今日任务视图：任务 + 药品展示信息。
class DoseTaskView {
  const DoseTaskView({
    required this.task,
    required this.medicationName,
    required this.doseUnit,
    this.form = MedicationForm.other,
    this.meal,
    this.asNeeded = false,
  });

  final DoseTask task;
  final String medicationName;
  final String doseUnit;
  final MedicationForm form;

  /// 餐前/餐中/餐后（时刻级优先，计划级兜底）。
  final MealRelation? meal;

  /// 是否按需药。
  final bool asNeeded;
}

/// 今日页数据。
class TodayView {
  const TodayView({
    required this.date,
    required this.tasks,
    required this.pendingCount,
    required this.missedCount,
    required this.takenCount,
  });

  final DateTime date;
  final List<DoseTaskView> tasks;
  final int pendingCount;
  final int missedCount;
  final int takenCount;

  /// 顶部"下一顿"：最近的待服任务。
  DoseTaskView? nextUp() {
    final now = DateTime.now();
    final pending = tasks.where((t) => t.task.isPending).toList()
      ..sort(
        (a, b) => a.task.scheduledDateTime.compareTo(b.task.scheduledDateTime),
      );
    if (pending.isEmpty) {
      return null;
    }
    return pending.firstWhere(
      (t) => t.task.scheduledDateTime.isAfter(now),
      orElse: () => pending.last,
    );
  }
}

/// 药箱列表项：药品 + 计划摘要 + 下一次服药时间。
class MedicationCardView {
  const MedicationCardView({
    required this.medication,
    required this.schedules,
    this.nextPlannedAt,
    this.nextDoseSummary,
  });

  final Medication medication;
  final List<MedicationSchedule> schedules;

  /// 下一次服药时间（按"下一次服药时间"排序，最紧急排最前，docs/02 F1）。
  final DateTime? nextPlannedAt;
  final String? nextDoseSummary;
}

/// 模型配置列表项。
class ModelConfigView {
  const ModelConfigView({
    required this.config,
    required this.hasKey,
    this.lastTestOk,
    this.lastTestMessage,
  });

  final AiModelConfig config;

  /// 密钥是否已配置（不返回密钥内容）。
  final bool hasKey;

  /// 上次连通性测试结果（docs/07 模型管理页显示状态）。
  final bool? lastTestOk;
  final String? lastTestMessage;
}

/// AI 代办写操作的回显事件（docs/03 §4 可撤销确认条）。
class AgentWriteEvent {
  const AgentWriteEvent({
    required this.taskId,
    required this.summary,
    required this.kind,
    this.operationId,
  });

  final String kind; // taken / skipped / draft
  final String taskId;
  final String summary;
  final String? operationId;
}
