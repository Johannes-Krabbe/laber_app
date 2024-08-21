import 'package:laber_app/api/models/types/public_user.dart';

class UserGetByIdResponse {
  ApiPublicUser? user;

  UserGetByIdResponse({
    this.user,
  });

  UserGetByIdResponse.fromJson(Map<String, dynamic> json) {
    if (json['user'] != null) {
      user = ApiPublicUser.fromJson(json['user']);
    }
  }
}
