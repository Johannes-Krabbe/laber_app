import 'package:laber_app/api/models/types/private_message.dart';
import 'package:laber_app/api/repositories/message_repository.dart';
import 'package:laber_app/services/chat_service.dart';
import 'package:laber_app/services/message_encryption_service.dart';
import 'package:laber_app/store/repositories/raw_message_repository.dart';
import 'dart:convert';

import 'package:laber_app/store/secure/auth_store_service.dart';
import 'package:laber_app/types/message/api_message.dart';
import 'package:laber_app/types/message/message_data.dart';

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
            await ChatService.createChatFromInitiationMessage(
                agreementMessageData: agreementMessageData);
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
