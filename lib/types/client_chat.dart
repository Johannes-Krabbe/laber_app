import 'dart:convert';

import 'package:laber_app/types/client_device.dart';
import 'package:laber_app/types/client_message.dart';

class ClientChat {
  final List<ClientRawMessage> rawMessages;
  final List<ClientDevice> devices;

  ClientChat({
    this.rawMessages = const [],
    this.devices = const [],
  });

  ClientChat copyWith({
    List<ClientRawMessage>? rawMessages,
  }) {
    return ClientChat(
      rawMessages: rawMessages ?? this.rawMessages,
    );
  }

  Future<String> toJson() async {
    List<String> chatMessagesJson = [];
    for(var rawMessage in rawMessages) {
      chatMessagesJson.add(await rawMessage.toJson());
    }

    return jsonEncode({
      'rawMessages': chatMessagesJson,
    });
  }

  ClientRawMessage? get latestMessage {
    if(rawMessages.isEmpty) return null;
    rawMessages.sort((a, b) => a.unixTime.compareTo(b.unixTime));
    return rawMessages.last;
  }

  List<ClientRawMessage> get sortedRawMessages {
    List<ClientRawMessage> sortedMessages = rawMessages;
    sortedMessages.sort((a, b) => a.unixTime.compareTo(b.unixTime));
    return sortedMessages.toList();
  }

  List<ClientParsedMessage> get sortedParsedMessages {
    List<ClientParsedMessage> sortedMessages = parsedMessages;
    sortedMessages.sort((a, b) => a.unixTime.compareTo(b.unixTime));
    return sortedMessages.reversed.toList();
  }

  List<ClientParsedMessage> get parsedMessages {
    List<ClientParsedMessage> parsedMessages = [];

    for (var rawMessage in sortedRawMessages) {
      switch (rawMessage.type) {
        case RawMessageTypes.textMessage:
          parsedMessages.add(ClientParsedMessage(
            content: rawMessage.content['message']!,
            id: rawMessage.id,
            userId: rawMessage.senderUserId,
            unixTime: rawMessage.unixTime,
            type: ParsedMessageTypes.textMessage,
            reactions: [],
            relatedMessageIds: [],
          ));
          break;
        case RawMessageTypes.reaction:
          parsedMessages
              .where((element) => element.id == rawMessage.relatedMessageId)
              .first
            ..reactions.add(ClientReaction(
              emoji: rawMessage.content['emoji']!,
              userId: rawMessage.senderUserId,
              unixTime: rawMessage.unixTime,
            ))
            ..relatedMessageIds.add(rawMessage.id);
          break;
        default:
      }
    }

    return parsedMessages;
  }

  static Future<ClientChat> fromJsonString(String jsonString) async {
    final json = jsonDecode(jsonString);
    List<ClientRawMessage> rawMessages = [];
    for (var rawMessage in json['rawMessages']) {
      rawMessages.add(await ClientRawMessage.fromJsonString(rawMessage));
    }

    return ClientChat(
      rawMessages: rawMessages,
    );
  }

  static Future<ClientChat> addMessage(ClientChat chat,ClientRawMessage message, String senderId) {
    return Future.value(chat.copyWith(
      rawMessages: [...chat.rawMessages, message],
    ));
  }
}
