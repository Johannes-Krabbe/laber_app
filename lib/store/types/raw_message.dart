import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:isar/isar.dart';
import 'package:laber_app/store/types/chat.dart';

part 'raw_message.g.dart';

@collection
class RawMessage {
  Id id = Isar.autoIncrement;

  @Index(type: IndexType.hash)
  String? apiId;

  @enumerated
  late RawMessageTypes type;

  late String senderUserId;
  late String senderDeviceId;

  late String content;
  late int unixTime;

  @enumerated
  late RawMessageStatus status;

  @Backlink(to: 'messages')
  final chat = IsarLink<Chat>();

  // == helper methods ==
  @ignore
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

  @ignore
  String get previewString {
    switch (type) {
      case RawMessageTypes.textMessage:
        TextMessageContent content = TextMessageContent.fromJsonString(this.content);
        return content.text;
      case RawMessageTypes.reaction:
        return 'Reaction';
      default:
        return 'Unknown';
    }
  }
}

enum RawMessageStatus {
  sending,
  sent,
  failed,
  received,
}

enum RawMessageTypes {
  initMessage,
  textMessage,
  reaction,
}

class InitMessageContent {}

class TextMessageContent {
  String text;

  TextMessageContent({required this.text});

  String toJsonString() {
    return jsonEncode({
      'text': text,
    });
  }

  static TextMessageContent fromJsonString(String jsonString) {
    final json = jsonDecode(jsonString);
    final text = json['text'];
    var content = TextMessageContent(text: text);
    return content;
  }
}

class ReactionMessageContent {
  late String messageApiId;
  late String reaction;

  ReactionMessageContent({required this.messageApiId, required this.reaction});

  String toJsonString() {
    return jsonEncode({
      'messageApiId': messageApiId,
      'reaction': reaction,
    });
  }

  static ReactionMessageContent fromJsonString(String jsonString) {
    final json = jsonDecode(jsonString);
    final messageApiId= json['messageApiId'];
    final reaction = json['reaction'];
    var content = ReactionMessageContent(messageApiId: messageApiId, reaction: reaction);
    return content;
  }
}

int calculateDayDifference(DateTime date) {
  DateTime now = DateTime.now();
  DateTime dateToCompare = DateTime(date.year, date.month, date.day);
  return now.difference(dateToCompare).inDays;
}
