import 'package:shared_preferences/shared_preferences.dart';

/// 键值存储抽象：非敏感设置走 SharedPreferences（docs/04 §1），
/// 测试用内存实现替换（docs/04 §8 可替换性）。
abstract class KeyValueStore {
  String? getString(String key);
  Future<void> setString(String key, String value);
  int? getInt(String key);
  Future<void> setInt(String key, int value);
  double? getDouble(String key);
  Future<void> setDouble(String key, double value);
  bool? getBool(String key);
  Future<void> setBool(String key, bool value);
  Future<void> remove(String key);
}

class SharedPreferencesStore implements KeyValueStore {
  SharedPreferencesStore(this._prefs);

  final SharedPreferences _prefs;

  @override
  String? getString(String key) => _prefs.getString(key);

  @override
  Future<void> setString(String key, String value) =>
      _prefs.setString(key, value);

  @override
  int? getInt(String key) => _prefs.getInt(key);

  @override
  Future<void> setInt(String key, int value) => _prefs.setInt(key, value);

  @override
  double? getDouble(String key) => _prefs.getDouble(key);

  @override
  Future<void> setDouble(String key, double value) =>
      _prefs.setDouble(key, value);

  @override
  bool? getBool(String key) => _prefs.getBool(key);

  @override
  Future<void> setBool(String key, bool value) => _prefs.setBool(key, value);

  @override
  Future<void> remove(String key) => _prefs.remove(key);
}

/// 内存实现（单测 / 纯净启动）。
class InMemoryKeyValueStore implements KeyValueStore {
  final Map<String, Object> _map = {};

  @override
  String? getString(String key) => _map[key] as String?;

  @override
  Future<void> setString(String key, String value) async => _map[key] = value;

  @override
  int? getInt(String key) => _map[key] as int?;

  @override
  Future<void> setInt(String key, int value) async => _map[key] = value;

  @override
  double? getDouble(String key) => _map[key] as double?;

  @override
  Future<void> setDouble(String key, double value) async => _map[key] = value;

  @override
  bool? getBool(String key) => _map[key] as bool?;

  @override
  Future<void> setBool(String key, bool value) async => _map[key] = value;

  @override
  Future<void> remove(String key) async => _map.remove(key);
}

/// 敏感键值抽象：API Key 存 flutter_secure_storage（docs/03 §10）。
abstract class SecureKeyValueStore {
  Future<String?> read(String key);
  Future<void> write(String key, String value);
  Future<void> delete(String key);
}
