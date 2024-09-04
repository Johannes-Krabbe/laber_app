import 'dart:convert';

import 'package:cryptography/cryptography.dart';
import 'package:isar/isar.dart';
import 'package:laber_app/api/repositories/device_repository.dart';
import 'package:laber_app/isar.dart';
import 'package:laber_app/store/services/contact_service.dart';
import 'package:laber_app/store/types/chat.dart';
import 'package:laber_app/store/types/contact.dart';
import 'package:laber_app/store/types/device.dart';
import 'package:laber_app/utils/auth_store_repository.dart';
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

    contact = await ContactService.refetchContact(contact.apiId);

    final chat = Chat();
    chat.contact.value = contact;
    await isar.chats.put(chat);
  }

  static Future<void> createSecrets({required Chat chat}) async {
    final contact = chat.contact.value;
    if (contact == null) {
      throw Exception('Contact not found');
    }

    final authStore =
        await AuthStateStoreRepository.getCurrentFromSecureStorage();

    for (var deviceId in contact.deviceApiIds) {
      var exisitingDevices = chat.devices.where((device) {
        return device.apiId == deviceId;
      }).toList();

      if (exisitingDevices.isEmpty || exisitingDevices.length > 1) {
        // TODO: error.
        continue;
      }

      var deviceRes = await DeviceRepository().getKeyBundle(deviceId);

      if (deviceRes.status != 200) {
        continue;
      }

      var meIdentityKey = authStore!.meDevice.identityKeyPair;
      var meEphemeralKey = await X25519Util.generateKeyPair();

      // verify signature
      var signature = deviceRes.body!.device!.signedPreKey!.signature;

      var contactIdentityKey =
          await deviceRes.body!.device!.identityKey!.publicKey;

      var isValid = await Ed25519Util.verify(
        content: deviceRes.body!.device!.signedPreKey!.key!,
        signature:
            Signature(utf8.encode(signature!), publicKey: contactIdentityKey),
      );

      if (!isValid) {
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
      });
    }
  }
}
