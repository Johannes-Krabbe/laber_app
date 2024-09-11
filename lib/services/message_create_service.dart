import 'package:isar/isar.dart';
import 'package:laber_app/isar.dart';
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

    final messageObj = RawMessage()
      ..content = message
      ..type = RawMessageTypes.textMessage
      ..senderUserId = meUser.id
      ..senderDeviceId = meDevice.id
      ..content = content.toJsonString()
      ..status = RawMessageStatus.sending
      ..unixTime = DateTime.now().millisecondsSinceEpoch
      ..chat.value = chat;

    await isar.writeTxn(() async {
      await isar.rawMessages.put(messageObj);
      await messageObj.chat.save();
    });

    // TODO: send message
  }
}
