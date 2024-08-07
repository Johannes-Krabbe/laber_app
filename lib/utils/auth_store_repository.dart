import 'package:laber_app/types/client_me_device.dart';
import 'package:laber_app/types/client_me_user.dart';
import 'dart:convert';

import 'package:laber_app/utils/secure_storage_repository.dart';

class AuthStateStore {
  final String token;
  final ClientMeUser meUser;
  final ClientMeDevice meDevice;

  AuthStateStore(this.token, this.meUser, this.meDevice);

  Future<String> toJsonString() async {
    return jsonEncode({
      'token': token,
      'meUser': meUser.toJsonString(),
      'meDevice': await meDevice.toJsonString(),
    });
  }

  static Future<AuthStateStore> fromJsonString(String jsonString) async {
    final json = jsonDecode(jsonString);
    return AuthStateStore(
      json['token'],
      ClientMeUser.fromJsonString(json['meUser']),
      await ClientMeDevice.fromJsonString(json['meDevice']),
    );
  }

  static Future<List<AuthStateStore>> getAllFromSecureStorage() async {
    final secureStorage = SecureStorageRepository();

    final authStateStoreString =
        await secureStorage.read(SecureStorageKeys.authStateStore);
    if (authStateStoreString == null) {
      return [];
    }

    final authStateStoreArray = jsonDecode(authStateStoreString);

    final List<AuthStateStore> authStateStores = [];
    for (final authStateStore in authStateStoreArray) {
      authStateStores.add(await AuthStateStore.fromJsonString(authStateStore));
    }

    return authStateStores;
  }

  static Future<void> saveToSecureStorage(AuthStateStore authStateStore) async {
    final secureStorage = SecureStorageRepository();

    final authStateStores = await getAllFromSecureStorage();
    authStateStores.add(authStateStore);

    await secureStorage.write(
      SecureStorageKeys.authStateStore,
      jsonEncode(await Future.wait(
          authStateStores.map((store) => store.toJsonString()).toList())),
    );
  }

  static Future<void> saveAsCurrentToSecureStorage(
      AuthStateStore authStateStore) async {
    final secureStorage = SecureStorageRepository();

    await AuthStateStore.saveToSecureStorage(authStateStore);

    await secureStorage.write(
        SecureStorageKeys.authCurrentUserId, authStateStore.meUser.id);
  }

  static Future<AuthStateStore?> getCurrentFromSecureStorage() async {
    final secureStorage = SecureStorageRepository();

    final authStateStoreString =
        await secureStorage.read(SecureStorageKeys.authCurrentUserId);
    if (authStateStoreString == null) {
      return null;
    }

    final authStateStores = await getAllFromSecureStorage();

    for (final authStateStore in authStateStores) {
      if (authStateStore.meUser.id == authStateStoreString) {
        return authStateStore;
      }
    }

    return null;
  }

  static Future<void> deleteFromSecureStorage(String userId) async {
    final secureStorage = SecureStorageRepository();

    final authStateStores = await getAllFromSecureStorage();
    final newAuthStateStores =
        authStateStores.where((store) => store.meUser.id != userId).toList();

    await secureStorage.write(
      SecureStorageKeys.authStateStore,
      jsonEncode(await Future.wait(
          newAuthStateStores.map((store) => store.toJsonString()).toList())),
    );
  }

  static Future<void> deleteCurrentFromSecureStorageWithStore() async {
    final secureStorage = SecureStorageRepository();

    final authStateStoreString =
        await secureStorage.read(SecureStorageKeys.authCurrentUserId);
    if (authStateStoreString == null) {
      return;
    }

    await deleteFromSecureStorage(authStateStoreString);

    await secureStorage.delete(SecureStorageKeys.authCurrentUserId);
  }

  static Future<void> deleteCurrentFromSecureStorage() async {
    final secureStorage = SecureStorageRepository();

    await secureStorage.delete(SecureStorageKeys.authCurrentUserId);
  }

  static Future<void> updateInSecureStorageByUserId(
      AuthStateStore authStateStore) async {
    deleteFromSecureStorage(authStateStore.meUser.id);
    saveToSecureStorage(authStateStore);
  }
}
