import 'dart:convert';

import 'package:cryptography/cryptography.dart';
import 'package:isar/isar.dart';
import 'package:laber_app/api/models/types/private_message.dart';
import 'package:laber_app/api/repositories/device_repository.dart';
import 'package:laber_app/api/repositories/user_repository.dart';
import 'package:laber_app/isar.dart';
import 'package:laber_app/store/secure/auth_store_service.dart';
import 'package:laber_app/store/services/contact_service.dart';
import 'package:laber_app/store/types/chat.dart';
import 'package:laber_app/store/types/contact.dart';
import 'package:laber_app/store/types/device.dart';
import 'package:laber_app/utils/curve/x25519_util.dart';

class MessageService {
  static Future<void> processIncomingMessage(
      ApiPrivateMessage apiMessage) async {
    final isar = await getIsar();

    final authStateStore = await AuthStateStoreService.readFromSecureStorage();

    if (authStateStore == null) {
      throw Exception('AuthStateStore is null');
    }

    if (isAgreementMessageData(apiMessage.content)) {
      final agreementMessageData =
          AgreementMessageData.fromJson(jsonDecode(apiMessage.content));

      var contact = await isar.contacts
          .where()
          .apiIdEqualTo(agreementMessageData.initiatorUserId)
          .findFirst();

      if (contact == null) {
        final apiUser = (await UserRepository()
                .getById(agreementMessageData.initiatorUserId))
            .body
            ?.user;

        if (apiUser == null) {
          throw Exception('User not found');
        }

        contact = await ContactService.addContact(apiUser, null);
      }

      contact = await ContactService.refetchContact(contact.apiId);

      if (contact.deviceApiIds
              .contains(agreementMessageData.initiatorDeviceId) ==
          false) {
        throw Exception('Device not found');
      }

      final existingDevice = contact.chat.value?.devices.firstWhere(
          (element) => element.apiId == agreementMessageData.initiatorDeviceId);

      if (existingDevice != null) {
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

      final contactIdentityKey = identityKey;
      final contactEphemeralKey = await X25519Util.stringToPublicKey(
          agreementMessageData.ephemeralPublicKey);
      final meIdentityKey = authStateStore.meDevice.identityKeyPair.keyPair;
      final mePreKey = authStateStore.meDevice.signedPreKeyPairs
          .where((element) {
            return element.id == agreementMessageData.signedPreKeyId;
          })
          .first
          .keyPair;

      final meOneTimePreKey =
          authStateStore.meDevice.onetimePreKeyPairs.where((element) {
        return element.id == agreementMessageData.onetimePreKeyId;
      });

      ({
        String safetyNumber,
        SecretKey sharedSecret,
        SharedSecretVersion version
      }) result;

      if (meOneTimePreKey.isEmpty) {
        result = await X25519Util.calculateSecret(
          contactIdentityKey: contactIdentityKey,
          contactEphemeralKey: contactEphemeralKey,
          meIdentityKey: meIdentityKey,
          mePreKey: mePreKey,
          meOneTimePreKey: null,
        );
      } else {
        result = await X25519Util.calculateSecret(
          contactIdentityKey: contactIdentityKey,
          contactEphemeralKey: contactEphemeralKey,
          meIdentityKey: meIdentityKey,
          mePreKey: mePreKey,
          meOneTimePreKey: meOneTimePreKey.first.keyPair,
        );
      }

      final chat = Chat()..contact.value = contact;

      final device = Device()
        ..apiId = agreementMessageData.initiatorDeviceId
        ..safetyNumber = result.safetyNumber
        ..secret = result.sharedSecret.toString()
        ..chat.value = chat;

      await isar.writeTxn(() async {
        await isar.chats.put(chat);
        await chat.contact.save();

        await isar.devices.put(device);
        await device.chat.save();
      });
    }
  }
}

bool isAgreementMessageData(String data) {
  final json = jsonDecode(data);

  return json['type'] == EncryptedMessageDataTypes.keyAgreement;
}

class AgreementMessageData {
  final String onetimePreKeyId;
  final String signedPreKeyId;
  final String ephemeralPublicKey;

  final String initiatorDeviceId;
  final String initiatorUserId;

  final EncryptedMessageDataTypes type;

  AgreementMessageData({
    required this.onetimePreKeyId,
    required this.signedPreKeyId,
    required this.ephemeralPublicKey,
    required this.initiatorDeviceId,
    required this.initiatorUserId,
    required this.type,
  });

  static AgreementMessageData fromJson(Map<String, dynamic> json) {
    return AgreementMessageData(
      onetimePreKeyId: json['onetimePreKeyId'],
      signedPreKeyId: json['signedPreKeyId'],
      ephemeralPublicKey: json['ephemeralPublicKey'],
      initiatorDeviceId: json['initiatorDeviceId'],
      initiatorUserId: json['initiatorUserId'],
      type: EncryptedMessageDataTypes.keyAgreement,
    );
  }
}

enum EncryptedMessageDataTypes {
  keyAgreement,
  message,
}
