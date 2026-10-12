import 'dart:io';

import 'package:care_pill/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../application/controllers/today_controller.dart';
import '../../application/providers.dart';
import '../../core/formatters.dart';
import '../../domain/models/enums.dart';
import '../../domain/models/medication_draft.dart';
import '../../domain/models/schedule.dart';
import '../shell/app_shell.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';

/// 草稿确认页（docs/07 §2：左原图/右字段，逐项可改；存疑高亮"请核对"）。
///
/// docs/03 §6：一切识别结果只是草稿，确认页是强制步骤，不可跳过。
class DraftConfirmPage extends ConsumerStatefulWidget {
  const DraftConfirmPage({
    super.key,
    required this.draftId,
    this.returnToOnboarding = false,
  });

  final String draftId;
  final bool returnToOnboarding;

  @override
  ConsumerState<DraftConfirmPage> createState() => _DraftConfirmPageState();
}

class _DraftConfirmPageState extends ConsumerState<DraftConfirmPage> {
  PreferredSizeWidget _appBar() => buildPillPalAppBar(
    title: tr.draftConfirm.title,
    backLocation: widget.returnToOnboarding ? '/onboarding?step=2' : '/cabinet',
  );

  MedicationDraft? _draft;
  bool _loading = true;

  late final TextEditingController _name;
  late final TextEditingController _spec;
  late final TextEditingController _unit;
  late final TextEditingController _usage;
  MedicationForm _form = MedicationForm.tablet;
  List<TimeSlot> _times = [];
  String? _photoPath;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController();
    _spec = TextEditingController();
    _unit = TextEditingController(text: tr.units.tablet);
    _usage = TextEditingController();
    _load();
  }

  @override
  void dispose() {
    _name.dispose();
    _spec.dispose();
    _unit.dispose();
    _usage.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final draft = await ref.read(draftRepositoryProvider).get(widget.draftId);
    if (!mounted) {
      return;
    }
    if (draft == null) {
      setState(() {
        _loading = false;
      });
      return;
    }
    final p = draft.payload;
    setState(() {
      _draft = draft;
      _loading = false;
      _name.text = p.name ?? '';
      _spec.text = p.spec ?? '';
      _unit.text = p.doseUnit ?? tr.units.tablet;
      _usage.text = p.usageText ?? '';
      _form = p.form ?? MedicationForm.tablet;
      _times = List.of(p.times);
      _photoPath = draft.photoPath;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Rebuild localized labels, including those constructed in helper methods.
    Localizations.localeOf(context);
    final theme = Theme.of(context);
    if (_loading) {
      return Scaffold(appBar: _appBar(), body: const LoadingView());
    }
    if (_draft == null) {
      return Scaffold(
        appBar: _appBar(),
        body: const ErrorView(error: 'draft missing'),
      );
    }
    final uncertain = _draft!.payload.uncertain;
    bool isUncertain(String field) => uncertain.contains(field);

    return Scaffold(
      appBar: _appBar(),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: BigPrimaryButton(
            label: tr.draftConfirm.save,
            icon: Icons.check,
            onPressed: _save,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (_photoPath != null && File(_photoPath!).existsSync())
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 220),
                child: Image.file(File(_photoPath!), fit: BoxFit.cover),
              ),
            ),
          const SizedBox(height: 12),
          if (isUncertain('name'))
            _uncertainBanner(theme, tr.draftConfirm.uncertainName),
          PillPalField(
            label: tr.draftConfirm.name,
            child: TextField(
              controller: _name,
              style: theme.textTheme.titleMedium,
            ),
          ),
          const SizedBox(height: 14),
          Text(tr.draftConfirm.form, style: theme.textTheme.titleSmall),
          const SizedBox(height: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final f in MedicationForm.values)
                PillPalChoice(
                  label: f.label,
                  selected: _form == f,
                  onSelected: (_) => setState(() => _form = f),
                ),
            ],
          ),
          const SizedBox(height: 14),
          PillPalField(
            label: tr.draftConfirm.unit,
            child: TextField(
              controller: _unit,
              style: theme.textTheme.bodyLarge,
            ),
          ),
          const SizedBox(height: 14),
          PillPalField(
            label: tr.draftConfirm.spec,
            child: TextField(
              controller: _spec,
              style: theme.textTheme.bodyLarge,
            ),
          ),
          const SizedBox(height: 14),
          if (isUncertain('times'))
            _uncertainBanner(theme, tr.draftConfirm.uncertainTime),
          Text(tr.draftConfirm.times, style: theme.textTheme.titleSmall),
          const SizedBox(height: 8),
          if (_times.isEmpty)
            Text(tr.draftConfirm.noTimes, style: theme.textTheme.bodyLarge)
          else
            for (var i = 0; i < _times.length; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: PillPalField(
                  label:
                      '${friendlyTime(_times[i].time)} '
                      '${friendlyDose(_times[i].effectiveDose, _unit.text)}'
                      '${_times[i].meal == null ? '' : '，${_times[i].meal!.label}'}',
                  child: BigOutlinedButton(
                    label: tr.draftConfirm.removeTime,
                    icon: Icons.delete_outline,
                    onPressed: () => setState(() => _times.removeAt(i)),
                  ),
                ),
              ),
          const SizedBox(height: 14),
          if (_usage.text.isNotEmpty)
            SectionCard(
              title: tr.draftConfirm.originalText,
              child: Text(_usage.text, style: theme.textTheme.bodyLarge),
            ),
          const SizedBox(height: 12),
          Text(tr.draftConfirm.reviewHint, style: theme.textTheme.bodyMedium),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _uncertainBanner(ThemeData theme, String text) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppTheme.warnAmber.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: AppTheme.warnAmber, size: 26),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodyLarge!.copyWith(
                color: AppTheme.warnAmber,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _save() async {
    if (_draft == null) {
      return;
    }
    if (_name.text.trim().isEmpty) {
      UndoBar.show(context, message: tr.draftConfirm.missingName);
      return;
    }
    final withSchedule = _times.isNotEmpty;
    final overrides = MedicationDraftPayload(
      name: _name.text.trim(),
      form: _form,
      spec: _spec.text.trim().isEmpty ? null : _spec.text.trim(),
      doseUnit: _unit.text.trim().isEmpty ? tr.units.tablet : _unit.text.trim(),
      usageText: _usage.text.trim().isEmpty ? null : _usage.text.trim(),
      times: _times,
      frequencyHint: _draft!.payload.frequencyHint,
      notes: _draft!.payload.notes,
      uncertain: _draft!.payload.uncertain,
    );
    try {
      final med = await ref
          .read(medicationServiceProvider)
          .createFromDraft(
            _draft!,
            overrides: overrides,
            withSchedule: withSchedule,
          );
      await ref
          .read(draftRepositoryProvider)
          .setStatus(_draft!.id, DraftStatus.confirmed);
      await ref.read(reminderSchedulerProvider).refreshAfterDataChange();
      ref.invalidate(todayControllerProvider);
      ref.invalidate(cabinetControllerProvider);
      if (mounted) {
        UndoBar.show(
          context,
          message: withSchedule
              ? tr.draftConfirm.savedScheduled
              : tr.draftConfirm.savedUnscheduled,
        );
        if (widget.returnToOnboarding) {
          popPillPalPage(
            context,
            fallbackLocation: '/onboarding?step=2',
            result: true,
          );
        } else {
          context.pushReplacement('/medication/${med.id}');
        }
      }
    } catch (e) {
      if (mounted) {
        UndoBar.show(context, message: friendlyError(e));
      }
    }
  }
}
