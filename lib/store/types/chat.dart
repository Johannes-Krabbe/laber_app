import 'package:isar/isar.dart';
import 'package:laber_app/store/types/contact.dart';
import 'package:laber_app/store/types/device.dart';
import 'package:laber_app/store/types/raw_message.dart';

part 'chat.g.dart';

@collection
class Chat {
  Id id = Isar.autoIncrement;

  final messages = IsarLinks<RawMessage>();

  final devices = IsarLinks<Device>();

  @Backlink(to: 'chat')
  final contact = IsarLink<Contact>();

  // == helper methods ==

  @ignore
  RawMessage? get latestMessage =>
      messages.isNotEmpty ? sortedMessages.first : null;

  @ignore
  List<RawMessage> get sortedMessages {
    List<RawMessage> sortedMessages = List.from(messages);
    sortedMessages.sort((a, b) => a.unixTime.compareTo(b.unixTime));
    return sortedMessages.reversed.toList();
  }

  @ignore
  List<ClientParsedMessage> get sortedParsedMessages {
    List<ClientParsedMessage> sortedMessages = parsedMessages;
    sortedMessages.sort((a, b) => a.unixTime.compareTo(b.unixTime));
    return sortedMessages.reversed.toList();
  }

  @ignore
  List<ClientParsedMessage> get parsedMessages {
    List<ClientParsedMessage> parsedMessages = [];

    for (var rawMessage in messages) {
      switch (rawMessage.type) {
        case RawMessageTypes.textMessage:
          final content = TextMessageContent.fromJsonString(rawMessage.content);
          parsedMessages.add(ClientParsedMessage(
            text: content.text,
            uniqueId: rawMessage.uniqueId,
            senderUserId: rawMessage.senderUserId,
            unixTime: rawMessage.unixTime,
            type: ParsedMessageTypes.textMessage,
            reactions: [],
          ));
          break;
        case RawMessageTypes.infoMessage:
          final content = InfoMessageContent.fromJsonString(rawMessage.content);
          parsedMessages.add(ClientParsedMessage(
            text: content.text,
            uniqueId: rawMessage.uniqueId,
            senderUserId: rawMessage.senderUserId,
            unixTime: rawMessage.unixTime,
            type: ParsedMessageTypes.infoMessage,
            reactions: [],
          ));
          break;
        case RawMessageTypes.reaction:
          final content =
              ReactionMessageContent.fromJsonString(rawMessage.content);

          parsedMessages
              .where((element) => element.uniqueId == content.messageUniqueId)
              .first
              .reactions
              .add(ClientReaction(
                  emoji: content.reaction,
                  userId: rawMessage.senderUserId,
                  unixTime: rawMessage.unixTime));
          break;
        default:
          break;
      }
    }

    return parsedMessages;
  }
}

class ClientParsedMessage {
  final String text;
  final String uniqueId;
  final String senderUserId;
  final int unixTime;
  final ParsedMessageTypes type;
  final List<ClientReaction> reactions;

  ClientParsedMessage({
    required this.text,
    required this.uniqueId,
    required this.senderUserId,
    required this.unixTime,
    required this.type,
    required this.reactions,
  });
}

enum ParsedMessageTypes { textMessage, infoMessage }

class ClientReaction {
  final String emoji;
  final String userId;
  final int unixTime;

  ClientReaction({
    required this.emoji,
    required this.userId,
    required this.unixTime,
  });
}
