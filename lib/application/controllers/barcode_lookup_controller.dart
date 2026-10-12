import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/cancellation.dart';
import '../../data/barcode/open_fda_barcode_lookup.dart';
import '../../domain/models/medication_barcode.dart';
import '../../domain/services/barcode_lookup.dart';

final barcodeLookupProvider = Provider<BarcodeLookup>((ref) {
  final lookup = OpenFdaBarcodeLookup();
  ref.onDispose(lookup.close);
  return lookup;
});

enum BarcodeLookupPhase { idle, loading, results, notFound, error }

class BarcodeLookupState {
  const BarcodeLookupState({
    this.input = '',
    this.phase = BarcodeLookupPhase.idle,
    this.matches = const [],
    this.inputProblem,
    this.failure,
  });
  final String input;
  final BarcodeLookupPhase phase;
  final List<BarcodeMedication> matches;
  final BarcodeProblem? inputProblem;
  final BarcodeLookupFailure? failure;
}

final barcodeLookupControllerProvider =
    NotifierProvider.autoDispose<BarcodeLookupController, BarcodeLookupState>(
      BarcodeLookupController.new,
    );

class BarcodeLookupController extends Notifier<BarcodeLookupState> {
  CancellationSignal? _pending;
  bool _disposed = false;

  @override
  BarcodeLookupState build() {
    ref.onDispose(() {
      _disposed = true;
      _pending?.cancel();
    });
    return const BarcodeLookupState();
  }

  void edit(String value) {
    _pending?.cancel();
    state = BarcodeLookupState(input: value);
  }

  void cancelPending() {
    if (state.phase == BarcodeLookupPhase.loading) edit(state.input);
  }

  Future<void> lookup() async {
    if (state.phase == BarcodeLookupPhase.loading) return;
    final input = state.input;
    final MedicationBarcode barcode;
    try {
      barcode = MedicationBarcode.parse(input);
    } on BarcodeInputException catch (e) {
      state = BarcodeLookupState(
        input: input,
        phase: BarcodeLookupPhase.error,
        inputProblem: e.problem,
      );
      return;
    }
    _pending?.cancel();
    final cancellation = _pending = CancellationSignal();
    state = BarcodeLookupState(input: input, phase: BarcodeLookupPhase.loading);
    try {
      final matches = await ref
          .read(barcodeLookupProvider)
          .lookup(barcode, cancellation: cancellation);
      if (_disposed || cancellation.isCancelled) return;
      state = BarcodeLookupState(
        input: input,
        matches: matches,
        phase: matches.isEmpty
            ? BarcodeLookupPhase.notFound
            : BarcodeLookupPhase.results,
      );
    } on OperationCancelled {
      // A newer input or page disposal owns the state now.
    } catch (e) {
      if (_disposed || cancellation.isCancelled) return;
      state = BarcodeLookupState(
        input: input,
        phase: BarcodeLookupPhase.error,
        failure: e is BarcodeLookupException
            ? e.failure
            : BarcodeLookupFailure.unavailable,
      );
    }
  }
}
