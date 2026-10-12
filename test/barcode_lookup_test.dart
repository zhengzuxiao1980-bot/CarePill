import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:care_pill/application/controllers/barcode_lookup_controller.dart';
import 'package:care_pill/core/cancellation.dart';
import 'package:care_pill/data/barcode/open_fda_barcode_lookup.dart';
import 'package:care_pill/domain/models/medication_barcode.dart';
import 'package:care_pill/domain/services/barcode_lookup.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

const _code = '0300450297211';
const _canonical = '00300450297211';

Map<String, Object?> _label({
  String code = _code,
  String type = 'HUMAN OTC DRUG',
  String maker = 'Kenvue',
  String name = 'Tylenol',
}) => {
  'id': 'label-id',
  'openfda': {
    'upc': [code],
    'product_type': [type],
    'brand_name': [name],
    'generic_name': ['Acetaminophen'],
    'manufacturer_name': [maker],
  },
  'dosage_and_administration': ['Never use this as a personal schedule'],
};

void main() {
  group('Barcode normalization', () {
    for (final value in [
      _code,
      '300450297211',
      _canonical,
      ' ０３００４５０２９７２１１ ',
      '0300 4502 9721 1',
      '0300-4502-9721-1',
      '(01)$_canonical(17)261231(10)LOT(21)SERIAL',
      ']d201${_canonical}1726123110LOT\x1d21SERIAL',
      '01${_canonical}17261231',
      'https://id.gs1.org/01/$_canonical/21/serial?10=lot',
      'https://untrusted.invalid/01/$_canonical',
    ]) {
      test('extracts only exact GTIN from $value', () {
        expect(MedicationBarcode.parse(value).canonical, _canonical);
      });
    }
    test('supports EAN-8 and expands scanner UPC-E separately', () {
      expect(MedicationBarcode.parse('96385074').gtin, '96385074');
      expect(MedicationBarcode.expandUpcE('04252614'), '042100005264');
      expect(MedicationBarcode.parse(_code).lookupCodes, {
        _canonical,
        _code,
        '300450297211',
      });
    });
    for (final (value, problem) in [
      ('12345678901234567890', BarcodeProblem.traceability),
      ('', BarcodeProblem.unsupported),
      ('0300450297212', BarcodeProblem.invalid),
      ('0000000000000', BarcodeProblem.invalid),
      ('12345678901', BarcodeProblem.invalid),
      ('https://example.com/?code=$_code', BarcodeProblem.unsupported),
      ('http://id.gs1.org/01/$_canonical', BarcodeProblem.unsupported),
      ('https://id.gs1.org/01/%FF', BarcodeProblem.unsupported),
      ('https://id.gs1.org/01/00300450297212', BarcodeProblem.invalid),
      ('hello $_code', BarcodeProblem.unsupported),
      ('1' * 2049, BarcodeProblem.unsupported),
    ]) {
      test('rejects ${value.substring(0, value.length.clamp(0, 60))}', () {
        expect(
          () => MedicationBarcode.parse(value),
          throwsA(
            isA<BarcodeInputException>().having(
              (e) => e.problem,
              'problem',
              problem,
            ),
          ),
        );
      });
    }
  });

  group('openFDA gateway', () {
    test('queries fixed HTTPS endpoint with GTIN variants only', () async {
      final adapter = _Adapter(200, {
        'results': [_label()],
      });
      final lookup = OpenFdaBarcodeLookup(
        dio: Dio()..httpClientAdapter = adapter,
      );
      addTearDown(lookup.close);
      final results = await lookup.lookup(
        MedicationBarcode.parse(
          'https://untrusted.invalid/01/$_canonical/21/private-serial',
        ),
        cancellation: CancellationSignal(),
      );
      expect(results.single.name, 'Tylenol');
      expect(adapter.request!.uri.host, 'api.fda.gov');
      expect(adapter.request!.path, 'https://api.fda.gov/drug/label.json');
      expect(
        adapter.request!.queryParameters['search'],
        'openfda.upc:"$_canonical" OR openfda.upc:"300450297211" OR openfda.upc:"$_code"',
      );
      expect(adapter.request!.uri.toString(), isNot(contains('serial')));
      expect(adapter.request!.uri.toString(), isNot(contains('untrusted')));
    });
    test('filters mismatches and nonhuman products; keeps distinct makers', () {
      final results = OpenFdaBarcodeLookup.parseResponse({
        'results': [
          _label(),
          _label(),
          _label(maker: 'Other maker'),
          _label(type: 'ANIMAL OTC DRUG'),
          _label(code: '96385074'),
          {'openfda': <String, Object?>{}},
          null,
        ],
      }, MedicationBarcode.parse(_code));
      expect(results, hasLength(2));
      expect(results.map((e) => e.manufacturer), ['Kenvue', 'Other maker']);
    });
    test('generic-name fallback; malformed data is a service error', () {
      final results = OpenFdaBarcodeLookup.parseResponse({
        'results': [_label(name: '')],
      }, MedicationBarcode.parse(_code));
      expect(results.single.name, 'Acetaminophen');
      expect(
        () => OpenFdaBarcodeLookup.parseResponse(
          '<html>error</html>',
          MedicationBarcode.parse(_code),
        ),
        throwsA(isA<BarcodeLookupException>()),
      );
    });
    for (final (status, body, failure) in [
      (
        404,
        {
          'error': {'code': 'NOT_FOUND'},
        },
        null,
      ),
      (
        404,
        {
          'error': {'code': 'OTHER'},
        },
        BarcodeLookupFailure.unavailable,
      ),
      (429, <String, Object?>{}, BarcodeLookupFailure.rateLimited),
      (503, <String, Object?>{}, BarcodeLookupFailure.unavailable),
    ]) {
      test('HTTP $status $body', () async {
        final lookup = OpenFdaBarcodeLookup(
          dio: Dio()..httpClientAdapter = _Adapter(status, body),
        );
        addTearDown(lookup.close);
        final request = lookup.lookup(
          MedicationBarcode.parse(_code),
          cancellation: CancellationSignal(),
        );
        if (failure == null) {
          expect(await request, isEmpty);
        } else {
          await expectLater(
            request,
            throwsA(
              isA<BarcodeLookupException>().having(
                (e) => e.failure,
                'failure',
                failure,
              ),
            ),
          );
        }
      });
    }
    for (final (type, failure) in [
      (DioExceptionType.connectionTimeout, BarcodeLookupFailure.timeout),
      (DioExceptionType.receiveTimeout, BarcodeLookupFailure.timeout),
      (DioExceptionType.connectionError, BarcodeLookupFailure.network),
    ]) {
      test('maps $type', () async {
        final lookup = OpenFdaBarcodeLookup(
          dio: Dio()..httpClientAdapter = _Adapter(200, {}, error: type),
        );
        addTearDown(lookup.close);
        await expectLater(
          lookup.lookup(
            MedicationBarcode.parse(_code),
            cancellation: CancellationSignal(),
          ),
          throwsA(
            isA<BarcodeLookupException>().having(
              (e) => e.failure,
              'failure',
              failure,
            ),
          ),
        );
      });
    }
    test('cancels an in-flight HTTP request', () async {
      final cancellation = CancellationSignal();
      final adapter = _Adapter(200, {}, pending: Completer<ResponseBody>());
      final lookup = OpenFdaBarcodeLookup(
        dio: Dio()..httpClientAdapter = adapter,
      );
      addTearDown(lookup.close);
      final request = lookup.lookup(
        MedicationBarcode.parse(_code),
        cancellation: cancellation,
      );
      final assertion = expectLater(
        request,
        throwsA(isA<OperationCancelled>()),
      );
      await Future<void>.delayed(Duration.zero);
      cancellation.cancel();
      await assertion;
    });
  });

  group('Lookup controller (no database dependencies)', () {
    late ProviderContainer container;
    late _FakeLookup fake;
    late BarcodeLookupController controller;
    setUp(() {
      fake = _FakeLookup();
      container = ProviderContainer(
        overrides: [barcodeLookupProvider.overrideWithValue(fake)],
      );
      container.listen(barcodeLookupControllerProvider, (_, _) {});
      controller = container.read(barcodeLookupControllerProvider.notifier);
    });
    tearDown(() => container.dispose());
    test('invalid and traceability codes never call the service', () async {
      for (final value in [
        '123',
        '12345678901234567890',
        'https://example.com',
      ]) {
        controller.edit(value);
        await controller.lookup();
        expect(
          container.read(barcodeLookupControllerProvider).phase,
          BarcodeLookupPhase.error,
        );
      }
      expect(fake.calls, isEmpty);
    });
    test('deduplicates pending requests, handles empty and retry', () async {
      controller.edit(_code);
      final first = controller.lookup();
      await controller.lookup();
      expect(fake.calls, hasLength(1));
      fake.calls.first.$2.complete([]);
      await first;
      expect(
        container.read(barcodeLookupControllerProvider).phase,
        BarcodeLookupPhase.notFound,
      );
      final retry = controller.lookup();
      fake.calls.last.$2.complete(_matches);
      await retry;
      expect(container.read(barcodeLookupControllerProvider).matches, _matches);
    });
    test('edit cancels old request and ignores its late response', () async {
      controller.edit(_code);
      final old = controller.lookup();
      controller.edit('96385074');
      expect(fake.calls.first.$1.isCancelled, isTrue);
      final current = controller.lookup();
      fake.calls.first.$2.complete(_matches);
      await old;
      expect(
        container.read(barcodeLookupControllerProvider).phase,
        BarcodeLookupPhase.loading,
      );
      fake.calls.last.$2.complete([]);
      await current;
      expect(container.read(barcodeLookupControllerProvider).matches, isEmpty);
    });
    test('failure is retryable, and editing clears the error', () async {
      controller.edit(_code);
      final request = controller.lookup();
      fake.calls.single.$2.completeError(
        const BarcodeLookupException(BarcodeLookupFailure.timeout),
      );
      await request;
      expect(
        container.read(barcodeLookupControllerProvider).failure,
        BarcodeLookupFailure.timeout,
      );
      controller.edit(_code);
      expect(container.read(barcodeLookupControllerProvider).failure, isNull);
    });
    test('dispose cancels pending request and ignores late result', () async {
      controller.edit(_code);
      final request = controller.lookup();
      container.invalidate(barcodeLookupControllerProvider);
      expect(fake.calls.single.$1.isCancelled, isTrue);
      fake.calls.single.$2.complete(_matches);
      await request;
    });
  });
}

const _matches = [
  BarcodeMedication(
    barcode: _code,
    name: 'Tylenol',
    genericName: 'Acetaminophen',
    manufacturer: 'Kenvue',
    labelId: 'test',
  ),
];

class _FakeLookup implements BarcodeLookup {
  final calls = <(CancellationSignal, Completer<List<BarcodeMedication>>)>[];
  @override
  Future<List<BarcodeMedication>> lookup(
    MedicationBarcode barcode, {
    required CancellationSignal cancellation,
  }) {
    final pending = Completer<List<BarcodeMedication>>();
    calls.add((cancellation, pending));
    return pending.future;
  }
}

class _Adapter implements HttpClientAdapter {
  _Adapter(this.status, this.body, {this.error, this.pending});
  final int status;
  final Object body;
  final DioExceptionType? error;
  final Completer<ResponseBody>? pending;
  RequestOptions? request;
  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    request = options;
    if (error != null) {
      throw DioException(requestOptions: options, type: error!);
    }
    if (pending != null) return pending!.future;
    return ResponseBody.fromString(
      jsonEncode(body),
      status,
      headers: {
        Headers.contentTypeHeader: ['application/json'],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}
