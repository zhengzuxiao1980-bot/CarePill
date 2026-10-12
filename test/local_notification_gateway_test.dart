import 'dart:async';

import 'package:care_pill/platform/local_notification_gateway.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const channel = MethodChannel('dexterous.com/flutter/local_notifications');
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

  setUp(() {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    AndroidFlutterLocalNotificationsPlugin.registerWith();
  });
  tearDown(() {
    messenger.setMockMethodCallHandler(channel, null);
    debugDefaultTargetPlatformOverride = null;
  });

  test('并发初始化和通知操作共享一次初始化', () async {
    final initialized = Completer<bool>();
    final calls = <MethodCall>[];
    messenger.setMockMethodCallHandler(channel, (call) async {
      calls.add(call);
      if (call.method == 'initialize') return initialized.future;
      return null;
    });
    final gateway = LocalNotificationGateway(onNotificationTap: (_) {});
    final first = gateway.init();
    final second = gateway.init();
    final show = gateway.showNow(
      id: 1,
      title: 'Test',
      body: 'Test',
      payload: '',
      fullScreen: false,
    );
    await Future<void>.delayed(Duration.zero);
    expect(calls.map((c) => c.method), ['initialize']);
    expect(identical(first, second), isTrue);
    expect((calls.single.arguments as Map)['defaultIcon'], 'ic_notification');
    initialized.complete(true);
    await Future.wait([first, second, show]);
    await gateway.init();
    expect(calls.where((c) => c.method == 'initialize').length, 1);
    expect(calls.map((c) => c.method), [
      'initialize',
      'createNotificationChannel',
      'show',
    ]);
  });

  test('初始化失败后下次通知操作能重试', () async {
    var attempts = 0;
    messenger.setMockMethodCallHandler(channel, (call) async {
      if (call.method == 'initialize') {
        if (++attempts == 1) throw PlatformException(code: 'invalid_icon');
        return true;
      }
      return null;
    });
    final gateway = LocalNotificationGateway(onNotificationTap: (_) {});
    await expectLater(gateway.init(), throwsA(isA<PlatformException>()));
    await gateway.cancel(1);
    expect(attempts, 2);
  });

  test('初始化超时后可重试，迟到成功不覆盖新初始化', () async {
    final stalled = Completer<bool>();
    var attempts = 0;
    messenger.setMockMethodCallHandler(channel, (call) async {
      if (call.method == 'initialize') {
        if (++attempts == 1) return stalled.future;
        return true;
      }
      return null;
    });
    final gateway = LocalNotificationGateway(
      onNotificationTap: (_) {},
      initializationTimeout: const Duration(milliseconds: 30),
    );
    await expectLater(gateway.init(), throwsA(isA<TimeoutException>()));
    await gateway.init();
    stalled.complete(true);
    await Future<void>.delayed(Duration.zero);
    await gateway.init();
    expect(attempts, 2);
  });

  test('冷启动意图读取不需要初始化通知插件', () async {
    final calls = <String>[];
    messenger.setMockMethodCallHandler(channel, (call) async {
      calls.add(call.method);
      return {
        'notificationLaunchedApp': true,
        'notificationResponse': {
          'payload': '{"taskIds":["dose"]}',
          'notificationResponseType': 0,
        },
      };
    });
    final gateway = LocalNotificationGateway(onNotificationTap: (_) {});
    expect(await gateway.initialLaunchPayload(), '{"taskIds":["dose"]}');
    expect(calls, ['getNotificationAppLaunchDetails']);
  });

  test('iOS 初始化不弹权限，权限由引导显式申请', () async {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    IOSFlutterLocalNotificationsPlugin.registerWith();
    final calls = <MethodCall>[];
    messenger.setMockMethodCallHandler(channel, (call) async {
      calls.add(call);
      return true;
    });
    final gateway = LocalNotificationGateway(onNotificationTap: (_) {});
    await gateway.init();
    final settings = calls.single.arguments as Map;
    expect(settings['requestAlertPermission'], false);
    expect(settings['requestBadgePermission'], false);
    expect(settings['requestSoundPermission'], false);
    expect(await gateway.requestPermissions(), true);
    expect(calls.last.method, 'requestPermissions');
    expect((calls.last.arguments as Map)['alert'], true);
  });
}
