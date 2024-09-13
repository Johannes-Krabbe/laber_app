import 'dart:convert';

import 'package:cryptography/cryptography.dart';
import 'package:laber_app/api/repositories/device_repository.dart';
import 'package:laber_app/services/contact_service.dart';
import 'package:laber_app/store/repositories/contact_repository.dart';
import 'package:laber_app/store/repositories/outgoing_message_repository.dart';
import 'package:laber_app/store/secure/auth_store_service.dart';
import 'package:laber_app/store/types/contact.dart';

import 'package:laber_app/isar.dart';
import 'package:laber_app/store/types/chat.dart';
import 'package:laber_app/store/types/device.dart';
import 'package:laber_app/types/message/api_message.dart';
import 'package:laber_app/types/message/message_data.dart';
import 'package:laber_app/utils/curve/crypto_util.dart';
import 'package:laber_app/utils/curve/secret_util.dart';
import 'package:laber_app/utils/curve/x25519_util.dart';
import 'package:laber_app/utils/curve/xeddsa_util.dart';

class ChatService {
  /* ===
  === Initiator functions ===
  These functions are used when the user wants to create a chat
  === */
  static Future<void> createChat({required String contactApiId}) async {
    var contact = await ContactRepository.getContact(contactApiId);
    if (contact == null) {
      throw Exception('Contact not found');
    }
    if (contact.chat.value != null) {
      throw Exception('Chat already exists');
    }

    final chat = Chat();

    contact = await ContactService.refetchContact(contact.apiId);
    contact.chat.value = chat;

    final isar = await getIsar();

    await isar.writeTxn(() async {
      await isar.chats.put(chat);
      await isar.contacts.put(contact!);
      await contact.chat.save();
    });

    await createSecrets(chat: chat);
  }

  static Future<void> createSecrets({required Chat chat}) async {
    var contact = chat.contact.value;
    if (contact == null) {
      throw Exception('Contact not found');
    }

    // we refetch contact when creating the chat => not necessary to refetch again
    // contact = await ContactService.refetchContact(contact.apiId);

    final authStore = await AuthStateStoreService.readFromSecureStorage();

    for (var deviceId in contact.deviceApiIds) {
      var exisitingDevices = chat.devices.where((device) {
        return device.apiId == deviceId;
      }).toList();

      if (exisitingDevices.isNotEmpty) {
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

      final signedPreKeyBytes = (await CryptoUtil.stringToPublicKey(
              deviceRes.body!.device!.signedPreKey!.key!))
          .bytes;

      var isValid = await XeddsaUtil.verifyX25519(
          content: signedPreKeyBytes,
          publicKeyBytes: contactIdentityKey.bytes,
          signature: base64Decode(signature!));

      if (!isValid) {
        print('Signature is not valid');
        continue;
      }

      var sharedSecretRes = await SecretUtil.initiatorKeyCalculation(
        meIdentityKey: meIdentityKey.keyPair,
        meEphemeralKey: meEphemeralKey,
        contactIdentityKey:
            await deviceRes.body!.device!.identityKey!.publicKey,
        contactPreKey: await deviceRes.body!.device!.signedPreKey!.publicKey,
        contactOneTimePreKey:
            await deviceRes.body!.device!.oneTimePreKey!.publicKey,
      );

      final meEphemeralPublicKey = await meEphemeralKey.extractPublicKey();

      final agreementMessageData = AgreementMessageData(
        onetimePreKeyId: deviceRes.body!.device!.oneTimePreKey!.id!,
        signedPreKeyId: deviceRes.body!.device!.signedPreKey!.id!,
        ephemeralPublicKey: await CryptoUtil.publicKeyToString(
            meEphemeralPublicKey, KeyPairType.x25519),
        initiatorDeviceId: authStore.meDevice.id,
        initiatorUserId: authStore.meUser.id,
        type: EncryptedMessageDataTypes.keyAgreement,
      );

      final apiMessageData = ApiMessageData(
        encryptedMessage: agreementMessageData.toJsonString(),
        enctyptionContext: '',
        type: ApiMessageDataTypes.keyAgreement,
      );

      final apiMessage = ApiMessage(
        messageData: apiMessageData,
        apiSenderDeviceId: authStore.meDevice.id,
        apiRecipientDeviceId: deviceId,
      );

      await OutgoingMessageRepository.create(
        content: apiMessage,
        recipientDeviceId: deviceId,
      );

      final device = Device()
        ..safetyNumber = sharedSecretRes.safetyNumber
        ..version = sharedSecretRes.version
        ..secret =
            await CryptoUtil.secretKeyToString(sharedSecretRes.sharedSecret)
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

  /* ===
  === Recipient functions ===
  These functions are used when the user recieves a initiation message
  === */

  static Future<void> createChatFromInitiationMessage(
      {required AgreementMessageData agreementMessageData}) async {
    final isar = await getIsar();

    var contact = await ContactRepository.getContact(
        agreementMessageData.initiatorUserId);

    // TODO: iniatior could be me
    if (contact == null) {
      // can throw
      contact = await ContactService.fetchContact(
          agreementMessageData.initiatorUserId);
    } else {
      contact = await ContactService.refetchContact(contact.apiId);
    }

    if (contact == null) {
      throw Exception('Contact not found');
    }

    if (contact.deviceApiIds.contains(agreementMessageData.initiatorDeviceId) ==
        false) {
      throw Exception('Device not found');
    }

    final existingDevice = contact.chat.value?.devices.where(
        (element) => element.apiId == agreementMessageData.initiatorDeviceId);

    if (existingDevice != null && existingDevice.isNotEmpty) {
      throw Exception('Device already exists');
    }

    final apiDevice = await DeviceRepository()
        .getPublic(agreementMessageData.initiatorDeviceId);

    if (apiDevice.body == null) {
      throw Exception('Device not found');
    }

    final identityKey = await apiDevice.body?.device?.identityKey?.publicKey;

    if (identityKey == null) {
      throw Exception('Identity key not found');
    }

    final authStateStore = await AuthStateStoreService.readFromSecureStorage();

    if (authStateStore == null) {
      throw Exception('AuthStateStore is null');
    }

    final contactIdentityKey = identityKey;
    final contactEphemeralKey = await CryptoUtil.stringToPublicKey(
        agreementMessageData.ephemeralPublicKey);
    final meIdentityKey = authStateStore.meDevice.identityKeyPair.keyPair;
    final mePreKey = authStateStore.meDevice.signedPreKeyPairs
        .where((element) {
          return element.id == agreementMessageData.signedPreKeyId;
        })
        .first
        .keyPair;

    SimpleKeyPair? meOneTimePreKey;

    if (agreementMessageData.onetimePreKeyId != null) {
      final meOneTimePreKeys =
          authStateStore.meDevice.onetimePreKeyPairs.where((element) {
        return element.id == agreementMessageData.onetimePreKeyId;
      });

      if (meOneTimePreKeys.isEmpty) {
        print('One time pre key not found');
        throw Exception('One time pre key not found');
      } else if (meOneTimePreKeys.length > 1) {
        print('More than one one time pre key found');
        throw Exception('More than one one time pre key found');
      }
      meOneTimePreKey = meOneTimePreKeys.first.keyPair;
    }

    final result = await SecretUtil.recipientKeyCalculation(
      contactIdentityKey: contactIdentityKey,
      contactEphemeralKey: contactEphemeralKey,
      meIdentityKey: meIdentityKey,
      mePreKey: mePreKey,
      meOneTimePreKey: meOneTimePreKey,
    );

    final chat = Chat()..contact.value = contact;

    final device = Device()
      ..apiId = agreementMessageData.initiatorDeviceId
      ..safetyNumber = result.safetyNumber
      ..secret = await CryptoUtil.secretKeyToString(result.sharedSecret)
      ..chat.value = chat
      ..version = result.version;

    await isar.writeTxn(() async {
      await isar.chats.put(chat);
      await chat.contact.save();

      await isar.devices.put(device);
      await device.chat.save();
    });
  }
}
