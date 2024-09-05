/*
import 'dart:convert';

import 'package:intl/intl.dart';

class ClientRawMessage {
  final String id;
  final Map<String, String> content;
  final RawMessageTypes type;
  final String senderUserId;
  final String senderDeviceId;
  final String? relatedMessageId;
  final int unixTime;
  final String chatId;

  ClientRawMessage({
    required this.id,
    required this.content,
    required this.type,
    required this.senderUserId,
    required this.senderDeviceId,
    this.relatedMessageId,
    required this.unixTime,
    required this.chatId,
  });

  Future<String> toJson() async {
    return jsonEncode({
      'id': id,
      'content': content,
      'type': type.index,
      'senderUserId': senderUserId,
      'senderDeviceId': senderDeviceId,
      'relatedMessageId': relatedMessageId,
      'unixTime': unixTime,
      'chatId': chatId,
    });
  }

  static Future<ClientRawMessage> fromJsonString(String jsonString) async {
    final json = jsonDecode(jsonString);

    final rawContent = json['content'];

    final stringContent = <String, String>{};

    for (var key in rawContent.keys) {
      stringContent[key] = rawContent[key].toString();
    }

    return ClientRawMessage(
      id: json['id'],
      content: stringContent,
      type: RawMessageTypes.values[json['type']],
      senderUserId: json['senderUserId'],
      senderDeviceId: json['senderDeviceId'],
      relatedMessageId: json['relatedMessageId'],
      unixTime: json['unixTime'],
      chatId: json['chatId'],
    );
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
*/


int calculateDayDifference(DateTime date) {
  DateTime now = DateTime.now();
  DateTime dateToCompare = DateTime(date.year, date.month, date.day);
  return now.difference(dateToCompare).inDays;
}
