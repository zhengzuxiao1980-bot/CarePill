import 'dart:async';

import 'package:care_pill/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/controllers/today_controller.dart';
import '../../application/providers.dart';
import '../../core/formatters.dart';
import '../../domain/models/dose_task.dart';
import '../../domain/models/view_models.dart';
import '../../domain/services/speech_service.dart';
import '../shell/app_shell.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';

/// 全屏提醒页（docs/06 §2）。
///
/// 超大字"该吃药了"；三个大按钮：吃了 / 等会儿再提醒 / 今天不吃了。
/// 进入时 TTS 播报 2 遍。
class ReminderFullscreenPage extends ConsumerStatefulWidget {
  const ReminderFullscreenPage({super.key, required this.taskIds});

  final List<String> taskIds;

  @override
  ConsumerState<ReminderFullscreenPage> createState() =>
      _ReminderFullscreenPageState();
}

class _ReminderFullscreenPageState
    extends ConsumerState<ReminderFullscreenPage> {
  List<_ReminderItem>? _items;
  String? _error;
  late final SpeechService _speech;

  @override
  void initState() {
    super.initState();
    _speech = ref.read(speechServiceProvider);
    _load();
  }

  Future<void> _load() async {
    final dose = ref.read(doseServiceProvider);
    final views = await dose.todayViews();
    final byId = {for (final v in views) v.task.id: v};
    final items = <_ReminderItem>[];
    for (final id in widget.taskIds) {
      final view = byId[id];
      if (view != null && (view.task.isPending || view.task.isMissed)) {
        items.add(_ReminderItem(view: view));
      }
    }
    if (!mounted) {
      return;
    }
    setState(() {
      _items = items;
    });
    unawaited(_speak(items));
  }

  Future<void> _speak(List<_ReminderItem> items) async {
    if (items.isEmpty) {
      return;
    }
    final speech = _speech;
    final lines = items
        .map(
          (e) => tr.reminderFullscreen.doseDescription(
            arg1: (friendlyTime(e.view.task.scheduledTime)).toString(),
            arg2: (e.view.medicationName).toString(),
            arg3: (friendlyDose(
              e.view.task.plannedDose,
              e.view.doseUnit,
            )).toString(),
          ),
        )
        .toList();
    final text = tr.reminderFullscreen.announcement(
      arg1: (friendlyTime(items.first.view.task.scheduledTime)).toString(),
      arg2: tr.reminderFullscreen.medicine,
      arg3: (lines.join('；')).toString(),
    );
    final result = await speech.speak(text, owner: SpeechOwner.reminder);
    // 播报 2 遍（docs/06 §2）。
    if (mounted && result.status == PlaybackStatus.completed) {
      await speech.speak(text, owner: SpeechOwner.reminder);
    }
  }

  @override
  void dispose() {
    // 离开页面停止播报。
    _speech.stopSpeak(owner: SpeechOwner.reminder);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Rebuild localized labels, including those constructed in helper methods.
    Localizations.localeOf(context);
    final theme = Theme.of(context);
    final items = _items;
    return PopScope(
      canPop: true,
      child: Scaffold(
        backgroundColor: AppTheme.brand,
        appBar: AppBar(
          backgroundColor: AppTheme.brand,
          surfaceTintColor: Colors.transparent,
          leading: const PillPalBackButton(
            fallbackLocation: '/today',
            color: Colors.white,
          ),
        ),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.notifications_active,
                    color: Colors.white,
                    size: 72,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    tr.reminderFullscreen.title,
                    style: theme.textTheme.displaySmall!.copyWith(
                      color: Colors.white,
                      fontSize: 44,
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (_error != null)
                    Text(
                      _error!,
                      style: theme.textTheme.bodyLarge!.copyWith(
                        color: Colors.white,
                      ),
                    )
                  else if (items == null)
                    const CircularProgressIndicator(color: Colors.white)
                  else if (items.isEmpty)
                    Text(
                      tr.reminderFullscreen.alreadyRecorded,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineSmall!.copyWith(
                        color: Colors.white,
                      ),
                    )
                  else
                    for (final item in items)
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            Text(
                              '${item.view.medicationName} '
                              '${friendlyDose(item.view.task.plannedDose, item.view.doseUnit)}',
                              style: theme.textTheme.headlineSmall,
                            ),
                            Text(
                              '${friendlyTime(item.view.task.scheduledTime)}'
                              '${item.view.meal == null ? '' : '，${friendlyMeal(item.view.meal!.json)}'}',
                              style: theme.textTheme.titleMedium,
                            ),
                          ],
                        ),
                      ),
                  const SizedBox(height: 24),
                  if (items != null && items.isNotEmpty) ...[
                    BigPrimaryButton(
                      label: items.length == 1
                          ? tr.reminderFullscreen.taken
                          : tr.reminderFullscreen.allTaken,
                      icon: Icons.check,
                      color: Colors.white,
                      foregroundColor: AppTheme.brand,
                      onPressed: _takeAll,
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 72,
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white, width: 2),
                        ),
                        onPressed: _snooze,
                        icon: const Icon(Icons.snooze, size: 28),
                        label: Text(
                          tr.reminderFullscreen.snooze,
                          style: theme.textTheme.titleMedium!.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 72,
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white, width: 2),
                        ),
                        onPressed: _skipAll,
                        icon: const Icon(Icons.remove_circle_outline, size: 28),
                        label: Text(
                          tr.reminderFullscreen.skip,
                          style: theme.textTheme.titleMedium!.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _takeAll() async {
    final items = _items ?? const [];
    final notifier = ref.read(todayControllerProvider.notifier);
    final errors = <String>[];
    for (final item in items) {
      final error = await notifier.markTaken(item.view.task.id);
      if (error != null) {
        errors.add(error);
      }
    }
    if (errors.isNotEmpty) {
      if (mounted) {
        UndoBar.show(
          context,
          message: tr.reminderFullscreen.partialFailure(
            arg1: (errors.first).toString(),
          ),
        );
      }
      return;
    }
    ref.invalidate(todayControllerProvider);
    if (mounted) {
      UndoBar.show(
        context,
        message: tr.reminderFullscreen.recorded(
          arg1: (items.length).toString(),
        ),
        onUndo: () async {
          for (final item in items) {
            await ref
                .read(todayControllerProvider.notifier)
                .undo(item.view.task.id);
          }
        },
      );
      popPillPalPage(context, fallbackLocation: '/today');
    }
  }

  Future<void> _snooze() async {
    final items = _items ?? const [];
    await ref
        .read(reminderSchedulerProvider)
        .snooze(
          taskIds: items.map((e) => e.view.task.id).toList(),
          medicationNames: items.map((e) => e.view.medicationName).toList(),
        );
    if (mounted) {
      UndoBar.show(context, message: tr.reminderFullscreen.snoozed);
      popPillPalPage(context, fallbackLocation: '/today');
    }
  }

  Future<void> _skipAll() async {
    final items = _items ?? const [];
    final confirmed = await confirmDangerous(
      context,
      title: tr.reminderFullscreen.skipTitle,
      message: tr.reminderFullscreen.skipMessage,
      confirmLabel: tr.reminderFullscreen.skipConfirm,
    );
    if (!confirmed) {
      return;
    }
    final errors = <String>[];
    for (final item in items) {
      final error = await ref
          .read(todayControllerProvider.notifier)
          .skip(item.view.task.id);
      if (error != null) {
        errors.add(error);
      }
    }
    if (errors.isNotEmpty) {
      if (mounted) {
        UndoBar.show(
          context,
          message: tr.reminderFullscreen.partialFailure(
            arg1: (errors.first).toString(),
          ),
        );
      }
      return;
    }
    if (mounted) {
      popPillPalPage(context, fallbackLocation: '/today');
    }
  }
}

class _ReminderItem {
  const _ReminderItem({required this.view});

  final DoseTaskView view;
}
