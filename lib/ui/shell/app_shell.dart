import 'package:care_pill/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_theme.dart';
import '../widgets/common.dart';

/// 四 Tab 外壳（docs/07 §1：今日 / 药箱 / AI助手 / 设置，没有更多）。
class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  static List<(String, IconData)> get _tabs => [
    (tr.appShell.today, Icons.today),
    (tr.appShell.cabinet, Icons.medication),
    (tr.appShell.assistant, Icons.forum),
    (tr.appShell.settings, Icons.settings),
  ];

  @override
  Widget build(BuildContext context) {
    // Rebuild localized labels, including those constructed in helper methods.
    Localizations.localeOf(context);
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: PillPalNavBar(
        selectedIndex: navigationShell.currentIndex,
        tabs: _tabs,
        onSelected: (index) => navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        ),
      ),
    );
  }
}

/// 轻量悬浮胶囊导航，保持 64dp 以上触控目标。
class PillPalNavBar extends StatelessWidget {
  const PillPalNavBar({
    super.key,
    required this.selectedIndex,
    required this.tabs,
    required this.onSelected,
  });

  final int selectedIndex;
  final List<(String, IconData)> tabs;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    // Rebuild localized labels, including those constructed in helper methods.
    Localizations.localeOf(context);
    final theme = Theme.of(context);
    final navFontSize = (theme.textTheme.labelSmall?.fontSize ?? 14)
        .clamp(14.0, 18.0)
        .toDouble();
    return SafeArea(
      top: false,
      minimum: const EdgeInsets.fromLTRB(12, 4, 12, 10),
      child: Container(
        constraints: const BoxConstraints(minHeight: 78),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.92),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: AppTheme.border),
          boxShadow: const [
            BoxShadow(
              color: Color(0x1F4776A1),
              blurRadius: 22,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final (index, tab) in tabs.indexed)
                Expanded(
                  child: Semantics(
                    button: true,
                    selected: selectedIndex == index,
                    label: tab.$1,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(21),
                      onTap: () => onSelected(index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        curve: Curves.easeOut,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: selectedIndex == index
                              ? AppTheme.primary.withValues(alpha: 0.12)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(21),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              tab.$2,
                              size: 24,
                              color: selectedIndex == index
                                  ? AppTheme.primary
                                  : AppTheme.muted,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              tab.$1,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.labelSmall!.copyWith(
                                fontSize: navFontSize,
                                color: selectedIndex == index
                                    ? AppTheme.primary
                                    : AppTheme.muted,
                                fontWeight: selectedIndex == index
                                    ? FontWeight.w800
                                    : FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 页面标题栏统一构建：右上角固定全局"字"按钮（docs/07 §1）。
PreferredSizeWidget buildPillPalAppBar({
  required String title,
  List<Widget> actions = const [],
  Widget? leading,
  String? backLocation,
}) {
  return AppBar(
    title: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const BrandMark(size: 34),
        const SizedBox(width: 8),
        Flexible(child: Text(title, overflow: TextOverflow.ellipsis)),
      ],
    ),
    leading:
        leading ??
        (backLocation == null
            ? null
            : PillPalBackButton(fallbackLocation: backLocation)),
    actions: [...actions, const FontSizeButton(), const SizedBox(width: 8)],
  );
}

/// Return to the actual entry screen, or the parent for a direct/deep link.
void popPillPalPage(
  BuildContext context, {
  required String fallbackLocation,
  Object? result,
}) {
  final router = GoRouter.maybeOf(context);
  if (router != null) {
    if (router.canPop()) {
      router.pop(result);
    } else {
      router.go(fallbackLocation);
    }
  } else {
    Navigator.of(context).maybePop(result);
  }
}

class PillPalBackButton extends StatelessWidget {
  const PillPalBackButton({
    super.key,
    required this.fallbackLocation,
    this.color,
  });

  final String fallbackLocation;
  final Color? color;

  @override
  Widget build(BuildContext context) => BackButton(
    color: color,
    onPressed: () =>
        popPillPalPage(context, fallbackLocation: fallbackLocation),
  );
}
