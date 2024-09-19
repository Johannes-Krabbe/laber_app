import 'package:laber_app/isar.dart';
import 'package:laber_app/store/secure/auth_store_service.dart';
import 'package:laber_app/store/types/chat.dart';
import 'package:laber_app/store/types/device.dart';
import 'package:laber_app/store/types/raw_message.dart';

class InfoMessageService {
  AuthStateStoreService? authStateStore;

  createChatInitializedMessage(Chat chat) async {
    await readAuthStateStore();

    await createBaseInfoMessage(
        content: "You initialized the Chat", chat: chat);
  }

  initializeSecretCreation(Device device, Chat chat) async {
    await readAuthStateStore();

    await createBaseInfoMessage(
      content:
          "You initialized the secret generation with the device with the id: ${device.apiId}",
      chat: chat,
    );
  }

  createdSecretFromInitializationMessage(Chat chat, Device device) async {
    await readAuthStateStore();

    await createBaseInfoMessage(
      content: "You created the secret from the initialization message for the device with the id: ${device.apiId}",
      chat: chat,
    );
  }

  createBaseInfoMessage({required String content, required Chat chat}) async {
    await readAuthStateStore();

    final rawMessage = RawMessage()
      ..type = RawMessageTypes.infoMessage
      ..senderUserId = authStateStore!.meUser.id
      ..senderDeviceId = authStateStore!.meDevice.id
      ..recipientUserId = authStateStore!.meDevice.id
      ..content = InfoMessageContent(text: content).toJsonString()
      ..unixTime = DateTime.now().millisecondsSinceEpoch
      ..status = RawMessageStatus.none
      ..chat.value = chat;
    final isar = await getIsar();

    await isar.writeTxn(() async {
      await isar.rawMessages.put(rawMessage);
      await rawMessage.chat.save();
    });
  }

  readAuthStateStore() async {
    authStateStore ??= await AuthStateStoreService.readFromSecureStorage();
  }
}
