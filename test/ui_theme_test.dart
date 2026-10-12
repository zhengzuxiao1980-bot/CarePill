import 'package:care_pill/ui/shell/app_shell.dart';
import 'package:care_pill/ui/theme/app_theme.dart';
import 'package:care_pill/ui/widgets/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('品牌背景和导航在特大字号下保持可见', (tester) async {
    await tester.binding.setSurfaceSize(const Size(360, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.theme(2),
        home: Scaffold(
          body: PillPalBackdrop(
            child: const Center(child: BrandMark(size: 96)),
          ),
          bottomNavigationBar: PillPalNavBar(
            selectedIndex: 0,
            tabs: const [
              ('今日', Icons.today),
              ('药箱', Icons.medication),
              ('AI助手', Icons.forum),
              ('设置', Icons.settings),
            ],
            onSelected: (_) {},
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(BrandMark), findsOneWidget);
    expect(find.text('今日'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('主按钮文字和图标随背景及禁用状态使用正确前景色', (tester) async {
    final theme = AppTheme.theme(1);
    final disabledColor = theme.colorScheme.onSurface.withValues(alpha: 0.38);
    final cases = <(Color?, Color?, bool, Color)>[
      (null, null, true, Colors.white),
      (AppTheme.warnAmber, null, true, Colors.white),
      (AppTheme.badRed, null, true, Colors.white),
      (Colors.white, AppTheme.brand, true, AppTheme.brand),
      (null, null, false, disabledColor),
      (Colors.white, AppTheme.brand, false, disabledColor),
    ];
    for (final (background, foreground, enabled, expected) in cases) {
      await tester.pumpWidget(
        MaterialApp(
          theme: theme,
          home: Scaffold(
            body: BigPrimaryButton(
              label: '确认',
              icon: Icons.check,
              color: background,
              foregroundColor: foreground,
              onPressed: enabled ? () {} : null,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        _paintedColor(tester, find.text('确认'))?.toARGB32(),
        expected.toARGB32(),
      );
      expect(
        _paintedColor(tester, find.byIcon(Icons.check))?.toARGB32(),
        expected.toARGB32(),
      );
      expect(tester.takeException(), isNull);
    }
  });

  testWidgets('次要按钮禁用时文字和图标同步变灰', (tester) async {
    final theme = AppTheme.theme(1);
    await tester.pumpWidget(
      MaterialApp(
        theme: theme,
        home: const Scaffold(
          body: BigOutlinedButton(
            label: '拍照识别',
            icon: Icons.camera_alt,
            onPressed: null,
          ),
        ),
      ),
    );
    final expected = theme.colorScheme.onSurface.withValues(alpha: 0.38);
    expect(
      _paintedColor(tester, find.text('拍照识别'))?.toARGB32(),
      expected.toARGB32(),
    );
    expect(
      _paintedColor(tester, find.byIcon(Icons.camera_alt))?.toARGB32(),
      expected.toARGB32(),
    );
  });

  testWidgets('深色提示条的消息与撤销操作保持白色', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.theme(1),
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () =>
                  UndoBar.show(context, message: '记上了', onUndo: () {}),
              child: const Text('显示提示'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('显示提示'));
    await tester.pumpAndSettle();

    expect(_paintedColor(tester, find.text('记上了')), Colors.white);
    expect(_paintedColor(tester, find.text('撤销')), Colors.white);
    expect(tester.takeException(), isNull);
  });
}

// 检查最终绘制的文字 / 图标颜色，而非仅检查 ButtonStyle 配置。
Color? _paintedColor(WidgetTester tester, Finder widget) {
  final richText = tester.widget<RichText>(
    find.descendant(of: widget, matching: find.byType(RichText)),
  );
  final style = richText.text.style;
  return style?.foreground?.color ?? style?.color;
}
