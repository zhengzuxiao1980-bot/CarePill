import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'application/platform_startup.dart';
import 'application/providers.dart';
import 'application/router.dart';
import 'background/daily_maintenance.dart';
import 'core/app_logger.dart';
import 'data/settings/app_settings.dart';
import 'data/settings/key_value_store.dart';
import 'i18n/locale_preferences.dart';
import 'platform/local_notification_gateway.dart';
import 'platform/timezone_setup.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  await initializeLocale(
    SettingsService(SharedPreferencesStore(prefs)),
    deviceLocale: PlatformDispatcher.instance.locale.toLanguageTag(),
  );

  // 时区（提醒精确到本地墙钟，docs/06 §6）。
  initializePillPalTimeZone();

  // 日志：debug 全量 + 文件留痕（docs/04 §10）。
  String? logDir;
  try {
    final docs = await getApplicationDocumentsDirectory();
    logDir = '${docs.path}${Platform.pathSeparator}logs';
  } catch (_) {
    logDir = null; // 单测/桌面环境没有路径插件。
  }
  AppLog.init(verbose: kDebugMode, logDirectory: logDir);
  FlutterError.onError = (details) {
    AppLog.recordCrash(
      'flutter',
      details.exception,
      details.stack ?? StackTrace.empty,
    );
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    AppLog.recordCrash('platform', error, stack);
    return true;
  };

  // 先显示 Flutter 页面，通知和后台服务在首帧后初始化。
  final gateway = LocalNotificationGateway(
    onNotificationTap: handleReminderPayload,
  );

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        // 所有前台提醒共用同一网关，避免重复注册插件回调。
        reminderGatewayProvider.overrideWithValue(gateway),
        appPlatformStartupProvider.overrideWith((ref) {
          final startup = AppPlatformStartup(
            initializeNotifications: gateway.init,
            readLaunchPayload: gateway.initialLaunchPayload,
            onLaunchPayload: handleReminderPayload,
            registerMaintenance: Platform.isAndroid
                ? registerPillPalMaintenance
                : null,
          );
          ref.onDispose(startup.dispose);
          return startup;
        }),
      ],
      child: const PillPalApp(),
    ),
  );
}
