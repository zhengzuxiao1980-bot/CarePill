import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../domain/models/medication_barcode.dart';
import '../../i18n/strings.g.dart';
import '../widgets/common.dart';

/// MobileScanner owns its controller and camera lifecycle. No image is returned
/// or uploaded. A capture closes this route once, even with repeated detections.
class BarcodeCameraPage extends StatefulWidget {
  const BarcodeCameraPage({super.key});

  @override
  State<BarcodeCameraPage> createState() => _BarcodeCameraPageState();
}

class _BarcodeCameraPageState extends State<BarcodeCameraPage> {
  bool _returned = false;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(tr.barcode.title)),
    body: SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(tr.barcode.aim),
          ),
          Expanded(
            child: MobileScanner(
              onDetect: (capture) {
                if (_returned || !mounted) return;
                final values = capture.barcodes
                    .map((b) {
                      if (b.format != BarcodeFormat.upcE ||
                          b.rawValue == null) {
                        return b.rawValue;
                      }
                      try {
                        return MedicationBarcode.expandUpcE(b.rawValue!);
                      } on BarcodeInputException {
                        return 'UPC-E: ${b.rawValue}';
                      }
                    })
                    .whereType<String>()
                    .where((s) => s.isNotEmpty)
                    .toSet()
                    .toList();
                if (values.isEmpty) return;
                _returned = true;
                Navigator.of(context).pop(values);
              },
              errorBuilder: (context, error) => SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(tr.barcode.cameraError),
                    const SizedBox(height: 16),
                    BigOutlinedButton(
                      label: tr.barcode.manual,
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
