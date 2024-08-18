import 'package:laber_app/api/models/types/public_user.dart';

class UserDiscoverPhoneNumberResponse {
  List<ApiPublicUser>? users;

  UserDiscoverPhoneNumberResponse({
    this.users,
  });

  UserDiscoverPhoneNumberResponse.fromJson(Map<String, dynamic> json) {
    if (json['users'] != null) {
      users = <ApiPublicUser>[];
      json['users'].forEach((v) {
        users!.add(ApiPublicUser.fromJson(v));
      });
    }
  }
}
