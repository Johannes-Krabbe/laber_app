import 'package:isar/isar.dart';
import 'package:laber_app/isar.dart';
import 'package:laber_app/store/repositories/device_repository.dart';
import 'package:laber_app/store/types/raw_message.dart';

class RawMessageStoreRepository {
  Future<void> saveRawMessage(RawMessage rawMessage) async {
    final device =
        await DeviceStoreRepository().getByApiId(rawMessage.senderDeviceId);

    if (device == null) {
      throw Exception('Device not found');
    }

    final chat = device.chat.value;

    if (chat == null) {
      throw Exception('Chat not found');
    }
    
    if(await getByUniqueId(rawMessage.uniqueId) != null) {
      return;
    }

    rawMessage.chat.value = chat;

    final isar = await getIsar();

    await isar.writeTxn(() async {
      await isar.rawMessages.put(rawMessage);
      await rawMessage.chat.save();
    });
  }

  Future<RawMessage?> getByUniqueId(String uniqueId) async {
    final isar = await getIsar();

    return isar.rawMessages.where().uniqueIdEqualTo(uniqueId).findFirst();
  }
}
