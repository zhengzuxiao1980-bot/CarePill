import '../../core/app_constants.dart';
import 'key_value_store.dart';

/// 设置键名（非敏感项，存 SharedPreferences；docs/05 §2 app_settings）。
abstract final class SettingKeys {
  static const languageCode = 'settings.language_code';
  static const fontTier = 'settings.font_tier';
  static const ttsEnabled = 'settings.tts_enabled';
  static const ttsRate = 'settings.tts_rate';
  static const reminderLeadMinutes = 'settings.reminder_lead_minutes';
  static const escalationCount = 'settings.escalation_count';
  static const escalationIntervalMinutes =
      'settings.escalation_interval_minutes';
  static const gracePeriodMinutes = 'settings.grace_period_minutes';
  static const onboardingDone = 'settings.onboarding_done';
  static const chatModelId = 'settings.chat_model_id';
  static const visionModelId = 'settings.vision_model_id';
  static const quietStart = 'settings.quiet_start';
  static const quietEnd = 'settings.quiet_end';
  static const lastLaunchMs = 'settings.last_launch_ms';
}

/// 设置项快照（UI 只读这一份；默认值集中在此，禁止散落，docs/04 §9.4）。
class SettingsSnapshot {
  const SettingsSnapshot({
    String? languageCode,
    required this.fontTier,
    required this.ttsEnabled,
    required this.ttsRate,
    required this.reminderLeadMinutes,
    required this.escalationCount,
    required this.escalationIntervalMinutes,
    required this.gracePeriodMinutes,
    required this.onboardingDone,
    required this.chatModelId,
    required this.visionModelId,
    required this.quietStart,
    required this.quietEnd,
  }) : _languageCode = languageCode;

  /// 0=标准 1=大（默认） 2=特大（docs/07 §3）。
  final int fontTier;
  // Hot reload keeps older snapshots alive without initializing new fields.
  // Resolve the default when reading, including snapshots without a language.
  final String? _languageCode;
  String get languageCode => _languageCode ?? 'zh';
  final bool ttsEnabled;
  final double ttsRate;
  final int reminderLeadMinutes;
  final int escalationCount;
  final int escalationIntervalMinutes;
  final int gracePeriodMinutes;
  final bool onboardingDone;
  final String? chatModelId;
  final String? visionModelId;
  final String quietStart;
  final String quietEnd;
}

/// 设置服务（docs/04 §9.4：默认值集中在 settings service）。
class SettingsService {
  SettingsService(this._kv);

  final KeyValueStore _kv;

  String? get languageCode => _kv.getString(SettingKeys.languageCode);
  Future<void> setLanguageCode(String value) =>
      _kv.setString(SettingKeys.languageCode, value);

  int get fontTier => _kv.getInt(SettingKeys.fontTier) ?? 1;
  Future<void> setFontTier(int v) =>
      _kv.setInt(SettingKeys.fontTier, v.clamp(0, 2));

  bool get ttsEnabled => _kv.getBool(SettingKeys.ttsEnabled) ?? true;
  Future<void> setTtsEnabled(bool v) => _kv.setBool(SettingKeys.ttsEnabled, v);

  /// TTS 语速倍率，1.0 为正常；默认略慢（docs/03 §9 默认调慢一档）。
  double get ttsRate => _kv.getDouble(SettingKeys.ttsRate) ?? 0.85;
  Future<void> setTtsRate(double v) =>
      _kv.setDouble(SettingKeys.ttsRate, v.clamp(0.5, 1.5));

  int get reminderLeadMinutes =>
      _kv.getInt(SettingKeys.reminderLeadMinutes) ??
      kDefaultReminderLeadMinutes;
  Future<void> setReminderLeadMinutes(int v) =>
      _kv.setInt(SettingKeys.reminderLeadMinutes, v.clamp(0, 120));

  int get escalationCount =>
      _kv.getInt(SettingKeys.escalationCount) ?? kDefaultEscalationCount;
  Future<void> setEscalationCount(int v) =>
      _kv.setInt(SettingKeys.escalationCount, v.clamp(0, 10));

  int get escalationIntervalMinutes =>
      _kv.getInt(SettingKeys.escalationIntervalMinutes) ??
      kDefaultEscalationIntervalMinutes;
  Future<void> setEscalationIntervalMinutes(int v) =>
      _kv.setInt(SettingKeys.escalationIntervalMinutes, v.clamp(5, 120));

  int get gracePeriodMinutes =>
      _kv.getInt(SettingKeys.gracePeriodMinutes) ?? kDefaultGracePeriodMinutes;
  Future<void> setGracePeriodMinutes(int v) =>
      _kv.setInt(SettingKeys.gracePeriodMinutes, v.clamp(10, 240));

  bool get onboardingDone => _kv.getBool(SettingKeys.onboardingDone) ?? false;
  Future<void> setOnboardingDone(bool v) =>
      _kv.setBool(SettingKeys.onboardingDone, v);

  String? get chatModelId => _kv.getString(SettingKeys.chatModelId);
  Future<void> setChatModelId(String? v) => v == null
      ? _kv.remove(SettingKeys.chatModelId)
      : _kv.setString(SettingKeys.chatModelId, v);

  String? get visionModelId => _kv.getString(SettingKeys.visionModelId);
  Future<void> setVisionModelId(String? v) => v == null
      ? _kv.remove(SettingKeys.visionModelId)
      : _kv.setString(SettingKeys.visionModelId, v);

  String get quietStart =>
      _kv.getString(SettingKeys.quietStart) ?? kDefaultQuietStart;
  Future<void> setQuietStart(String v) =>
      _kv.setString(SettingKeys.quietStart, v);

  String get quietEnd =>
      _kv.getString(SettingKeys.quietEnd) ?? kDefaultQuietEnd;
  Future<void> setQuietEnd(String v) => _kv.setString(SettingKeys.quietEnd, v);

  int? get lastLaunchMs => _kv.getInt(SettingKeys.lastLaunchMs);
  Future<void> setLastLaunch(DateTime t) =>
      _kv.setInt(SettingKeys.lastLaunchMs, t.millisecondsSinceEpoch);

  SettingsSnapshot snapshot() => SettingsSnapshot(
    languageCode: languageCode ?? 'zh',
    fontTier: fontTier,
    ttsEnabled: ttsEnabled,
    ttsRate: ttsRate,
    reminderLeadMinutes: reminderLeadMinutes,
    escalationCount: escalationCount,
    escalationIntervalMinutes: escalationIntervalMinutes,
    gracePeriodMinutes: gracePeriodMinutes,
    onboardingDone: onboardingDone,
    chatModelId: chatModelId,
    visionModelId: visionModelId,
    quietStart: quietStart,
    quietEnd: quietEnd,
  );
}
