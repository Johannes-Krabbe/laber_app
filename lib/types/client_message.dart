import 'dart:convert';

import 'package:intl/intl.dart';

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

  Future<String> toJson() async {
    return jsonEncode({
      'id': id,
      'content': content,
      'type': type.index,
      'senderUserId': senderUserId,
      'relatedMessageId': relatedMessageId,
      'unixTime': unixTime,
      'chatId': chatId,
    });
  }

  String get formattedLongTime {
    var time = DateTime.fromMillisecondsSinceEpoch(unixTime);
    var timediff = calculateDayDifference(time);

    if (timediff == 0) {
      return DateFormat('HH:mm').format(time);
    } else if (timediff == 1) {
      return 'Yesterday';
    } else if (timediff < 5) {
      return DateFormat('EEEE').format(time);
    } else {
      return DateFormat('dd.MM.yyyy').format(time);
    }
  }

  String get previewString {
      switch (type) {
        case RawMessageTypes.textMessage:
          return content['message']!;
        case RawMessageTypes.reaction:
          return 'Reaction';
        default:
          return 'Unknown';
  }
  }


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


int calculateDayDifference(DateTime date) {
  DateTime now = DateTime.now();
  DateTime dateToCompare = DateTime(date.year, date.month, date.day);
  return now.difference(dateToCompare).inDays;
}

