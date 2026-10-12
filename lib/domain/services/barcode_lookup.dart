import '../../core/cancellation.dart';
import '../models/medication_barcode.dart';

enum BarcodeLookupFailure { network, timeout, rateLimited, unavailable }

class BarcodeLookupException implements Exception {
  const BarcodeLookupException(this.failure);
  final BarcodeLookupFailure failure;
}

abstract interface class BarcodeLookup {
  Future<List<BarcodeMedication>> lookup(
    MedicationBarcode barcode, {
    required CancellationSignal cancellation,
  });
}
