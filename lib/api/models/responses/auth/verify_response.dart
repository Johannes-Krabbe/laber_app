import 'package:laber_app/api/models/types/private_user.dart';

class AuthVerifyResponse {
  ApiPrivateUser? user;
  String? token;
  String? message;

  AuthVerifyResponse({this.user, this.token, this.message});

  AuthVerifyResponse.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? ApiPrivateUser.fromJson(json['user']) : null;
    token = json['token'];
    message = json['message'];
  }
}

