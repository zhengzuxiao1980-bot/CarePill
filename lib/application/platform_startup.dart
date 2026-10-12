import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/app_logger.dart';

/// main 注入平台服务；App 首帧后启动，测试可替换或不启用。
final appPlatformStartupProvider = Provider<AppPlatformStartup?>((ref) => null);

/// 非必需的平台启动工作不得阻塞首帧，也不得阻塞彼此。
class AppPlatformStartup {
  AppPlatformStartup({
    required this.initializeNotifications,
    required this.readLaunchPayload,
    required this.onLaunchPayload,
    this.registerMaintenance,
    this.taskTimeout = const Duration(seconds: 10),
  });

  final Future<void> Function() initializeNotifications;
  final Future<String?> Function() readLaunchPayload;
  final void Function(String) onLaunchPayload;
  final Future<void> Function()? registerMaintenance;
  final Duration taskTimeout;

  Future<void>? _started;
  bool _disposed = false;

  Future<void> start() {
    if (_disposed) return Future.value();
    return _started ??= Future.wait([
      _guard('通知初始化', initializeNotifications),
      _guard('冷启动通知跳转', () async {
        // 在派发之前限制等待；超时或离开 App 后不再消费迟到的结果。
        final payload = await readLaunchPayload().timeout(taskTimeout);
        if (!_disposed && payload != null) onLaunchPayload(payload);
      }),
      if (registerMaintenance != null) _guard('每日后台维护注册', registerMaintenance!),
    ]).then((_) => AppLog.i('平台启动任务结束'));
  }

  Future<void> _guard(String name, Future<void> Function() action) async {
    try {
      await Future<void>.sync(action).timeout(taskTimeout);
    } catch (error, stack) {
      AppLog.e('$name失败，前台继续运行', error, stack);
    }
  }

  void dispose() => _disposed = true;
}
