import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/settings/app_settings.dart';
import '../../i18n/strings.g.dart';
import '../providers.dart';
import 'today_controller.dart';

/// 设置页控制器：快照 + 各设置项更新（更新后联动重排提醒）。
class SettingsController extends Notifier<SettingsSnapshot> {
  @override
  SettingsSnapshot build() => ref.watch(settingsServiceProvider).snapshot();

  SettingsService get _service => ref.read(settingsServiceProvider);

  Future<void> setLanguage(AppLocale locale) async {
    await _service.setLanguageCode(locale.languageCode);
    await LocaleSettings.setLocale(locale);
    state = _service.snapshot();
    // Cabinet summaries are computed by its service and need a fresh translation.
    ref.invalidate(cabinetControllerProvider);
    await ref.read(speechServiceProvider).stopSpeak();
    await ref.read(speechServiceProvider).cancelListening();
    await ref.read(reminderSchedulerProvider).syncUpcoming();
  }

  Future<void> setFontTier(int tier) async {
    await _service.setFontTier(tier);
    await ref.read(fontTierProvider.notifier).setTier(tier);
    state = _service.snapshot();
  }

  Future<void> setTtsEnabled(bool v) async {
    await _service.setTtsEnabled(v);
    if (!v) await ref.read(speechServiceProvider).stopSpeak();
    state = _service.snapshot();
  }

  Future<void> setTtsRate(double v) async {
    await _service.setTtsRate(v);
    state = _service.snapshot();
  }

  Future<void> setReminderLeadMinutes(int v) async {
    await _service.setReminderLeadMinutes(v);
    state = _service.snapshot();
    await ref.read(reminderSchedulerProvider).syncUpcoming();
  }

  Future<void> setEscalationCount(int v) async {
    await _service.setEscalationCount(v);
    state = _service.snapshot();
    await ref.read(reminderSchedulerProvider).syncUpcoming();
  }

  Future<void> setEscalationIntervalMinutes(int v) async {
    await _service.setEscalationIntervalMinutes(v);
    state = _service.snapshot();
    await ref.read(reminderSchedulerProvider).syncUpcoming();
  }

  Future<void> setGracePeriodMinutes(int v) async {
    await _service.setGracePeriodMinutes(v);
    state = _service.snapshot();
  }

  Future<void> setQuietStart(String v) async {
    await _service.setQuietStart(v);
    state = _service.snapshot();
  }

  Future<void> setQuietEnd(String v) async {
    await _service.setQuietEnd(v);
    state = _service.snapshot();
  }

  Future<void> setOnboardingDone(bool v) async {
    await _service.setOnboardingDone(v);
    state = _service.snapshot();
  }

  Future<void> setChatModelId(String? id) async {
    await _service.setChatModelId(id);
    state = _service.snapshot();
  }

  Future<void> setVisionModelId(String? id) async {
    await _service.setVisionModelId(id);
    state = _service.snapshot();
  }

  /// 记录本次启动时间（时间跳变检测用，docs/06 §6）。
  Future<void> markLaunch(DateTime now) => _service.setLastLaunch(now);
}

final settingsControllerProvider =
    NotifierProvider<SettingsController, SettingsSnapshot>(
      SettingsController.new,
    );
