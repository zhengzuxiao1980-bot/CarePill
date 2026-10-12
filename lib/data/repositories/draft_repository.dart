import 'dart:convert';

import 'package:drift/drift.dart';

import '../../domain/models/enums.dart';
import '../../domain/models/medication_draft.dart';
import '../db/app_database.dart';
import '../db/upsert.dart';

abstract class DraftRepository {
  Future<void> save(MedicationDraft draft);
  Future<MedicationDraft?> get(String id);
  Future<List<MedicationDraft>> pending();
  Future<void> setStatus(String id, DraftStatus status);
}

class DriftDraftRepository implements DraftRepository {
  DriftDraftRepository(this._db);

  final AppDatabase _db;

  static MedicationDraft rowToDraft(DraftRow r) => MedicationDraft(
        id: r.id,
        source: DraftSource.values.firstWhere(
          (e) => e.json == r.source,
          orElse: () => DraftSource.photo,
        ),
        payload: MedicationDraftPayload.fromJson(
          jsonDecode(r.payloadJson) as Map<String, dynamic>,
        ),
        photoPath: r.photoPath,
        status: DraftStatus.values.firstWhere(
          (e) => e.json == r.status,
          orElse: () => DraftStatus.pending,
        ),
        createdAt: DateTime.fromMillisecondsSinceEpoch(r.createdAt),
      );

  @override
  Future<void> save(MedicationDraft draft) {
    return _db.into(_db.medicationDrafts).insertOrUpdate(
          MedicationDraftsCompanion.insert(
            id: draft.id,
            source: draft.source.json,
            payloadJson: jsonEncode(draft.payload.toJson()),
            photoPath: Value(draft.photoPath),
            status: draft.status.json,
            createdAt: draft.createdAt.millisecondsSinceEpoch,
          ),
        );
  }

  @override
  Future<MedicationDraft?> get(String id) async {
    final row =
        await (_db.select(_db.medicationDrafts)..where((d) => d.id.equals(id)))
            .getSingleOrNull();
    return row == null ? null : rowToDraft(row);
  }

  @override
  Future<List<MedicationDraft>> pending() async {
    final rows = await (_db.select(_db.medicationDrafts)
          ..where((d) => d.status.equals(DraftStatus.pending.json))
          ..orderBy([(d) => OrderingTerm.desc(d.createdAt)]))
        .get();
    return rows.map(rowToDraft).toList();
  }

  @override
  Future<void> setStatus(String id, DraftStatus status) {
    return (_db.update(_db.medicationDrafts)..where((d) => d.id.equals(id)))
        .write(MedicationDraftsCompanion(status: Value(status.json)));
  }
}
