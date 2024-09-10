import 'package:laber_app/api/models/types/private_message.dart';
import 'package:laber_app/api/repositories/message_repository.dart';
import 'package:laber_app/services/chat_service.dart';
import 'dart:convert';

import 'package:laber_app/store/secure/auth_store_service.dart';
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
    for (var message in messages) {
      await processMessage(message);
    }
  }

  static Future<void> processMessage(ApiPrivateMessage apiMessage) async {
    final authStateStore = await AuthStateStoreService.readFromSecureStorage();

    if (authStateStore == null) {
      throw Exception('AuthStateStore is null');
    }

    if (isAgreementMessageData(apiMessage.content)) {
      final agreementMessageData =
          AgreementMessageData.fromJson(jsonDecode(apiMessage.content));
      await ChatService.createChatFromInitiationMessage(agreementMessageData: agreementMessageData);
    }
  }
}
