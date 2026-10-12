import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import '../../core/app_logger.dart';
import 'tables.dart';

part 'app_database.g.dart';

/// 应用数据库（docs/04：Drift/SQLite）。
///
/// - schemaVersion 从 1 起步，改表必须 +1 并写迁移 step（docs/04 §11）；
/// - 迁移步骤必须留痕（docs/04 §10 三类必留痕之一）。
@DriftDatabase(
  tables: [
    Medications,
    MedicationSchedules,
    DoseTasks,
    ChatSessions,
    ChatMessages,
    AiModelConfigs,
    MedicationDrafts,
    AgentRecords,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.executor);

  /// 生产入口。
  factory AppDatabase.open() => AppDatabase(driftDatabase(name: 'pillpal'));

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      AppLog.i('数据库创建 schemaVersion=$schemaVersion');
      await m.createAll();
    },
    onUpgrade: (m, from, to) async {
      AppLog.i('数据库迁移 $from → $to');
      if (from < 2) {
        await m.addColumn(chatMessages, chatMessages.sequence);
        await m.addColumn(aiModelConfigs, aiModelConfigs.contextWindowTokens);
        await m.createTable(agentRecords);
        final rows = await customSelect(
          'SELECT id FROM chat_messages ORDER BY created_at, rowid',
        ).get();
        for (var i = 0; i < rows.length; i++) {
          await customStatement(
            'UPDATE chat_messages SET sequence = ? WHERE id = ?',
            [i + 1, rows[i].read<String>('id')],
          );
        }
      }
    },
  );
}
