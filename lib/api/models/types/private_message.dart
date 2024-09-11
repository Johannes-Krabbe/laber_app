import 'dart:convert';

import 'package:laber_app/types/message/api_message.dart';

class ApiPrivateMessage {
  String apiId;
  String senderDeviceId;
  String senderUserId;
  String content;
  int unixCreatedAt;

  ApiPrivateMessage({
    required this.apiId,
    required this.senderDeviceId,
    required this.senderUserId,
    required this.content,
    required this.unixCreatedAt,
  });

  static ApiPrivateMessage fromJson(Map<String, dynamic> json) {
    final message = ApiPrivateMessage(
      apiId: json['id'],
      senderDeviceId: json['senderDeviceId'],
      senderUserId: json['senderUserId'],
      content: json['content'],
      unixCreatedAt: json['unixCreatedAt'],
    );
    return message;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': apiId,
      'senderDeviceId': senderDeviceId,
      'senderUserId': senderUserId,
      'content': content,
      'unixCreatedAt': unixCreatedAt,
    };
  }

  ApiMessageData get apiMessageData {
    return ApiMessageData.fromJsonString(jsonDecode(content)['message']);
  }
}
