import 'dart:io';

import 'package:care_pill/i18n/strings.g.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../application/controllers/settings_controller.dart';
import '../../application/controllers/today_controller.dart';
import '../../application/providers.dart';
import '../../core/app_logger.dart';
import '../../data/backup/backup_service.dart';
import '../shell/app_shell.dart';
import '../widgets/common.dart';
import 'language_picker.dart';

/// 设置页（docs/07 §1：子女的领域）。
class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  bool _testingReminder = false;

  @override
  Widget build(BuildContext context) {
    // Rebuild localized labels, including those constructed in helper methods.
    Localizations.localeOf(context);
    final theme = Theme.of(context);
    final settings = ref.watch(settingsControllerProvider);
    return Scaffold(
      appBar: buildPillPalAppBar(title: tr.settings.title),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 40),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 2, 20, 6),
            child: Row(
              children: [
                const BrandMark(size: 46),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    tr.settings.intro,
                    style: theme.textTheme.titleMedium,
                  ),
                ),
              ],
            ),
          ),
          // 显示。
          SectionCard(
            title: tr.common.language,
            child: PillPalField(
              label: tr.common.languageHint,
              child: const LanguagePicker(),
            ),
          ),
          SectionCard(
            title: tr.settings.display,
            child: PillPalField(
              label: tr.settings.fontSize,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (final (i, label) in [
                    tr.settings.standard,
                    tr.settings.large,
                    tr.settings.extraLarge,
                  ].indexed)
                    PillPalChoice(
                      label: label,
                      selected: settings.fontTier == i,
                      onSelected: (_) => ref
                          .read(settingsControllerProvider.notifier)
                          .setFontTier(i),
                    ),
                ],
              ),
            ),
          ),
          // 提醒。
          SectionCard(
            title: tr.settings.reminders,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _numberField(
                  label: tr.settings.leadTime,
                  unit: tr.settings.minutes,
                  value: settings.reminderLeadMinutes,
                  min: 0,
                  max: 60,
                  step: 5,
                  onChanged: (v) => ref
                      .read(settingsControllerProvider.notifier)
                      .setReminderLeadMinutes(v),
                ),
                _numberField(
                  label: tr.settings.repeatCount,
                  unit: tr.settings.times,
                  value: settings.escalationCount,
                  min: 0,
                  max: 6,
                  step: 1,
                  onChanged: (v) => ref
                      .read(settingsControllerProvider.notifier)
                      .setEscalationCount(v),
                ),
                _numberField(
                  label: tr.settings.repeatInterval,
                  unit: tr.settings.minutes,
                  value: settings.escalationIntervalMinutes,
                  min: 5,
                  max: 60,
                  step: 5,
                  onChanged: (v) => ref
                      .read(settingsControllerProvider.notifier)
                      .setEscalationIntervalMinutes(v),
                ),
                _numberField(
                  label: tr.settings.gracePeriod,
                  unit: tr.settings.minutes,
                  value: settings.gracePeriodMinutes,
                  min: 15,
                  max: 180,
                  step: 15,
                  onChanged: (v) => ref
                      .read(settingsControllerProvider.notifier)
                      .setGracePeriodMinutes(v),
                ),
                Text(tr.settings.quietTitle, style: theme.textTheme.bodyLarge),
                const SizedBox(height: 6),
                Text(tr.settings.quietHint, style: theme.textTheme.bodyMedium),
                const Divider(),
                const SizedBox(height: 8),
                Text(
                  tr.settings.reminderHint,
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 12),
                BigOutlinedButton(
                  label: _testingReminder
                      ? tr.settings.testing
                      : tr.settings.testReminder,
                  icon: Icons.notifications_active,
                  onPressed: _testingReminder ? null : _testReminder,
                ),
                const SizedBox(height: 8),
                BigOutlinedButton(
                  label: tr.settings.phoneGuide,
                  icon: Icons.phone_android,
                  onPressed: () => context.push('/settings/rom-guide'),
                ),
              ],
            ),
          ),
          // 语音。
          SectionCard(
            title: tr.settings.speech,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                PillPalSwitchField(
                  label: tr.settings.tts,
                  description: tr.settings.ttsHint,
                  value: settings.ttsEnabled,
                  onChanged: (v) => ref
                      .read(settingsControllerProvider.notifier)
                      .setTtsEnabled(v),
                ),
                const SizedBox(height: 24),
                PillPalField(
                  label: tr.settings.speechRate,
                  child: Slider(
                    value: settings.ttsRate,
                    min: 0.5,
                    max: 1.5,
                    divisions: 10,
                    label: settings.ttsRate < 0.75
                        ? tr.settings.slow
                        : settings.ttsRate > 1.05
                        ? tr.settings.fast
                        : tr.settings.normal,
                    onChanged: (v) => ref
                        .read(settingsControllerProvider.notifier)
                        .setTtsRate(double.parse(v.toStringAsFixed(2))),
                  ),
                ),
                const SizedBox(height: 12),
                BigOutlinedButton(
                  label: tr.settings.preview,
                  icon: Icons.volume_up_outlined,
                  onPressed: () async {
                    final speech = ref.read(speechServiceProvider);
                    // 语速改动即时生效：直接构造一次播报。
                    await speech.speak(tr.settings.speechSample);
                  },
                ),
              ],
            ),
          ),
          // AI 模型。
          SectionCard(
            title: tr.settings.models,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(tr.settings.modelsHint, style: theme.textTheme.bodyMedium),
                const SizedBox(height: 12),
                BigPrimaryButton(
                  label: tr.settings.manageModels,
                  icon: Icons.smart_toy,
                  height: 72,
                  onPressed: () => context.push('/settings/models'),
                ),
              ],
            ),
          ),
          // 数据与统计。
          SectionCard(
            title: tr.settings.data,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BigOutlinedButton(
                  label: tr.settings.stats,
                  icon: Icons.calendar_month,
                  onPressed: () => context.push('/settings/stats'),
                ),
                const SizedBox(height: 8),
                BigOutlinedButton(
                  label: tr.settings.exportBackup,
                  icon: Icons.ios_share,
                  onPressed: _exportBackup,
                ),
                const SizedBox(height: 8),
                BigOutlinedButton(
                  label: tr.settings.restoreBackup,
                  icon: Icons.restore,
                  onPressed: _importBackup,
                ),
                const SizedBox(height: 8),
                BigOutlinedButton(
                  label: tr.settings.exportLogs,
                  icon: Icons.receipt_long,
                  onPressed: _exportLogs,
                ),
                const SizedBox(height: 8),
                BigOutlinedButton(
                  label: tr.settings.onboarding,
                  icon: Icons.school,
                  onPressed: () => context.push('/onboarding?replay=1'),
                ),
              ],
            ),
          ),
          // 关于。
          SectionCard(
            title: tr.settings.about,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BigOutlinedButton(
                  label: tr.settings.privacy,
                  icon: Icons.privacy_tip,
                  onPressed: () => context.push('/settings/about'),
                ),
                const SizedBox(height: 8),
                Text(tr.settings.aboutHint, style: theme.textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _numberField({
    required String label,
    required String unit,
    required int value,
    required int min,
    required int max,
    required int step,
    required ValueChanged<int> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: PillPalField(
        label: label,
        child: PillPalStepper(
          label: label,
          value: '$value $unit',
          onDecrease: value <= min
              ? null
              : () => onChanged((value - step).clamp(min, max)),
          onIncrease: value >= max
              ? null
              : () => onChanged((value + step).clamp(min, max)),
        ),
      ),
    );
  }

  Future<void> _testReminder() async {
    setState(() => _testingReminder = true);
    final scheduler = ref.read(reminderSchedulerProvider);
    final gateway = ref.read(reminderGatewayProvider);
    await gateway.requestPermissions();
    await scheduler.fireTestReminder();
    if (!mounted) {
      return;
    }
    setState(() => _testingReminder = false);
    UndoBar.show(context, message: tr.settings.testSent);
  }

  Future<void> _exportBackup() async {
    try {
      final dir = Directory.systemTemp;
      final file = await ref
          .read(backupServiceProvider)
          .exportToFile(
            '${dir.path}${Platform.pathSeparator}${backupFileName(DateTime.now())}',
          );
      if (!mounted) {
        return;
      }
      UndoBar.show(
        context,
        message: tr.settings.backupSaved(arg1: (file.path).toString()),
      );
      await AppLog.flush();
    } catch (e) {
      if (mounted) {
        UndoBar.show(context, message: friendlyError(e));
      }
    }
  }

  /// 从备份文件恢复（docs/02 F10；二次确认，docs/07 §3）。
  Future<void> _importBackup() async {
    final ok = await confirmDangerous(
      context,
      title: tr.settings.restoreTitle,
      message: tr.settings.restoreMessage,
      confirmLabel: tr.settings.restore,
    );
    if (!ok) {
      return;
    }
    try {
      final file = await openFile(
        acceptedTypeGroups: [
          XTypeGroup(label: tr.settings.backupFile, extensions: ['json']),
        ],
      );
      if (file == null) {
        return;
      }
      await ref.read(backupServiceProvider).importFromFile(file.path);
      ref.invalidate(todayControllerProvider);
      ref.invalidate(cabinetControllerProvider);
      if (!mounted) {
        return;
      }
      await ref.read(reminderSchedulerProvider).refreshAfterDataChange();
      if (mounted) {
        UndoBar.show(context, message: tr.settings.restored);
      }
    } catch (e) {
      if (mounted) {
        UndoBar.show(context, message: friendlyError(e));
      }
    }
  }

  Future<void> _exportLogs() async {
    await AppLog.flush();
    final dir = AppLog.logDirectory;
    if (!mounted) {
      return;
    }
    UndoBar.show(
      context,
      message: dir == null
          ? tr.settings.logsDisabled
          : tr.settings.logsPath(arg1: (dir).toString()),
    );
  }
}
