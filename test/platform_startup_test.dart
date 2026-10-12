import 'dart:async';

import 'package:care_pill/app.dart';
import 'package:care_pill/application/app_bootstrap.dart';
import 'package:care_pill/application/platform_startup.dart';
import 'package:care_pill/application/providers.dart';
import 'package:care_pill/application/router.dart';
import 'package:care_pill/data/settings/app_settings.dart';
import 'package:care_pill/data/settings/key_value_store.dart';
import 'package:care_pill/i18n/strings.g.dart';
import 'package:care_pill/ui/onboarding/onboarding_page.dart';
import 'package:care_pill/ui/today/reminder_fullscreen_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fakes/fakes.dart';

void main() {
  test('通知和维护失败不会妨碍读取冷启动通知，只启动一次', () async {
    final payloads = <String>[];
    var notificationAttempts = 0;
    var maintenanceAttempts = 0;
    final startup = AppPlatformStartup(
      initializeNotifications: () async {
        notificationAttempts++;
        throw StateError('invalid_icon');
      },
      registerMaintenance: () async {
        maintenanceAttempts++;
        throw StateError('workmanager unavailable');
      },
      readLaunchPayload: () async => '{"taskIds":["dose-1"]}',
      onLaunchPayload: payloads.add,
    );
    await Future.wait([startup.start(), startup.start()]);
    expect(notificationAttempts, 1);
    expect(maintenanceAttempts, 1);
    expect(payloads, ['{"taskIds":["dose-1"]}']);
  });

  test('插件无响应会超时，迟到的通知启动结果不再跳转', () async {
    final notifications = Completer<void>();
    final maintenance = Completer<void>();
    final launch = Completer<String?>();
    final payloads = <String>[];
    final startup = AppPlatformStartup(
      initializeNotifications: () => notifications.future,
      registerMaintenance: () => maintenance.future,
      readLaunchPayload: () => launch.future,
      onLaunchPayload: payloads.add,
      taskTimeout: const Duration(milliseconds: 30),
    );
    await startup.start();
    launch.complete('late');
    notifications.complete();
    maintenance.complete();
    await Future<void>.delayed(Duration.zero);
    expect(payloads, isEmpty);
  });

  test('释放启动器后忽略通知结果', () async {
    final launch = Completer<String?>();
    final payloads = <String>[];
    final startup = AppPlatformStartup(
      initializeNotifications: () async {},
      readLaunchPayload: () => launch.future,
      onLaunchPayload: payloads.add,
    );
    final pending = startup.start();
    startup.dispose();
    launch.complete('late');
    await pending;
    expect(payloads, isEmpty);
  });

  for (final fails in [false, true]) {
    testWidgets('平台服务${fails ? '失败' : '无响应'}仍显示首帧并能进入引导下一步', (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final notification = Completer<void>();
      final maintenance = Completer<void>();
      final startup = AppPlatformStartup(
        initializeNotifications: () {
          // 必须在首帧已经有可用页面之后才调用插件。
          expect(find.byType(OnboardingPage), findsOneWidget);
          return fails
              ? Future.error(StateError('invalid_icon'))
              : notification.future;
        },
        registerMaintenance: () => fails
            ? Future.error(StateError('workmanager unavailable'))
            : maintenance.future,
        readLaunchPayload: () async => null,
        onLaunchPayload: (_) {},
      );
      final container = _container(startup);
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const PillPalApp(),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(OnboardingPage), findsOneWidget);
      await tester.tap(find.text(tr.onboarding.start));
      await tester.pumpAndSettle();
      expect(find.byType(BackButton), findsOneWidget);
      expect(tester.takeException(), isNull);
      notification.complete();
      maintenance.complete();
      await tester.pump(const Duration(seconds: 1));
      await tester.pumpWidget(const SizedBox.shrink());
      startup.dispose();
      container.dispose();
    });
  }

  testWidgets('首帧后读取冷启动通知并进入提醒页', (tester) async {
    final launch = Completer<String?>();
    final startup = AppPlatformStartup(
      initializeNotifications: () async {},
      readLaunchPayload: () => launch.future,
      onLaunchPayload: handleReminderPayload,
    );
    final container = _container(startup, onboardingDone: true);
    // 真实路由 + 内存仓库，检验提醒页参数，而非只检验回调被调用。
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const PillPalApp(),
      ),
    );
    await tester.pumpAndSettle();
    expect(container.read(routerProvider).state.uri.path, '/today');
    launch.complete('{"taskIds":["dose-1","dose-2"]}');
    await tester.pumpAndSettle();
    expect(container.read(routerProvider).state.uri.path, '/reminder');
    expect(
      tester
          .widget<ReminderFullscreenPage>(find.byType(ReminderFullscreenPage))
          .taskIds,
      ['dose-1', 'dose-2'],
    );
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
    startup.dispose();
    container.dispose();
  });
}

ProviderContainer _container(
  AppPlatformStartup startup, {
  bool onboardingDone = false,
}) {
  final store = InMemoryKeyValueStore();
  store.setBool(SettingKeys.onboardingDone, onboardingDone);
  return ProviderContainer(
    overrides: [
      keyValueStoreProvider.overrideWithValue(store),
      appBootstrapProvider.overrideWith((ref) {}),
      appPlatformStartupProvider.overrideWithValue(startup),
      medicationRepositoryProvider.overrideWithValue(
        InMemoryMedicationRepository(),
      ),
      doseTaskRepositoryProvider.overrideWithValue(
        InMemoryDoseTaskRepository(),
      ),
      reminderGatewayProvider.overrideWithValue(FakeReminderGateway()),
      speechServiceProvider.overrideWithValue(FakeSpeechService()),
    ],
  );
}
