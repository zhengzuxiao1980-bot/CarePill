import 'dart:convert';
import 'dart:io';

import 'package:uuid/uuid.dart';

import '../../core/app_constants.dart';
import '../../core/exceptions.dart';
import '../../domain/models/ai_model_config.dart';
import '../../domain/models/dose_task.dart';
import '../../domain/models/enums.dart';
import '../../domain/models/medication.dart';
import '../../domain/models/schedule.dart';
import '../repositories/agent_store.dart';
import '../repositories/dose_task_repository.dart';
import '../repositories/medication_repository.dart';
import '../repositories/model_config_repository.dart';
import '../settings/app_settings.dart';
import '../settings/key_value_store.dart';

/// 数据导出 / 导入（docs/02 F10、docs/05 §4）。
///
/// - 单文件 JSON，带 schemaVersion；
/// - **默认不含 API 密钥**（docs/03 §10）；[includeSecrets] 为 true 需 UI 二次确认；
/// - 支持 v1/v2 导入，v1 保留本地显式记忆。
class BackupService {
  BackupService({
    required MedicationRepository medicationRepository,
    required DoseTaskRepository doseTaskRepository,
    required ModelConfigRepository modelConfigRepository,
    required KeyValueStore kv,
    Future<T> Function<T>(Future<T> Function())? transaction,
    AgentStore? agentStore,
    this.contextCutoff,
  }) : _medications = medicationRepository,
       _tasks = doseTaskRepository,
       _models = modelConfigRepository,
       _kv = kv,
       _transaction = transaction,
       _agentStore = agentStore ?? InMemoryAgentStore();

  final MedicationRepository _medications;
  final DoseTaskRepository _tasks;
  final ModelConfigRepository _models;
  final KeyValueStore _kv;
  final Future<T> Function<T>(Future<T> Function())? _transaction;
  final AgentStore _agentStore;
  final Future<int> Function()? contextCutoff;

  Future<Map<String, dynamic>> exportJson({bool includeSecrets = false}) async {
    final meds = await _medications.listAll();
    final schedules = await _medications.allSchedules();
    final configs = await _models.list();
    final tasks = await _tasks.tasksBetween('2000-01-01', '2999-12-31');

    final settings = <String, Object?>{
      SettingKeys.fontTier: _kv.getInt(SettingKeys.fontTier),
      SettingKeys.ttsEnabled: _kv.getBool(SettingKeys.ttsEnabled),
      SettingKeys.ttsRate: _kv.getDouble(SettingKeys.ttsRate),
      SettingKeys.reminderLeadMinutes: _kv.getInt(
        SettingKeys.reminderLeadMinutes,
      ),
      SettingKeys.escalationCount: _kv.getInt(SettingKeys.escalationCount),
      SettingKeys.escalationIntervalMinutes: _kv.getInt(
        SettingKeys.escalationIntervalMinutes,
      ),
      SettingKeys.gracePeriodMinutes: _kv.getInt(
        SettingKeys.gracePeriodMinutes,
      ),
      SettingKeys.chatModelId: _kv.getString(SettingKeys.chatModelId),
      SettingKeys.visionModelId: _kv.getString(SettingKeys.visionModelId),
      SettingKeys.quietStart: _kv.getString(SettingKeys.quietStart),
      SettingKeys.quietEnd: _kv.getString(SettingKeys.quietEnd),
    };

    final modelConfigs = <Map<String, dynamic>>[];
    for (final c in configs) {
      // 使用模型 JSON 的 camelCase 字段，和 AiModelConfig.fromJson 保持一致；
      // 导入仍兼容旧备份里的 created_at。
      final json = c.toJson();
      if (includeSecrets) {
        final key = await _models.apiKeyOf(c.id);
        json['api_key'] = key;
      }
      modelConfigs.add(json);
    }

    return {
      'schema_version': kBackupSchemaVersion,
      'app': 'pillpal',
      'exported_at': DateTime.now().toIso8601String(),
      'includes_secrets': includeSecrets,
      'medications': meds.map(_medToJson).toList(),
      'schedules': schedules.map(_scheduleToJson).toList(),
      'dose_tasks': tasks.map(_taskToJson).toList(),
      'model_configs': modelConfigs,
      'settings': settings,
      'memories': [
        for (final memory in await _agentStore.list('memory'))
          {...memory, 'sourceMessageId': null},
      ],
    };
  }

  Future<File> exportToFile(String path, {bool includeSecrets = false}) async {
    final json = await exportJson(includeSecrets: includeSecrets);
    final file = File(path);
    await file.writeAsString(const JsonEncoder.withIndent('  ').convert(json));
    return file;
  }

  /// 导入：接受 v1/v2；整库覆盖前先校验并保存快照（导出是唯一逃生通道，
  /// 导入属于显式用户操作）。
  Future<void> importJson(Map<String, dynamic> json) async {
    final version = json['schema_version'];
    if (version is int && (version == 1 || version == kBackupSchemaVersion)) {
      // ok
    } else {
      throw ValidationException(
        'schema_version',
        cause: '仅支持 schemaVersion=1 或 $kBackupSchemaVersion 的备份文件',
      );
    }

    // 先完整解析和校验，任何格式错误都不能破坏当前数据。
    final meds = _decodeList(json['medications'], 'medications', _medFromJson);
    final schedules = _decodeList(
      json['schedules'],
      'schedules',
      _scheduleFromJson,
    );
    final tasks = _decodeList(json['dose_tasks'], 'dose_tasks', _taskFromJson);
    final configs = _decodeMapList(json['model_configs'], 'model_configs');
    late final List<AiModelConfig> parsedConfigs;
    try {
      parsedConfigs = configs.map(_configFromJson).toList();
    } catch (e) {
      throw ValidationException('model_configs', cause: e);
    }
    final settingsRaw = json['settings'];
    if (settingsRaw != null && settingsRaw is! Map<String, dynamic>) {
      throw const ValidationException('settings', cause: '必须是 JSON 对象');
    }
    final settings = settingsRaw as Map<String, dynamic>? ?? {};
    final includesSecretsRaw = json['includes_secrets'];
    if (includesSecretsRaw != null && includesSecretsRaw is! bool) {
      throw const ValidationException('includes_secrets', cause: '必须是布尔值');
    }
    for (final config in configs) {
      final key = config['api_key'];
      if (key != null && key is! String) {
        throw const ValidationException(
          'model_configs.api_key',
          cause: '必须是字符串',
        );
      }
    }

    _validateReferences(meds, schedules, tasks, parsedConfigs);
    _validateSettings(settings);
    if (version == 2 && json['memories'] is! List) {
      throw const ValidationException(
        'memories',
        cause: 'v2 requires an explicit memories array',
      );
    }
    final memories = version == 1
        ? null
        : _decodeMapList(json['memories'], 'memories');
    if (memories != null) {
      final ids = <String>{};
      for (final m in memories) {
        if (m['id'] is! String ||
            (m['id'] as String).isEmpty ||
            !ids.add(m['id'] as String) ||
            m['content'] is! String ||
            (m['content'] as String).trim().isEmpty ||
            (m['content'] as String).length > 2000 ||
            m['sourceText'] is! String ||
            m['createdAt'] is! String ||
            m['updatedAt'] is! String ||
            DateTime.tryParse(m['createdAt'] as String) == null ||
            DateTime.tryParse(m['updatedAt'] as String) == null) {
          throw const ValidationException('memories');
        }
      }
    }

    final existingConfigs = await _models.list();
    final existingKeys = <String, String?>{
      for (final config in existingConfigs)
        config.id: await _models.apiKeyOf(config.id),
    };
    final incomingIds = configs.map((c) => c['id']).whereType<String>().toSet();

    final snapshot = await _captureSnapshot(existingConfigs);
    Future<void> apply() async {
      await _clearForImport();

      for (final m in meds) {
        await _medications.save(m);
      }
      for (final s in schedules) {
        await _medications.saveSchedule(s);
      }
      await _tasks.upsertMissing(tasks);
      // 备份是覆盖操作：删除备份中不存在的配置与密钥；同 ID 且备份未带
      // 密钥时保留本机密钥，避免普通备份恢复后 AI 突然失效。
      for (final existing in existingConfigs) {
        if (!incomingIds.contains(existing.id)) {
          await _models.delete(existing.id);
        }
      }
      final includesSecrets = json['includes_secrets'] == true;
      for (var i = 0; i < configs.length; i++) {
        final c = configs[i];
        final config = parsedConfigs[i];
        final rawKey = c['api_key'];
        final apiKey = rawKey is String
            ? rawKey
            : includesSecrets
            ? ''
            : existingKeys[config.id];
        await _models.save(config, apiKey: apiKey);
      }
      await _clearRestorableSettings();
      for (final entry in settings.entries) {
        await _restoreSetting(entry.key, entry.value);
      }
      if (memories != null) {
        for (final m in await _agentStore.list('memory')) {
          await _agentStore.remove('memory:${m['id']}');
        }
        for (final m in memories) {
          await _agentStore.put('memory:${m['id']}', 'memory', {
            ...m,
            'sourceMessageId': null,
          });
        }
      }
      await _agentStore.resetContext(
        cutoff: await contextCutoff?.call() ?? 0,
        restored: true,
      );
    }

    try {
      if (_transaction != null) {
        await _transaction<void>(apply);
      } else {
        await apply();
      }
    } catch (_) {
      // 仓库接口可被内存 fake 替换；统一用同一套快照回滚语义，确保任一
      // 写入失败都不会留下“半套导入”。Drift 实现的单表清空本身仍在事务中。
      await _restoreSnapshot(snapshot);
      rethrow;
    }
  }

  Future<_BackupSnapshot> _captureSnapshot(List<AiModelConfig> configs) async {
    final settings = <String, Object?>{
      for (final key in _restorableSettingKeys) key: _readSetting(key),
    };
    return _BackupSnapshot(
      memories: await _agentStore.list('memory'),
      context: await _agentStore.get('context'),
      medications: await _medications.listAll(),
      schedules: await _medications.allSchedules(),
      tasks: await _tasks.tasksBetween('0000-01-01', '9999-12-31'),
      configs: configs,
      keys: {
        for (final config in configs)
          config.id: await _models.apiKeyOf(config.id),
      },
      settings: settings,
    );
  }

  Future<void> _restoreSnapshot(_BackupSnapshot snapshot) async {
    await _tasks.clearAll();
    await _medications.clearAll();
    for (final medication in snapshot.medications) {
      await _medications.save(medication);
    }
    for (final schedule in snapshot.schedules) {
      await _medications.saveSchedule(schedule);
    }
    for (final config in await _models.list()) {
      await _models.delete(config.id);
    }
    for (final config in snapshot.configs) {
      await _models.save(config, apiKey: snapshot.keys[config.id]);
    }
    await _clearRestorableSettings();
    for (final entry in snapshot.settings.entries) {
      final value = entry.value;
      if (value != null) {
        await _restoreSetting(entry.key, value);
      }
    }
    await _tasks.upsertMissing(snapshot.tasks);
    for (final m in await _agentStore.list('memory')) {
      await _agentStore.remove('memory:${m['id']}');
    }
    for (final m in snapshot.memories) {
      await _agentStore.put('memory:${m['id']}', 'memory', m);
    }
    if (snapshot.context == null) {
      await _agentStore.remove('context');
    } else {
      await _agentStore.put('context', 'context', snapshot.context!);
    }
  }

  /// 清空旧数据（顺序：任务→计划→药品）。
  Future<void> _clearForImport() async {
    await _tasks.clearAll();
    await _medications.clearAll();
  }

  Future<void> _clearRestorableSettings() async {
    for (final key in _restorableSettingKeys) {
      await _kv.remove(key);
    }
  }

  /// 只接受已知键，按原类型恢复，避免脏数据写坏设置。
  static const Set<String> _restorableSettingKeys = {
    SettingKeys.fontTier,
    SettingKeys.ttsEnabled,
    SettingKeys.ttsRate,
    SettingKeys.reminderLeadMinutes,
    SettingKeys.escalationCount,
    SettingKeys.escalationIntervalMinutes,
    SettingKeys.gracePeriodMinutes,
    SettingKeys.chatModelId,
    SettingKeys.visionModelId,
    SettingKeys.quietStart,
    SettingKeys.quietEnd,
  };

  Future<void> _restoreSetting(String key, Object? value) async {
    if (!_restorableSettingKeys.contains(key) || value == null) {
      return;
    }
    if (key == SettingKeys.ttsRate && value is num) {
      await _kv.setDouble(key, value.toDouble());
    } else if (value is int) {
      await _kv.setInt(key, value);
    } else if (value is bool) {
      await _kv.setBool(key, value);
    } else if (value is double) {
      await _kv.setDouble(key, value);
    } else if (value is String) {
      await _kv.setString(key, value);
    }
  }

  Object? _readSetting(String key) {
    for (final read in <Object? Function()>[
      () => _kv.getString(key),
      () => _kv.getInt(key),
      () => _kv.getDouble(key),
      () => _kv.getBool(key),
    ]) {
      try {
        final value = read();
        if (value != null) {
          return value;
        }
      } on TypeError {
        // InMemoryKeyValueStore 的不同类型读取会抛 TypeError，继续探测。
      }
    }
    return null;
  }

  void _validateReferences(
    List<Medication> medications,
    List<MedicationSchedule> schedules,
    List<DoseTask> tasks,
    List<AiModelConfig> configs,
  ) {
    _ensureUnique(medications.map((m) => m.id), 'medications.id');
    _ensureUnique(schedules.map((s) => s.id), 'schedules.id');
    _ensureUnique(tasks.map((t) => t.id), 'dose_tasks.id');
    _ensureUnique(configs.map((c) => c.id), 'model_configs.id');
    for (final config in configs) {
      config.validateBudget();
    }
    final medicationIds = medications.map((m) => m.id).toSet();
    final scheduleIds = schedules.map((s) => s.id).toSet();
    for (final schedule in schedules) {
      if (!medicationIds.contains(schedule.medicationId)) {
        throw ValidationException(
          'schedules.medication_id',
          cause: '找不到药品 ${schedule.medicationId}',
        );
      }
    }
    for (final task in tasks) {
      if (!medicationIds.contains(task.medicationId) ||
          !scheduleIds.contains(task.scheduleId)) {
        throw ValidationException('dose_tasks', cause: '任务关联的药品或计划不存在');
      }
    }
  }

  void _ensureUnique(Iterable<String> ids, String field) {
    final seen = <String>{};
    for (final id in ids) {
      if (id.trim().isEmpty || !seen.add(id)) {
        throw ValidationException(field, cause: 'ID 为空或重复');
      }
    }
  }

  void _validateSettings(Map<String, dynamic> settings) {
    for (final entry in settings.entries) {
      if (!_restorableSettingKeys.contains(entry.key)) {
        continue;
      }
      final value = entry.value;
      // 导出文件会保留尚未设置的可选项为 null；导入时先清除旧值即可。
      if (value == null) {
        continue;
      }
      final valid = switch (entry.key) {
        SettingKeys.fontTier ||
        SettingKeys.reminderLeadMinutes ||
        SettingKeys.escalationCount ||
        SettingKeys.escalationIntervalMinutes ||
        SettingKeys.gracePeriodMinutes => value is int,
        SettingKeys.ttsEnabled => value is bool,
        SettingKeys.ttsRate => value is num,
        SettingKeys.chatModelId ||
        SettingKeys.visionModelId ||
        SettingKeys.quietStart ||
        SettingKeys.quietEnd => value is String,
        _ => false,
      };
      if (!valid) {
        throw ValidationException(entry.key, cause: '设置类型不正确');
      }
    }
  }

  List<T> _decodeList<T>(
    Object? raw,
    String field,
    T Function(Map<String, dynamic>) decode,
  ) {
    if (raw == null) {
      return <T>[];
    }
    if (raw is! List) {
      throw ValidationException(field, cause: '必须是 JSON 数组');
    }
    try {
      return raw.map((e) {
        if (e is! Map<String, dynamic>) {
          throw ValidationException(field, cause: '数组元素必须是 JSON 对象');
        }
        return decode(e);
      }).toList();
    } on ValidationException {
      rethrow;
    } catch (e) {
      throw ValidationException(field, cause: e);
    }
  }

  List<Map<String, dynamic>> _decodeMapList(Object? raw, String field) {
    if (raw == null) {
      return <Map<String, dynamic>>[];
    }
    if (raw is! List) {
      throw ValidationException(field, cause: '必须是 JSON 数组');
    }
    return raw.map((e) {
      if (e is! Map<String, dynamic>) {
        throw ValidationException(field, cause: '数组元素必须是 JSON 对象');
      }
      return e;
    }).toList();
  }

  Future<void> importFromFile(String path) async {
    final text = await File(path).readAsString();
    final json = jsonDecode(text);
    if (json is Map<String, dynamic>) {
      await importJson(json);
    } else {
      throw const ValidationException('file', cause: '不是合法的备份文件');
    }
  }

  // ---- JSON 映射（与 Drift 行映射口径一致） ----

  Map<String, dynamic> _medToJson(Medication m) => {
    'id': m.id,
    'name': m.name,
    'form': m.form.json,
    'spec': m.spec,
    'dose_unit': m.doseUnit,
    'notes': m.notes,
    'photo_path': m.photoPath,
    'source': m.source.json,
    'ai_extract_json': m.aiExtractJson,
    'status': m.status.json,
    'created_at': m.createdAt.millisecondsSinceEpoch,
    'updated_at': m.updatedAt.millisecondsSinceEpoch,
  };

  Medication _medFromJson(Map<String, dynamic> j) => Medication(
    id: j['id'] as String,
    name: j['name'] as String,
    form: MedicationForm.values.firstWhere(
      (e) => e.json == j['form'],
      orElse: () => MedicationForm.other,
    ),
    spec: j['spec'] as String?,
    doseUnit: j['dose_unit'] as String? ?? '片',
    notes: j['notes'] as String?,
    photoPath: j['photo_path'] as String?,
    source: MedicationSource.values.firstWhere(
      (e) => e.json == j['source'],
      orElse: () => MedicationSource.manual,
    ),
    aiExtractJson: j['ai_extract_json'] as String?,
    status: MedicationStatus.values.firstWhere(
      (e) => e.json == j['status'],
      orElse: () => MedicationStatus.active,
    ),
    createdAt: DateTime.fromMillisecondsSinceEpoch(j['created_at'] as int),
    updatedAt: DateTime.fromMillisecondsSinceEpoch(j['updated_at'] as int),
  );

  Map<String, dynamic> _scheduleToJson(MedicationSchedule s) => {
    'id': s.id,
    'medication_id': s.medicationId,
    'frequency_type': s.frequencyType.json,
    'weekdays': s.weekdays?.join(','),
    'interval_days': s.intervalDays,
    'anchor_date': s.anchorDate,
    'times': s.times.map((t) => t.toJson()).toList(),
    'meal_relation': s.mealRelation?.json,
    'start_date': s.startDate,
    'end_date': s.endDate,
    'status': s.status.json,
    'created_at': s.createdAt.millisecondsSinceEpoch,
  };

  MedicationSchedule _scheduleFromJson(Map<String, dynamic> j) =>
      MedicationSchedule(
        id: j['id'] as String,
        medicationId: j['medication_id'] as String,
        frequencyType: FrequencyType.values.firstWhere(
          (e) => e.json == j['frequency_type'],
          orElse: () => FrequencyType.daily,
        ),
        weekdays: (j['weekdays'] as String?)
            ?.split(',')
            .where((e) => e.isNotEmpty)
            .map(int.parse)
            .toList(),
        intervalDays: j['interval_days'] as int?,
        anchorDate: j['anchor_date'] as String?,
        times: (j['times'] as List<dynamic>? ?? const [])
            .map((e) => TimeSlot.fromJson(e as Map<String, dynamic>))
            .toList(),
        mealRelation: j['meal_relation'] == null
            ? null
            : MealRelation.values.firstWhere(
                (e) => e.json == j['meal_relation'],
                orElse: () => MealRelation.after,
              ),
        startDate: j['start_date'] as String,
        endDate: j['end_date'] as String?,
        status: ScheduleStatus.values.firstWhere(
          (e) => e.json == j['status'],
          orElse: () => ScheduleStatus.active,
        ),
        createdAt: DateTime.fromMillisecondsSinceEpoch(j['created_at'] as int),
      );

  Map<String, dynamic> _taskToJson(DoseTask t) => {
    'id': t.id,
    'schedule_id': t.scheduleId,
    'medication_id': t.medicationId,
    'scheduled_date': t.scheduledDate,
    'scheduled_time': t.scheduledTime,
    'planned_dose': t.plannedDose,
    'status': t.status.json,
    'taken_at': t.takenAt,
    'mark_source': t.markSource?.json,
    'note': t.note,
  };

  DoseTask _taskFromJson(Map<String, dynamic> j) => DoseTask(
    id: j['id'] as String,
    scheduleId: j['schedule_id'] as String,
    medicationId: j['medication_id'] as String,
    scheduledDate: j['scheduled_date'] as String,
    scheduledTime: j['scheduled_time'] as String,
    plannedDose: (j['planned_dose'] as num).toDouble(),
    status: DoseStatus.values.firstWhere(
      (e) => e.json == j['status'],
      orElse: () => DoseStatus.pending,
    ),
    takenAt: j['taken_at'] as int?,
    markSource: j['mark_source'] == null
        ? null
        : MarkSource.values.firstWhere(
            (e) => e.json == j['mark_source'],
            orElse: () => MarkSource.tap,
          ),
    note: j['note'] as String?,
  );

  AiModelConfig _configFromJson(Map<String, dynamic> j) {
    final json = Map<String, dynamic>.from(j);
    json['createdAt'] =
        (j['createdAt'] as String?) ??
        (j['created_at'] is int
            ? DateTime.fromMillisecondsSinceEpoch(j['created_at'] as int)
                  .toIso8601String()
            : DateTime.now().toIso8601String());
    return AiModelConfig.fromJson(json);
  }
}

class _BackupSnapshot {
  const _BackupSnapshot({
    required this.medications,
    required this.schedules,
    required this.tasks,
    required this.configs,
    required this.keys,
    required this.settings,
    required this.memories,
    required this.context,
  });

  final List<Medication> medications;
  final List<MedicationSchedule> schedules;
  final List<DoseTask> tasks;
  final List<AiModelConfig> configs;
  final Map<String, String?> keys;
  final Map<String, Object?> settings;
  final List<Map<String, dynamic>> memories;
  final Map<String, dynamic>? context;
}

/// 生成本地导出文件名。
String backupFileName(DateTime now) =>
    'pillpal-backup-${now.toIso8601String().substring(0, 10)}.json';

/// 新 id 生成（备份/草稿复用）。
String newId() => const Uuid().v4();
