import 'dart:convert';

import 'package:laber_app/store/secure/secure_storage_service.dart';

class AccountDeviceStoreService {
  static store(AccountDeviceStore accountDeviceStore) async {
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

  static Future<List<AccountDeviceStore>?> getAll() async {
    final secureStorage = SecureStorageService();

    final jsonString = await secureStorage.read(
      SecureStorageKeys.accountDeviceStore,
    );

    if (jsonString == null) {
      return null;
    }

    final deviceStrings = jsonDecode(jsonString);

    final List<AccountDeviceStore> devices = [];

    for (var deviceString in deviceStrings) {
      devices.add(AccountDeviceStore.fromJsonString(deviceString));
    }

    return devices;
  }

  static Future<AccountDeviceStore?> get(String apiId) async {
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

class AccountDeviceStore {
  final String apiId;
  final String secret;

  AccountDeviceStore({required this.apiId, required this.secret});

  String toJsonString() {
    return jsonEncode({
      'apiId': apiId,
      'secret': secret,
    });
  }

  static AccountDeviceStore fromJsonString(String jsonString) {
    final Map<String, dynamic> json = jsonDecode(jsonString);
    return AccountDeviceStore(
      apiId: json['apiId'],
      secret: json['secret'],
    );
  }
}
