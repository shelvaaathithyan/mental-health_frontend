import 'dart:async';

import 'package:get_storage/get_storage.dart';

abstract class AuthLocalStore {
  Future<void> write(String key, dynamic value);
  T? read<T>(String key);
  Future<void> remove(String key);
}

class GetStorageAuthLocalStore implements AuthLocalStore {
  GetStorageAuthLocalStore({GetStorage? storage})
      : _storage = storage ?? GetStorage();

  final GetStorage _storage;

  @override
  Future<void> write(String key, dynamic value) async {
    await _storage.write(key, value);
  }

  @override
  T? read<T>(String key) {
    return _storage.read<T>(key);
  }

  @override
  Future<void> remove(String key) async {
    await _storage.remove(key);
  }
}

class InMemoryAuthLocalStore implements AuthLocalStore {
  final Map<String, dynamic> _memory = {};

  @override
  Future<void> write(String key, dynamic value) async {
    _memory[key] = value;
  }

  @override
  T? read<T>(String key) {
    final value = _memory[key];
    if (value is T?) {
      return value;
    }
    return value as T?;
  }

  @override
  Future<void> remove(String key) async {
    _memory.remove(key);
  }

  void clear() => _memory.clear();
}
