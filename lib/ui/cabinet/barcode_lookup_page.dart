import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../application/controllers/barcode_lookup_controller.dart';
import '../../application/controllers/models_controller.dart';
import '../../domain/models/medication_barcode.dart';
import '../../domain/services/barcode_lookup.dart';
import '../../domain/services/model_selection.dart';
import '../../i18n/strings.g.dart';
import '../shell/app_shell.dart';
import '../widgets/common.dart';
import 'barcode_camera_page.dart';

class BarcodeLookupPage extends ConsumerStatefulWidget {
  const BarcodeLookupPage({super.key, this.returnToOnboarding = false});
  final bool returnToOnboarding;

  @override
  ConsumerState<BarcodeLookupPage> createState() => _BarcodeLookupPageState();
}

class _BarcodeLookupPageState extends ConsumerState<BarcodeLookupPage> {
  final _input = TextEditingController();
  final _resultKey = GlobalKey();
  final _scroll = ScrollController();
  bool _opening = false;
  String get _suffix =>
      widget.returnToOnboarding ? '?returnToOnboarding=1' : '';
  bool get _cameraSupported =>
      !kIsWeb &&
      {
        TargetPlatform.android,
        TargetPlatform.iOS,
        TargetPlatform.macOS,
      }.contains(defaultTargetPlatform);

  @override
  void dispose() {
    _input.dispose();
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Localizations.localeOf(context);
    final state = ref.watch(barcodeLookupControllerProvider);
    final controller = ref.read(barcodeLookupControllerProvider.notifier);
    final busy = state.phase == BarcodeLookupPhase.loading || _opening;
    final capability = ref.watch(visionCapabilityProvider).value;
    final canPhoto =
        capability == VisionCapability.native ||
        capability == VisionCapability.fallback;
    final message = _message(state);
    return Scaffold(
      appBar: buildPillPalAppBar(
        title: tr.barcode.title,
        backLocation: widget.returnToOnboarding
            ? '/onboarding?step=2'
            : '/cabinet',
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          controller: _scroll,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(tr.barcode.coverage),
              const SizedBox(height: 12),
              Text(
                tr.barcode.privacy,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              if (_cameraSupported)
                BigPrimaryButton(
                  label: tr.barcode.scan,
                  icon: Icons.qr_code_scanner,
                  onPressed: busy ? null : _scan,
                )
              else
                Text(tr.barcode.cameraUnsupported),
              const SizedBox(height: 20),
              PillPalField(
                label: tr.barcode.manual,
                child: TextField(
                  key: const ValueKey('barcode-input'),
                  controller: _input,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.search,
                  maxLength: 2048,
                  decoration: InputDecoration(
                    hintText: tr.barcode.hint,
                    counterText: '',
                  ),
                  onChanged: controller.edit,
                  onSubmitted: (_) {
                    FocusScope.of(context).unfocus();
                    _lookup();
                  },
                ),
              ),
              const SizedBox(height: 12),
              BigOutlinedButton(
                label: tr.barcode.lookup,
                icon: Icons.search,
                onPressed: busy
                    ? null
                    : () {
                        FocusScope.of(context).unfocus();
                        _lookup();
                      },
              ),
              SizedBox(key: _resultKey, height: 20),
              if (state.phase == BarcodeLookupPhase.loading) ...[
                const SizedBox(height: 20),
                const LinearProgressIndicator(),
                Text(tr.barcode.loading),
              ],
              if (message != null) ...[
                const SizedBox(height: 20),
                Semantics(liveRegion: true, child: Text(message)),
              ],
              if (state.matches.isNotEmpty) ...[
                const SizedBox(height: 20),
                Text(
                  tr.barcode.results,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(tr.barcode.review),
                for (final medicine in state.matches)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: SectionCard(
                      title: medicine.name,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (medicine.genericName.isNotEmpty)
                            Text(
                              tr.barcode.generic(value: medicine.genericName),
                            ),
                          if (medicine.manufacturer.isNotEmpty)
                            Text(
                              tr.barcode.manufacturer(
                                value: medicine.manufacturer,
                              ),
                            ),
                          Text(tr.barcode.code(value: medicine.barcode)),
                          Text(tr.barcode.source),
                          const SizedBox(height: 12),
                          BigPrimaryButton(
                            label: tr.barcode.use,
                            onPressed: busy
                                ? null
                                : () =>
                                      _open('/medication/new', extra: medicine),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
              const SizedBox(height: 24),
              BigOutlinedButton(
                label: tr.cabinet.manual,
                icon: Icons.edit,
                onPressed: _opening ? null : () => _open('/medication/new'),
              ),
              const SizedBox(height: 12),
              BigOutlinedButton(
                label: capability == VisionCapability.fallback
                    ? tr.cabinet.photoUncertain
                    : canPhoto
                    ? tr.cabinet.photo
                    : tr.cabinet.photoSetup,
                icon: Icons.camera_alt,
                onPressed: canPhoto && !_opening
                    ? () => _open('/medication/photo')
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _lookup() async {
    await ref.read(barcodeLookupControllerProvider.notifier).lookup();
    if (!mounted) return;
    final phase = ref.read(barcodeLookupControllerProvider).phase;
    if (phase == BarcodeLookupPhase.idle || phase == BarcodeLookupPhase.loading) {
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final target = _resultKey.currentContext;
      if (mounted && target != null) {
        Scrollable.ensureVisible(
          target,
          alignment: 0.05,
          duration: const Duration(milliseconds: 250),
        );
      }
    });
  }

  Future<void> _open(String path, {BarcodeMedication? extra}) async {
    ref.read(barcodeLookupControllerProvider.notifier).cancelPending();
    setState(() => _opening = true);
    try {
      final saved = await context.push<bool>('$path$_suffix', extra: extra);
      if (mounted && saved == true) {
        popPillPalPage(
          context,
          fallbackLocation: widget.returnToOnboarding
              ? '/onboarding?step=2'
              : '/cabinet',
          result: true,
        );
      }
    } finally {
      if (mounted) setState(() => _opening = false);
    }
  }

  Future<void> _scan() async {
    setState(() => _opening = true);
    try {
      final values = await Navigator.of(context).push<List<String>>(
        MaterialPageRoute(builder: (_) => const BarcodeCameraPage()),
      );
      if (!mounted || values == null || values.isEmpty) return;
      final value = values.length == 1
          ? values.single
          : await showDialog<String>(
              context: context,
              builder: (context) => SimpleDialog(
                title: Text(tr.barcode.choose),
                children: [
                  for (final code in values)
                    SimpleDialogOption(
                      onPressed: () => Navigator.pop(context, code),
                      child: Text(
                        code,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                ],
              ),
            );
      if (!mounted || value == null) return;
      _input.text = value;
      final controller = ref.read(barcodeLookupControllerProvider.notifier);
      controller.edit(value);
      await _lookup();
    } finally {
      if (mounted) setState(() => _opening = false);
    }
  }

  String? _message(BarcodeLookupState state) {
    if (state.inputProblem != null) {
      return switch (state.inputProblem!) {
        BarcodeProblem.invalid => tr.barcode.invalid,
        BarcodeProblem.unsupported => tr.barcode.unsupported,
        BarcodeProblem.traceability => tr.barcode.traceability,
      };
    }
    if (state.failure != null) {
      return switch (state.failure!) {
        BarcodeLookupFailure.network => tr.barcode.network,
        BarcodeLookupFailure.timeout => tr.barcode.timeout,
        BarcodeLookupFailure.rateLimited => tr.barcode.rateLimited,
        BarcodeLookupFailure.unavailable => tr.barcode.unavailable,
      };
    }
    return state.phase == BarcodeLookupPhase.notFound
        ? tr.barcode.notFound
        : null;
  }
}
