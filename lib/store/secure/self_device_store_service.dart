import 'dart:convert';

import 'package:laber_app/store/secure/secure_storage_service.dart';

class SelfDeviceStoreService {
  static store(SelfDeviceStore accountDeviceStore) async {
    final secureStorage = SecureStorageService();

    final devices = await getAll();

    if (devices == null) {
      await secureStorage.write(
        SecureStorageKeys.accountDeviceStore,
        jsonEncode([accountDeviceStore.toJsonString()]),
      );
    } else {
      final withoutNew = devices.where((device) {
        return device.apiId != accountDeviceStore.apiId;
      }).toList();
      withoutNew.add(accountDeviceStore);

      await secureStorage.write(
        SecureStorageKeys.accountDeviceStore,
        jsonEncode(withoutNew.map((device) => device.toJsonString()).toList()),
      );
    }
  }

  static Future<List<SelfDeviceStore>?> getAll() async {
    final secureStorage = SecureStorageService();

    final jsonString = await secureStorage.read(
      SecureStorageKeys.accountDeviceStore,
    );

    if (jsonString == null) {
      return null;
    }

    final deviceStrings = jsonDecode(jsonString);

    final List<SelfDeviceStore> devices = [];

    for (var deviceString in deviceStrings) {
      devices.add(SelfDeviceStore.fromJsonString(deviceString));
    }

    return devices;
  }

  static Future<SelfDeviceStore?> get(String apiId) async {
    final devices = await getAll();

    if (devices == null) {
      return null;
    }

    final device = devices.where((device) {
      return device.apiId == apiId;
    }).toList();

    if (device.isEmpty) {
      return null;
    }

    return device.first;
  }
}

class SelfDeviceStore {
  final String apiId;
  final String secret;

  SelfDeviceStore({required this.apiId, required this.secret});

  String toJsonString() {
    return jsonEncode({
      'apiId': apiId,
      'secret': secret,
    });
  }

  static SelfDeviceStore fromJsonString(String jsonString) {
    final Map<String, dynamic> json = jsonDecode(jsonString);
    return SelfDeviceStore(
      apiId: json['apiId'],
      secret: json['secret'],
    );
  }
}
