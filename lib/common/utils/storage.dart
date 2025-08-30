import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// kv离线存储
class Storage {
  // 单例写法
  static final Storage _instance = Storage._internal();

  factory Storage() => _instance;
  

  late final FlutterSecureStorage _storage;

  Storage._internal();

  Future<void> init() async {
    _storage = FlutterSecureStorage();
  }

  Future setJson(String key, Object value) async {
    await _storage.write(
      key: key, 
      value: jsonEncode(value),
      aOptions: _getAndroidOptions()
    );
  }

  Future setString(String key, String value) async {
    await _storage.write(
      key: key, 
      value: value,
      aOptions: _getAndroidOptions()
    );
  }

  Future setBool(String key, bool value) async {
    await _storage.write(
      key: key, 
      value: value.toString(),
      aOptions: _getAndroidOptions()
    );
  }

  Future<String> getString(String key) async {
    final value = await _storage.read(key: key);
    return value ?? '';
  }

  Future<bool> getBool(String key) async {
    final value = await _storage.read(key: key);
    return value == 'true';
  }

  Future<Map<String, dynamic>> getJson(String key) {
    return _storage.read(key: key).then((value) => 
      value != null ? jsonDecode(value) : {}
    );
  }

  Future remove(String key) async {
    await _storage.delete(key: key);
  }

  AndroidOptions _getAndroidOptions() => const AndroidOptions(
    encryptedSharedPreferences: true,
  );
}

