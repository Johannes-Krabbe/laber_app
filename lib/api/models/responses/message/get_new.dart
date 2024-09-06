import 'package:laber_app/api/models/types/private_message.dart';

class MessageGetNewResponse {
  List<ApiPrivateMessage>? messages;

  MessageGetNewResponse({this.messages});

  MessageGetNewResponse.fromJson(Map<String, dynamic> json) {
    if (json['messages'] != null) {
      messages = [];
      json['messages'].forEach((v) {
        messages!.add(ApiPrivateMessage.fromJson(v));
      });
    } else {
      messages = [];
    }
  }

}
