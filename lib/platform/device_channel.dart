import 'package:care_pill/i18n/strings.g.dart';
import 'package:flutter/services.dart';

import '../core/app_logger.dart';

/// Android 设备信息与系统设置直达（ROM 保活引导，docs/06 §4）。
///
/// 实现在 MainActivity.kt 的小型 MethodChannel，不引入额外依赖。
class DeviceInfoChannel {
  static const MethodChannel _channel = MethodChannel('pillpal/device');

  /// 厂商（小米/华为/荣耀/OPPO/vivo…），非 Android 返回 null。
  static Future<String?> manufacturer() =>
      _safe<String?>(() => _channel.invokeMethod<String>('manufacturer'));

  static Future<bool> isIgnoringBatteryOptimizations() async =>
      await _safe<bool?>(
        () => _channel.invokeMethod<bool>('ignoringBattery'),
      ) ??
      true;

  static Future<bool> fullScreenIntentEnabled() async =>
      await _safe<bool?>(
        () => _channel.invokeMethod<bool>('fullScreenIntent'),
      ) ??
      true;

  static Future<void> openBatteryOptimizationSettings() =>
      _safe<void>(() => _channel.invokeMethod('openBatterySettings'));

  static Future<void> openExactAlarmSettings() =>
      _safe<void>(() => _channel.invokeMethod('openAlarmSettings'));

  static Future<void> openAppNotificationSettings() =>
      _safe<void>(() => _channel.invokeMethod('openNotificationSettings'));

  static Future<void> openSpeechSettings({bool permission = false}) =>
      _safe<void>(
        () => _channel.invokeMethod('openSpeechSettings', {
          'permission': permission,
        }),
      );

  static Future<T?> _safe<T>(Future<T> Function() call) async {
    try {
      return await call();
    } on PlatformException catch (e) {
      AppLog.w('设备通道调用失败：${e.code} ${e.message}');
      return null;
    } on MissingPluginException {
      return null;
    }
  }
}

/// 厂商 → 引导文案（docs/06 §4：自启动+锁后台+通知三类开关）。
String romGuideTitle(String? manufacturer) {
  final m = manufacturer ?? '';
  if (m.contains('xiaomi') || m.contains('redmi')) {
    return tr.deviceChannel.xiaomiTitle;
  }
  if (m.contains('HUAWEI') || m.contains('HONOR')) {
    return tr.deviceChannel.huaweiTitle;
  }
  if (m.contains('OPPO') || m.contains('realme')) {
    return tr.deviceChannel.oppoTitle;
  }
  if (m.contains('vivo') || m.contains('iQOO')) {
    return tr.deviceChannel.vivoTitle;
  }
  return tr.deviceChannel.title;
}

List<String> romGuideSteps(String? manufacturer) {
  final m = manufacturer ?? '';
  final steps = <String>[
    tr.deviceChannel.autoStart,
    tr.deviceChannel.battery,
    tr.deviceChannel.notifications,
  ];
  if (m.contains('xiaomi') || m.contains('redmi')) {
    steps.insert(0, tr.deviceChannel.xiaomiHint);
  }
  return steps;
}
