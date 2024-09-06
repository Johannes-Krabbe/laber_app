import 'package:laber_app/api/models/types/private_message.dart';

class MessagePostNewResponse {
  final ApiPrivateMessage? message;

  MessagePostNewResponse({this.message});

  MessagePostNewResponse.fromJson(Map<String, dynamic> json)
      : message = json['message'] != null
            ? ApiPrivateMessage.fromJson(json['message'])
            : null;
}
