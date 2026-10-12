import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

import '../core/app_logger.dart';
import '../data/db/app_database.dart';
import '../data/repositories/dose_task_repository.dart';
import '../data/repositories/medication_repository.dart';
import '../data/settings/app_settings.dart';
import '../data/settings/key_value_store.dart';
import '../domain/services/dose_service.dart';
import '../domain/services/reminder_scheduler.dart';
import '../i18n/locale_preferences.dart';
import '../platform/local_notification_gateway.dart';
import '../platform/timezone_setup.dart';

const String pillPalMaintenanceTask = 'pillpal.daily-maintenance';

/// WorkManager 的顶层入口，必须保留给 release tree shaker。
@pragma('vm:entry-point')
void pillPalBackgroundDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    if (task != pillPalMaintenanceTask) {
      return true;
    }
    WidgetsFlutterBinding.ensureInitialized();
    initializePillPalTimeZone();
    AppLog.init(verbose: false);

    AppDatabase? db;
    try {
      final prefs = await SharedPreferences.getInstance();
      db = AppDatabase.open();
      final settings = SettingsService(SharedPreferencesStore(prefs));
      await initializeLocale(settings);
      final dose = DoseService(
        taskRepository: DriftDoseTaskRepository(db),
        medicationRepository: DriftMedicationRepository(db),
      );
      final gateway = LocalNotificationGateway(onNotificationTap: (_) {});
      await gateway.init();
      final scheduler = ReminderScheduler(
        doseService: dose,
        gateway: gateway,
        settingsOf: () => ReminderSettings(
          reminderLeadMinutes: settings.reminderLeadMinutes,
          escalationCount: settings.escalationCount,
          escalationIntervalMinutes: settings.escalationIntervalMinutes,
          gracePeriodMinutes: settings.gracePeriodMinutes,
        ),
      );
      await scheduler.onAppStart();
      await AppLog.flush();
      return true;
    } catch (error, stack) {
      AppLog.e('后台提醒维护失败', error, stack);
      await AppLog.flush();
      return false;
    } finally {
      await db?.close();
      AppLog.dispose();
    }
  });
}

Future<void> registerPillPalMaintenance() async {
  final workmanager = Workmanager();
  await workmanager.initialize(pillPalBackgroundDispatcher);
  await workmanager.registerPeriodicTask(
    pillPalMaintenanceTask,
    pillPalMaintenanceTask,
    frequency: const Duration(hours: 24),
    flexInterval: const Duration(hours: 2),
    initialDelay: _untilNextLocalMaintenance(),
    existingWorkPolicy: ExistingPeriodicWorkPolicy.keep,
    backoffPolicy: BackoffPolicy.exponential,
    backoffPolicyDelay: const Duration(minutes: 15),
  );
}

Duration _untilNextLocalMaintenance() {
  final now = DateTime.now();
  var next = DateTime(now.year, now.month, now.day + 1, 0, 5);
  if (!next.isAfter(now)) {
    next = next.add(const Duration(days: 1));
  }
  return next.difference(now);
}
