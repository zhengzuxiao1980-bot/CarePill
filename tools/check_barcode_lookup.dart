// Explicit live smoke check; never part of offline unit tests.
// dart run tools/check_barcode_lookup.dart 0300450297211
import 'dart:io';

import 'package:care_pill/core/cancellation.dart';
import 'package:care_pill/data/barcode/open_fda_barcode_lookup.dart';
import 'package:care_pill/domain/models/medication_barcode.dart';

Future<void> main(List<String> args) async {
  if (args.length != 1) {
    stderr.writeln('Usage: dart run tools/check_barcode_lookup.dart <GTIN>');
    exitCode = 64;
    return;
  }
  final lookup = OpenFdaBarcodeLookup();
  final cancellation = CancellationSignal();
  try {
    final results = await lookup.lookup(
      MedicationBarcode.parse(args.single),
      cancellation: cancellation,
    );
    stdout.writeln('openFDA: ${results.length} matching medicine(s)');
    for (final medicine in results) {
      stdout.writeln(
        '${medicine.name} | ${medicine.genericName} | ${medicine.manufacturer}',
      );
    }
  } finally {
    cancellation.cancel();
    lookup.close();
  }
}
