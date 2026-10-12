import 'package:drift/drift.dart';

import '../../domain/models/ai_model_config.dart';
import '../../domain/models/enums.dart';
import '../db/app_database.dart';
import '../db/upsert.dart';
import '../settings/key_value_store.dart';

abstract class ModelConfigRepository {
  Future<List<AiModelConfig>> list();
  Future<AiModelConfig?> get(String id);

  /// [apiKey] 非 null 时写入 secure storage；null 不动原值；空串删除。
  Future<void> save(AiModelConfig config, {String? apiKey});

  Future<void> delete(String id);
  Future<String?> apiKeyOf(String id);

  /// 设为"对话默认"（其余配置取消默认，docs/03 §2 多配置规则）。
  Future<void> setChatDefault(String id);
}

class DriftModelConfigRepository implements ModelConfigRepository {
  DriftModelConfigRepository(this._db, this._secure);

  final AppDatabase _db;
  final SecureKeyValueStore _secure;

  static String _keyOf(String configId) => 'model_api_key.$configId';

  static AiModelConfig rowToConfig(ModelConfigRow r) => AiModelConfig(
    id: r.id,
    name: r.name,
    baseUrl: r.baseUrl,
    modelId: r.modelId,
    supportsChat: r.supportsChat,
    supportsVision: r.supportsVision,
    supportsFunctionCalling: r.supportsFunctionCalling,
    temperature: r.temperature,
    maxTokens: r.maxTokens,
    contextWindowTokens: r.contextWindowTokens,
    usage: ModelUsage.values.firstWhere(
      (e) => e.json == r.usage,
      orElse: () => ModelUsage.chat,
    ),
    isChatDefault: r.isChatDefault,
    createdAt: DateTime.fromMillisecondsSinceEpoch(r.createdAt),
  );

  @override
  Future<List<AiModelConfig>> list() async {
    final rows = await (_db.select(
      _db.aiModelConfigs,
    )..orderBy([(c) => OrderingTerm.desc(c.createdAt)])).get();
    return rows.map(rowToConfig).toList();
  }

  @override
  Future<AiModelConfig?> get(String id) async {
    final row = await (_db.select(
      _db.aiModelConfigs,
    )..where((c) => c.id.equals(id))).getSingleOrNull();
    return row == null ? null : rowToConfig(row);
  }

  @override
  Future<void> save(AiModelConfig config, {String? apiKey}) async {
    config.validateBudget();
    await _db
        .into(_db.aiModelConfigs)
        .insertOrUpdate(
          AiModelConfigsCompanion.insert(
            id: config.id,
            name: config.name,
            baseUrl: config.baseUrl,
            modelId: config.modelId,
            supportsChat: Value(config.supportsChat),
            supportsVision: Value(config.supportsVision),
            supportsFunctionCalling: Value(config.supportsFunctionCalling),
            temperature: Value(config.temperature),
            maxTokens: Value(config.maxTokens),
            contextWindowTokens: Value(config.contextWindowTokens),
            usage: config.usage.json,
            isChatDefault: Value(config.isChatDefault),
            createdAt: config.createdAt.millisecondsSinceEpoch,
          ),
        );
    final key = _keyOf(config.id);
    if (apiKey != null) {
      if (apiKey.isEmpty) {
        await _secure.delete(key);
      } else {
        await _secure.write(key, apiKey);
      }
    }
    if (config.isChatDefault) {
      await setChatDefault(config.id);
    }
  }

  @override
  Future<void> delete(String id) async {
    await (_db.delete(_db.aiModelConfigs)..where((c) => c.id.equals(id))).go();
    await _secure.delete(_keyOf(id));
  }

  @override
  Future<String?> apiKeyOf(String id) => _secure.read(_keyOf(id));

  @override
  Future<void> setChatDefault(String id) async {
    await _db.transaction(() async {
      await _db.customStatement(
        'UPDATE ai_model_configs SET is_chat_default = 0',
      );
      await (_db.update(_db.aiModelConfigs)..where((c) => c.id.equals(id)))
          .write(const AiModelConfigsCompanion(isChatDefault: Value(true)));
    });
  }
}
