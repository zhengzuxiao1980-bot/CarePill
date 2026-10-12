import 'package:care_pill/i18n/strings.g.dart';
import 'package:flutter/material.dart';

import '../../core/app_constants.dart';
import '../../core/formatters.dart';
import '../../domain/models/enums.dart';
import '../../domain/models/stats.dart';

/// CarePill 的品牌视觉令牌和适老化主题。
///
/// 颜色取自参考图的浅蓝光晕、暖白留白和深海军蓝字色；字号和点击
/// 目标继续遵守 docs/07 的适老化要求。
abstract final class AppTheme {
  static const Color brand = Color(0xFF163A78);
  static const Color primary = Color(0xFF1976F3);
  static const Color cyan = Color(0xFF129EAD);
  static const Color ink = Color(0xFF122A55);
  static const Color muted = Color(0xFF5B7190);
  static const Color canvas = Color(0xFFF6FBFF);
  static const Color warmSurface = Color(0xFFFFFEF8);
  static const Color border = Color(0xFFDCE8F4);
  static const Color okGreen = Color(0xFF16846C);
  static const Color warnAmber = Color(0xFFB66A08);
  static const Color badRed = Color(0xFFC7474B);

  static const LinearGradient brandGradient = LinearGradient(
    colors: [Color(0xFF1C86F5), Color(0xFF2755C9)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static double baseOf(int tier) => switch (tier) {
    0 => kFontStandardBase,
    2 => kFontXlargeBase,
    _ => kFontLargeBase,
  };

  static ThemeData theme(int tier) {
    final base = baseOf(tier);
    final scheme =
        ColorScheme.fromSeed(
          seedColor: primary,
          brightness: Brightness.light,
        ).copyWith(
          primary: primary,
          onPrimary: Colors.white,
          secondary: cyan,
          onSecondary: Colors.white,
          surface: Colors.white,
          onSurface: ink,
          outline: border,
          error: badRed,
          onError: Colors.white,
        );
    final textTheme = TextTheme(
      displaySmall: TextStyle(
        fontSize: base + 12,
        fontWeight: FontWeight.w800,
        color: ink,
        letterSpacing: -0.5,
      ),
      headlineMedium: TextStyle(
        fontSize: base + 10,
        fontWeight: FontWeight.w800,
        color: ink,
        letterSpacing: -0.3,
      ),
      headlineSmall: TextStyle(
        fontSize: base + 8,
        fontWeight: FontWeight.w800,
        color: ink,
      ),
      titleLarge: TextStyle(
        fontSize: base + 6,
        fontWeight: FontWeight.w800,
        color: ink,
      ),
      titleMedium: TextStyle(
        fontSize: base + 4,
        fontWeight: FontWeight.w700,
        color: ink,
      ),
      titleSmall: TextStyle(
        fontSize: base + 2,
        fontWeight: FontWeight.w700,
        color: ink,
      ),
      bodyLarge: TextStyle(fontSize: base + 2, height: 1.5, color: ink),
      bodyMedium: TextStyle(fontSize: base, height: 1.5, color: muted),
      bodySmall: TextStyle(fontSize: base - 2, height: 1.4, color: muted),
      labelLarge: TextStyle(
        fontSize: base + 2,
        fontWeight: FontWeight.w800,
        color: ink,
      ),
      labelMedium: TextStyle(
        fontSize: base,
        fontWeight: FontWeight.w700,
        color: ink,
      ),
      labelSmall: TextStyle(fontSize: base - 2, color: muted),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      textTheme: textTheme,
      scaffoldBackgroundColor: Colors.transparent,
      appBarTheme: AppBarTheme(
        centerTitle: false,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: textTheme.titleLarge,
        iconTheme: const IconThemeData(color: ink, size: 28),
        toolbarHeight: 70,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        height: 76,
        labelTextStyle: WidgetStatePropertyAll(
          TextStyle(
            fontSize: base - 3,
            fontWeight: FontWeight.w700,
            color: ink,
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          minimumSize: const Size(160, 72),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          elevation: 5,
          shadowColor: primary.withValues(alpha: 0.24),
          textStyle: TextStyle(fontSize: base + 4, fontWeight: FontWeight.w800),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          minimumSize: const Size(120, 64),
          elevation: 3,
          textStyle: TextStyle(fontSize: base + 2, fontWeight: FontWeight.w800),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: brand,
          minimumSize: const Size(120, 64),
          side: const BorderSide(color: primary, width: 1.6),
          textStyle: TextStyle(fontSize: base + 2, fontWeight: FontWeight.w700),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        elevation: 7,
        iconSize: 32,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.9),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: primary, width: 2),
        ),
        hintStyle: TextStyle(
          color: muted.withValues(alpha: 0.8),
          fontSize: base + 1,
        ),
      ),
      cardTheme: CardThemeData(
        color: Colors.white.withValues(alpha: 0.92),
        elevation: 1,
        shadowColor: const Color(0xFF6C93BD).withValues(alpha: 0.13),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
          side: const BorderSide(color: border),
        ),
      ),
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        titleTextStyle: textTheme.titleMedium,
        subtitleTextStyle: textTheme.bodyMedium,
        iconColor: primary,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        contentTextStyle: TextStyle(
          fontSize: base + 2,
          height: 1.5,
          color: Colors.white,
        ),
        actionTextColor: Colors.white,
        backgroundColor: brand,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: warmSurface,
        titleTextStyle: textTheme.titleLarge,
        contentTextStyle: textTheme.bodyLarge,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      dividerTheme: const DividerThemeData(color: border, thickness: 1),
      chipTheme: ChipThemeData(
        backgroundColor: Colors.white.withValues(alpha: 0.88),
        selectedColor: primary.withValues(alpha: 0.14),
        side: const BorderSide(color: border),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
        labelStyle: textTheme.labelMedium,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    );
  }
}

/// 状态徽章：颜色 + 图标双编码（色盲安全，docs/07 §3）。
class StatusBadge extends StatelessWidget {
  const StatusBadge({super.key, required this.status});

  final DoseStatus status;

  @override
  Widget build(BuildContext context) {
    // Rebuild localized labels, including those constructed in helper methods.
    Localizations.localeOf(context);
    final theme = Theme.of(context);
    final style = switch (status) {
      DoseStatus.taken => (
        AppTheme.okGreen,
        Icons.check_circle,
        tr.appTheme.taken,
      ),
      DoseStatus.missed => (AppTheme.badRed, Icons.error, tr.appTheme.missed),
      DoseStatus.skipped => (
        AppTheme.warnAmber,
        Icons.remove_circle,
        tr.appTheme.skipped,
      ),
      DoseStatus.pending => (
        AppTheme.muted,
        Icons.schedule,
        tr.appTheme.pending,
      ),
    };
    final (color, icon, label) = style;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.16)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 21),
          const SizedBox(width: 6),
          Text(
            label,
            style: theme.textTheme.labelMedium!.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}

/// 日历健康色（绿=全服 黄=有跳过 红=有漏服）。
Color dayHealthColor(DayHealth health) => switch (health) {
  DayHealth.allTaken => AppTheme.okGreen,
  DayHealth.hasSkipped => AppTheme.warnAmber,
  DayHealth.hasMissed => AppTheme.badRed,
  DayHealth.incomplete => const Color(0xFF7892AD),
  DayHealth.none => const Color(0xFFD8E5F0),
};

/// 口语化任务摘要："早上 8 点，降压药 1 片，餐后"。
String taskSummary({
  required String time,
  required String name,
  required double dose,
  required String unit,
  String? meal,
}) {
  final mealText = friendlyMeal(meal);
  return '${friendlyTime(time)}，$name ${friendlyDose(dose, unit)}'
      '${mealText == null ? '' : '，$mealText'}';
}
