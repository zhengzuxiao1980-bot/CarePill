import 'dart:math' as math;

import 'package:care_pill/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/providers.dart';
import '../../core/app_constants.dart';
import '../../core/exceptions.dart';
import '../theme/app_theme.dart';

/// 全局浅蓝到暖白的品牌背景，圆弧装饰只做低对比度层次，不干扰文字。
class PillPalBackdrop extends StatelessWidget {
  const PillPalBackdrop({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    // Rebuild localized labels, including those constructed in helper methods.
    Localizations.localeOf(context);
    return Stack(
      fit: StackFit.expand,
      children: [
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFEAF9FF), Color(0xFFF7FBFF), Color(0xFFFFFDF4)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [0, 0.52, 1],
            ),
          ),
        ),
        Positioned(
          left: -110,
          top: -120,
          child: Container(
            width: 340,
            height: 340,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  const Color(0xFF93E3F3).withValues(alpha: 0.28),
                  const Color(0xFF93E3F3).withValues(alpha: 0),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          right: -130,
          top: -100,
          child: Container(
            width: 360,
            height: 360,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  const Color(0xFFFFE7AE).withValues(alpha: 0.2),
                  const Color(0xFFFFE7AE).withValues(alpha: 0),
                ],
              ),
            ),
          ),
        ),
        const Positioned.fill(
          child: IgnorePointer(
            child: CustomPaint(painter: _BackdropArcPainter()),
          ),
        ),
        child,
      ],
    );
  }
}

/// CarePill brand artwork shared with the mobile launch icons.
class BrandMark extends StatelessWidget {
  const BrandMark({super.key, this.size = 72});
  final double size;

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(size * 0.22),
    child: Image.asset(
      'assets/brand/icon.png',
      width: size,
      height: size,
      fit: BoxFit.contain,
      excludeFromSemantics: true,
    ),
  );
}

/// 品牌化区块卡片，供设置和子页面统一使用。
class PillPalSectionCard extends StatelessWidget {
  const PillPalSectionCard({
    super.key,
    required this.title,
    required this.child,
    this.action,
    this.icon,
  });

  final String title;
  final Widget child;
  final Widget? action;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    // Rebuild localized labels, including those constructed in helper methods.
    Localizations.localeOf(context);
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (icon != null) ...[
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: AppTheme.primary.withValues(alpha: 0.11),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(icon, color: AppTheme.primary, size: 24),
                  ),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: Text(title, style: theme.textTheme.titleMedium),
                ),
                ?action,
              ],
            ),
            const SizedBox(height: 14),
            child,
          ],
        ),
      ),
    );
  }
}

/// 把异常翻译成口语文案（docs/04 §10 翻译原则、docs/07 §5 文案）。
/// UI 层是唯一做这件事的地方。
String friendlyError(Object error) {
  if (error is AppException) {
    return switch (error) {
      NetworkException(:final kind) => switch (kind) {
        NetworkErrorKind.timeout => tr.common.timeout,
        _ => tr.common.networkError,
      },
      AiException(:final code) => switch (code) {
        AiErrorCode.notConfigured => tr.common.modelMissing,
        AiErrorCode.capabilityMissing => tr.common.capabilityMissing,
        AiErrorCode.protocol => tr.common.modelError,
        AiErrorCode.parse => tr.common.parseError,
        AiErrorCode.rateLimited => tr.common.rateLimited,
        AiErrorCode.authentication => tr.agentV2.authFailed,
        AiErrorCode.contextLength => tr.agentV2.contextTooLong,
      },
      ValidationException() => tr.common.validationError,
      DatabaseException() => tr.common.databaseError,
    };
  }
  return tr.common.unknownError;
}

/// 主操作大按钮（≥96dp 高，docs/07 §3）。
class BigPrimaryButton extends StatelessWidget {
  const BigPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.color,
    this.foregroundColor,
    this.height = kPrimaryButtonHeight,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color? color;
  final Color? foregroundColor;

  /// 最小高度；长文案随字号自然撑高。
  final double height;

  @override
  Widget build(BuildContext context) {
    // Rebuild localized labels, including those constructed in helper methods.
    Localizations.localeOf(context);
    final theme = Theme.of(context);
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: icon == null ? const SizedBox.shrink() : Icon(icon, size: 32),
        label: Text(label),
        // 排版交给按钮样式，文字和图标继承启用 / 禁用态的前景色。
        style: ElevatedButton.styleFrom(
          minimumSize: Size(0, height),
          backgroundColor: color ?? AppTheme.brand,
          foregroundColor: foregroundColor,
          textStyle: theme.textTheme.labelLarge!.copyWith(fontSize: 26),
        ),
      ),
    );
  }
}

/// 次要大按钮。
class BigOutlinedButton extends StatelessWidget {
  const BigOutlinedButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    // Rebuild localized labels, including those constructed in helper methods.
    Localizations.localeOf(context);
    final theme = Theme.of(context);
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: icon == null ? const SizedBox.shrink() : Icon(icon, size: 26),
        label: Text(label),
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(0, 72),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          textStyle: theme.textTheme.titleMedium,
        ),
      ),
    );
  }
}

/// 字段始终上文下控件，不随字号或屏幕宽度切换排列方式。
class PillPalField extends StatelessWidget {
  const PillPalField({
    super.key,
    required this.label,
    required this.child,
    this.description,
  });

  final String label;
  final String? description;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    // Rebuild localized labels, including those constructed in helper methods.
    Localizations.localeOf(context);
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(label, style: theme.textTheme.bodyLarge),
        if (description != null) ...[
          const SizedBox(height: 6),
          Text(description!, style: theme.textTheme.bodyMedium),
        ],
        const SizedBox(height: 12),
        child,
      ],
    );
  }
}

/// 开关跟在完整的名称和说明下方。
class PillPalSwitchField extends StatelessWidget {
  const PillPalSwitchField({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.description,
  });

  final String label;
  final String? description;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    // Rebuild localized labels, including those constructed in helper methods.
    Localizations.localeOf(context);
    return PillPalField(
      label: label,
      description: description,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Semantics(
          label: label,
          child: Switch(value: value, onChanged: onChanged),
        ),
      ),
    );
  }
}

/// 一个选项占一整行；同组选项用 Column 排列，避免不规则折行。
class PillPalChoice extends StatelessWidget {
  const PillPalChoice({
    super.key,
    required this.label,
    required this.selected,
    required this.onSelected,
    this.multiSelect = false,
  });

  final String label;
  final bool selected;
  final ValueChanged<bool> onSelected;
  final bool multiSelect;

  @override
  Widget build(BuildContext context) {
    // Rebuild localized labels, including those constructed in helper methods.
    Localizations.localeOf(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Semantics(
        selected: selected,
        child: SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () => onSelected(!selected),
            icon: Icon(
              multiSelect
                  ? (selected ? Icons.check_box : Icons.check_box_outline_blank)
                  : (selected
                        ? Icons.radio_button_checked
                        : Icons.radio_button_off),
            ),
            label: Text(label),
            style: OutlinedButton.styleFrom(
              alignment: Alignment.centerLeft,
              minimumSize: const Size(0, 64),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              backgroundColor: selected
                  ? AppTheme.primary.withValues(alpha: 0.12)
                  : Colors.white,
              side: BorderSide(
                color: selected ? AppTheme.primary : AppTheme.border,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// 数值和单位作为一个完整控件，字段名称始终放在控件上方。
class PillPalStepper extends StatelessWidget {
  const PillPalStepper({
    super.key,
    required this.label,
    required this.value,
    required this.onDecrease,
    required this.onIncrease,
  });

  final String label;
  final String value;
  final VoidCallback? onDecrease;
  final VoidCallback? onIncrease;

  @override
  Widget build(BuildContext context) {
    // Rebuild localized labels, including those constructed in helper methods.
    Localizations.localeOf(context);
    return Row(
      children: [
        IconButton(
          tooltip: tr.common.decrease(arg1: (label).toString()),
          constraints: const BoxConstraints(minWidth: 64, minHeight: 64),
          onPressed: onDecrease,
          icon: const Icon(Icons.remove_circle_outline, size: 32),
        ),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        IconButton(
          tooltip: tr.common.increase(arg1: (label).toString()),
          constraints: const BoxConstraints(minWidth: 64, minHeight: 64),
          onPressed: onIncrease,
          icon: const Icon(Icons.add_circle_outline, size: 32),
        ),
      ],
    );
  }
}

/// 区块卡片（一屏一件事）。
class SectionCard extends StatelessWidget {
  const SectionCard({
    super.key,
    required this.title,
    required this.child,
    this.action,
  });

  final String title;
  final Widget child;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    // Rebuild localized labels, including those constructed in helper methods.
    Localizations.localeOf(context);
    return PillPalSectionCard(title: title, action: action, child: child);
  }
}

/// AI 免责脚注（docs/03 §8：脚注常驻但低调）。
class DisclaimerFooter extends StatelessWidget {
  const DisclaimerFooter({super.key});

  @override
  Widget build(BuildContext context) {
    // Rebuild localized labels, including those constructed in helper methods.
    Localizations.localeOf(context);
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Text(
        tr.ai.disclaimer,
        style: theme.textTheme.bodySmall!.copyWith(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.55),
        ),
      ),
    );
  }
}

/// 空态（引导下一步做什么）。
class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.hint,
    this.action,
  });

  final IconData icon;
  final String title;
  final String? hint;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    // Rebuild localized labels, including those constructed in helper methods.
    Localizations.localeOf(context);
    final theme = Theme.of(context);
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 72, color: theme.colorScheme.primary),
              const SizedBox(height: 16),
              Text(title, style: theme.textTheme.titleLarge),
              if (hint != null) ...[
                const SizedBox(height: 8),
                Text(
                  hint!,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium,
                ),
              ],
              if (action != null) ...[const SizedBox(height: 24), action!],
            ],
          ),
        ),
      ),
    );
  }
}

/// 加载中。
class LoadingView extends StatelessWidget {
  const LoadingView({super.key, this.label});

  final String? label;

  @override
  Widget build(BuildContext context) {
    // Rebuild localized labels, including those constructed in helper methods.
    Localizations.localeOf(context);
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(strokeWidth: 4),
          const SizedBox(height: 16),
          Text(label ?? tr.common.loading, style: theme.textTheme.bodyLarge),
        ],
      ),
    );
  }
}

/// 错误视图（口语文案 + 重试）。
class ErrorView extends StatelessWidget {
  const ErrorView({super.key, required this.error, this.onRetry});

  final Object? error;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    // Rebuild localized labels, including those constructed in helper methods.
    Localizations.localeOf(context);
    final theme = Theme.of(context);
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.cloud_off, size: 64, color: AppTheme.warnAmber),
              const SizedBox(height: 16),
              Text(
                friendlyError(error ?? 'unknown'),
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge,
              ),
              if (onRetry != null) ...[
                const SizedBox(height: 16),
                BigOutlinedButton(
                  label: tr.common.retry,
                  icon: Icons.refresh,
                  onPressed: onRetry,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// 可撤销确认条（docs/03 §4 写操作回显）。
class UndoBar {
  UndoBar._();

  static void show(
    BuildContext context, {
    required String message,
    VoidCallback? onUndo,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 5),
        content: Text(message),
        action: onUndo == null
            ? null
            : SnackBarAction(label: tr.common.undo, onPressed: onUndo),
      ),
    );
  }
}

/// 破坏性操作二次确认（docs/07 §3 反馈规范）。
Future<bool> confirmDangerous(
  BuildContext context, {
  required String title,
  required String message,
  String? confirmLabel,
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(tr.common.cancel),
        ),
        FilledButton(
          style: FilledButton.styleFrom(backgroundColor: AppTheme.badRed),
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(confirmLabel ?? tr.common.confirm),
        ),
      ],
    ),
  );
  return result ?? false;
}

/// 全局"字"按钮（docs/07 §1：任意页面右上角三档字号切换）。
class FontSizeButton extends ConsumerWidget {
  const FontSizeButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Rebuild localized labels, including those constructed in helper methods.
    Localizations.localeOf(context);
    final tier = ref.watch(fontTierProvider);
    return IconButton(
      tooltip: tr.common.fontSize,
      onPressed: () => ref.read(fontTierProvider.notifier).cycle(),
      icon: Badge(
        isLabelVisible: true,
        label: Text(switch (tier) {
          0 => tr.common.standardBadge,
          2 => tr.common.extraLargeBadge,
          _ => tr.common.largeBadge,
        }, style: const TextStyle(fontSize: 12)),
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.72),
            shape: BoxShape.circle,
            border: Border.all(color: AppTheme.border),
          ),
          child: const Icon(Icons.format_size, size: 25),
        ),
      ),
    );
  }
}

class _BackdropArcPainter extends CustomPainter {
  const _BackdropArcPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.1
      ..color = const Color(0xFF6C9DBB).withValues(alpha: 0.14);
    canvas.drawArc(
      Rect.fromCircle(
        center: Offset(size.width * 0.1, size.height * 1.03),
        radius: size.width * 0.34,
      ),
      math.pi * 1.06,
      math.pi * 0.84,
      false,
      paint,
    );
    canvas.drawArc(
      Rect.fromCircle(
        center: Offset(size.width * 0.88, size.height * 0.03),
        radius: size.width * 0.29,
      ),
      math.pi * 0.1,
      math.pi * 0.78,
      false,
      paint,
    );
    canvas.drawArc(
      Rect.fromCircle(
        center: Offset(size.width * 0.5, -size.height * 0.18),
        radius: size.width * 0.42,
      ),
      math.pi * 0.16,
      math.pi * 0.78,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
