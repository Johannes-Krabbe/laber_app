import 'package:laber_app/types/client_message.dart';

class ClientChat {
  final List<ClientRawMessage> rawMessages;

  ClientChat({
    this.rawMessages = const [],
  });

  ClientChat copyWith({
    List<ClientRawMessage>? rawMessages,
  }) {
    return ClientChat(
      rawMessages: rawMessages ?? this.rawMessages,
    );
  }

  /*
  Message? get latestMessage {
    if(rawMessages.isEmpty) return null;
    rawMessages.sort((a, b) => a.unixTime.compareTo(b.unixTime));
    return rawMessages.last;
  }
  */

  List<ClientRawMessage> get sortedRawMessages {
    List<ClientRawMessage> sortedMessages = rawMessages;
    sortedMessages.sort((a, b) => a.unixTime.compareTo(b.unixTime));
    return sortedMessages.toList();
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
}
