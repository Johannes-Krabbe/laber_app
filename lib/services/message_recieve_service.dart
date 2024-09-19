import 'package:laber_app/api/models/types/private_message.dart';
import 'package:laber_app/api/repositories/message_repository.dart';
import 'package:laber_app/services/chat_service.dart';
import 'package:laber_app/services/key_agreement_service.dart';
import 'package:laber_app/services/message_encryption_service.dart';
import 'package:laber_app/store/repositories/raw_message_repository.dart';
import 'dart:convert';

import 'package:laber_app/store/secure/auth_store_service.dart';
import 'package:laber_app/store/secure/self_device_store_service.dart';
import 'package:laber_app/types/message/api_message.dart';
import 'package:laber_app/types/message/message_data.dart';
import 'package:laber_app/utils/curve/crypto_util.dart';

class MessageRecieveService {
  // Can throw
  processNew() async {
    final newMessages = await MessageRepository().getNew();

    if (newMessages.status != 200 || newMessages.body?.messages == null) {
      throw Exception("Could not fetch Messages");
    }

    await processMessages(newMessages.body!.messages!);
  }

  processMessages(List<ApiPrivateMessage> messages) async {
    print('Processing ${messages.length} messages');
    for (var message in messages) {
      await processMessage(message);
    }
  }

  static Future<void> processMessage(ApiPrivateMessage apiMessage) async {
    final authStateStore = await AuthStateStoreService.readFromSecureStorage();

    if (authStateStore == null) {
      throw Exception('AuthStateStore is null');
    }

    switch (apiMessage.apiMessage.messageData.type) {
      case ApiMessageDataTypes.keyAgreement:
        {
          final agreementMessageData = AgreementMessageData.fromJson(
              jsonDecode(apiMessage.apiMessage.messageData.encryptedMessage));

          try {
            // Variables
            final authStore =
                await AuthStateStoreService.readFromSecureStorage();
            final isSelfInitiated =
                agreementMessageData.initiatorUserId == authStore!.meUser.id;

            // Check if the handshake is self initiated
            if (isSelfInitiated) {
              // if yes validate the message
              if (agreementMessageData.initiatorDeviceId ==
                  authStore.meDevice.id) {
                throw Exception('Initiator is me');
              }

              final existingDevice = await SelfDeviceStoreService.get(
                agreementMessageData.initiatorDeviceId,
              );

              if (existingDevice != null) {
                throw Exception('Device already exists');
              }

              // Process the message
              final result =
                  await KeyAgreementService.processInitializationMessage(
                agreementMessageData,
              );

              if (result == null) {
                throw Exception('Error processing initiation message');
              }

              // Save the device
              await SelfDeviceStoreService.store(
                SelfDeviceStore(
                  secret:
                      await CryptoUtil.secretKeyToString(result.sharedSecret),
                  apiId: agreementMessageData.initiatorDeviceId,
                ),
              );
            } else {
              await ChatService.createChatFromInitiationMessage(
                agreementMessageData: agreementMessageData,
              );
            }
          } catch (e) {
            print('Error creating chat from initiation message: $e');
          }
          break;
        }
      case ApiMessageDataTypes.applicationRawMessage:
        {
          final decryptedMessage = await MessageEncryptionService()
              .decryptMessage(apiMessage: apiMessage.apiMessage);
          await RawMessageStoreRepository().saveRawMessage(decryptedMessage);
          break;
        }
      default:
    }
  }
}
