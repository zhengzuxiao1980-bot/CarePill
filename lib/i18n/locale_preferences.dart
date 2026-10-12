import '../data/settings/app_settings.dart';
import 'strings.g.dart';

/// Restore the saved choice before notifications or other services create text.
/// Slang resolves regional variants and unsupported languages to the base locale.
Future<void> initializeLocale(
  SettingsService settings, {
  String? deviceLocale,
}) async {
  final locale = AppLocaleUtils.parse(
    settings.languageCode ?? deviceLocale ?? 'zh',
  );
  await LocaleSettings.setLocale(locale);
  await settings.setLanguageCode(locale.languageCode);
}
