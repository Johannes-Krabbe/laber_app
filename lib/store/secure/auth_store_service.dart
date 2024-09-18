import 'package:laber_app/store/secure/secure_storage_service.dart';
import 'package:laber_app/types/client_me_device.dart';
import 'package:laber_app/types/client_me_user.dart';
import 'dart:convert';

class AuthStateStoreService {
  final String token;
  final ClientMeUser meUser;
  final ClientMeDevice meDevice;

  AuthStateStoreService(this.token, this.meUser, this.meDevice);

  Future<String> toJsonString() async {
    return jsonEncode({
      'token': token,
      'meUser': meUser.toJsonString(),
      'meDevice': await meDevice.toJsonString(),
    });
  }

  static Future<AuthStateStoreService?> fromJsonString(
      String jsonString) async {
    final Map<String, dynamic> json = jsonDecode(jsonString);
    return AuthStateStoreService(
      json['token'],
      ClientMeUser.fromJsonString(json['meUser']),
      await ClientMeDevice.fromJsonString(json['meDevice']),
    );
  }

  static Future<void> saveToSecureStorage(
      AuthStateStoreService authStateStore) async {
    final secureStorage = SecureStorageService();

    await secureStorage.write(
      SecureStorageKeys.authStateStore,
      await authStateStore.toJsonString(),
    );
  }

  static Future<AuthStateStoreService?> readFromSecureStorage() async {
    final secureStorage = SecureStorageService();

    final jsonString = await secureStorage.read(
      SecureStorageKeys.authStateStore,
    );

    if (jsonString == null) {
      return null;
    }

    return AuthStateStoreService.fromJsonString(jsonString);
  }

  static Future<void> deleteFromSecureStorage() async {
    final secureStorage = SecureStorageService();

    await secureStorage.delete(
      SecureStorageKeys.authStateStore,
    );
  }
}
