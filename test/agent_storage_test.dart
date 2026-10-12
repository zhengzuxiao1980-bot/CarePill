import 'dart:io';

import 'package:care_pill/data/backup/backup_service.dart';
import 'package:care_pill/data/db/app_database.dart';
import 'package:care_pill/data/repositories/agent_store.dart';
import 'package:care_pill/data/repositories/chat_repository.dart';
import 'package:care_pill/data/settings/key_value_store.dart';
import 'package:care_pill/domain/models/chat_message.dart';
import 'package:care_pill/domain/models/enums.dart';
import 'package:care_pill/domain/services/memory_service.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fakes/fakes.dart';

void main() {
  test('v1 database migrates in place; tied timestamps preserve insertion order and records', () async {
    final dir = await Directory.systemTemp.createTemp('carepill-migration-');
    final file = File('${dir.path}/old.sqlite');
    var db = AppDatabase(NativeDatabase(file));
    try {
      await db.customSelect('SELECT 1 FROM chat_messages').get();
      await db.customStatement('DROP TABLE agent_records');
      await db.customStatement(
        'ALTER TABLE chat_messages DROP COLUMN sequence',
      );
      await db.customStatement(
        'ALTER TABLE ai_model_configs DROP COLUMN context_window_tokens',
      );
      await db.customStatement("INSERT INTO chat_sessions VALUES ('main', 1)");
      await db.customStatement(
        "INSERT INTO chat_messages (id,session_id,role,content,created_at) VALUES ('z','main','user','first',100),('a','main','assistant','second',100)",
      );
      await db.customStatement(
        "INSERT INTO medications (id,name,form,dose_unit,source,status,created_at,updated_at) VALUES ('med','existing medicine','tablet','pill','manual','active',1,1)",
      );
      await db.customStatement('PRAGMA user_version = 1');
      await db.close();
      db = AppDatabase(NativeDatabase(file));
      final chat = DriftChatRepository(db);
      final rows = await chat.recent();
      expect(rows.map((m) => m.content), ['first', 'second']);
      expect(rows.map((m) => m.sequence), [1, 2]);
      expect(
        (await db.customSelect('SELECT name FROM medications').getSingle())
            .read<String>('name'),
        'existing medicine',
      );
      await chat.append(
        ChatMessage(
          id: 'third',
          sessionId: 'main',
          role: ChatRole.user,
          content: 'third',
          createdAt: DateTime.fromMillisecondsSinceEpoch(100),
        ),
      );
      await chat.append(
        ChatMessage(
          id: 'third',
          sessionId: 'main',
          role: ChatRole.user,
          content: 'duplicate',
          createdAt: DateTime.now(),
        ),
      );
      expect((await chat.recent()).map((m) => m.content), [
        'first',
        'second',
        'third',
      ]);
      await DriftAgentStore(db)
          .put('memory:test', 'memory', {'content': 'persistent'});
      await db.close();
      db = AppDatabase(NativeDatabase(file));
      expect(
        (await DriftAgentStore(db).get('memory:test'))!['content'],
        'persistent',
      );
    } finally {
      await db.close();
      await dir.delete(recursive: true);
    }
  });
  test(
    'operation transaction rolls domain mutation and journal back together',
    () async {
      final db = AppDatabase(NativeDatabase.memory());
      final store = DriftAgentStore(db);
      try {
        await expectLater(
          store.transaction(() async {
            await db.customStatement(
              "INSERT INTO chat_sessions VALUES ('rollback',1)",
            );
            await store.put('op:test', 'operation', {'committed': true});
            throw StateError('cancelled before commit');
          }),
          throwsStateError,
        );
        expect(await store.get('op:test'), isNull);
        expect(
          await db
              .customSelect("SELECT * FROM chat_sessions WHERE id='rollback'")
              .get(),
          isEmpty,
        );
      } finally {
        await db.close();
      }
    },
  );
  test('v2 backup exports memories; v1 preserves local memory; invalid import is non-destructive', () async {
    final store = InMemoryAgentStore();
    final memory = MemoryService(store);
    final service = BackupService(
      medicationRepository: InMemoryMedicationRepository(),
      doseTaskRepository: InMemoryDoseTaskRepository(),
      modelConfigRepository: InMemoryModelConfigRepository(),
      kv: InMemoryKeyValueStore(),
      agentStore: store,
      contextCutoff: () async => 10,
    );
    await memory.save(
      '请用短句回答',
      sourceMessageId: 'u:private',
      sourceText: '请记住：请用短句回答',
    );
    final backup = await service.exportJson();
    expect(backup['schema_version'], 2);
    expect(
      ((backup['memories'] as List).single
          as Map<String, dynamic>)['sourceMessageId'],
      isNull,
    );
    final incomplete = Map<String, dynamic>.of(backup)..remove('memories');
    await expectLater(service.importJson(incomplete), throwsA(anything));
    expect(await memory.all(), hasLength(1));
    await memory.deleteAll();
    await service.importJson(backup);
    expect((await memory.all()).single['content'], '请用短句回答');
    expect((await store.context())['cutoff'], 10);
    final legacy = Map<String, dynamic>.from(backup)
      ..['schema_version'] = 1
      ..remove('memories');
    await service.importJson(legacy);
    expect(await memory.all(), hasLength(1));
    final invalid = Map<String, dynamic>.from(backup)
      ..['memories'] = [
        {'id': 'broken'},
      ];
    await expectLater(service.importJson(invalid), throwsA(isA<Exception>()));
    expect(await memory.all(), hasLength(1));
  });
}
