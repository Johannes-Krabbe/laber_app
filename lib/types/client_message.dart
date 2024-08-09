class ClientRawMessage {
  final String id;
  final Map<String, String> content;
  final RawMessageTypes type;
  final String senderUserId;
  final String relatedMessageId;
  final int unixTime;
  final String chatId;

  ClientRawMessage({
    required this.id,
    required this.content,
    required this.type,
    required this.senderUserId,
    required this.relatedMessageId,
    required this.unixTime,
    required this.chatId,
  });
}

enum RawMessageTypes {
  textMessage,
  reaction,
}

class ClientParsedMessage{
  final String content;
  final String id;
  final String userId;
  final int unixTime;
  final ParsedMessageTypes type;
  final List<ClientReaction> reactions;
  final List<String> relatedMessageIds;

  ClientParsedMessage({
    required this.content,
    required this.id,
    required this.userId,
    required this.unixTime,
    required this.type,
    required this.reactions,
    required this.relatedMessageIds,
  });
}

enum ParsedMessageTypes {
  textMessage
}

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
