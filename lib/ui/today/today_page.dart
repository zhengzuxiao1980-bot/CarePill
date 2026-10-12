import 'package:care_pill/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../application/controllers/today_controller.dart';
import '../../core/formatters.dart';
import '../../domain/models/dose_task.dart';
import '../../domain/models/enums.dart';
import '../../domain/models/view_models.dart';
import '../shell/app_shell.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';

/// 今日页：回答"现在该干什么？"（docs/07 §1）。
///
/// 时间轴：已吃✓ / 待吃大卡片 / 漏吃红标；顶部"下一顿"。
class TodayPage extends ConsumerWidget {
  const TodayPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Rebuild localized labels, including those constructed in helper methods.
    Localizations.localeOf(context);
    final state = ref.watch(todayControllerProvider);
    return Scaffold(
      appBar: buildPillPalAppBar(title: tr.today.title),
      body: state.when(
        loading: () => const LoadingView(),
        error: (e, _) => ErrorView(
          error: e,
          onRetry: () => ref.invalidate(todayControllerProvider),
        ),
        data: (today) => _TodayBody(today: today),
      ),
    );
  }
}

class _TodayBody extends ConsumerWidget {
  const _TodayBody({required this.today});

  final TodayView today;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Rebuild localized labels, including those constructed in helper methods.
    Localizations.localeOf(context);
    final theme = Theme.of(context);
    if (today.tasks.isEmpty) {
      return EmptyState(
        icon: Icons.medication_liquid,
        title: tr.today.emptyTitle,
        hint: tr.today.emptyHint,
        action: BigPrimaryButton(
          label: tr.today.add,
          icon: Icons.add,
          height: 72,
          onPressed: () => context.push('/medication/new'),
        ),
      );
    }
    final nextUp = today.nextUp();
    return ListView(
      padding: const EdgeInsets.only(bottom: 32),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(tr.today.today, style: theme.textTheme.headlineSmall),
              const SizedBox(height: 4),
              Text(tr.today.tagline, style: theme.textTheme.bodyMedium),
            ],
          ),
        ),
        // 顶部：下一顿。
        if (nextUp != null)
          Container(
            margin: const EdgeInsets.fromLTRB(16, 10, 16, 6),
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
            decoration: BoxDecoration(
              gradient: AppTheme.brandGradient,
              borderRadius: BorderRadius.circular(24),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x321976F3),
                  blurRadius: 18,
                  offset: Offset(0, 9),
                ),
              ],
            ),
            child: Row(
              children: [
                const BrandMark(size: 66),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tr.today.nextDose,
                        style: theme.textTheme.labelLarge!.copyWith(
                          color: Colors.white.withValues(alpha: 0.82),
                        ),
                      ),
                      Text(
                        friendlyTime(nextUp.task.scheduledTime),
                        style: theme.textTheme.headlineSmall!.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '${nextUp.medicationName} '
                        '${friendlyDose(nextUp.task.plannedDose, nextUp.doseUnit)}'
                        '${nextUp.meal == null ? '' : '，${friendlyMeal(nextUp.meal!.json)}'}',
                        style: theme.textTheme.bodyLarge!.copyWith(
                          color: Colors.white.withValues(alpha: 0.92),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        // 漏服横条（docs/06 §3：不只依赖通知）。
        if (today.missedCount > 0)
          Container(
            margin: const EdgeInsets.fromLTRB(16, 8, 16, 6),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppTheme.badRed.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: AppTheme.badRed.withValues(alpha: 0.16),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.error, color: AppTheme.badRed, size: 30),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    tr.today.missedHint(arg1: (today.missedCount).toString()),
                    style: theme.textTheme.bodyLarge!.copyWith(
                      color: AppTheme.badRed,
                    ),
                  ),
                ),
              ],
            ),
          ),
        const SizedBox(height: 8),
        for (final view in today.tasks)
          _TaskCard(key: ValueKey(view.task.id), view: view),
      ],
    );
  }
}

class _TaskCard extends ConsumerWidget {
  const _TaskCard({super.key, required this.view});

  final DoseTaskView view;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Rebuild localized labels, including those constructed in helper methods.
    Localizations.localeOf(context);
    final theme = Theme.of(context);
    final task = view.task;
    final now = DateTime.now();
    final isDue =
        task.isPending &&
        task.scheduledDateTime.isBefore(now.add(const Duration(minutes: 1)));
    final mealText = view.meal == null
        ? ''
        : '，${friendlyMeal(view.meal!.json)}';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 17, 18, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${friendlyTime(task.scheduledTime)} · ${view.medicationName}',
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 10),
                StatusBadge(status: task.status),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              tr.today.doseSummary(
                arg1: (friendlyDose(
                  task.plannedDose,
                  view.doseUnit,
                )).toString(),
                arg2: (mealText).toString(),
                arg3: (view.asNeeded ? tr.today.asNeededSuffix : '').toString(),
              ),
              style: theme.textTheme.bodyLarge,
            ),
            if (task.isTaken) ...[
              const SizedBox(height: 4),
              Text(
                _takenLine(task, now),
                style: theme.textTheme.bodyMedium!.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ],
            if (task.isMissed) ...[
              const SizedBox(height: 4),
              Text(
                tr.today.missedDoseHint,
                style: theme.textTheme.bodyMedium!.copyWith(
                  color: AppTheme.badRed,
                ),
              ),
            ],
            const SizedBox(height: 12),
            if (task.isPending && isDue)
              BigPrimaryButton(
                label: tr.today.taken,
                icon: Icons.check,
                onPressed: () => _markTaken(context, ref),
              )
            else if (task.isPending)
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  BigOutlinedButton(
                    label: tr.today.taken,
                    icon: Icons.check,
                    onPressed: () => _markTaken(context, ref),
                  ),
                  const SizedBox(height: 12),
                  BigOutlinedButton(
                    label: tr.today.skip,
                    icon: Icons.remove_circle_outline,
                    onPressed: () => _skip(context, ref),
                  ),
                ],
              )
            else if (task.isMissed)
              BigPrimaryButton(
                label: tr.today.catchUp,
                icon: Icons.restore,
                color: AppTheme.warnAmber,
                height: 72,
                onPressed: () => _markTaken(context, ref, catchUp: true),
              )
            else if (task.isTaken || task.isSkipped)
              SizedBox(
                height: 56,
                width: double.infinity,
                child: TextButton.icon(
                  onPressed: () => _undo(context, ref),
                  icon: const Icon(Icons.undo, size: 24),
                  label: Text(tr.today.undo, style: theme.textTheme.bodyLarge),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _takenLine(DoseTask task, DateTime now) {
    final takenAt = task.takenAt;
    if (takenAt == null) {
      return '';
    }
    final at = DateTime.fromMillisecondsSinceEpoch(takenAt);
    final sourceText = switch (task.markSource) {
      MarkSource.catchUp => tr.today.catchUpSource,
      MarkSource.ai => tr.today.aiSource,
      MarkSource.voice => tr.today.voiceSource,
      _ => '',
    };
    return tr.today.recordedAt(
      arg1: (friendlyDate(at, now: now)).toString(),
      arg2: (friendlyTime(at.hhMm)).toString(),
      arg3: (sourceText.isEmpty ? '' : '（$sourceText）').toString(),
    );
  }

  Future<void> _markTaken(
    BuildContext context,
    WidgetRef ref, {
    bool catchUp = false,
  }) async {
    final error = await ref
        .read(todayControllerProvider.notifier)
        .markTaken(
          view.task.id,
          source: catchUp ? MarkSource.catchUp : MarkSource.tap,
        );
    if (context.mounted) {
      if (error != null) {
        UndoBar.show(context, message: friendlyError(error));
        return;
      }
      final mealText = view.meal == null
          ? ''
          : '，${friendlyMeal(view.meal!.json)}';
      UndoBar.show(
        context,
        message: tr.today.recorded(
          arg1: (view.medicationName).toString(),
          arg2: (friendlyTime(view.task.scheduledTime)).toString(),
          arg3: (friendlyDose(view.task.plannedDose, view.doseUnit)).toString(),
          arg4: (mealText).toString(),
        ),
        onUndo: () =>
            ref.read(todayControllerProvider.notifier).undo(view.task.id),
      );
    }
  }

  Future<void> _skip(BuildContext context, WidgetRef ref) async {
    final confirmed = await confirmDangerous(
      context,
      title: tr.today.skipTitle,
      message: tr.today.skipMessage(
        arg1: (view.medicationName).toString(),
        arg2: (friendlyTime(view.task.scheduledTime)).toString(),
      ),
      confirmLabel: tr.today.skip,
    );
    if (!confirmed) {
      return;
    }
    final error = await ref
        .read(todayControllerProvider.notifier)
        .skip(view.task.id);
    if (context.mounted && error != null) {
      UndoBar.show(context, message: friendlyError(error));
    }
  }

  Future<void> _undo(BuildContext context, WidgetRef ref) async {
    final error = await ref
        .read(todayControllerProvider.notifier)
        .undo(view.task.id);
    if (context.mounted) {
      UndoBar.show(
        context,
        message: error == null ? tr.today.undone : friendlyError(error),
      );
    }
  }
}
