import 'package:isar/isar.dart';
import 'package:laber_app/isar.dart';
import 'package:laber_app/store/types/device.dart';

class DeviceStoreRepository {
  Future<Device?> getByApiId(String apiId) async {
    final isar = await getIsar();
    final device = await isar.devices.where().apiIdEqualTo(apiId).findFirst();
    return device;
  }
}
