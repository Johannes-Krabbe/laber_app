import 'dart:convert';

import 'package:cryptography/cryptography.dart';
import 'package:isar/isar.dart';
import 'package:laber_app/api/repositories/device_repository.dart';
import 'package:laber_app/isar.dart';
import 'package:laber_app/store/secure/auth_store_service.dart';
import 'package:laber_app/store/services/contact_service.dart';
import 'package:laber_app/store/types/chat.dart';
import 'package:laber_app/store/types/contact.dart';
import 'package:laber_app/store/types/device.dart';
import 'package:laber_app/store/types/raw_message.dart';
import 'package:laber_app/utils/curve/ed25519_util.dart';
import 'package:laber_app/utils/curve/x25519_util.dart';

class ChatService {
  static Future<List<Chat>> getAllChats() async {
    final isar = await getIsar();
    final chats = await isar.chats.where().findAll();
    return chats;
  }

  static Future<Chat?> getChat({required String contactApiId}) async {
    final isar = await getIsar();
    final contact = await isar.contacts
        .where()
        .filter()
        .apiIdEqualTo(contactApiId)
        .findFirst();
    return contact?.chat.value;
  }

  static Future<void> sendMessage({
    required String contactApiId,
    required String message,
  }) async {
    final isar = await getIsar();
    var contact =
        await isar.contacts.where().apiIdEqualTo(contactApiId).findFirst();
    var chat = contact?.chat.value;

    if (chat == null) {
      await createChat(contactApiId: contactApiId);

      // refetch
      contact =
          await isar.contacts.where().apiIdEqualTo(contactApiId).findFirst();
      chat = contact?.chat.value;
    }

    if (chat == null) {
      throw Exception('Chat was not created');
    }

    await createSecrets(chat: chat);

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

  static Future<void> createChat({required String contactApiId}) async {
    final isar = await getIsar();
    var contact = await isar.contacts
        .where()
        .filter()
        .apiIdEqualTo(contactApiId)
        .findFirst();
    if (contact == null) {
      throw Exception('Contact not found');
    }
    if (contact.chat.value != null) {
      throw Exception('Chat already exists');
    }

    final chat = Chat();

    contact = await ContactService.refetchContact(contact.apiId);
    contact.chat.value = chat;

    await isar.writeTxn(() async {
      await isar.chats.put(chat);
      await isar.contacts.put(contact!);
      await contact.chat.save();
    });

    await createSecrets(chat: chat);
  }

  static Future<void> createSecrets({required Chat chat}) async {
    print('Creating secrets');

    var contact = chat.contact.value;
    if (contact == null) {
      throw Exception('Contact not found');
    }

    contact = await ContactService.refetchContact(contact.apiId);

    final authStore = await AuthStateStoreService.readFromSecureStorage();

    for (var deviceId in contact.deviceApiIds) {
      var exisitingDevices = chat.devices.where((device) {
        return device.apiId == deviceId;
      }).toList();

      if (exisitingDevices.isNotEmpty) {
        print('Device already exists');
        // TODO: error.
        continue;
      }

      var deviceRes = await DeviceRepository().getKeyBundle(deviceId);

      if (deviceRes.status != 200) {
        print('DeviceRes is not 200');
        continue;
      }

      var meIdentityKey = authStore!.meDevice.identityKeyPair;
      var meEphemeralKey = await X25519Util.generateKeyPair();

      // verify signature
      var signature = deviceRes.body!.device!.signedPreKey!.signature;

      var contactIdentityKey =
          await deviceRes.body!.device!.identityKey!.publicKey;

      print("publicKey");
      print(contactIdentityKey.bytes);

      print("signature");
      print(stringToUint8List(signature!));

      var isValid = await Ed25519Util.verify(
        content: deviceRes.body!.device!.signedPreKey!.key!,
        signature: Signature(stringToUint8List(signature!),
            publicKey: contactIdentityKey),
      );

      if (!isValid) {
        print('Signature is not valid');
        continue;
      }

      var sharedSecretRes = await X25519Util.getSharedSecretForChat(
        meIdentityKey: meIdentityKey.keyPair,
        meEphemeralKey: meEphemeralKey,
        contactIdentityKey:
            await deviceRes.body!.device!.identityKey!.publicKey,
        contactPreKey: await deviceRes.body!.device!.signedPreKey!.publicKey,
        contactOneTimePreKey:
            await deviceRes.body!.device!.oneTimePreKey!.publicKey,
      );

      final device = Device()
        ..safetyNumber = sharedSecretRes.safetyNumber
        ..version = sharedSecretRes.version
        // TODO does this work?
        ..secret = sharedSecretRes.sharedSecret.toString()
        ..apiId = deviceId;
      chat.devices.add(device);

      final isar = await getIsar();

      await isar.writeTxn(() async {
        await isar.devices.put(device);
        await isar.chats.put(chat);
        await chat.devices.save();
      });
    }
  }
}

List<int> stringToUint8List(String input) {
  return base64Decode(input);
}
