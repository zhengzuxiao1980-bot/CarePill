import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:care_pill/ai/client/ai_client.dart';
import 'package:care_pill/ai/client/ai_models.dart';
import 'package:care_pill/app.dart';
import 'package:care_pill/application/app_bootstrap.dart';
import 'package:care_pill/application/controllers/barcode_lookup_controller.dart';
import 'package:care_pill/application/controllers/model_setup_controller.dart';
import 'package:care_pill/application/controllers/settings_controller.dart';
import 'package:care_pill/application/providers.dart';
import 'package:care_pill/application/router.dart';
import 'package:care_pill/core/cancellation.dart';
import 'package:care_pill/core/exceptions.dart';
import 'package:care_pill/data/repositories/agent_store.dart';
import 'package:care_pill/data/settings/app_settings.dart';
import 'package:care_pill/data/settings/key_value_store.dart';
import 'package:care_pill/domain/models/ai_model_config.dart';
import 'package:care_pill/domain/models/enums.dart';
import 'package:care_pill/domain/models/medication_barcode.dart';
import 'package:care_pill/domain/models/medication_draft.dart';
import 'package:care_pill/domain/models/schedule.dart';
import 'package:care_pill/domain/services/barcode_lookup.dart';
import 'package:care_pill/domain/services/medication_service.dart';
import 'package:care_pill/i18n/locale_preferences.dart';
import 'package:care_pill/i18n/strings.g.dart';
import 'package:care_pill/ui/cabinet/photo_capture_page.dart';
import 'package:care_pill/ui/settings/language_picker.dart';
import 'package:care_pill/ui/shell/app_shell.dart';
import 'package:care_pill/ui/theme/app_theme.dart';
import 'package:care_pill/ui/widgets/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:slang_flutter/slang_flutter.dart';

import 'fakes/fakes.dart';

final _captureKey = GlobalKey();

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    final fontPath = Platform.environment['CAREPILL_QA_FONT'];
    if (fontPath == null) return;
    final bytes = ByteData.sublistView(await File(fontPath).readAsBytes());
    for (final family in ['CarePillQA', 'Roboto', 'Ahem']) {
      await (FontLoader(family)..addFont(Future.value(bytes))).load();
    }
    await (FontLoader(
      'MaterialIcons',
    )..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf'))).load();
  });
  tearDown(() => LocaleSettings.setLocale(AppLocale.zh));

  for (final locale in AppLocale.values) {
    for (final size in [const Size(360, 800), const Size(390, 844)]) {
      testWidgets('Barcode review and save in $locale at $size', (
        tester,
      ) async {
        final fixture = await _pumpApp(
          tester,
          size,
          model: false,
          barcodeLookup: _BarcodeFixture(),
        );
        await LocaleSettings.setLocale(locale);
        final router = fixture.container.read(routerProvider);
        router.go('/cabinet');
        await tester.pumpAndSettle();
        await _reveal(tester, find.text(tr.cabinet.add));
        await tester.tap(find.text(tr.cabinet.add));
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text(tr.barcode.entry));
        await tester.tap(find.text(tr.barcode.entry));
        await tester.pumpAndSettle();
        final input = find.byKey(const ValueKey('barcode-input'));
        await _reveal(tester, input);
        await tester.enterText(input, '0300450297211');
        tester.view.viewInsets = const FakeViewPadding(bottom: 300);
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        tester.view.resetViewInsets();
        final query = find.widgetWithText(BigOutlinedButton, tr.barcode.lookup);
        await _reveal(tester, query);
        await tester.tap(query);
        await tester.pumpAndSettle();
        expect(fixture.meds.meds, isEmpty);
        await _reveal(tester, find.text(tr.barcode.use));
        await _capture(tester, 'barcode-result-${locale.languageCode}', size);
        await tester.tap(find.text(tr.barcode.use));
        await tester.pumpAndSettle();
        expect(router.state.uri.path, '/medication/new');
        await _reveal(tester, find.byKey(const ValueKey('medication-name')));
        expect(
          tester
              .widget<TextField>(find.byKey(const ValueKey('medication-name')))
              .controller!
              .text,
          'Example medicine',
        );
        // Cancelling review returns to the same results without writing.
        await tester.binding.handlePopRoute();
        await tester.pumpAndSettle();
        expect(router.state.uri.path, '/medication/scan');
        expect(fixture.meds.meds, isEmpty);
        expect(
          tester.widget<TextField>(input).controller!.text,
          '0300450297211',
        );
        await _reveal(tester, find.text(tr.barcode.use));
        await tester.tap(find.text(tr.barcode.use));
        await tester.pumpAndSettle();
        await tester.tap(find.text(tr.medicationForm.next));
        await tester.pumpAndSettle();
        expect(find.text(tr.barcode.missingUnit), findsOneWidget);
        ScaffoldMessenger.of(tester.element(find.text(tr.medicationForm.next)))
            .removeCurrentSnackBar();
        await tester.pumpAndSettle();
        final unit = find.byKey(const ValueKey('medication-unit'));
        await _reveal(tester, unit);
        await tester.enterText(unit, 'mL');
        await tester.tap(find.text(tr.medicationForm.next));
        await tester.pumpAndSettle();
        await _reveal(tester, find.text(tr.medicationForm.asNeededHint));
        await tester.tap(find.text(tr.medicationForm.next));
        await tester.pumpAndSettle();
        expect(fixture.meds.meds, isEmpty);
        await tester.tap(find.text(tr.medicationForm.save));
        await tester.pumpAndSettle();
        expect(router.state.uri.path, '/cabinet');
        expect(
          fixture.meds.meds.values.single.source,
          MedicationSource.barcode,
        );
        expect(fixture.meds.meds.values.single.doseUnit, 'mL');
        expect(fixture.meds.meds.values.single.spec, isNull);
        expect(fixture.meds.schedules.values.single.times, isEmpty);
        expect(fixture.gateway.scheduled, isEmpty);
        expect(tester.takeException(), isNull);
      });
    }
  }

  testWidgets('Barcode onboarding back and manual fallback return contract', (
    tester,
  ) async {
    final fixture = await _pumpApp(
      tester,
      const Size(360, 800),
      onboarding: true,
      model: false,
      barcodeLookup: _BarcodeFixture(),
    );
    final router = fixture.container.read(routerProvider);
    await _reveal(tester, find.text(tr.onboarding.start));
    await tester.tap(find.text(tr.onboarding.start));
    await tester.pumpAndSettle();
    await _reveal(tester, find.text(tr.onboarding.skip));
    await tester.tap(find.text(tr.onboarding.skip));
    await tester.pumpAndSettle();
    await _reveal(tester, find.text(tr.barcode.entry));
    await tester.tap(find.text(tr.barcode.entry));
    await tester.pumpAndSettle();
    expect(router.state.uri.path, '/medication/scan');
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.text(tr.onboarding.medicineTitle), findsOneWidget);
    await tester.tap(find.text(tr.barcode.entry));
    await tester.pumpAndSettle();
    final input = find.byKey(const ValueKey('barcode-input'));
    await _reveal(tester, input);
    await tester.enterText(input, '12345678901234567890');
    final query = find.widgetWithText(BigOutlinedButton, tr.barcode.lookup);
    await _reveal(tester, query);
    await tester.tap(query);
    await tester.pumpAndSettle();
    await _reveal(tester, find.text(tr.barcode.traceability));
    expect(fixture.meds.meds, isEmpty);
    await _reveal(tester, find.text(tr.cabinet.manual));
    await tester.tap(find.text(tr.cabinet.manual));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const ValueKey('medication-name')),
      'My medicine',
    );
    for (var i = 0; i < 2; i++) {
      await tester.tap(find.text(tr.medicationForm.next));
      await tester.pumpAndSettle();
    }
    await tester.tap(find.text(tr.medicationForm.save));
    await tester.pumpAndSettle();
    expect(router.state.uri.path, '/today');
    expect(fixture.store.getBool(SettingKeys.onboardingDone), isTrue);
    expect(fixture.meds.meds.values.single.source, MedicationSource.manual);
    expect(tester.takeException(), isNull);
  });

  for (final locale in AppLocale.values) {
    for (final size in [const Size(360, 800), const Size(390, 844)]) {
      testWidgets(
        'AI wizard back, keyboard and failed connection in $locale at $size',
        (tester) async {
          final fixture = await _pumpApp(
            tester,
            size,
            model: false,
            aiClient: _RejectedSetupClient(),
          );
          await LocaleSettings.setLocale(locale);
          final router = fixture.container.read(routerProvider);
          unawaited(router.push<void>('/settings/models/new'));
          await tester.pumpAndSettle();
          await _capture(tester, 'ai-provider-${locale.languageCode}', size);
          await tester.tap(find.text(tr.modelSetup.next));
          await tester.pumpAndSettle();
          expect(find.text(tr.modelSetup.chooseProvider), findsOneWidget);
          await _reveal(
            tester,
            find.byKey(const ValueKey('provider-deepseek')),
          );
          await tester.tap(find.byKey(const ValueKey('provider-deepseek')));
          await tester.tap(find.text(tr.modelSetup.next));
          await tester.pumpAndSettle();
          await _capture(tester, 'ai-connect-${locale.languageCode}', size);
          final key = find.byKey(const ValueKey('setup-key'));
          await _reveal(tester, key);
          await tester.enterText(key, 'test-draft-key');
          tester.view.viewInsets = const FakeViewPadding(bottom: 300);
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
          tester.view.resetViewInsets();
          await tester.tap(find.text(tr.modelSetup.next));
          await tester.pumpAndSettle();
          await _capture(tester, 'ai-model-${locale.languageCode}', size);
          await tester.binding.handlePopRoute();
          await tester.pumpAndSettle();
          await _reveal(tester, key);
          expect(
            tester.widget<TextField>(key).controller!.text,
            'test-draft-key',
          );
          await tester.tap(find.text(tr.modelSetup.next));
          await tester.pumpAndSettle();
          await tester.tap(find.text(tr.modelSetup.next));
          await tester.pumpAndSettle();
          await _capture(tester, 'ai-review-${locale.languageCode}', size);
          await tester.tap(find.text(tr.modelSetup.test));
          await tester.pumpAndSettle();
          await _reveal(tester, find.text(tr.modelSetup.authError));
          expect(
            await fixture.container.read(modelConfigRepositoryProvider).list(),
            isEmpty,
          );
          await tester.tap(find.text(tr.modelSetup.saveLater));
          await tester.pumpAndSettle();
          expect(router.state.uri.path, '/today');
          expect(
            (await fixture.container.read(modelConfigRepositoryProvider).list())
                .length,
            1,
          );
          expect(find.text(tr.modelSetup.savedConnected), findsNothing);
          expect(tester.takeException(), isNull);
        },
      );
    }
  }

  for (final locale in AppLocale.values) {
    testWidgets(
      'Current DeepSeek presets fill and save capabilities in $locale',
      (tester) async {
        final fixture = await _pumpApp(tester, const Size(360, 800));
        await LocaleSettings.setLocale(locale);
        final router = fixture.container.read(routerProvider);
        unawaited(router.push<void>('/settings/models/new'));
        await tester.pumpAndSettle();

        await _reveal(tester, find.byKey(const ValueKey('provider-deepseek')));
        await tester.tap(find.byKey(const ValueKey('provider-deepseek')));
        await tester.tap(find.text(tr.modelSetup.next));
        await tester.pumpAndSettle();
        await _reveal(tester, find.byKey(const ValueKey('setup-key')));
        await tester.enterText(
          find.byKey(const ValueKey('setup-key')),
          'test-only-key',
        );
        await tester.tap(find.text(tr.modelSetup.next));
        await tester.pumpAndSettle();
        for (final (model, vision) in [
          ('deepseek-flash', true),
          ('deepseek-v4-pro', false),
          ('deepseek-flash', true),
        ]) {
          tester
              .state<ScrollableState>(find.byType(Scrollable).first)
              .position
              .jumpTo(0);
          await tester.pumpAndSettle();
          final choice = find.byKey(ValueKey('model-$model'));
          await _reveal(tester, choice);
          await tester.tap(choice);
          await tester.pumpAndSettle();
          final draft = fixture.container.read(modelSetupProvider(null)).config;
          expect(draft.modelId, model);
          expect(draft.supportsVision, vision);
          expect(draft.supportsFunctionCalling, isTrue);
        }
        await tester.tap(find.text(tr.modelSetup.next));
        await tester.pumpAndSettle();
        await tester.tap(find.text(tr.modelSetup.saveLater));
        await tester.pumpAndSettle();
        final saved =
            (await fixture.container.read(modelConfigRepositoryProvider).list())
                .singleWhere((config) => config.modelId == 'deepseek-flash');
        expect(saved.baseUrl, 'https://api.deepseek.com');
        expect(saved.supportsVision, isTrue);
        expect(saved.supportsFunctionCalling, isTrue);
        expect(saved.usage, ModelUsage.both);
        expect(tester.takeException(), isNull);
      },
    );
  }

  for (final legacyModel in ['deepseek-chat', 'deepseek-reasoner']) {
    testWidgets('Legacy $legacyModel upgrade preserves name and stored key', (
      tester,
    ) async {
      final fixture = await _pumpApp(tester, const Size(360, 800));
      final repo = fixture.container.read(modelConfigRepositoryProvider);
      await repo.save(
        AiModelConfig(
          id: 'legacy',
          name: 'Family model',
          baseUrl: 'https://api.deepseek.com/v1',
          modelId: legacyModel,
          usage: ModelUsage.chat,
          createdAt: DateTime.now(),
        ),
        apiKey: 'retained-test-key',
      );
      unawaited(
        fixture.container
            .read(routerProvider)
            .push<void>('/settings/models/legacy'),
      );
      await tester.pumpAndSettle();
      for (var i = 0; i < 2; i++) {
        await tester.tap(find.text(tr.modelSetup.next));
        await tester.pumpAndSettle();
      }
      expect(find.text(tr.modelEdit.deepseekUpdateTitle), findsOneWidget);
      expect((await repo.get('legacy'))!.modelId, legacyModel);
      await _reveal(tester, find.text(tr.modelEdit.deepseekUpdate));
      await tester.tap(find.text(tr.modelEdit.deepseekUpdate));
      await tester.pumpAndSettle();
      expect((await repo.get('legacy'))!.modelId, legacyModel);
      while (find.text(tr.modelSetup.next).evaluate().isNotEmpty) {
        await tester.tap(find.text(tr.modelSetup.next));
        await tester.pumpAndSettle();
      }
      await tester.tap(find.text(tr.modelSetup.saveLater));
      await tester.pumpAndSettle();
      final saved = (await repo.get('legacy'))!;
      expect(saved.name, 'Family model');
      expect(saved.baseUrl, 'https://api.deepseek.com/v1');
      expect(saved.modelId, 'deepseek-flash');
      expect(saved.supportsVision, isTrue);
      expect(await repo.apiKeyOf('legacy'), 'retained-test-key');
      expect(tester.takeException(), isNull);
    });
  }

  for (final size in [const Size(360, 800), const Size(412, 915)]) {
    testWidgets('English tabs, forms and retained routes at large text $size', (
      tester,
    ) async {
      final fixture = await _pumpApp(tester, size);
      expect(find.text(tr.today.emptyTitle), findsOneWidget);
      await _capture(tester, 'today', size);
      await _tab(tester, 1);
      expect(find.text(tr.cabinet.emptyTitle), findsOneWidget);
      await _reveal(tester, find.text(tr.cabinet.add));
      await tester.tap(find.text(tr.cabinet.add));
      await tester.pumpAndSettle();
      await tester.tap(find.text(tr.cabinet.manual));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField).first, 'My medicine');
      await tester.tap(find.text(tr.medicationForm.next));
      await tester.pumpAndSettle();
      await _reveal(tester, find.text(tr.medicationForm.weekdays));
      await tester.tap(find.text(tr.medicationForm.weekdays));
      await tester.pumpAndSettle();
      await _reveal(tester, find.text('Monday'));
      expect(tester.takeException(), isNull);
      fixture.container.read(routerProvider).go('/assistant');
      await tester.pumpAndSettle();
      expect(find.text(tr.assistant.inputHint), findsOneWidget);
      await _capture(tester, 'assistant', size);
      await _tab(tester, 3);
      expect(find.byType(LanguagePicker), findsOneWidget);
      await _capture(tester, 'settings', size);
      await _reveal(tester, find.text('简体中文'));
      await tester.tap(find.text('简体中文'));
      await tester.pumpAndSettle();
      tester
          .state<ScrollableState>(find.byType(Scrollable).first)
          .position
          .jumpTo(0);
      await tester.pumpAndSettle();
      expect(find.text('把 CarePill 调成适合您的样子'), findsOneWidget);
      expect(fixture.store.getString(SettingKeys.languageCode), 'zh');
      await _tab(tester, 2);
      expect(find.text('想问什么就说…'), findsOneWidget);
      await _reveal(tester, find.text('今天吃了吗'));
      expect(find.text('今天吃了吗'), findsOneWidget);
      await _tab(tester, 0);
      expect(find.text('今天还没有安排吃药'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets(
      'Welcome guide can switch language and scroll all steps $size',
      (tester) async {
        await _pumpApp(tester, size, onboarding: true);
        await _reveal(tester, find.text('简体中文'));
        await tester.tap(find.text('简体中文'));
        await tester.pumpAndSettle();
        await _reveal(tester, find.text('开始'));
        expect(find.text('开始'), findsOneWidget);
        await _reveal(tester, find.text('English'));
        await tester.tap(find.text('English'));
        await tester.pumpAndSettle();
        await _reveal(tester, find.text(tr.onboarding.start));
        await tester.tap(find.text(tr.onboarding.start));
        await tester.pumpAndSettle();
        await _capture(tester, 'onboarding', size);
        await _reveal(tester, find.text(tr.onboarding.skip));
        await tester.tap(find.text(tr.onboarding.skip));
        await tester.pumpAndSettle();
        await _reveal(tester, find.text(tr.onboarding.finish));
        await tester.tap(find.text(tr.onboarding.finish));
        await tester.pumpAndSettle();
        expect(find.text(tr.today.emptyTitle), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );
  }

  testWidgets(
    'Language change updates scheduled reminders and Taken keeps its behavior',
    (tester) async {
      final fixture = await _pumpApp(
        tester,
        const Size(360, 800),
        medicine: true,
      );
      final before = fixture.gateway.cancelAllCount;
      await tester.runAsync(
        () => fixture.container
            .read(settingsControllerProvider.notifier)
            .setLanguage(AppLocale.zh),
      );
      await tester.pumpAndSettle();
      expect(fixture.gateway.cancelAllCount, greaterThan(before));
      expect(fixture.gateway.scheduled.last.title, '该吃药了');
      await tester.runAsync(
        () => fixture.container
            .read(settingsControllerProvider.notifier)
            .setLanguage(AppLocale.en),
      );
      await tester.pumpAndSettle();
      expect(
        fixture.gateway.scheduled.last.title,
        tr.reminderScheduler.dueTitle,
      );
      await _reveal(tester, find.text('Taken'));
      await tester.tap(find.text('Taken'));
      await tester.pumpAndSettle();
      expect(
        fixture.tasks.tasks.values.where(
          (task) => task.status == DoseStatus.taken,
        ),
        hasLength(1),
      );
      expect(fixture.meds.meds.values.single.name, 'Amlodipine 降压药');
      expect(tester.takeException(), isNull);
    },
  );

  group('Back navigation', () {
    testWidgets('Onboarding saves advance the guide and finish on Today', (
      tester,
    ) async {
      final fixture = await _pumpApp(
        tester,
        const Size(360, 800),
        onboarding: true,
      );
      await _reveal(tester, find.text(tr.onboarding.start));
      await tester.tap(find.text(tr.onboarding.start));
      await tester.pumpAndSettle();
      await _reveal(tester, find.text(tr.onboarding.addModel));
      await tester.tap(find.text(tr.onboarding.addModel));
      await tester.pumpAndSettle();
      await _reveal(tester, find.byKey(const ValueKey('provider-deepseek')));
      await tester.tap(find.byKey(const ValueKey('provider-deepseek')));
      await tester.tap(find.text(tr.modelSetup.next));
      await tester.pumpAndSettle();
      await _reveal(tester, find.byKey(const ValueKey('setup-key')));
      await tester.enterText(
        find.byKey(const ValueKey('setup-key')),
        'test-key',
      );
      while (find.text(tr.modelSetup.next).evaluate().isNotEmpty) {
        await tester.tap(find.text(tr.modelSetup.next));
        await tester.pumpAndSettle();
      }
      await tester.tap(find.text(tr.modelSetup.saveLater));
      await tester.pumpAndSettle();
      expect(find.text(tr.onboarding.medicineTitle), findsOneWidget);
      await _reveal(tester, find.text(tr.onboarding.manual));
      await tester.tap(find.text(tr.onboarding.manual));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField).first, 'First medicine');
      for (var i = 0; i < 2; i++) {
        await tester.tap(find.text(tr.medicationForm.next));
        await tester.pumpAndSettle();
      }
      await tester.tap(find.text(tr.medicationForm.save));
      await tester.pumpAndSettle();
      expect(fixture.container.read(routerProvider).state.uri.path, '/today');
      expect(fixture.store.getBool(SettingKeys.onboardingDone), isTrue);
      expect(fixture.meds.meds.values.single.name, 'First medicine');
      expect(tester.takeException(), isNull);
    });

    testWidgets('Saved draft opens details and retains Cabinet as the parent', (
      tester,
    ) async {
      final fixture = await _pumpApp(tester, const Size(360, 800));
      await fixture.container
          .read(draftRepositoryProvider)
          .save(
            MedicationDraft(
              id: 'test-draft',
              source: DraftSource.photo,
              payload: const MedicationDraftPayload(name: 'Draft medicine'),
              status: DraftStatus.pending,
              createdAt: DateTime.now(),
            ),
          );
      await _tab(tester, 1);
      final router = fixture.container.read(routerProvider);
      unawaited(router.push<void>('/draft/test-draft'));
      await tester.pumpAndSettle();
      expect(find.byType(BackButton), findsOneWidget);
      await tester.tap(find.text(tr.draftConfirm.save));
      await tester.pumpAndSettle();
      expect(
        router.state.uri.path,
        '/medication/${fixture.meds.meds.keys.single}',
      );
      await _back(tester);
      expect(router.state.uri.path, '/cabinet');
    });

    testWidgets('Model add, edit and save preserve the Settings stack', (
      tester,
    ) async {
      final fixture = await _pumpApp(tester, const Size(360, 800));
      final router = fixture.container.read(routerProvider);
      await _tab(tester, 3);
      expect(find.byType(BackButton), findsNothing);
      await _reveal(tester, find.text(tr.settings.manageModels));
      await tester.tap(find.text(tr.settings.manageModels));
      await tester.pumpAndSettle();
      expect(find.byType(PillPalNavBar), findsNothing);
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();
      expect(router.state.uri.path, '/settings/models/new');
      await _back(tester);
      expect(router.state.uri.path, '/settings/models');
      await _reveal(tester, find.text(tr.modelManage.edit));
      await tester.tap(find.text(tr.modelManage.edit));
      await tester.pumpAndSettle();
      while (find.text(tr.modelSetup.next).evaluate().isNotEmpty) {
        await tester.tap(find.text(tr.modelSetup.next));
        await tester.pumpAndSettle();
      }
      await tester.tap(find.text(tr.modelSetup.saveLater));
      await tester.pumpAndSettle();
      expect(router.state.uri.path, '/settings/models');
      await _back(tester);
      expect(router.state.uri.path, '/settings');
      expect(find.byType(BackButton), findsNothing);
    });

    testWidgets('Assistant model setup returns to Assistant', (tester) async {
      final fixture = await _pumpApp(
        tester,
        const Size(360, 800),
        model: false,
      );
      await _tab(tester, 2);
      await _reveal(tester, find.text(tr.assistant.addModel));
      await tester.tap(find.text(tr.assistant.addModel));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();
      await _back(tester);
      await _back(tester);
      expect(
        fixture.container.read(routerProvider).state.uri.path,
        '/assistant',
      );
      expect(
        tester.widget<PillPalNavBar>(find.byType(PillPalNavBar)).selectedIndex,
        2,
      );
    });

    testWidgets(
      'Every secondary route has a back button and direct-link fallback',
      (tester) async {
        final fixture = await _pumpApp(
          tester,
          const Size(360, 800),
          medicine: true,
        );
        final router = fixture.container.read(routerProvider);
        final medicineId = fixture.meds.meds.keys.single;
        final routes = <(String, String)>[
          ('/settings/models', '/settings'),
          ('/settings/models/new', '/settings/models'),
          ('/settings/models/test-model', '/settings/models'),
          ('/settings/stats', '/settings'),
          ('/settings/about', '/settings'),
          ('/settings/rom-guide', '/settings'),
          ('/medication/new', '/cabinet'),
          ('/medication/$medicineId', '/cabinet'),
          ('/medication/$medicineId/edit', '/medication/$medicineId'),
          ('/medication/missing', '/cabinet'),
          ('/medication/photo', '/cabinet'),
          ('/draft/missing', '/cabinet'),
          ('/reminder', '/today'),
          ('/onboarding?replay=1', '/settings'),
        ];
        for (final (location, fallback) in routes) {
          router.go('/assistant');
          await tester.pumpAndSettle();
          unawaited(router.push<void>(location));
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull, reason: location);
          expect(find.byType(PillPalNavBar), findsNothing, reason: location);
          expect(find.byType(BackButton), findsOneWidget, reason: location);
          if (location == '/medication/photo') {
            expect(find.byType(PhotoCapturePage), findsOneWidget);
          }
          await _back(tester);
          expect(router.state.uri.path, '/assistant', reason: location);
          router.go(location);
          await tester.pumpAndSettle();
          expect(router.canPop(), isFalse);
          await _back(tester);
          expect(router.state.uri.path, fallback, reason: location);
        }
        await tester.pump(const Duration(seconds: 1));
      },
    );

    testWidgets(
      'Medicine wizard handles toolbar and system back without losing input',
      (tester) async {
        final fixture = await _pumpApp(tester, const Size(360, 800));
        await _reveal(tester, find.text(tr.today.add));
        await tester.tap(find.text(tr.today.add));
        await tester.pumpAndSettle();
        await tester.enterText(
          find.byType(TextField).first,
          'Remember this name',
        );
        await tester.tap(find.text(tr.medicationForm.next));
        await tester.pumpAndSettle();
        await tester.binding.handlePopRoute();
        await tester.pumpAndSettle();
        expect(find.text('Remember this name'), findsOneWidget);
        await tester.tap(find.text(tr.medicationForm.next));
        await tester.pumpAndSettle();
        await _back(tester);
        expect(find.text('Remember this name'), findsOneWidget);
        await _back(tester);
        expect(fixture.container.read(routerProvider).state.uri.path, '/today');
      },
    );

    testWidgets('Medicine edit saves back to details and then Cabinet', (
      tester,
    ) async {
      final fixture = await _pumpApp(
        tester,
        const Size(360, 800),
        medicine: true,
      );
      final router = fixture.container.read(routerProvider);
      await _tab(tester, 1);
      await tester.tap(find.text('Amlodipine 降压药'));
      await tester.pumpAndSettle();
      await _reveal(tester, find.text(tr.medicationDetail.edit));
      await tester.tap(find.text(tr.medicationDetail.edit));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField).first, 'Updated medicine');
      for (var i = 0; i < 2; i++) {
        await tester.tap(find.text(tr.medicationForm.next));
        await tester.pumpAndSettle();
      }
      await tester.tap(find.text(tr.medicationForm.saveChanges));
      await tester.pumpAndSettle();
      expect(
        router.state.uri.path,
        '/medication/${fixture.meds.meds.keys.single}',
      );
      expect(find.text('Updated medicine'), findsOneWidget);
      await _back(tester);
      expect(router.state.uri.path, '/cabinet');
    });

    testWidgets(
      'Onboarding cancels child forms to the same step and steps back',
      (tester) async {
        final fixture = await _pumpApp(
          tester,
          const Size(360, 800),
          onboarding: true,
        );
        expect(find.byType(BackButton), findsNothing);
        await _reveal(tester, find.text(tr.onboarding.start));
        await tester.tap(find.text(tr.onboarding.start));
        await tester.pumpAndSettle();
        await _reveal(tester, find.text(tr.onboarding.addModel));
        await tester.tap(find.text(tr.onboarding.addModel));
        await tester.pumpAndSettle();
        await _back(tester);
        expect(find.text(tr.onboarding.modelTitle), findsOneWidget);
        await _reveal(tester, find.text(tr.onboarding.skip));
        await tester.tap(find.text(tr.onboarding.skip));
        await tester.pumpAndSettle();
        await _reveal(tester, find.text(tr.onboarding.manual));
        await tester.tap(find.text(tr.onboarding.manual));
        await tester.pumpAndSettle();
        await _back(tester);
        expect(find.text(tr.onboarding.medicineTitle), findsOneWidget);
        await tester.binding.handlePopRoute();
        await tester.pumpAndSettle();
        expect(find.text(tr.onboarding.modelTitle), findsOneWidget);
        await _back(tester);
        expect(find.byType(LanguagePicker), findsOneWidget);
        expect(fixture.store.getBool(SettingKeys.onboardingDone), isFalse);
        await tester.pump(const Duration(seconds: 1));
      },
    );

    testWidgets('Replaying onboarding can exit or finish back to Settings', (
      tester,
    ) async {
      final fixture = await _pumpApp(tester, const Size(360, 800));
      final router = fixture.container.read(routerProvider);
      await _tab(tester, 3);
      Future<void> openGuide() async {
        await _reveal(tester, find.text(tr.settings.onboarding));
        await tester.tap(find.text(tr.settings.onboarding));
        await tester.pumpAndSettle();
        expect(find.byType(BackButton), findsOneWidget);
        expect(fixture.store.getBool(SettingKeys.onboardingDone), isTrue);
      }

      await openGuide();
      await _back(tester);
      expect(router.state.uri.path, '/settings');
      await openGuide();
      for (final label in [
        tr.onboarding.start,
        tr.onboarding.skip,
        tr.onboarding.finish,
      ]) {
        await _reveal(tester, find.text(label));
        await tester.tap(find.text(label));
        await tester.pumpAndSettle();
      }
      expect(router.state.uri.path, '/settings');
      await tester.pump(const Duration(seconds: 1));
    });
  });
}

Future<void> _back(WidgetTester tester) async {
  expect(find.byType(BackButton), findsOneWidget);
  await tester.tap(find.byType(BackButton));
  await tester.pumpAndSettle();
  expect(tester.takeException(), isNull);
}

Future<
  ({
    ProviderContainer container,
    InMemoryKeyValueStore store,
    FakeReminderGateway gateway,
    InMemoryDoseTaskRepository tasks,
    InMemoryMedicationRepository meds,
  })
>
_pumpApp(
  WidgetTester tester,
  Size size, {
  bool onboarding = false,
  bool medicine = false,
  bool model = true,
  AiChatClient? aiClient,
  BarcodeLookup? barcodeLookup,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  tester.platformDispatcher.textScaleFactorTestValue = 1.3;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
  final store = InMemoryKeyValueStore();
  await store.setInt(SettingKeys.fontTier, 2);
  await store.setBool(SettingKeys.onboardingDone, !onboarding);
  await initializeLocale(SettingsService(store), deviceLocale: 'en-US');
  final gateway = FakeReminderGateway();
  final meds = InMemoryMedicationRepository();
  final tasks = InMemoryDoseTaskRepository();
  final models = InMemoryModelConfigRepository();
  if (model) {
    await models.save(
      AiModelConfig(
        id: 'test-model',
        name: 'Test model',
        baseUrl: 'https://example.com/v1',
        modelId: 'test',
        usage: ModelUsage.chat,
        supportsChat: true,
        isChatDefault: true,
        createdAt: DateTime.now(),
      ),
      apiKey: 'test-key',
    );
  }
  final container = ProviderContainer(
    overrides: [
      keyValueStoreProvider.overrideWithValue(store),
      medicationRepositoryProvider.overrideWithValue(meds),
      doseTaskRepositoryProvider.overrideWithValue(tasks),
      modelConfigRepositoryProvider.overrideWithValue(models),
      chatRepositoryProvider.overrideWithValue(InMemoryChatRepository()),
      agentStoreProvider.overrideWithValue(InMemoryAgentStore()),
      draftRepositoryProvider.overrideWithValue(InMemoryDraftRepository()),
      reminderGatewayProvider.overrideWithValue(gateway),
      speechServiceProvider.overrideWithValue(FakeSpeechService()),
      if (aiClient != null) aiClientProvider.overrideWithValue(aiClient),
      if (barcodeLookup != null)
        barcodeLookupProvider.overrideWithValue(barcodeLookup),
    ],
  );
  if (medicine) {
    await container
        .read(medicationServiceProvider)
        .createManual(
          name: 'Amlodipine 降压药',
          form: MedicationForm.tablet,
          doseUnit: '片',
          scheduleInputs: [
            ScheduleDraftInput(
              frequencyType: FrequencyType.daily,
              times: const [TimeSlot(time: '23:59', dose: 1)],
            ),
          ],
        );
    await container.read(doseServiceProvider).expandTasks();
  }
  addTearDown(() async {
    await tester.pumpWidget(const SizedBox.shrink());
    container.dispose();
  });
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: RepaintBoundary(
        key: _captureKey,
        child: Platform.environment['CAREPILL_QA_FONT'] == null
            ? const PillPalApp()
            : const _VisualApp(),
      ),
    ),
  );
  await tester.pumpAndSettle();
  expect(tester.takeException(), isNull);
  return (
    container: container,
    store: store,
    gateway: gateway,
    tasks: tasks,
    meds: meds,
  );
}

// Same app theme and router, with an explicit test font for every text style.
// Without this, Flutter's test font draws some button/app-bar labels as blocks.
class _VisualApp extends ConsumerWidget {
  const _VisualApp();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(appBootstrapProvider);
    final theme = AppTheme.theme(ref.watch(fontTierProvider));
    ButtonStyle withFont(ButtonStyle style) => style.copyWith(
      textStyle: WidgetStateProperty.resolveWith(
        (states) => style.textStyle!
            .resolve(states)!
            .copyWith(fontFamily: 'CarePillQA'),
      ),
    );
    return StreamBuilder<AppLocale>(
      stream: LocaleSettings.getLocaleStream(),
      initialData: LocaleSettings.currentLocale,
      builder: (context, locale) => MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: ref.watch(routerProvider),
        locale: locale.requireData.flutterLocale,
        supportedLocales: AppLocaleUtils.instance.supportedLocales,
        localizationsDelegates: GlobalMaterialLocalizations.delegates,
        theme: theme.copyWith(
          textTheme: theme.textTheme.apply(fontFamily: 'CarePillQA'),
          appBarTheme: theme.appBarTheme.copyWith(
            titleTextStyle: theme.appBarTheme.titleTextStyle!.copyWith(
              fontFamily: 'CarePillQA',
            ),
          ),
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: withFont(theme.outlinedButtonTheme.style!),
          ),
          filledButtonTheme: FilledButtonThemeData(
            style: withFont(theme.filledButtonTheme.style!),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: withFont(theme.elevatedButtonTheme.style!),
          ),
        ),
        builder: (context, child) => PillPalBackdrop(child: child!),
      ),
    );
  }
}

Future<void> _tab(WidgetTester tester, int index) async {
  final nav = tester.widget<PillPalNavBar>(find.byType(PillPalNavBar));
  await tester.tap(
    find.descendant(
      of: find.byType(PillPalNavBar),
      matching: find.text(nav.tabs[index].$1),
    ),
  );
  await tester.pumpAndSettle();
  expect(
    tester.widget<PillPalNavBar>(find.byType(PillPalNavBar)).selectedIndex,
    index,
  );
  expect(tester.takeException(), isNull);
}

Future<void> _reveal(WidgetTester tester, Finder finder) async {
  await tester.scrollUntilVisible(
    finder,
    180,
    scrollable: find.byType(Scrollable).first,
    maxScrolls: 100,
  );
  await tester.pumpAndSettle();
  expect(tester.takeException(), isNull);
}

Future<void> _capture(WidgetTester tester, String page, Size size) async {
  if (Platform.environment['CAREPILL_QA_FONT'] == null) return;
  await tester.runAsync(() async {
    final boundary =
        _captureKey.currentContext!.findRenderObject()!
            as RenderRepaintBoundary;
    final image = await boundary.toImage();
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    await Directory('build/ui-preview').create(recursive: true);
    await File('build/ui-preview/en-$page-${size.width.toInt()}.png')
        .writeAsBytes(bytes!.buffer.asUint8List());
    image.dispose();
  });
}

class _RejectedSetupClient implements AiChatClient {
  @override
  Future<AiChatResult> chat(
    AiChatRequest request, {
    required AiClientConfig config,
  }) async {
    throw const AiException(AiErrorCode.authentication);
  }
}

class _BarcodeFixture implements BarcodeLookup {
  @override
  Future<List<BarcodeMedication>> lookup(
    MedicationBarcode barcode, {
    required CancellationSignal cancellation,
  }) async => [
    BarcodeMedication(
      barcode: barcode.gtin,
      name: 'Example medicine',
      genericName: 'Example ingredient',
      manufacturer: 'Example manufacturer',
      labelId: 'test',
    ),
  ];
}
