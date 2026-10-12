import 'package:care_pill/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../application/controllers/models_controller.dart';
import '../../application/controllers/settings_controller.dart';
import '../../application/providers.dart';
import '../../domain/services/model_selection.dart';
import '../settings/language_picker.dart';
import '../shell/app_shell.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';

/// 首次启动引导（docs/02 F11）：欢迎 → 加模型（可跳过）→ 加第一个药。
class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key, this.initialStep = 0, this.replay = false});

  final int initialStep;
  final bool replay;

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  late int _step;

  @override
  void initState() {
    super.initState();
    _step = widget.initialStep.clamp(0, 2);
    // 引导入口申请通知权限（docs/06 §4：引导页一步申请）。
    Future<void>.delayed(const Duration(seconds: 1), () {
      if (!mounted || _step > 0) {
        return;
      }
      ref.read(reminderGatewayProvider).requestPermissions();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Rebuild localized labels, including those constructed in helper methods.
    Localizations.localeOf(context);
    final theme = Theme.of(context);
    return PopScope(
      canPop: _step == 0,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && _step > 0) _back();
      },
      child: Scaffold(
        appBar: _step > 0 || widget.replay
            ? buildPillPalAppBar(
                title: 'CarePill',
                leading: BackButton(onPressed: _back),
              )
            : null,
        body: SafeArea(
          child: switch (_step) {
            0 => _buildWelcome(theme),
            1 => _buildModelStep(theme),
            _ => _buildMedStep(theme),
          },
        ),
      ),
    );
  }

  void _back() {
    if (_step > 0) {
      setState(() => _step--);
    } else if (widget.replay) {
      popPillPalPage(context, fallbackLocation: '/settings');
    }
  }

  Widget _buildWelcome(ThemeData theme) {
    return _scrollableStep(
      padding: 28,
      child: Column(
        children: [
          const Spacer(),
          const BrandMark(size: 118),
          const SizedBox(height: 24),
          Text('CarePill', style: theme.textTheme.displaySmall),
          const SizedBox(height: 12),
          Text(
            tr.onboarding.welcome,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 20),
          const LanguagePicker(),
          const Spacer(),
          BigPrimaryButton(
            label: tr.onboarding.start,
            icon: Icons.arrow_forward,
            onPressed: () => setState(() => _step = 1),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildModelStep(ThemeData theme) {
    return _scrollableStep(
      padding: 20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _progress(theme, 1),
          const SizedBox(height: 24),
          Text(tr.onboarding.modelTitle, style: theme.textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text(tr.onboarding.modelHint, style: theme.textTheme.bodyLarge),
          const SizedBox(height: 20),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tr.onboarding.requirements,
                    style: theme.textTheme.titleSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    tr.onboarding.requirementsHint,
                    style: TextStyle(height: 1.6),
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          BigPrimaryButton(
            label: tr.onboarding.addModel,
            icon: Icons.smart_toy,
            onPressed: () async {
              final saved = await context.push<bool>(
                '/settings/models/new?returnToOnboarding=1',
              );
              if (mounted && saved == true) {
                setState(() => _step = 2);
              }
            },
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,

            child: TextButton(
              onPressed: () => setState(() => _step = 2),
              child: Text(
                tr.onboarding.skip,
                style: theme.textTheme.titleMedium,
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildMedStep(ThemeData theme) {
    final capability = ref.watch(visionCapabilityProvider).value;
    final hasModel = ref.watch(hasChatModelProvider).value ?? false;
    final canPhoto =
        capability == VisionCapability.native ||
        capability == VisionCapability.fallback;
    return _scrollableStep(
      padding: 20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _progress(theme, 2),
          const SizedBox(height: 24),
          Text(
            tr.onboarding.medicineTitle,
            style: theme.textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            hasModel ? tr.onboarding.modelReady : tr.onboarding.manualHint,
            style: theme.textTheme.bodyLarge,
          ),
          const SizedBox(height: 24),
          BigPrimaryButton(
            label: tr.onboarding.manual,
            icon: Icons.edit,
            onPressed: () async {
              final saved = await context.push<bool>(
                '/medication/new?returnToOnboarding=1',
              );
              if (mounted && saved == true) {
                await _finish();
              }
            },
          ),
          const SizedBox(height: 12),
          BigOutlinedButton(
            label: tr.barcode.entry,
            icon: Icons.qr_code_scanner,
            onPressed: () async {
              final saved = await context.push<bool>(
                '/medication/scan?returnToOnboarding=1',
              );
              if (mounted && saved == true) await _finish();
            },
          ),
          const SizedBox(height: 12),
          BigOutlinedButton(
            label: capability == VisionCapability.fallback
                ? tr.onboarding.photoUncertain
                : canPhoto
                ? tr.onboarding.photo
                : tr.onboarding.photoSetup,
            icon: Icons.camera_alt,
            onPressed: canPhoto
                ? () async {
                    final saved = await context.push<bool>(
                      '/medication/photo?returnToOnboarding=1',
                    );
                    if (mounted && saved == true) {
                      await _finish();
                    }
                  }
                : null,
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,

            child: TextButton(
              onPressed: _finish,
              child: Text(
                tr.onboarding.finish,
                style: theme.textTheme.titleMedium,
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _scrollableStep({required double padding, required Widget child}) {
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: IntrinsicHeight(
            child: Padding(padding: EdgeInsets.all(padding), child: child),
          ),
        ),
      ),
    );
  }

  Future<void> _finish() async {
    if (widget.replay) {
      popPillPalPage(context, fallbackLocation: '/settings');
      return;
    }
    await ref.read(settingsControllerProvider.notifier).setOnboardingDone(true);
    if (mounted) {
      context.go('/today');
    }
  }

  Widget _progress(ThemeData theme, int current) {
    return Row(
      children: [
        const BrandMark(size: 42),
        const SizedBox(width: 10),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              minHeight: 8,
              value: current / 2,
              backgroundColor: AppTheme.primary.withValues(alpha: 0.12),
              valueColor: const AlwaysStoppedAnimation(AppTheme.primary),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Text('$current/2', style: theme.textTheme.labelLarge),
      ],
    );
  }
}
