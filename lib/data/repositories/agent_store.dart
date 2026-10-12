import 'dart:async';
import 'dart:convert';

import '../db/app_database.dart';

/// Versioned local records for turns, summaries, explicit memories and operations.
/// A production transaction also covers domain repositories on the same database.
abstract class AgentStore {
  Future<Map<String, dynamic>?> get(String key);
  Future<void> put(String key, String kind, Map<String, dynamic> value);
  Future<void> remove(String key);
  Future<List<Map<String, dynamic>>> list(String kind);
  Future<T> transaction<T>(Future<T> Function() action);

  Future<Map<String, dynamic>> context() async =>
      await get('context') ??
      {
        'generation': 0,
        'cutoff': 0,
        'covered': 0,
        'summary': '',
        'suppressed': <String>[],
      };

  Future<void> resetContext({int? cutoff, bool restored = false}) async {
    final value = await context();
    value['generation'] = (value['generation'] as int) + 1;
    value['covered'] = cutoff ?? 0;
    value['cutoff'] = cutoff ?? 0;
    value['summary'] = '';
    if (restored) {
      value['dataRevision'] = (value['dataRevision'] as int? ?? 0) + 1;
    }
    await put('context', 'context', value);
  }
}

class DriftAgentStore extends AgentStore {
  DriftAgentStore(this.db);
  final AppDatabase db;
  @override
  Future<Map<String, dynamic>?> get(String key) async {
    final row = await (db.select(
      db.agentRecords,
    )..where((r) => r.id.equals(key))).getSingleOrNull();
    return row == null ? null : jsonDecode(row.payload) as Map<String, dynamic>;
  }

  @override
  Future<void> put(String key, String kind, Map<String, dynamic> value) async {
    await db
        .into(db.agentRecords)
        .insertOnConflictUpdate(
          AgentRecordsCompanion.insert(
            id: key,
            kind: kind,
            payload: jsonEncode(value),
          ),
        );
  }

  @override
  Future<void> remove(String key) async {
    await (db.delete(db.agentRecords)..where((r) => r.id.equals(key))).go();
  }

  @override
  Future<List<Map<String, dynamic>>> list(String kind) async =>
      (await (db.select(
            db.agentRecords,
          )..where((r) => r.kind.equals(kind))).get())
          .map((r) => jsonDecode(r.payload) as Map<String, dynamic>)
          .toList();
  @override
  Future<T> transaction<T>(Future<T> Function() action) =>
      db.transaction(action);
}

/// Pure Dart fake/default for isolated domain tests. Production always injects Drift.
class InMemoryAgentStore extends AgentStore {
  final _records = <String, (String, Map<String, dynamic>)>{};
  Future<void> _tail = Future.value();
  Map<String, dynamic> _copy(Map<String, dynamic> v) =>
      jsonDecode(jsonEncode(v)) as Map<String, dynamic>;
  @override
  Future<Map<String, dynamic>?> get(String key) async =>
      _records[key] == null ? null : _copy(_records[key]!.$2);
  @override
  Future<void> put(String key, String kind, Map<String, dynamic> value) async {
    _records[key] = (kind, _copy(value));
  }

  @override
  Future<void> remove(String key) async {
    _records.remove(key);
  }

  @override
  Future<List<Map<String, dynamic>>> list(String kind) async => _records.values
      .where((r) => r.$1 == kind)
      .map((r) => _copy(r.$2))
      .toList();
  @override
  Future<T> transaction<T>(Future<T> Function() action) async {
    final previous = _tail;
    final done = Completer<void>();
    _tail = done.future;
    await previous;
    final snapshot = Map.of(_records);
    try {
      return await action();
    } catch (_) {
      _records
        ..clear()
        ..addAll(snapshot);
      rethrow;
    } finally {
      done.complete();
    }
  }
}
