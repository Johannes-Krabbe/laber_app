import 'package:laber_app/api/models/types/private_user.dart';

class VerifyResponse {
  PrivateUser? user;
  String? token;
  String? message;

  VerifyResponse({this.user, this.token, this.message});

  VerifyResponse.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? new PrivateUser.fromJson(json['user']) : null;
    token = json['token'];
    message = json['message'];
  }
}

