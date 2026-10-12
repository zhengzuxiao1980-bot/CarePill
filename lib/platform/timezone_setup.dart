import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

/// 初始化应用使用的本地墙钟时区。
///
/// 主 isolate 和 WorkManager 后台 isolate 都必须调用，避免后台续排时
/// 把本地时间误当成 UTC。
void initializePillPalTimeZone() {
  tzdata.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation(_localTimeZoneName()));
}

String _localTimeZoneName() {
  final offset = DateTime.now().timeZoneOffset;
  if (offset == const Duration(hours: 8)) {
    return 'Asia/Shanghai';
  }
  return _fallbackZone(offset);
}

String _fallbackZone(Duration offset) {
  const known = <String, Duration>{
    'Asia/Tokyo': Duration(hours: 9),
    'Asia/Singapore': Duration(hours: 8),
    'Asia/Hong_Kong': Duration(hours: 8),
    'Asia/Kolkata': Duration(hours: 5, minutes: 30),
    'Europe/London': Duration.zero,
    'Europe/Paris': Duration(hours: 1),
    'America/New_York': Duration(hours: -5),
    'America/Chicago': Duration(hours: -6),
    'America/Denver': Duration(hours: -7),
    'America/Los_Angeles': Duration(hours: -8),
  };
  for (final entry in known.entries) {
    if (entry.value == offset) {
      return entry.key;
    }
  }
  final hours = offset.inHours;
  return hours >= 0 ? 'Etc/GMT-$hours' : 'Etc/GMT+${-hours}';
}
