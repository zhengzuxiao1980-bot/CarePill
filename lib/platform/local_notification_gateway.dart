import 'dart:convert';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

import '../core/app_constants.dart';
import '../core/app_logger.dart';
import '../domain/services/reminder_scheduler.dart';
import '../i18n/strings.g.dart';

/// 本地通知网关：系统实现（docs/06）。
///
/// - 高优先级渠道 + 闹钟音频属性（媒体静音也能响）+ 自定义长铃声；
/// - fullScreenIntent 锁屏直接弹全屏提醒页；
/// - 精确闹钟不可用时退化 inexact（docs/06 §4）。
class LocalNotificationGateway implements ReminderGateway {
  LocalNotificationGateway({
    required void Function(String payload) onNotificationTap,
    this.initializationTimeout = const Duration(seconds: 10),
  }) : _onTap = onNotificationTap;

  final void Function(String payload) _onTap;

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  final Duration initializationTimeout;
  Future<void>? _initialization;

  /// 并发调用共享初始化；失败或超时后允许下次操作重试。
  Future<void> init() {
    if (_initialization != null) return _initialization!;
    late final Future<void> pending;
    pending = _initialize()
        .timeout(initializationTimeout)
        .then(
          (_) => AppLog.i('通知插件初始化完成'),
          onError: (Object error, StackTrace stack) {
            if (identical(_initialization, pending)) _initialization = null;
            Error.throwWithStackTrace(error, stack);
          },
        );
    return _initialization = pending;
  }

  Future<void> _initialize() async {
    const androidInit = AndroidInitializationSettings('ic_notification');
    const darwinInit = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    await _plugin.initialize(
      settings: const InitializationSettings(
        android: androidInit,
        iOS: darwinInit,
      ),
      onDidReceiveNotificationResponse: (response) {
        AppLog.i('通知点击 id=${response.id} payload=${response.payload}');
        _onTap(response.payload ?? '');
      },
    );
    await _createChannelIfNeeded();
  }

  Future<void> _createChannelIfNeeded() async {
    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (android == null) {
      return;
    }
    final channel = AndroidNotificationChannel(
      kReminderChannelId,
      tr.notifications.channelName,
      description: tr.notifications.channelDescription,
      importance: Importance.max,
      sound: RawResourceAndroidNotificationSound('alert_long'),
      audioAttributesUsage: AudioAttributesUsage.alarm,
    );
    await android.createNotificationChannel(channel);
  }

  NotificationDetails _details({
    required bool fullScreen,
    required bool withSound,
  }) {
    final android = AndroidNotificationDetails(
      kReminderChannelId,
      tr.notifications.channelName,
      channelDescription: tr.notifications.channelDescription,
      importance: Importance.max,
      priority: Priority.max,
      category: AndroidNotificationCategory.alarm,
      fullScreenIntent: fullScreen,
      audioAttributesUsage: AudioAttributesUsage.alarm,
      sound: withSound
          ? const RawResourceAndroidNotificationSound('alert_long')
          : null,
      autoCancel: true,
    );
    const ios = DarwinNotificationDetails(
      presentAlert: true,
      presentSound: true,
      presentBanner: true,
      interruptionLevel: InterruptionLevel.timeSensitive,
    );
    return NotificationDetails(android: android, iOS: ios);
  }

  @override
  Future<void> schedule(ReminderPlanItem item) async {
    await init();
    final scheduled = tz.TZDateTime.from(item.at, tz.local);
    final details = _details(
      fullScreen: item.fullScreen,
      withSound: item.withSound,
    );
    try {
      await _plugin.zonedSchedule(
        id: item.id,
        title: item.title,
        body: item.body,
        payload: item.payload,
        scheduledDate: scheduled,
        notificationDetails: details,
        androidScheduleMode: await exactAlarmsEnabled()
            ? AndroidScheduleMode.exactAllowWhileIdle
            : AndroidScheduleMode.inexactAllowWhileIdle,
      );
      AppLog.d('注册提醒 id=${item.id} at=${item.at}');
    } catch (e, st) {
      // 精确闹钟被拒/系统限制：退化到 inexact（docs/06 §4）。
      AppLog.w('注册精确提醒失败，退化 inexact：$e', e, st);
      try {
        await _plugin.zonedSchedule(
          id: item.id,
          title: item.title,
          body: item.body,
          payload: item.payload,
          scheduledDate: scheduled,
          notificationDetails: details,
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        );
      } catch (e2) {
        AppLog.e('注册提醒彻底失败 id=${item.id}', e2);
      }
    }
  }

  @override
  Future<void> cancel(int id) async {
    await init();
    await _plugin.cancel(id: id);
  }

  @override
  Future<void> cancelAllScheduled() async {
    await init();
    // Android allows updating a channel's display name without changing its ID
    // or the user's permission/sound settings when the app language changes.
    await _createChannelIfNeeded();
    await _plugin.cancelAll();
  }

  /// 冷启动是否由通知拉起（docs/06 §6 深链）。
  Future<String?> initialLaunchPayload() async {
    // 读取 Activity 启动意图不依赖初始化，通知服务失败也保留冷启动深链。
    final details = await _plugin.getNotificationAppLaunchDetails();
    if (details == null || !details.didNotificationLaunchApp) {
      return null;
    }
    return details.notificationResponse?.payload;
  }

  @override
  Future<bool> notificationsEnabled() async {
    await init();
    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    final enabled = await android?.areNotificationsEnabled();
    return enabled ?? true;
  }

  @override
  Future<bool> exactAlarmsEnabled() async {
    await init();
    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    final can = await android?.canScheduleExactNotifications();
    return can ?? true;
  }

  @override
  Future<bool> requestPermissions() async {
    await init();
    var ok = true;
    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (android != null) {
      final granted = await android.requestNotificationsPermission();
      ok = granted ?? true;
      await android.requestExactAlarmsPermission();
      await android.requestFullScreenIntentPermission();
    }
    final ios = _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();
    if (ios != null) {
      ok =
          await ios.requestPermissions(alert: true, badge: true, sound: true) ??
          true;
    }
    return ok;
  }

  @override
  Future<void> showNow({
    required int id,
    required String title,
    required String body,
    required String payload,
    required bool fullScreen,
  }) async {
    await init();
    await _plugin.show(
      id: id,
      title: title,
      body: body,
      payload: payload,
      notificationDetails: _details(fullScreen: fullScreen, withSound: true),
    );
  }
}

/// 解析提醒通知 payload（纯函数，可测）：
/// `{"taskIds": ["id1", "id2"]}`。
List<String> parseReminderPayload(String? payload) {
  if (payload == null || payload.isEmpty) {
    return const [];
  }
  try {
    final decoded = jsonDecode(payload);
    if (decoded is Map<String, dynamic> && decoded['taskIds'] is List) {
      return (decoded['taskIds'] as List).whereType<String>().toList();
    }
  } catch (_) {
    // payload 只在调试/升级跨版本时可能损坏，静默忽略。
  }
  return const [];
}
