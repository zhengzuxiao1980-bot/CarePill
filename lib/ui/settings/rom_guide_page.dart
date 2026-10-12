import 'package:care_pill/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/providers.dart';
import '../../platform/device_channel.dart';
import '../shell/app_shell.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';

/// 厂商 ROM 保活引导页（docs/06 §4：自启动+锁后台+通知三类开关）。
class RomGuidePage extends ConsumerStatefulWidget {
  const RomGuidePage({super.key});

  @override
  ConsumerState<RomGuidePage> createState() => _RomGuidePageState();
}

class _RomGuidePageState extends ConsumerState<RomGuidePage> {
  String? _manufacturer;
  bool _ignoringBattery = true;
  bool _notifications = true;
  bool _exactAlarms = true;
  bool _fullScreen = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final manufacturer = await DeviceInfoChannel.manufacturer();
    final ignoring = await DeviceInfoChannel.isIgnoringBatteryOptimizations();
    final gateway = ref.read(reminderGatewayProvider);
    final notifications = await gateway.notificationsEnabled();
    final exact = await gateway.exactAlarmsEnabled();
    final fullScreen = await DeviceInfoChannel.fullScreenIntentEnabled();
    if (mounted) {
      setState(() {
        _manufacturer = manufacturer;
        _ignoringBattery = ignoring;
        _notifications = notifications;
        _exactAlarms = exact;
        _fullScreen = fullScreen;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Rebuild localized labels, including those constructed in helper methods.
    Localizations.localeOf(context);
    final theme = Theme.of(context);
    final steps = romGuideSteps(_manufacturer);
    return Scaffold(
      appBar: buildPillPalAppBar(
        title: romGuideTitle(_manufacturer),
        backLocation: '/settings',
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(tr.romGuide.intro, style: theme.textTheme.bodyLarge),
          const SizedBox(height: 16),
          for (final step in steps)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(step, style: theme.textTheme.bodyLarge),
              ),
            ),
          const SizedBox(height: 8),
          if (!_ignoringBattery)
            Card(
              color: AppTheme.warnAmber.withValues(alpha: 0.1),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  tr.romGuide.batteryHint,
                  style: theme.textTheme.bodyLarge!.copyWith(
                    color: AppTheme.warnAmber,
                  ),
                ),
              ),
            ),
          SectionCard(
            title: tr.romGuide.permissions,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _permissionLine(tr.romGuide.notifications, _notifications),
                _permissionLine(tr.romGuide.exactAlarms, _exactAlarms),
                _permissionLine(tr.romGuide.fullScreen, _fullScreen),
              ],
            ),
          ),
          const SizedBox(height: 8),
          BigPrimaryButton(
            label: _ignoringBattery
                ? tr.romGuide.batteryAllowed
                : tr.romGuide.disableBattery,
            icon: Icons.battery_saver,
            height: 76,
            onPressed: _ignoringBattery
                ? null
                : DeviceInfoChannel.openBatteryOptimizationSettings,
          ),
          const SizedBox(height: 12),
          BigOutlinedButton(
            label: tr.romGuide.enableNotifications,
            icon: Icons.notifications,
            onPressed: () async {
              final messenger = ScaffoldMessenger.of(context);
              await ref.read(reminderGatewayProvider).requestPermissions();
              await _load();
              messenger.showSnackBar(
                SnackBar(content: Text(tr.romGuide.returnHint)),
              );
            },
          ),
          const SizedBox(height: 12),
          BigOutlinedButton(
            label: tr.romGuide.enableAlarms,
            icon: Icons.alarm,
            onPressed: DeviceInfoChannel.openExactAlarmSettings,
          ),
          const SizedBox(height: 24),
          Text(tr.romGuide.testHint, style: theme.textTheme.bodyMedium),
        ],
      ),
    );
  }

  Widget _permissionLine(String label, bool enabled) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      children: [
        Icon(
          enabled ? Icons.check_circle : Icons.error_outline,
          color: enabled ? AppTheme.okGreen : AppTheme.warnAmber,
          size: 24,
        ),
        const SizedBox(width: 8),
        Text(
          tr.romGuide.permissionStatus(
            arg1: (label).toString(),
            arg2: (enabled ? tr.romGuide.allowed : tr.romGuide.notAllowed)
                .toString(),
          ),
        ),
      ],
    ),
  );
}
