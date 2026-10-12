import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/app_logger.dart';
import 'providers.dart';

/// 启动引导（App 级执行一次）：
/// - 时间跳变检测（docs/06 §6：设备日期被误改时提示）；
/// - 记录本次启动时间；
/// - 启动补偿：任务展开 + 漏服判定 + 提醒重排（docs/06 §1 触发源 4）。
final appBootstrapProvider = Provider<void>((ref) {
  final settings = ref.watch(settingsServiceProvider);
  final scheduler = ref.watch(reminderSchedulerProvider);

  Future<void>(() async {
    final now = DateTime.now();
    final last = settings.lastLaunchMs;
    if (last != null &&
        now.millisecondsSinceEpoch <
            last - const Duration(hours: 2).inMilliseconds) {
      AppLog.w(
        '设备时间疑似回拨（上次启动 ${DateTime.fromMillisecondsSinceEpoch(last)}，'
        '本次 $now），提醒以当前设备时间为准',
      );
    }
    try {
      await settings.setLastLaunch(now);
      await scheduler.onAppStart();
      AppLog.i('启动补偿完成');
    } catch (e, st) {
      AppLog.e('启动补偿失败', e, st);
    }
  });
});
