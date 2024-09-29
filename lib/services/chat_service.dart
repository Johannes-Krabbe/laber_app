import 'package:laber_app/services/contact_service.dart';
import 'package:laber_app/services/info_message_service.dart';
import 'package:laber_app/services/key_agreement_service.dart';
import 'package:laber_app/services/self/self_devices_service.dart';
import 'package:laber_app/store/repositories/contact_repository.dart';
import 'package:laber_app/store/types/contact.dart';

import 'package:laber_app/isar.dart';
import 'package:laber_app/store/types/chat.dart';
import 'package:laber_app/store/types/device.dart';
import 'package:laber_app/types/message/message_data.dart';
import 'package:laber_app/utils/curve/crypto_util.dart';

class ChatService {
  /* ===
  === Initiator function ===
  This function is used when the user wants to create a chat
  === */
  static Future<void> createChat({required String contactApiId}) async {
    var contact = await ContactStoreRepository.getContact(contactApiId);
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

    await InfoMessageService().createChatInitializedMessage(chat);

    for (var deviceId in contact.deviceApiIds) {
      var exisitingDevices = chat.devices.where((device) {
        return device.apiId == deviceId;
      }).toList();

      if (exisitingDevices.isNotEmpty) {
        // TODO: error.
        continue;
      }

      final sharedSecretRes =
          await KeyAgreementService.creteInitializationMessage(deviceId);

      if (sharedSecretRes == null) {
        continue;
      }

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

      await InfoMessageService().initializeSecretCreation(device, chat);
    }

    // Check that all self devices have a shared secret
    await SelfDevicesService.initiateKeyAgreement();
  }

  /* ===
  === Recipient function ===
  This function is used when the user recieves a initiation message that is not created by the user (me)
  === */

  static Future<void> createChatFromInitiationMessage(
      {required AgreementMessageData agreementMessageData}) async {
    var contact = await ContactStoreRepository.getContact(
      agreementMessageData.initiatorUserId,
    );

    if (contact == null) {
      // can throw
      contact = await ContactService.fetchContact(
        agreementMessageData.initiatorUserId,
      );
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

    final result = await KeyAgreementService.processInitializationMessage(
        agreementMessageData);

    if (result == null) {
      throw Exception('Error processing initiation message');
    }

    final isar = await getIsar();

    var chat = contact.chat.value;

    chat ??= Chat()..contact.value = contact;

    final device = Device()
      ..apiId = agreementMessageData.initiatorDeviceId
      ..safetyNumber = result.safetyNumber
      ..secret = await CryptoUtil.secretKeyToString(result.sharedSecret)
      ..chat.value = chat
      ..version = result.version;

    await isar.writeTxn(() async {
      await isar.chats.put(chat!);
      await chat.contact.save();

      await isar.devices.put(device);
      await device.chat.save();
    });

    await InfoMessageService().createdSecretFromInitializationMessage(chat, device);
  }
}
