import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:isar/isar.dart';
import 'package:laber_app/store/types/chat.dart';
import 'package:laber_app/utils/id_generator.dart';

part 'raw_message.g.dart';

@collection
class RawMessage {
  Id id = Isar.autoIncrement;

  @Index(type: IndexType.hash)
  String uniqueId = newCuid();

  @enumerated
  late RawMessageTypes type;

  late String senderUserId;
  late String senderDeviceId;

  late String recipientUserId;

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
        TextMessageContent content =
            TextMessageContent.fromJsonString(this.content);
        return content.text;
      case RawMessageTypes.reaction:
        return 'Reaction';
      default:
        return 'Unknown';
    }
  }

  @ignore
  String get jsonString {
    return jsonEncode({
      'uniqueId': uniqueId,
      'type': type.toString(),
      'senderUserId': senderUserId,
      'senderDeviceId': senderDeviceId,
      'recipientUserId': recipientUserId,
      'content': content,
      'unixTime': unixTime,
      'status': status.toString(),
    });
  }

  static RawMessage fromJsonString(String jsonString) {
    final json = jsonDecode(jsonString);
    final uniqueId = json['uniqueId'];
    final type =
        RawMessageTypes.values.firstWhere((e) => e.toString() == json['type']);
    final senderUserId = json['senderUserId'];
    final senderDeviceId = json['senderDeviceId'];
    final recipientUserId = json['recipientUserId'];
    final content = json['content'];
    final unixTime = json['unixTime'];
    final status = RawMessageStatus.values
        .firstWhere((e) => e.toString() == json['status']);

    var message = RawMessage()
      ..uniqueId = uniqueId
      ..type = type
      ..senderUserId = senderUserId
      ..senderDeviceId = senderDeviceId
      ..recipientUserId = recipientUserId
      ..content = content
      ..unixTime = unixTime
      ..status = status;

    return message;
  }
}

enum RawMessageStatus {
  sending,
  sent,
  failed,
  received,
  none,
}

enum RawMessageTypes {
  textMessage,
  infoMessage,
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

class InfoMessageContent {
  String text;

  InfoMessageContent({required this.text});

  String toJsonString() {
    return jsonEncode({
      'text': text,
    });
  }

  static InfoMessageContent fromJsonString(String jsonString) {
    final json = jsonDecode(jsonString);
    final text = json['text'];
    var content = InfoMessageContent(text: text);
    return content;
  }
}

class ReactionMessageContent {
  late String messageUniqueId;
  late String reaction;

  ReactionMessageContent(
      {required this.messageUniqueId, required this.reaction});

  String toJsonString() {
    return jsonEncode({
      'messageUniqueId': messageUniqueId,
      'reaction': reaction,
    });
  }

  static ReactionMessageContent fromJsonString(String jsonString) {
    final json = jsonDecode(jsonString);
    final messageUniqueId = json['messageUniqueId'];
    final reaction = json['reaction'];
    var content = ReactionMessageContent(
        messageUniqueId: messageUniqueId, reaction: reaction);
    return content;
  }
}

int calculateDayDifference(DateTime date) {
  DateTime now = DateTime.now();
  DateTime dateToCompare = DateTime(date.year, date.month, date.day);
  return now.difference(dateToCompare).inDays;
}
