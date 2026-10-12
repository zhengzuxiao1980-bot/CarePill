import 'package:drift/drift.dart';

/// upsert 便捷封装：drift 2.35 用 onConflict 表达"存在即更新"。
extension UpsertExtension<T extends Table, D> on InsertStatement<T, D> {
  Future<int> insertOrUpdate(Insertable<D> row) {
    return insert(row, onConflict: DoUpdate((_) => row));
  }
}
