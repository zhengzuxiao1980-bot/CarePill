import 'package:care_pill/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/controllers/today_controller.dart';
import '../../application/providers.dart';
import '../../core/formatters.dart';
import '../../domain/models/enums.dart';
import '../../domain/models/medication.dart';
import '../../domain/models/medication_barcode.dart';
import '../../domain/models/schedule.dart';
import '../../domain/services/medication_service.dart';
import '../shell/app_shell.dart';
import '../widgets/common.dart';

/// 加药·手动 分步表单（docs/07 §2：名称→剂型剂量→什么时候吃→确认，一步一屏）。
class MedicationFormPage extends ConsumerStatefulWidget {
  const MedicationFormPage({
    super.key,
    this.editId,
    this.barcodeMedicine,
    this.returnToOnboarding = false,
  });

  /// 编辑已有药品。
  final String? editId;
  final BarcodeMedication? barcodeMedicine;
  final bool returnToOnboarding;

  @override
  ConsumerState<MedicationFormPage> createState() => _MedicationFormPageState();
}

class _MedicationFormPageState extends ConsumerState<MedicationFormPage> {
  String get _backLocation => widget.returnToOnboarding
      ? '/onboarding?step=2'
      : widget.editId == null
      ? '/cabinet'
      : '/medication/${widget.editId}';

  int _step = 0;
  bool _saving = false;
  bool _loaded = false;

  // 第一步：名称与基本信息。
  final _nameController = TextEditingController();
  final _specController = TextEditingController();
  final _notesController = TextEditingController();
  MedicationForm _form = MedicationForm.tablet;
  final _unitController = TextEditingController(text: tr.units.tablet);

  // 第二步：什么时候吃。
  FrequencyType _frequency = FrequencyType.daily;
  final Set<int> _weekdays = {1, 2, 3, 4, 5, 6, 7};
  int _intervalDays = 2;
  final List<TimeSlot> _times = [const TimeSlot(time: '08:00', dose: 1.0)];
  MealRelation? _meal = MealRelation.after;

  Medication? _existing;

  @override
  void initState() {
    super.initState();
    if (widget.editId != null) {
      _loadExisting();
    } else if (widget.barcodeMedicine case final medicine?) {
      _nameController.text = medicine.name;
      _notesController.text = [
        tr.barcode.source,
        tr.barcode.code(value: medicine.barcode),
        if (medicine.manufacturer.isNotEmpty)
          tr.barcode.manufacturer(value: medicine.manufacturer),
      ].join('\n');
      _form = MedicationForm.other;
      _unitController.clear();
      _frequency = FrequencyType.asNeeded;
      _meal = null;
    }
  }

  Future<void> _loadExisting() async {
    final detail = await ref
        .read(medicationServiceProvider)
        .detail(widget.editId!);
    if (detail == null || !mounted) {
      return;
    }
    final (med, schedules) = detail;
    setState(() {
      _loaded = true;
      _existing = med;
      _nameController.text = med.name;
      _specController.text = med.spec ?? '';
      _notesController.text = med.notes ?? '';
      _form = med.form;
      _unitController.text = med.doseUnit;
      if (schedules.isNotEmpty) {
        final s = schedules.first;
        _frequency = s.frequencyType;
        _weekdays
          ..clear()
          ..addAll(s.weekdays ?? {});
        _intervalDays = s.intervalDays ?? 2;
        _times
          ..clear()
          ..addAll(s.times);
        _meal = s.mealRelation ?? _meal;
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _specController.dispose();
    _notesController.dispose();
    _unitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Rebuild localized labels, including those constructed in helper methods.
    Localizations.localeOf(context);
    final theme = Theme.of(context);
    if (widget.editId != null && !_loaded) {
      return Scaffold(
        appBar: buildPillPalAppBar(
          title: tr.medicationForm.editTitle,
          backLocation: _backLocation,
        ),
        body: const LoadingView(),
      );
    }
    return PopScope(
      canPop: _step == 0,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && _step > 0) {
          setState(() => _step--);
        }
      },
      child: Scaffold(
        appBar: buildPillPalAppBar(
          backLocation: _backLocation,
          title: _existing == null
              ? tr.medicationForm.addTitle(arg1: (_step + 1).toString())
              : tr.medicationForm.editTitle,
          leading: _step > 0
              ? BackButton(onPressed: () => setState(() => _step--))
              : null,
        ),
        body: switch (_step) {
          0 => _buildStepBasic(theme),
          1 => _buildStepSchedule(theme),
          _ => _buildStepConfirm(theme),
        },
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16),
          child: _step < 2
              ? BigPrimaryButton(
                  label: tr.medicationForm.next,
                  icon: Icons.arrow_forward,
                  onPressed: () {
                    if (_step == 0 && _nameController.text.trim().isEmpty) {
                      UndoBar.show(
                        context,
                        message: tr.medicationForm.missingName,
                      );
                      return;
                    }
                    if (_step == 1 &&
                        _frequency != FrequencyType.asNeeded &&
                        _times.isEmpty) {
                      UndoBar.show(
                        context,
                        message: tr.medicationForm.missingTime,
                      );
                      return;
                    }
                    if (_step == 0 &&
                        widget.barcodeMedicine != null &&
                        _unitController.text.trim().isEmpty) {
                      UndoBar.show(context, message: tr.barcode.missingUnit);
                      return;
                    }
                    setState(() => _step++);
                  },
                )
              : BigPrimaryButton(
                  label: _existing == null
                      ? tr.medicationForm.save
                      : tr.medicationForm.saveChanges,
                  icon: Icons.check,
                  onPressed: _saving ? null : _save,
                ),
        ),
      ),
    );
  }

  Widget _buildStepBasic(ThemeData theme) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (widget.barcodeMedicine != null) ...[
          Text(tr.barcode.prefill),
          const SizedBox(height: 16),
        ],
        Text(tr.medicationForm.nameLabel, style: theme.textTheme.titleLarge),
        const SizedBox(height: 12),
        TextField(
          key: const ValueKey('medication-name'),
          controller: _nameController,
          style: theme.textTheme.bodyLarge,
          decoration: InputDecoration(hintText: tr.medicationForm.nameHint),
        ),
        const SizedBox(height: 20),
        Text(tr.medicationForm.formLabel, style: theme.textTheme.titleLarge),
        const SizedBox(height: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final f in MedicationForm.values)
              PillPalChoice(
                label: f.label,
                selected: _form == f,
                onSelected: (_) {
                  setState(() {
                    _form = f;
                    if (f == MedicationForm.liquid &&
                        _unitController.text == tr.units.tablet) {
                      _unitController.text = tr.units.ml;
                    }
                  });
                },
              ),
          ],
        ),
        const SizedBox(height: 20),
        PillPalField(
          label: tr.medicationForm.unitLabel,
          child: TextField(
            key: const ValueKey('medication-unit'),
            controller: _unitController,
            style: theme.textTheme.bodyLarge,
            decoration: InputDecoration(hintText: tr.medicationForm.unitHint),
          ),
        ),
        const SizedBox(height: 20),
        PillPalField(
          label: tr.medicationForm.specLabel,
          child: TextField(
            controller: _specController,
            style: theme.textTheme.bodyLarge,
            decoration: InputDecoration(hintText: tr.medicationForm.specHint),
          ),
        ),
        const SizedBox(height: 20),
        PillPalField(
          label: tr.medicationForm.notesLabel,
          child: TextField(
            controller: _notesController,
            style: theme.textTheme.bodyLarge,
            maxLines: 2,
            decoration: InputDecoration(hintText: tr.medicationForm.notesHint),
          ),
        ),
      ],
    );
  }

  Widget _buildStepSchedule(ThemeData theme) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          tr.medicationForm.frequencyLabel,
          style: theme.textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final f in FrequencyType.values)
              PillPalChoice(
                label: switch (f) {
                  FrequencyType.daily => tr.medicationForm.daily,
                  FrequencyType.weekdays => tr.medicationForm.weekdays,
                  FrequencyType.intervalDays => tr.medicationForm.interval,
                  FrequencyType.asNeeded => tr.medicationForm.asNeeded,
                },
                selected: _frequency == f,
                onSelected: (_) => setState(() => _frequency = f),
              ),
          ],
        ),
        const SizedBox(height: 16),
        if (_frequency == FrequencyType.weekdays)
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final d in [1, 2, 3, 4, 5, 6, 7])
                PillPalChoice(
                  label: friendlyWeekday(d),
                  multiSelect: true,
                  selected: _weekdays.contains(d),
                  onSelected: (on) => setState(() {
                    on ? _weekdays.add(d) : _weekdays.remove(d);
                  }),
                ),
            ],
          ),
        if (_frequency == FrequencyType.intervalDays)
          PillPalField(
            label: tr.medicationForm.intervalLabel,
            child: PillPalStepper(
              label: tr.medicationForm.intervalDays,
              value: tr.medicationForm.days(arg1: (_intervalDays).toString()),
              onDecrease: _intervalDays <= 1
                  ? null
                  : () => setState(
                      () => _intervalDays = (_intervalDays - 1).clamp(1, 30),
                    ),
              onIncrease: _intervalDays >= 30
                  ? null
                  : () => setState(
                      () => _intervalDays = (_intervalDays + 1).clamp(1, 30),
                    ),
            ),
          ),
        if (_frequency != FrequencyType.asNeeded) ...[
          const SizedBox(height: 16),
          for (var i = 0; i < _times.length; i++)
            _TimeEditor(
              key: ValueKey('time$i-${_times[i].time}'),
              index: i,
              slot: _times[i],
              unit: _unitController.text.trim().isEmpty
                  ? tr.units.tablet
                  : _unitController.text.trim(),
              onChanged: (slot) => setState(() => _times[i] = slot),
              onRemove: _times.length > 1
                  ? () => setState(() => _times.removeAt(i))
                  : null,
            ),
          const SizedBox(height: 8),
          BigOutlinedButton(
            label: tr.medicationForm.addTime,
            icon: Icons.add_alarm,
            onPressed: () => setState(() {
              _times.add(
                TimeSlot(time: _times.last.time, dose: _times.last.dose),
              );
            }),
          ),
          const SizedBox(height: 16),
          Text(tr.medicationForm.mealLabel, style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final m in MealRelation.values)
                PillPalChoice(
                  label: m.label,
                  selected: _meal == m,
                  onSelected: (_) => setState(() => _meal = m),
                ),
              PillPalChoice(
                label: tr.medicationForm.mealAny,
                selected: _meal == null,
                onSelected: (_) => setState(() => _meal = null),
              ),
            ],
          ),
        ] else
          Text(
            tr.medicationForm.asNeededHint,
            style: theme.textTheme.bodyLarge,
          ),
      ],
    );
  }

  Widget _buildStepConfirm(ThemeData theme) {
    final freqText = switch (_frequency) {
      FrequencyType.daily => tr.medicationForm.daily,
      FrequencyType.weekdays => tr.medicationForm.weeklySummary(
        arg1: (_weekdays.map(friendlyWeekday).join('、')).toString(),
      ),
      FrequencyType.intervalDays => tr.medicationForm.intervalSummary(
        arg1: (_intervalDays).toString(),
      ),
      FrequencyType.asNeeded => tr.medicationForm.asNeededSummary,
    };
    final timeText = _frequency == FrequencyType.asNeeded
        ? ''
        : '\n${_times.map((t) => '${friendlyTime(t.time)} ${friendlyDose(t.effectiveDose, _unitController.text.trim())}').join('\n')}';
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        SectionCard(
          title: tr.medicationForm.reviewTitle,
          child: Text(
            tr.medicationForm.reviewSummary(
              arg1: (_nameController.text.trim()).toString(),
              arg2: (_form.label).toString(),
              arg3: (_unitController.text.trim()).toString(),
              arg4:
                  (_specController.text.trim().isEmpty
                          ? ''
                          : tr.medicationForm.specSummary(
                              arg1: (_specController.text.trim()).toString(),
                            ))
                      .toString(),
              arg5: (freqText).toString(),
              arg6: (timeText).toString(),
              arg7: (_meal == null ? '' : '\n${_meal!.label}').toString(),
            ),
            style: theme.textTheme.bodyLarge,
          ),
        ),
        const SizedBox(height: 12),
        Text(tr.medicationForm.reviewHint, style: theme.textTheme.bodyMedium),
      ],
    );
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      final service = ref.read(medicationServiceProvider);
      final scheduler = ref.read(reminderSchedulerProvider);
      final unit = _unitController.text.trim().isEmpty
          ? tr.units.tablet
          : _unitController.text.trim();
      final slots = _times
          .map((t) => t.copyWith(dose: t.dose ?? 1.0, meal: t.meal ?? _meal))
          .toList();

      if (_existing == null) {
        await service.createManual(
          source: widget.barcodeMedicine == null
              ? MedicationSource.manual
              : MedicationSource.barcode,
          name: _nameController.text.trim(),
          form: _form,
          doseUnit: unit,
          spec: _specController.text.trim().isEmpty
              ? null
              : _specController.text.trim(),
          notes: _notesController.text.trim().isEmpty
              ? null
              : _notesController.text.trim(),
          scheduleInputs: [
            ScheduleDraftInput(
              frequencyType: _frequency,
              weekdays: _frequency == FrequencyType.weekdays
                  ? _weekdays.toList()
                  : null,
              intervalDays: _frequency == FrequencyType.intervalDays
                  ? _intervalDays
                  : null,
              times: _frequency == FrequencyType.asNeeded ? const [] : slots,
              mealRelation: _meal,
            ),
          ],
        );
        await scheduler.refreshAfterDataChange();
      } else {
        var med = _existing!;
        med = await _updateMed(med, unit);
        final schedules = await service.schedulesOf(med.id);
        if (schedules.isEmpty) {
          final input = ScheduleDraftInput(
            frequencyType: _frequency,
            weekdays: _frequency == FrequencyType.weekdays
                ? _weekdays.toList()
                : null,
            intervalDays: _frequency == FrequencyType.intervalDays
                ? _intervalDays
                : null,
            times: _frequency == FrequencyType.asNeeded ? const [] : slots,
            mealRelation: _meal,
          );
          await service.saveSchedule(input.build(med.id));
        } else {
          final s = schedules.first;
          await service.saveSchedule(
            s.copyWith(
              frequencyType: _frequency,
              weekdays: _frequency == FrequencyType.weekdays
                  ? _weekdays.toList()
                  : null,
              intervalDays: _frequency == FrequencyType.intervalDays
                  ? _intervalDays
                  : null,
              times: _frequency == FrequencyType.asNeeded ? const [] : slots,
              mealRelation: _meal,
            ),
          );
        }
        await scheduler.refreshAfterDataChange();
      }
      ref.invalidate(todayControllerProvider);
      ref.invalidate(cabinetControllerProvider);
      if (mounted) {
        UndoBar.show(context, message: tr.medicationForm.saved);
        popPillPalPage(context, fallbackLocation: _backLocation, result: true);
      }
    } catch (e) {
      if (mounted) {
        UndoBar.show(context, message: friendlyError(e));
      }
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }

  Future<Medication> _updateMed(Medication med, String unit) async {
    final service = ref.read(medicationServiceProvider);
    final updated = med.copyWith(
      name: _nameController.text.trim(),
      form: _form,
      doseUnit: unit,
      spec: _specController.text.trim().isEmpty
          ? med.spec
          : _specController.text.trim(),
      notes: _notesController.text.trim().isEmpty
          ? med.notes
          : _notesController.text.trim(),
    );
    await service.save(updated);
    return updated;
  }
}

/// 时间编辑行：滚轮时间 + 剂量步进（docs/07 §3：能选不填）。
class _TimeEditor extends StatelessWidget {
  const _TimeEditor({
    super.key,
    required this.index,
    required this.slot,
    required this.unit,
    required this.onChanged,
    this.onRemove,
  });

  final int index;
  final TimeSlot slot;
  final String unit;
  final ValueChanged<TimeSlot> onChanged;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    // Rebuild localized labels, including those constructed in helper methods.
    Localizations.localeOf(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PillPalField(
            label: tr.medicationForm.doseTime(arg1: (index + 1).toString()),
            child: BigOutlinedButton(
              icon: Icons.schedule,
              label: friendlyTime(slot.time),
              onPressed: () async {
                final picked = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay(
                    hour: int.parse(slot.time.split(':')[0]),
                    minute: int.parse(slot.time.split(':')[1]),
                  ),
                  builder: (context, child) => MediaQuery(
                    // 滚轮样式，适老化（docs/07 §3）。
                    data: MediaQuery.of(context)
                        .copyWith(alwaysUse24HourFormat: false),
                    child: child!,
                  ),
                );
                if (picked != null) {
                  onChanged(
                    slot.copyWith(
                      time:
                          '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}',
                    ),
                  );
                }
              },
            ),
          ),
          const SizedBox(height: 16),
          PillPalField(
            label: tr.medicationForm.doseAmount,
            child: PillPalStepper(
              label: tr.medicationForm.doseNumber(arg1: (index + 1).toString()),
              value: friendlyDose(slot.effectiveDose, unit),
              onDecrease: slot.effectiveDose <= 0.5
                  ? null
                  : () => onChanged(
                      slot.copyWith(
                        dose: ((slot.effectiveDose - 0.5).clamp(0.5, 20)),
                      ),
                    ),
              onIncrease: slot.effectiveDose >= 20
                  ? null
                  : () => onChanged(
                      slot.copyWith(
                        dose: ((slot.effectiveDose + 0.5).clamp(0.5, 20)),
                      ),
                    ),
            ),
          ),
          if (onRemove != null)
            BigOutlinedButton(
              onPressed: onRemove,
              label: tr.medicationForm.removeTime,
              icon: Icons.delete_outline,
            ),
        ],
      ),
    );
  }
}
