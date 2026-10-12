import 'dart:async';

import 'package:dio/dio.dart';

import '../../core/cancellation.dart';
import '../../domain/models/medication_barcode.dart';
import '../../domain/services/barcode_lookup.dart';

/// Public, keyless openFDA drug labels. UPC is an optional harmonized field;
/// missing records do not mean a product is invalid or not a medicine.
class OpenFdaBarcodeLookup implements BarcodeLookup {
  OpenFdaBarcodeLookup({Dio? dio})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              connectTimeout: const Duration(seconds: 10),
              receiveTimeout: const Duration(seconds: 15),
              followRedirects: false,
            ),
          );

  final Dio _dio;
  void close() => _dio.close(force: true);

  @override
  Future<List<BarcodeMedication>> lookup(
    MedicationBarcode barcode, {
    required CancellationSignal cancellation,
  }) async {
    cancellation.check();
    final token = CancelToken();
    unawaited(cancellation.whenCancelled.then((_) => token.cancel()));
    try {
      final response = await _dio.get<Object?>(
        'https://api.fda.gov/drug/label.json',
        queryParameters: {
          'search': barcode.lookupCodes
              .map((c) => 'openfda.upc:"$c"')
              .join(' OR '),
          'limit': 20,
        },
        cancelToken: token,
      );
      cancellation.check();
      return parseResponse(response.data, barcode);
    } on DioException catch (e) {
      cancellation.check();
      // Only openFDA's explicit no-match response is an empty result.
      final data = e.response?.data;
      final error = data is Map ? data['error'] : null;
      if (e.response?.statusCode == 404 &&
          error is Map &&
          error['code'] == 'NOT_FOUND') {
        return [];
      }
      throw BarcodeLookupException(switch (e.type) {
        DioExceptionType.connectionTimeout ||
        DioExceptionType.sendTimeout ||
        DioExceptionType.receiveTimeout => BarcodeLookupFailure.timeout,
        DioExceptionType.connectionError => BarcodeLookupFailure.network,
        _ =>
          e.response?.statusCode == 429
              ? BarcodeLookupFailure.rateLimited
              : BarcodeLookupFailure.unavailable,
      });
    }
  }

  static List<BarcodeMedication> parseResponse(
    Object? data,
    MedicationBarcode barcode,
  ) {
    if (data is! Map || data['results'] is! List) {
      throw const BarcodeLookupException(BarcodeLookupFailure.unavailable);
    }
    final matches = <String, BarcodeMedication>{};
    for (final row in data['results'] as List) {
      if (row is! Map || row['openfda'] is! Map) continue;
      final fields = row['openfda'] as Map;
      final codes = _strings(fields['upc']);
      final exact = codes.any((code) {
        try {
          return MedicationBarcode.parse(code).canonical == barcode.canonical;
        } on BarcodeInputException {
          return false;
        }
      });
      final types = _strings(fields['product_type']);
      if (!exact ||
          !types.any(
            (t) => t == 'HUMAN OTC DRUG' || t == 'HUMAN PRESCRIPTION DRUG',
          )) {
        continue;
      }
      final generic = _strings(fields['generic_name']).join(' / ');
      final brand = _strings(fields['brand_name']).join(' / ');
      final name = brand.isEmpty ? generic : brand;
      if (name.isEmpty) continue;
      final manufacturer = _strings(fields['manufacturer_name']).join(' / ');
      // Label versions may repeat the same product; do not merge different makers.
      matches.putIfAbsent(
        '$name\u0000$generic\u0000$manufacturer',
        () => BarcodeMedication(
          barcode: barcode.gtin,
          name: name,
          genericName: generic,
          manufacturer: manufacturer,
          labelId: row['id'] is String ? row['id'] as String : '',
        ),
      );
    }
    return List.unmodifiable(matches.values);
  }

  static List<String> _strings(Object? value) => value is List
      ? value
            .whereType<String>()
            .map((s) => s.trim())
            .where((s) => s.isNotEmpty)
            .toList()
      : [];
}
