import 'dart:convert';
import 'dart:io';

import 'package:care_pill/ai/prompts/app_prompts.dart';
import 'package:care_pill/ai/tools/rule_intent.dart';
import 'package:care_pill/core/formatters.dart';
import 'package:care_pill/data/settings/app_settings.dart';
import 'package:care_pill/data/settings/key_value_store.dart';
import 'package:care_pill/domain/models/enums.dart';
import 'package:care_pill/i18n/locale_preferences.dart';
import 'package:care_pill/i18n/strings.g.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  tearDown(() => LocaleSettings.setLocale(AppLocale.zh));

  test('Settings snapshots default a missing language without changing other settings', () {
    SettingsSnapshot snapshot(String? languageCode) => SettingsSnapshot(
      languageCode: languageCode,
      fontTier: 2,
      ttsEnabled: false,
      ttsRate: 0.7,
      reminderLeadMinutes: 5,
      escalationCount: 2,
      escalationIntervalMinutes: 15,
      gracePeriodMinutes: 60,
      onboardingDone: true,
      chatModelId: 'chat',
      visionModelId: null,
      quietStart: '22:00',
      quietEnd: '06:00',
    );

    final legacy = snapshot(null);
    expect(legacy.languageCode, 'zh');
    expect(legacy.fontTier, 2);
    expect(legacy.ttsEnabled, isFalse);
    expect(legacy.chatModelId, 'chat');
    expect(snapshot('en').languageCode, 'en');
    expect(snapshot('zh').languageCode, 'zh');
    expect(
      SettingsService(InMemoryKeyValueStore()).snapshot().languageCode,
      'zh',
    );
  });

  test('Chinese and English resources have matching keys and placeholders', () {
    Map<String, String> flatten(
      Map<String, dynamic> value, [
      String prefix = '',
    ]) {
      final result = <String, String>{};
      for (final entry in value.entries) {
        final key = '$prefix${entry.key}';
        if (entry.value is Map<String, dynamic>) {
          result.addAll(flatten(entry.value as Map<String, dynamic>, '$key.'));
        } else {
          result[key] = entry.value as String;
        }
      }
      return result;
    }

    final zh = flatten(
      jsonDecode(File('lib/i18n/zh.i18n.json').readAsStringSync())
          as Map<String, dynamic>,
    );
    final en = flatten(
      jsonDecode(File('lib/i18n/en.i18n.json').readAsStringSync())
          as Map<String, dynamic>,
    );
    expect(en.keys.toSet(), zh.keys.toSet());
    final parameters = RegExp(r'\$\{([^}]+)\}');
    for (final key in zh.keys) {
      expect(en[key]!.trim(), isNotEmpty, reason: key);
      expect(
        parameters.allMatches(en[key]!).map((m) => m[1]).toSet(),
        parameters.allMatches(zh[key]!).map((m) => m[1]).toSet(),
        reason: key,
      );
      if (key != 'common.chinese' && key != 'common.language') {
        expect(
          RegExp(r'[\u3400-\u9fff]').hasMatch(en[key]!),
          isFalse,
          reason: key,
        );
      }
    }
  });

  test('First launch resolves regional locales, persists choice and restores it in background', () async {
    final store = InMemoryKeyValueStore();
    var settings = SettingsService(store);
    await initializeLocale(settings, deviceLocale: 'en-GB');
    expect(LocaleSettings.currentLocale, AppLocale.en);
    expect(settings.languageCode, 'en');
    await LocaleSettings.setLocale(AppLocale.zh);
    settings = SettingsService(store);
    await initializeLocale(settings, deviceLocale: 'zh-CN');
    expect(LocaleSettings.currentLocale, AppLocale.en);
    await initializeLocale(
      SettingsService(InMemoryKeyValueStore()),
      deviceLocale: 'fr-FR',
    );
    expect(LocaleSettings.currentLocale, AppLocale.zh);
  });

  test('Localized time, relative dates and dose plurals keep wire formats unchanged', () async {
    final date = DateTime(2026, 10, 7, 20, 30);
    expect(date.isoDate, '2026-10-07');
    expect(friendlyTime('20:30'), '晚上 8 点半');
    expect(friendlyDose(1, '片'), '1片');
    await LocaleSettings.setLocale(AppLocale.en);
    expect(date.isoDate, '2026-10-07');
    expect(date.hhMm, '20:30');
    expect(friendlyTime('20:30'), '8:30\u202fPM');
    expect(friendlyTime('00:00'), '12:00\u202fAM');
    expect(friendlyDate(date, now: date), 'Today');
    expect(
      friendlyDate(date.add(const Duration(days: 1)), now: date),
      'Tomorrow',
    );
    expect(friendlyDate(DateTime(2026, 12, 4), now: date), 'Dec 4');
    expect(friendlyRelative(const Duration(minutes: -15)), '15 min ago');
    expect(friendlyWeekday(1), 'Monday');
    expect(friendlyMeal('after'), 'After meals');
    expect(friendlyDose(1, '片'), '1 tablet');
    expect(friendlyDose(2, 'tablet'), '2 tablets');
    expect(friendlyDose(1.5, '毫升'), '1.5 mL');
    expect(friendlyDose(2, 'custom scoops'), '2 custom scoops');
    expect(DoseStatus.taken.label, 'Taken');
    expect(DoseStatus.taken.json, 'taken');
    expect(MedicationForm.fromJsonString('tablet'), MedicationForm.tablet);
  });

  test('English quick questions work in rule fallback and AI prompts request English', () async {
    await LocaleSettings.setLocale(AppLocale.en);
    expect(
      RuleIntentMatcher.match(tr.assistant.quickStatus)?.tool,
      'get_dose_status',
    );
    expect(
      RuleIntentMatcher.match(tr.assistant.quickNext)?.tool,
      'get_next_dose',
    );
    expect(
      cannedReplyForTool('get_next_dose', {'none': true}),
      tr.ruleIntent.allDone,
    );
    final prompt = AppPrompts.buildSystemPrompt(
      nowText: '8 AM',
      todaySummary: 'None',
      tools: [],
      jsonProtocol: false,
    );
    expect(prompt, contains('Respond in English'));
    expect(
      AppPrompts.weeklyReportPrompt(statsText: 'None', nowText: '8 AM'),
      contains('Respond in English'),
    );
  });
}
