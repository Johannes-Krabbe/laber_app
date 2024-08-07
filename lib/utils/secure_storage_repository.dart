import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageRepository {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<void> write(SecureStorageKeys key, String value) async {
    await _secureStorage.delete(key: key.toString());
    await _secureStorage.write(key: key.toString(), value: value);
  }

  Future<String?> read(SecureStorageKeys key) async {
    return await _secureStorage.read(key: key.toString());
  }

  Future<void> delete(SecureStorageKeys key) async {
    await _secureStorage.delete(key: key.toString());
  }

  Future<void> deleteAll() async {
    await _secureStorage.deleteAll();
  }
}

enum SecureStorageKeys {
  authStateStore,
  authCurrentUserId,
}
