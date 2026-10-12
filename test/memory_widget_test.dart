import 'package:care_pill/application/providers.dart';
import 'package:care_pill/data/repositories/agent_store.dart';
import 'package:care_pill/domain/services/memory_service.dart';
import 'package:care_pill/i18n/strings.g.dart';
import 'package:care_pill/ui/assistant/memory_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  tearDown(() => LocaleSettings.setLocale(AppLocale.zh));
  for (final locale in AppLocale.values) {
    testWidgets('memory list, edit and undo at large text scale in $locale', (
      tester,
    ) async {
      await LocaleSettings.setLocale(locale);
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final store = InMemoryAgentStore();
      final memory = MemoryService(store);
      await memory.save('喜欢简短回答 / Prefer short replies');
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            agentStoreProvider.overrideWithValue(store),
            memoryServiceProvider.overrideWithValue(memory),
          ],
          child: MaterialApp(
            locale: Locale(locale.languageCode),
            supportedLocales: const [Locale('zh'), Locale('en')],
            localizationsDelegates: GlobalMaterialLocalizations.delegates,
            builder: (context, child) => MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: TextScaler.linear(1.5)),
              child: child!,
            ),
            home: const MemoryPage(),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('喜欢简短回答 / Prefer short replies'), findsOneWidget);
      await tester.tap(find.text(tr.agentV2.edit));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), '喜欢详细回答');
      await tester.tap(find.text(tr.agentV2.save));
      await tester.pumpAndSettle();
      expect((await memory.all()).single['content'], '喜欢详细回答');
      await tester.tap(find.text(tr.common.undo));
      await tester.pumpAndSettle();
      expect(
        (await memory.all()).single['content'],
        '喜欢简短回答 / Prefer short replies',
      );
      expect(tester.takeException(), isNull);
    });
  }
}
