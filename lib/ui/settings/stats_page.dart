import 'package:care_pill/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../ai/client/ai_models.dart';
import '../../ai/prompts/app_prompts.dart';
import '../../application/controllers/models_controller.dart';
import '../../application/controllers/stats_controller.dart';
import '../../application/providers.dart';
import '../../core/exceptions.dart';
import '../../core/formatters.dart';
import '../../domain/models/dose_task.dart';
import '../../domain/models/stats.dart';
import '../../domain/services/dose_service.dart';
import '../shell/app_shell.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';

/// 统计页（docs/02 F9：日历热图 + 依从率 + 漏服清单 + AI 周报）。
class StatsPage extends ConsumerWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Rebuild localized labels, including those constructed in helper methods.
    Localizations.localeOf(context);
    final theme = Theme.of(context);
    final state = ref.watch(statsControllerProvider);
    return Scaffold(
      appBar: buildPillPalAppBar(
        title: tr.stats.title,
        backLocation: '/settings',
      ),
      body: state.when(
        loading: () => const LoadingView(),
        error: (e, _) => ErrorView(error: e),
        data: (bundle) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // 依从率大数字。
            SectionCard(
              title: tr.stats.lastWeek,
              child: Column(
                children: [
                  Text(
                    bundle.stats7.expected == 0
                        ? tr.stats.empty
                        : '${(bundle.stats7.rate * 100).round()}%',
                    style: theme.textTheme.displaySmall!.copyWith(
                      color: AppTheme.brand,
                    ),
                  ),
                  Text(
                    bundle.stats7.toFriendlyText(),
                    style: theme.textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
            // 30 天日历。
            SectionCard(
              title: tr.stats.lastMonth,
              child: Column(
                children: [
                  GridView.count(
                    crossAxisCount: 10,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 6,
                    crossAxisSpacing: 6,
                    childAspectRatio: 0.9,
                    children: [
                      for (final entry in bundle.calendar)
                        Tooltip(
                          message: tr.stats.daySummary(
                            arg1: (entry.date.month).toString(),
                            arg2: (entry.date.day).toString(),
                            arg3: (entry.done).toString(),
                            arg4: (entry.total).toString(),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: dayHealthColor(entry.health),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                '${entry.date.day}',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color:
                                      entry.health == DayHealth.none ||
                                          entry.health == DayHealth.hasSkipped
                                      ? Colors.black87
                                      : Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            // 漏服清单。
            _MissedList(),
            const SizedBox(height: 16),
            // AI 周报（P2：给家人看的文字）。
            BigPrimaryButton(
              label: tr.stats.weeklyReport,
              icon: Icons.family_restroom,
              height: 76,
              onPressed: () => _generateReport(context, ref, bundle.stats7),
            ),
            const DisclaimerFooter(),
          ],
        ),
      ),
    );
  }

  Future<void> _generateReport(
    BuildContext context,
    WidgetRef ref,
    AdherenceStats stats,
  ) async {
    final messenger = ScaffoldMessenger.of(context);
    final theme = Theme.of(context);
    final hasModel = await ref.read(hasChatModelProvider.future);
    if (!hasModel) {
      messenger.showSnackBar(SnackBar(content: Text(tr.stats.setupModel)));
      return;
    }
    try {
      final selection = ref.read(modelSelectionProvider);
      final client = ref.read(aiClientProvider);
      final config = await selection.resolveChat();
      if (config == null) {
        throw const AiException(AiErrorCode.notConfigured);
      }
      final result = await client.chat(
        AiChatRequest(
          model: config.modelId,
          messages: [
            AiProtocolMessage(
              role: AiRole.user,
              content: AppPrompts.weeklyReportPrompt(
                statsText: stats.toFriendlyText(),
                nowText: DateTime.now().toIso8601String(),
              ),
            ),
          ],
          maxTokens: 300,
        ),
        config: config,
      );
      final report = result.message.text.trim();
      messenger.showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 8),
          content: Text(report, style: theme.textTheme.bodyLarge),
          action: SnackBarAction(label: tr.stats.close, onPressed: () {}),
        ),
      );
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(friendlyError(e))));
    }
  }
}

class _MissedList extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Rebuild localized labels, including those constructed in helper methods.
    Localizations.localeOf(context);
    // 从日历数据推导漏服清单太绕，直接查任务。
    final dose = ref.watch(doseServiceProvider);
    return FutureBuilder(
      future: _missedTasks(dose),
      builder: (context, snapshot) {
        final tasks = snapshot.data ?? const [];
        if (tasks.isEmpty) {
          return const SizedBox.shrink();
        }
        return SectionCard(
          title: tr.stats.missedTitle,
          child: Column(
            children: [
              for (final (name, line) in tasks)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                  leading: const Icon(Icons.error, color: AppTheme.badRed),
                  title: Text(
                    name,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  subtitle: Text(
                    line,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              Text(
                tr.stats.missedHint,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        );
      },
    );
  }

  Future<List<(String, String)>> _missedTasks(DoseService dose) async {
    final views = <(String, String)>[];
    final now = DateTime.now();
    for (var i = 0; i < 7; i++) {
      final date = now.subtract(Duration(days: i));
      final dayViews = await dose.viewsForDate(date);
      for (final v in dayViews) {
        if (v.task.isMissed) {
          views.add((
            '${friendlyDate(date, now: now)} ${v.medicationName}',
            tr.stats.notTaken(
              arg1: (friendlyTime(v.task.scheduledTime)).toString(),
            ),
          ));
        }
      }
    }
    return views;
  }
}
