import 'dart:io';
import 'dart:ui' as ui;

import 'package:care_pill/application/providers.dart';
import 'package:care_pill/data/settings/app_settings.dart';
import 'package:care_pill/data/settings/key_value_store.dart';
import 'package:care_pill/ui/cabinet/medication_form_page.dart';
import 'package:care_pill/ui/settings/model_edit_page.dart';
import 'package:care_pill/ui/settings/settings_page.dart';
import 'package:care_pill/ui/theme/app_theme.dart';
import 'package:care_pill/ui/widgets/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fakes/fakes.dart';

final _captureKey = GlobalKey();
final _qaFont = Platform.environment['CAREPILL_QA_FONT'];

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // 可选的本地视觉核对：加载机器上的中文字体并输出真实 Widget 渲染。
  setUpAll(() async {
    if (_qaFont != null) {
      final data = ByteData.sublistView(await File(_qaFont!).readAsBytes());
      for (final family in ['CarePillQA', 'Roboto', 'Ahem']) {
        await (FontLoader(family)..addFont(Future.value(data))).load();
      }
      await (FontLoader(
        'MaterialIcons',
      )..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf'))).load();
    }
  });

  for (final size in [const Size(360, 800), const Size(412, 915)]) {
    for (final tier in [0, 1, 2]) {
      testWidgets('设置固定上下排列 ${size.width} 字号$tier 系统缩放1.3', (tester) async {
        final store = InMemoryKeyValueStore();
        await store.setInt(SettingKeys.fontTier, tier);
        final speech = FakeSpeechService();
        await _pumpPage(tester, const SettingsPage(), store, size, speech);

        final first = tester.getRect(find.text('标准'));
        final second = tester.getRect(
          find.descendant(
            of: find.byType(PillPalChoice),
            matching: find.text('大'),
          ),
        );
        final third = tester.getRect(find.text('特大'));
        expect(first.bottom, lessThan(second.top));
        expect(second.bottom, lessThan(third.top));
        if (tier == 2) await _capture(tester, 'settings-${size.width.toInt()}');

        await _reveal(tester, find.byTooltip('增加过了多久算漏吃'));
        expect(
          tester.getRect(find.text('过了多久算漏吃')).bottom,
          lessThan(tester.getRect(find.byTooltip('增加过了多久算漏吃')).top),
        );
        await tester.tap(find.byTooltip('增加过了多久算漏吃'));
        await tester.pumpAndSettle();
        expect(store.getInt(SettingKeys.gracePeriodMinutes), 75);

        await _reveal(tester, find.text('试听'));
        expect(
          tester.getRect(find.byType(Slider)).bottom,
          lessThanOrEqualTo(tester.getRect(find.text('试听')).top),
        );
        await tester.tap(find.text('试听'));
        await tester.pumpAndSettle();
        expect(speech.spoken, ['该吃降压药了，一次一片。']);
        if (tier == 2) {
          await tester.ensureVisible(find.text('语音'));
          await tester.pumpAndSettle();
          await _capture(tester, 'voice-${size.width.toInt()}');
        }

        await _reveal(tester, find.text('隐私与免责说明'));
        expect(tester.takeException(), isNull);
      });
    }
  }

  testWidgets('加药的单位规格、选项和剂量纵排且可操作', (tester) async {
    final store = InMemoryKeyValueStore();
    await store.setInt(SettingKeys.fontTier, 2);
    await _pumpPage(
      tester,
      const MedicationFormPage(),
      store,
      const Size(360, 800),
    );
    await tester.enterText(find.byType(TextField).first, '测试药品');
    await _reveal(tester, find.text('口服液'));
    await tester.tap(find.text('口服液'));
    await tester.pumpAndSettle();
    await _reveal(tester, find.text('规格（可不填）'));
    expect(
      tester.getRect(find.text('一次多少（单位）')).top,
      lessThan(tester.getRect(find.text('规格（可不填）')).top),
    );
    expect(find.text('毫升'), findsOneWidget);

    await tester.tap(find.text('下一步'));
    await tester.pumpAndSettle();
    tester
        .state<ScrollableState>(find.byType(Scrollable).first)
        .position
        .jumpTo(0);
    await tester.pumpAndSettle();
    await _reveal(tester, find.text('每周几天'));
    await tester.tap(find.text('每周几天'));
    await tester.pumpAndSettle();
    await _reveal(tester, find.text('周一'));
    await tester.tap(find.text('周一'));
    await tester.pumpAndSettle();
    final monday = tester.widget<PillPalChoice>(
      find.ancestor(of: find.text('周一'), matching: find.byType(PillPalChoice)),
    );
    expect(monday.selected, isFalse);

    await _reveal(tester, find.byTooltip('增加第 1 次剂量'));
    await tester.tap(find.byTooltip('增加第 1 次剂量'));
    await tester.pumpAndSettle();
    expect(find.text('1.5毫升'), findsOneWidget);
    await _reveal(tester, find.text('加一个时间'));
    await tester.tap(find.text('加一个时间'));
    await tester.pumpAndSettle();
    await _reveal(tester, find.text('第 2 次服药时间'));
    await _reveal(tester, find.text('不固定'));
    await tester.tap(find.text('不固定'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('下一步'));
    await tester.pumpAndSettle();
    expect(find.textContaining('1.5毫升'), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets('模型表单长说明和开关上下排列且开关可操作', (tester) async {
    final store = InMemoryKeyValueStore();
    await store.setInt(SettingKeys.fontTier, 2);
    await _pumpPage(tester, const ModelEditPage(), store, const Size(360, 800));
    await tester.tap(find.byKey(const ValueKey('provider-deepseek')));
    await tester.tap(find.text('下一步'));
    await tester.pumpAndSettle();
    await _reveal(tester, find.byKey(const ValueKey('setup-key')));
    await tester.enterText(find.byKey(const ValueKey('setup-key')), 'test-key');
    await tester.tap(find.text('下一步'));
    await tester.pumpAndSettle();
    await _reveal(tester, find.text('高级设置'));
    await tester.tap(find.text('高级设置'));
    await tester.pumpAndSettle();
    await _reveal(tester, find.text('用途'));
    await _reveal(tester, find.text('对话+看图'));
    await tester.tap(find.text('对话+看图'));
    await tester.pumpAndSettle();
    await _reveal(tester, find.text('支持看图'));
    final toggle = find.descendant(
      of: find.widgetWithText(PillPalSwitchField, '支持看图'),
      matching: find.byType(Switch),
    );
    await tester.ensureVisible(toggle);
    expect(tester.widget<Switch>(toggle).value, isTrue);
    expect(
      tester.getRect(find.text('支持看图')).bottom,
      lessThan(tester.getRect(toggle).top),
    );
    await tester.tap(toggle);
    await tester.pumpAndSettle();
    expect(tester.widget<Switch>(toggle).value, isFalse);
    await _reveal(tester, find.text('回答最长字数（可选）'));
    expect(tester.takeException(), isNull);
  });
}

Future<void> _pumpPage(
  WidgetTester tester,
  Widget page,
  InMemoryKeyValueStore store,
  Size size, [
  FakeSpeechService? speech,
]) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        keyValueStoreProvider.overrideWithValue(store),
        speechServiceProvider.overrideWithValue(speech ?? FakeSpeechService()),
      ],
      child: Consumer(
        builder: (context, ref, _) {
          final theme = AppTheme.theme(ref.watch(fontTierProvider));
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: _qaFont == null ? theme : _withQaFont(theme),
            builder: (context, child) => RepaintBoundary(
              key: _captureKey,
              child: MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(textScaler: const TextScaler.linear(1.3)),
                child: PillPalBackdrop(child: child!),
              ),
            ),
            home: page,
          );
        },
      ),
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> _reveal(WidgetTester tester, Finder finder) async {
  await tester.scrollUntilVisible(
    finder,
    220,
    scrollable: find.byType(Scrollable).first,
    maxScrolls: 100,
  );
  await tester.pumpAndSettle();
  expect(tester.takeException(), isNull);
}

ThemeData _withQaFont(ThemeData theme) {
  ButtonStyle withFont(ButtonStyle style) => style.copyWith(
    textStyle: WidgetStateProperty.resolveWith(
      (states) =>
          style.textStyle!.resolve(states)!.copyWith(fontFamily: 'CarePillQA'),
    ),
  );
  return theme.copyWith(
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
  );
}

Future<void> _capture(WidgetTester tester, String name) async {
  if (_qaFont == null) return;
  await tester.runAsync(() async {
    final boundary =
        _captureKey.currentContext!.findRenderObject()!
            as RenderRepaintBoundary;
    final image = await boundary.toImage();
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    final directory = Directory('build/ui-preview');
    await directory.create(recursive: true);
    await File('${directory.path}/$name.png')
        .writeAsBytes(bytes!.buffer.asUint8List());
    image.dispose();
  });
}
