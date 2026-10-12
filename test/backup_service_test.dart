import 'package:care_pill/core/app_constants.dart';
import 'package:care_pill/core/exceptions.dart';
import 'package:care_pill/data/backup/backup_service.dart';
import 'package:care_pill/data/settings/app_settings.dart';
import 'package:care_pill/data/settings/key_value_store.dart';
import 'package:care_pill/domain/models/ai_model_config.dart';
import 'package:care_pill/domain/models/dose_task.dart';
import 'package:care_pill/domain/models/enums.dart';
import 'package:care_pill/domain/models/medication.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fakes/fakes.dart';

void main() {
  late InMemoryMedicationRepository medRepo;
  late InMemoryDoseTaskRepository taskRepo;
  late InMemoryModelConfigRepository modelRepo;
  late InMemoryKeyValueStore kv;

  setUp(() {
    medRepo = InMemoryMedicationRepository();
    taskRepo = InMemoryDoseTaskRepository();
    modelRepo = InMemoryModelConfigRepository();
    kv = InMemoryKeyValueStore();
  });

  BackupService buildService() => BackupService(
    medicationRepository: medRepo,
    doseTaskRepository: taskRepo,
    modelConfigRepository: modelRepo,
    kv: kv,
  );

  test('导出：schemaVersion + 药品/计划/任务/设置，默认不含密钥', () async {
    final now = DateTime(2026, 9, 28);
    await medRepo.save(
      Medication(
        id: 'm1',
        name: '降压药',
        form: MedicationForm.tablet,
        doseUnit: '片',
        source: MedicationSource.manual,
        status: MedicationStatus.active,
        createdAt: now,
        updatedAt: now,
      ),
    );
    await modelRepo.save(
      AiModelConfig(
        id: 'c1',
        name: 'deepseek',
        baseUrl: 'https://api.deepseek.com',
        modelId: 'deepseek-flash',
        usage: ModelUsage.chat,
        createdAt: now,
      ),
      apiKey: 'sk-secret',
    );
    await kv.setInt(SettingKeys.fontTier, 2);

    final json = await buildService().exportJson();
    expect(json['schema_version'], kBackupSchemaVersion);
    expect((json['medications'] as List), hasLength(1));
    expect((json['model_configs'] as List).first, isNot(contains('api_key')));
    expect((json['settings'] as Map)[SettingKeys.fontTier], 2);

    final withSecrets = await buildService().exportJson(includeSecrets: true);
    expect(
      ((withSecrets['model_configs'] as List).first
          as Map<String, dynamic>)['api_key'],
      'sk-secret',
    );
  });

  test('导入 v2：数据回读一致', () async {
    final now = DateTime(2026, 9, 28);
    final json = {
      'schema_version': kBackupSchemaVersion,
      'memories': <Map<String, dynamic>>[],
      'medications': [
        {
          'id': 'm1',
          'name': '降糖药',
          'form': 'tablet',
          'dose_unit': '片',
          'source': 'manual',
          'status': 'active',
          'created_at': now.millisecondsSinceEpoch,
          'updated_at': now.millisecondsSinceEpoch,
        },
      ],
      'schedules': [
        {
          'id': 's1',
          'medication_id': 'm1',
          'frequency_type': 'daily',
          'times_json': '[{"time":"08:00","dose":1.0}]',
          'times': <Map<String, Object>>[
            {'time': '08:00', 'dose': 1.0},
          ],
          'start_date': '2026-09-01',
          'status': 'active',
          'created_at': now.millisecondsSinceEpoch,
        },
      ],
      'dose_tasks': [
        {
          'id': 's1|2026-09-28|08:00',
          'schedule_id': 's1',
          'medication_id': 'm1',
          'scheduled_date': '2026-09-28',
          'scheduled_time': '08:00',
          'planned_dose': 1.0,
          'status': 'taken',
          'taken_at': now.millisecondsSinceEpoch,
        },
      ],
      'model_configs': <dynamic>[],
      'settings': {SettingKeys.fontTier: 0, SettingKeys.ttsEnabled: false},
    };
    await buildService().importJson(json);

    final meds = await medRepo.listAll();
    expect(meds.single.name, '降糖药');
    final schedules = await medRepo.allSchedules();
    expect(schedules.single.times.single.time, '08:00');
    final tasks = await taskRepo.tasksForDate('2026-09-28');
    expect(tasks.single.isTaken, isTrue);
    expect(kv.getInt(SettingKeys.fontTier), 0);
    expect(kv.getBool(SettingKeys.ttsEnabled), isFalse);
  });

  test('导入：版本不符拒绝（docs/05 §4 v1 仅同版本）', () async {
    await expectLater(
      buildService().importJson({'schema_version': 999}),
      throwsA(isA<ValidationException>()),
    );
  });

  test('导入：未知设置键被忽略（防脏数据）', () async {
    await buildService().importJson({
      'schema_version': kBackupSchemaVersion,
      'memories': <Map<String, dynamic>>[],
      'settings': {'hacker.key': 'x'},
    });
    expect(kv.getString('hacker.key'), isNull);
  });

  test('导入覆盖模型并保留同 ID 本机密钥，删除残留配置', () async {
    final now = DateTime(2026, 9, 28);
    final keep = AiModelConfig(
      id: 'keep',
      name: '新名字',
      baseUrl: 'https://example.com/v1',
      modelId: 'model',
      usage: ModelUsage.chat,
      createdAt: now,
    );
    await modelRepo.save(keep.copyWith(name: '旧名字'), apiKey: 'local-secret');
    await modelRepo.save(
      keep.copyWith(id: 'stale', name: '残留'),
      apiKey: 'stale-secret',
    );

    await buildService().importJson({
      'schema_version': kBackupSchemaVersion,
      'memories': <Map<String, dynamic>>[],
      'model_configs': [keep.toJson()..remove('createdAt')],
      'includes_secrets': false,
    });

    expect((await modelRepo.get('keep'))!.name, '新名字');
    expect(await modelRepo.apiKeyOf('keep'), 'local-secret');
    expect(await modelRepo.get('stale'), isNull);
    expect(await modelRepo.apiKeyOf('stale'), isNull);
  });

  test('损坏备份在清空前拒绝，原有数据保持不变', () async {
    final now = DateTime(2026, 9, 28);
    await medRepo.save(
      Medication(
        id: 'existing',
        name: '原有药',
        form: MedicationForm.tablet,
        doseUnit: '片',
        source: MedicationSource.manual,
        status: MedicationStatus.active,
        createdAt: now,
        updatedAt: now,
      ),
    );

    await expectLater(
      buildService().importJson({
        'schema_version': kBackupSchemaVersion,
        'memories': <Map<String, dynamic>>[],
        'medications': [
          {
            'id': 'incoming',
            'name': '新药',
            'form': 'tablet',
            'dose_unit': '片',
            'source': 'manual',
            'status': 'active',
            'created_at': now.millisecondsSinceEpoch,
            'updated_at': now.millisecondsSinceEpoch,
          },
        ],
        'schedules': [
          {
            'id': 'bad-schedule',
            'medication_id': 'missing-medication',
            'frequency_type': 'daily',
            'times': <Map<String, Object>>[
              {'time': '08:00', 'dose': 1.0},
            ],
            'start_date': '2026-09-01',
            'status': 'active',
            'created_at': now.millisecondsSinceEpoch,
          },
        ],
      }),
      throwsA(isA<ValidationException>()),
    );
    expect((await medRepo.get('existing'))!.name, '原有药');
  });
}
