import 'package:drift/drift.dart';

/// 全部表定义，与 docs/05 §2 一一对应。
///
/// api_key 不入 Drift（docs/05：以 config.id 为键存 flutter_secure_storage）。

@DataClassName('MedicationRow')
class Medications extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get form => text()();
  TextColumn get spec => text().nullable()();
  TextColumn get doseUnit => text()();
  TextColumn get notes => text().nullable()();
  TextColumn get photoPath => text().nullable()();
  TextColumn get source => text()();
  TextColumn get aiExtractJson => text().nullable()();
  TextColumn get status => text()();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('ScheduleRow')
class MedicationSchedules extends Table {
  TextColumn get id => text()();
  TextColumn get medicationId => text()();
  TextColumn get frequencyType => text()();
  TextColumn get weekdays => text().nullable()();
  IntColumn get intervalDays => integer().nullable()();
  TextColumn get anchorDate => text().nullable()();
  TextColumn get timesJson => text()();
  TextColumn get mealRelation => text().nullable()();
  TextColumn get startDate => text()();
  TextColumn get endDate => text().nullable()();
  TextColumn get status => text()();
  IntColumn get createdAt => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('DoseTaskRow')
@TableIndex(
  name: 'idx_tasks_date_time',
  columns: {#scheduledDate, #scheduledTime},
)
@TableIndex(
  name: 'idx_tasks_med_date',
  columns: {#medicationId, #scheduledDate},
)
class DoseTasks extends Table {
  TextColumn get id => text()();
  TextColumn get scheduleId => text()();
  TextColumn get medicationId => text()();
  TextColumn get scheduledDate => text()();
  TextColumn get scheduledTime => text()();
  RealColumn get plannedDose => real()();
  TextColumn get status => text()();
  IntColumn get takenAt => integer().nullable()();
  TextColumn get markSource => text().nullable()();
  TextColumn get note => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('ChatSessionRow')
class ChatSessions extends Table {
  TextColumn get id => text()();
  IntColumn get createdAt => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('ChatMessageRow')
class ChatMessages extends Table {
  IntColumn get sequence => integer().withDefault(const Constant(0))();
  TextColumn get id => text()();
  TextColumn get sessionId => text()();
  TextColumn get role => text()();
  TextColumn get content => text()();
  TextColumn get toolName => text().nullable()();
  TextColumn get toolPayload => text().nullable()();
  IntColumn get createdAt => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('ModelConfigRow')
class AiModelConfigs extends Table {
  IntColumn get contextWindowTokens =>
      integer().withDefault(const Constant(8192))();
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get baseUrl => text()();
  TextColumn get modelId => text()();
  BoolColumn get supportsChat => boolean().withDefault(const Constant(true))();
  BoolColumn get supportsVision =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get supportsFunctionCalling =>
      boolean().withDefault(const Constant(false))();
  RealColumn get temperature => real().nullable()();
  IntColumn get maxTokens => integer().nullable()();
  TextColumn get usage => text()();
  BoolColumn get isChatDefault =>
      boolean().withDefault(const Constant(false))();
  IntColumn get createdAt => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

class AgentRecords extends Table {
  TextColumn get id => text()();
  TextColumn get kind => text()();
  TextColumn get payload => text()();
  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('DraftRow')
class MedicationDrafts extends Table {
  TextColumn get id => text()();
  TextColumn get source => text()();
  TextColumn get payloadJson => text()();
  TextColumn get photoPath => text().nullable()();
  TextColumn get status => text()();
  IntColumn get createdAt => integer()();

  @override
  Set<Column> get primaryKey => {id};
}
