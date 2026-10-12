import 'package:care_pill/i18n/strings.g.dart';

import '../../core/formatters.dart';

/// 依从性统计（docs/02 F9）。
///
/// 口径：应服 = 非 skipped 的任务；已服 = status=taken；依从率 = 已服/应服。
class AdherenceStats {
  const AdherenceStats({
    required this.days,
    required this.expected,
    required this.taken,
    required this.missed,
    required this.skipped,
  });

  final int days;
  final int expected;
  final int taken;
  final int missed;
  final int skipped;

  double get rate => expected == 0 ? 1 : taken / expected;

  /// 口语化描述，供 AI 周报与 UI 使用（docs/07 §5）。
  String toFriendlyText() {
    if (expected == 0) {
      return tr.stats.emptySummary(arg1: (days).toString());
    }
    final percent = (rate * 100).round();
    return tr.stats.summary(
      arg1: (days).toString(),
      arg2: (expected).toString(),
      arg3: (taken).toString(),
      arg4: (missed).toString(),
      arg5: (percent).toString(),
    );
  }

  Map<String, dynamic> toToolJson() => {
    'days': days,
    'expected': expected,
    'taken': taken,
    'missed': missed,
    'skipped': skipped,
    'adherence_rate': (rate * 1000).round() / 1000,
  };
}

/// 单日健康度（docs/02 F9：绿=全服、黄=有跳过、红=有漏服）。
enum DayHealth { none, allTaken, hasSkipped, hasMissed, incomplete }

class DayHealthEntry {
  const DayHealthEntry({
    required this.date,
    required this.health,
    required this.total,
    required this.done,
  });

  final DateTime date;
  final DayHealth health;
  final int total;
  final int done;
}

DayHealth computeDayHealth({
  required int total,
  required int taken,
  required int missed,
  required int skipped,
}) {
  if (total == 0) {
    return DayHealth.none;
  }
  if (missed > 0) {
    return DayHealth.hasMissed;
  }
  if (skipped > 0) {
    return DayHealth.hasSkipped;
  }
  if (taken >= total) {
    return DayHealth.allTaken;
  }
  return DayHealth.incomplete;
}

/// 下一顿的口语摘要："晚上 8 点，降压药 1 片，餐后"。
String friendlyNextDose({
  required DateTime scheduledAt,
  required String medicationName,
  required double dose,
  required String unit,
  required DateTime now,
  String? meal,
}) {
  final dateText = friendlyDate(scheduledAt, now: now);
  final timeText = friendlyTime(scheduledAt.hhMm);
  final mealText = friendlyMeal(meal);
  return '$dateText $timeText，$medicationName ${friendlyDose(dose, unit)}'
      '${mealText == null ? '' : '，$mealText'}';
}
