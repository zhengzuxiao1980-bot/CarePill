import 'package:care_pill/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../application/controllers/today_controller.dart';
import '../../application/providers.dart';
import '../../core/formatters.dart';
import '../../domain/models/enums.dart';
import '../../domain/models/medication.dart';
import '../../domain/models/schedule.dart';
import '../shell/app_shell.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';

/// 药品详情页（docs/07 §2）：信息 + 计划列表 + 操作（暂停/编辑/停用）。
class MedicationDetailPage extends ConsumerStatefulWidget {
  const MedicationDetailPage({super.key, required this.medicationId});

  final String medicationId;

  @override
  ConsumerState<MedicationDetailPage> createState() =>
      _MedicationDetailPageState();
}

class _MedicationDetailPageState extends ConsumerState<MedicationDetailPage> {
  Future<(Medication, List<MedicationSchedule>)>? _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<(Medication, List<MedicationSchedule>)> _load() async {
    final service = ref.read(medicationServiceProvider);
    final detail = await service.detail(widget.medicationId);
    if (detail == null) {
      throw StateError(tr.medicationDetail.notFound);
    }
    return detail;
  }

  void _reload() {
    setState(() {
      _future = _load();
    });
    ref.invalidate(cabinetControllerProvider);
    ref.invalidate(todayControllerProvider);
  }

  @override
  Widget build(BuildContext context) {
    // Rebuild localized labels, including those constructed in helper methods.
    Localizations.localeOf(context);
    return Scaffold(
      appBar: buildPillPalAppBar(
        title: tr.medicationDetail.title,
        backLocation: '/cabinet',
      ),
      body: FutureBuilder<(Medication, List<MedicationSchedule>)>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const LoadingView();
          }
          if (snapshot.hasError) {
            return ErrorView(error: snapshot.error);
          }
          final (med, schedules) = snapshot.data!;
          return _buildBody(context, med, schedules);
        },
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    Medication med,
    List<MedicationSchedule> schedules,
  ) {
    final theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.only(bottom: 40),
      children: [
        SectionCard(
          title: med.name,
          action: med.status == MedicationStatus.active
              ? null
              : Text(
                  med.status.label,
                  style: theme.textTheme.titleSmall!.copyWith(
                    color: AppTheme.warnAmber,
                  ),
                ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _infoLine(theme, tr.medicationDetail.form, med.form.label),
              if (med.spec != null)
                _infoLine(theme, tr.medicationDetail.spec, med.spec!),
              _infoLine(
                theme,
                tr.medicationDetail.perDose,
                friendlyUnit(med.doseUnit),
              ),
              if (med.notes != null && med.notes!.isNotEmpty)
                _infoLine(theme, tr.medicationDetail.notes, med.notes!),
              if (med.source == MedicationSource.aiPhoto)
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    tr.medicationDetail.photoHint,
                    style: theme.textTheme.bodyMedium!.copyWith(
                      color: AppTheme.warnAmber,
                    ),
                  ),
                ),
            ],
          ),
        ),
        SectionCard(
          title: tr.medicationDetail.times,
          child: schedules.isEmpty
              ? Text(
                  tr.medicationDetail.noSchedule,
                  style: theme.textTheme.bodyLarge,
                )
              : Column(
                  children: [
                    for (final s in schedules)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              s.times.isEmpty
                                  ? s.frequencyType.label
                                  : '${s.frequencyType.label} · '
                                        '${s.times.map((t) => friendlyTime(t.time)).join('、')}',
                              style: theme.textTheme.titleSmall,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              s.status.label,
                              style: theme.textTheme.bodyMedium!.copyWith(
                                color: s.status == ScheduleStatus.active
                                    ? AppTheme.okGreen
                                    : AppTheme.warnAmber,
                              ),
                            ),
                            const SizedBox(height: 12),
                            BigOutlinedButton(
                              onPressed: () => _toggleSchedule(s),
                              label: s.status == ScheduleStatus.active
                                  ? tr.medicationDetail.pause
                                  : tr.medicationDetail.resume,
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              BigPrimaryButton(
                label: tr.medicationDetail.edit,
                icon: Icons.edit,
                height: 72,
                onPressed: () async {
                  await context.push('/medication/${med.id}/edit');
                  _reload();
                },
              ),
              const SizedBox(height: 12),
              BigOutlinedButton(
                label: med.status == MedicationStatus.active
                    ? tr.medicationDetail.archive
                    : tr.medicationDetail.reactivate,
                icon: med.status == MedicationStatus.active
                    ? Icons.archive
                    : Icons.unarchive,
                onPressed: () => _toggleArchive(med),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _infoLine(ThemeData theme, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: PillPalField(
        label: label,
        child: Text(value, style: theme.textTheme.bodyLarge),
      ),
    );
  }

  /// 计划暂停 / 恢复（docs/02 F2：住院、外出时）。
  Future<void> _toggleSchedule(MedicationSchedule s) async {
    final next = s.status == ScheduleStatus.active
        ? ScheduleStatus.paused
        : ScheduleStatus.active;
    await ref.read(medicationServiceProvider).setScheduleStatus(s.id, next);
    await ref.read(reminderSchedulerProvider).refreshAfterDataChange();
    _reload();
    if (mounted) {
      UndoBar.show(
        context,
        message: next == ScheduleStatus.active
            ? tr.medicationDetail.resumed
            : tr.medicationDetail.paused,
      );
    }
  }

  Future<void> _toggleArchive(Medication med) async {
    if (med.status == MedicationStatus.active) {
      final ok = await confirmDangerous(
        context,
        title: tr.medicationDetail.archiveTitle(arg1: (med.name).toString()),
        message: tr.medicationDetail.archiveMessage,
        confirmLabel: tr.medicationDetail.archiveConfirm,
      );
      if (!ok) {
        return;
      }
      await ref.read(medicationServiceProvider).archive(med.id);
      await ref.read(reminderSchedulerProvider).refreshAfterDataChange();
    } else {
      await ref.read(medicationServiceProvider).restore(med.id);
      await ref.read(reminderSchedulerProvider).refreshAfterDataChange();
    }
    _reload();
    if (mounted) {
      UndoBar.show(context, message: tr.medicationDetail.done);
    }
  }
}
