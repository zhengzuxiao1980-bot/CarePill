enum BarcodeProblem { invalid, unsupported, traceability }

class BarcodeInputException implements Exception {
  const BarcodeInputException(this.problem);
  final BarcodeProblem problem;
}

/// Only an exact, checksum-validated GTIN leaves the device. QR URLs are never
/// followed, and serial / batch / expiry information is not sent to the API.
class MedicationBarcode {
  const MedicationBarcode._(this.gtin);
  final String gtin;

  String get canonical => gtin.padLeft(14, '0');

  Set<String> get lookupCodes => {
    canonical,
    for (final length in [8, 12, 13])
      if (canonical.startsWith('0' * (14 - length)))
        canonical.substring(14 - length),
  };

  static MedicationBarcode parse(String raw) {
    if (raw.length > 2048) {
      throw const BarcodeInputException(BarcodeProblem.unsupported);
    }
    var value = raw.trim().replaceAllMapped(
      RegExp('[０-９]'),
      (m) => String.fromCharCode(m[0]!.codeUnitAt(0) - 0xfee0),
    );
    // AIM symbology identifiers for GS1-128 / DataMatrix / QR.
    final identifiedGs1 = RegExp(r'^\](C1|d2|Q3)').hasMatch(value);
    value = value.replaceFirst(RegExp(r'^\](C1|d2|Q3)'), '');
    final uri = Uri.tryParse(value);
    if (uri != null && uri.hasScheme) {
      final List<String> parts;
      try {
        parts = uri.pathSegments;
      } on FormatException {
        throw const BarcodeInputException(BarcodeProblem.unsupported);
      }
      if (uri.scheme != 'https' ||
          uri.host.isEmpty ||
          parts.length < 2 ||
          parts.first != '01' ||
          !RegExp(r'^\d{14}$').hasMatch(parts[1])) {
        throw const BarcodeInputException(BarcodeProblem.unsupported);
      }
      value = parts[1]; // GS1 Digital Link; host is never requested.
    } else if (!identifiedGs1 && RegExp(r'^\d{20}$').hasMatch(value)) {
      throw const BarcodeInputException(BarcodeProblem.traceability);
    } else {
      final human = RegExp(r'^\(01\)(\d{14})(?:$|\()').firstMatch(value);
      final gs1 = RegExp(r'^01(\d{14})(?:$|[\x1d0-9])').firstMatch(value);
      if (human != null || gs1 != null) {
        value = (human ?? gs1)![1]!;
      } else {
        value = value.replaceAll(RegExp(r'[\s-]'), '');
      }
    }
    if (!RegExp(r'^\d+$').hasMatch(value)) {
      throw const BarcodeInputException(BarcodeProblem.unsupported);
    }
    if (value.length == 20) {
      throw const BarcodeInputException(BarcodeProblem.traceability);
    }
    if (![8, 12, 13, 14].contains(value.length) || !_validChecksum(value)) {
      throw const BarcodeInputException(BarcodeProblem.invalid);
    }
    return MedicationBarcode._(value);
  }

  /// Scanner-reported UPC-E is compressed UPC-A, not an 8-digit EAN.
  static String expandUpcE(String value) {
    if (!RegExp(r'^[01]\d{7}$').hasMatch(value)) {
      throw const BarcodeInputException(BarcodeProblem.invalid);
    }
    final body = value.substring(1, 7);
    final last = body[5];
    final expanded = switch (last) {
      '0' ||
      '1' ||
      '2' => '${body.substring(0, 2)}${last}0000${body.substring(2, 5)}',
      '3' => '${body.substring(0, 3)}00000${body.substring(3, 5)}',
      '4' => '${body.substring(0, 4)}00000${body[4]}',
      _ => '${body.substring(0, 5)}0000$last',
    };
    return parse('${value[0]}$expanded${value[7]}').gtin;
  }

  static bool _validChecksum(String value) {
    var sum = 0;
    for (var i = value.length - 2, weight = 3; i >= 0; i--) {
      sum += int.parse(value[i]) * weight;
      weight = 4 - weight;
    }
    return (10 - sum % 10) % 10 == int.parse(value[value.length - 1]) &&
        !RegExp(r'^0+$').hasMatch(value);
  }
}

/// Product identity only. No personal dosage or schedule is inferred from labels.
class BarcodeMedication {
  const BarcodeMedication({
    required this.barcode,
    required this.name,
    required this.genericName,
    required this.manufacturer,
    required this.labelId,
  });
  final String barcode;
  final String name;
  final String genericName;
  final String manufacturer;
  final String labelId;
}
