import 'package:freezed_annotation/freezed_annotation.dart';

import '../../core/formatters.dart';
import 'enums.dart';

part 'dose_task.freezed.dart';

/// 服药任务：计划 × 日期展开出的当天实例（docs/05 §2 dose_tasks 表）。
///
/// id 是确定性的 `{scheduleId}|{date}|{time}`，保证展开幂等：
/// 同一天同一时刻重复展开不会产生重复任务。
@freezed
sealed class DoseTask with _$DoseTask {
  const factory DoseTask({
    required String id,
    required String scheduleId,
    required String medicationId,

    /// 应服日期（ISO yyyy-MM-dd）。
    required String scheduledDate,

    /// 应服时刻（HH:mm）。
    required String scheduledTime,
    required double plannedDose,

    required DoseStatus status,

    /// 实际打卡时间（epoch ms）。
    int? takenAt,

    MarkSource? markSource,

    /// 备注（AI 代办时带回的"刚才吃的"之类）。
    String? note,
  }) = _DoseTask;
}

extension DoseTaskX on DoseTask {
  DateTime get scheduledDateTime {
    final date = parseIsoDate(scheduledDate);
    final minutes = hhMmToMinutes(scheduledTime);
    return date.add(Duration(minutes: minutes));
  }

  bool get isPending => status == DoseStatus.pending;
  bool get isTaken => status == DoseStatus.taken;
  bool get isMissed => status == DoseStatus.missed;
  bool get isSkipped => status == DoseStatus.skipped;

  /// 是否为补记（与按点打卡区分，docs/06 §3）。
  bool get isCatchUp => markSource == MarkSource.catchUp;
}

/// 状态机允许的迁移（docs/05 §2 状态机）。
enum DoseAction { take, skip, undo }

extension DoseStatusMachine on DoseStatus {
  /// 判断某动作是否允许；不允许返回 false（由服务层抛错/忽略）。
  bool allows(DoseAction action) => switch (this) {
        DoseStatus.pending =>
          action == DoseAction.take || action == DoseAction.skip,
        DoseStatus.taken => action == DoseAction.undo,
        DoseStatus.skipped => action == DoseAction.undo,
        DoseStatus.missed => action == DoseAction.take, // 仅可补记
      };

  /// 迁移后的状态；不合法返回 null。
  DoseStatus? transition(DoseAction action) {
    if (!allows(action)) {
      return null;
    }
    return switch (action) {
      DoseAction.take => DoseStatus.taken,
      DoseAction.skip => DoseStatus.skipped,
      DoseAction.undo => DoseStatus.pending,
    };
  }
}
