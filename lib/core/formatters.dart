/// 时间口语化格式化（docs/04 core 约定、docs/07 §5 文案原则）。
///
/// "时间说'早上 8 点'不说 '08:00'"。
library;

import 'package:intl/intl.dart';

import '../i18n/strings.g.dart';

extension DateOnlyX on DateTime {
  /// 去掉时分秒的"日期"（保留本地时区语义，任务展开的锚点）。
  DateTime get dateOnly => DateTime(year, month, day);

  bool isSameDate(DateTime other) =>
      year == other.year && month == other.month && day == other.day;

  /// docs/05：weekdays 字段周一=1，与 Dart 的 weekday 定义一致。
  int get weekdayMonday1 => weekday;

  /// ISO 日期字符串（yyyy-MM-dd），dose_tasks.scheduled_date 存储格式。
  String get isoDate => DateFormat('yyyy-MM-dd', 'en_US').format(this);

  /// HH:mm。
  String get hhMm => DateFormat('HH:mm', 'en_US').format(this);
}

/// 解析 ISO 日期（yyyy-MM-dd）。
DateTime parseIsoDate(String s) {
  final parts = s.split('-');
  return DateTime(
    int.parse(parts[0]),
    int.parse(parts[1]),
    int.parse(parts[2]),
  );
}

/// 校验 HH:mm 格式（docs/03 §6 时刻格式校验）。
bool isValidHhMm(String s) {
  final m = RegExp(r'^(\d{1,2}):(\d{2})$').firstMatch(s);
  if (m == null) {
    return false;
  }
  final h = int.parse(m.group(1)!);
  final min = int.parse(m.group(2)!);
  return h >= 0 && h < 24 && min >= 0 && min < 60;
}

/// 解析 HH:mm 为当天分钟数。
int hhMmToMinutes(String s) {
  final parts = s.split(':');
  return int.parse(parts[0]) * 60 + int.parse(parts[1]);
}

/// 分钟数转 HH:mm。
String minutesToHhMm(int minutes) {
  final h = (minutes ~/ 60) % 24;
  final m = minutes % 60;
  return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}';
}

/// "早上 8 点"式口语时间。
String friendlyTime(String hhMm) {
  final minutes = hhMmToMinutes(hhMm);
  final h = minutes ~/ 60;
  final m = minutes % 60;
  if (LocaleSettings.currentLocale == AppLocale.en) {
    return DateFormat.jm('en_US').format(DateTime(2000, 1, 1, h, m));
  }
  final period = switch (h) {
    < 6 => tr.time.earlyMorning,
    < 9 => tr.time.morning,
    < 11 => tr.time.lateMorning,
    < 13 => tr.time.noon,
    < 18 => tr.time.afternoon,
    _ => tr.time.evening,
  };
  final hour12 = h % 12 == 0 ? 12 : h % 12;
  if (m == 0) {
    return tr.time.onHour(period: period, hour: hour12);
  }
  if (m == 30) {
    return tr.time.halfHour(period: period, hour: hour12);
  }
  return tr.time.withMinutes(period: period, hour: hour12, minute: m);
}

/// 今天 / 明天 / 昨天 / 具体日期。
String friendlyDate(DateTime date, {required DateTime now}) {
  final d = date.dateOnly;
  final today = now.dateOnly;
  if (d.isSameDate(today)) {
    return tr.time.today;
  }
  if (d.isSameDate(today.add(const Duration(days: 1)))) {
    return tr.time.tomorrow;
  }
  if (d.isSameDate(today.subtract(const Duration(days: 1)))) {
    return tr.time.yesterday;
  }
  return LocaleSettings.currentLocale == AppLocale.en
      ? DateFormat.MMMd('en_US').format(date)
      : tr.time.date(month: date.month, day: date.day);
}

/// 剂量口语："1 片" / "半片" / "1.5 片"。
String friendlyDose(double dose, String unit) {
  final text = dose == dose.roundToDouble()
      ? dose.round().toString()
      : dose.toStringAsFixed(1);
  // Chinese has no singular/plural distinction. English counts use Slang's
  // plural resolver; custom units are displayed exactly as entered.
  if (LocaleSettings.currentLocale == AppLocale.zh) {
    return tr.units.dose(amount: text, unit: friendlyUnit(unit));
  }
  return switch (unit.trim().toLowerCase()) {
    '片' || 'tablet' || 'tablets' => tr.units.tabletCount(n: dose, amount: text),
    '粒' ||
    'capsule' ||
    'capsules' => tr.units.capsuleCount(n: dose, amount: text),
    '喷' || 'spray' || 'sprays' => tr.units.sprayCount(n: dose, amount: text),
    '支' || 'vial' || 'vials' => tr.units.vialCount(n: dose, amount: text),
    '贴' || 'patch' || 'patches' => tr.units.patchCount(n: dose, amount: text),
    '毫升' || 'ml' => tr.units.dose(amount: text, unit: tr.units.ml),
    _ => tr.units.dose(amount: text, unit: unit),
  };
}

String friendlyUnit(String unit) => switch (unit.trim().toLowerCase()) {
  '片' || 'tablet' || 'tablets' => tr.units.tablet,
  '粒' || 'capsule' || 'capsules' => tr.units.capsule,
  '毫升' || 'ml' => tr.units.ml,
  '喷' || 'spray' || 'sprays' => tr.units.spray,
  '支' || 'vial' || 'vials' => tr.units.vial,
  '贴' || 'patch' || 'patches' => tr.units.patch,
  _ => unit,
};

/// 餐前/餐中/餐后标签。
String? friendlyMeal(String? meal) => switch (meal) {
  'before' => tr.enums.mealRelation.before,
  'with' => tr.enums.mealRelation.with_,
  'after' => tr.enums.mealRelation.after,
  _ => null,
};

/// 相对时间口语："3 分钟后" / "过了 20 分钟"。
String friendlyRelative(Duration duration) {
  final abs = duration.abs();
  if (abs.inSeconds < 60) {
    return duration.isNegative ? tr.time.justNow : tr.time.soon;
  }
  if (abs.inMinutes < 60) {
    return duration.isNegative
        ? tr.time.minutesAgo(count: abs.inMinutes)
        : tr.time.minutesFromNow(count: abs.inMinutes);
  }
  final hours = abs.inMinutes ~/ 60;
  final minutes = abs.inMinutes % 60;
  final core = minutes == 0
      ? tr.time.hours(hours: hours)
      : tr.time.hoursMinutes(hours: hours, minutes: minutes);
  return duration.isNegative
      ? tr.time.ago(duration: core)
      : tr.time.fromNow(duration: core);
}

String friendlyWeekday(int weekday) => [
  tr.weekdays.mon,
  tr.weekdays.tue,
  tr.weekdays.wed,
  tr.weekdays.thu,
  tr.weekdays.fri,
  tr.weekdays.sat,
  tr.weekdays.sun,
][weekday - 1];
