import 'package:isar/isar.dart';
import 'package:laber_app/isar.dart';
import 'package:laber_app/services/message_encryption_service.dart';
import 'package:laber_app/store/repositories/outgoing_message_repository.dart';
import 'package:laber_app/store/secure/account_device_store_service.dart';
import 'package:laber_app/store/secure/auth_store_service.dart';
import 'package:laber_app/store/types/contact.dart';
import 'package:laber_app/store/types/raw_message.dart';

class MessageCreateService {
  static Future<void> sendTextMessage({
    required String contactApiId,
    required String message,
  }) async {
    final isar = await getIsar();
    var contact =
        await isar.contacts.where().apiIdEqualTo(contactApiId).findFirst();
    var chat = contact?.chat.value;

    if (chat == null) {
      throw Exception('There is no chat');
    }

    final authStore = await AuthStateStoreService.readFromSecureStorage();

    final meDevice = authStore!.meDevice;
    final meUser = authStore.meUser;

    final content = TextMessageContent(text: message);

    final rawMessage = RawMessage()
      ..content = message
      ..type = RawMessageTypes.textMessage
      ..senderUserId = meUser.id
      ..senderDeviceId = meDevice.id
      ..recipientUserId = contact!.apiId
      ..content = content.toJsonString()
      ..status = RawMessageStatus.sending
      ..unixTime = DateTime.now().millisecondsSinceEpoch
      ..chat.value = chat;

    await isar.writeTxn(() async {
      await isar.rawMessages.put(rawMessage);
      await rawMessage.chat.save();
    });

    await sendRawMessage(contact: contact, message: rawMessage);
  }

  static Future<void> sendRawMessage({
    required Contact contact,
    required RawMessage message,
  }) async {
    final chat = contact.chat.value;

    final contactDevices = chat?.devices;

    if (contactDevices == null) {
      throw Exception('No devices found');
    }

    for (var device in contactDevices) {
      final apiMessage = await MessageEncryptionService().encryptMessage(
        message: message,
        secret: device.secret,
        apiRecipientDeviceId: device.apiId,
      );
      await OutgoingMessageRepository.create(
        content: apiMessage,
        recipientDeviceId: device.apiId,
      );
    }

    final meDevices = (await AccountDeviceStoreService.getAll()) ?? [];

    for (var device in meDevices) {
      final apiMessage = await MessageEncryptionService().encryptMessage(
        message: message,
        secret: device.secret,
        apiRecipientDeviceId: device.apiId,
      );
      await OutgoingMessageRepository.create(
        content: apiMessage,
        recipientDeviceId: device.apiId,
      );
    }
  }
}
