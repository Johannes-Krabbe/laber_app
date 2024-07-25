import 'package:laber_app/api/models/types/private_user.dart';

class AuthMeResponse {
  ApiPrivateUser? user;

  AuthMeResponse({this.user});

  AuthMeResponse.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? ApiPrivateUser.fromJson(json['user']) : null;
  }
}

