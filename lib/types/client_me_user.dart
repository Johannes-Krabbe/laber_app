import 'dart:convert';

import 'package:laber_app/api/models/types/private_user.dart';

class ClientMeUser {
  String? id;
  String? phoneNumber;
  int? unixCreatedAt;
  bool? onboardingCompleted;
  String? profilePicture;
  String? name;

  ClientMeUser({
    this.id,
    this.phoneNumber,
    this.unixCreatedAt,
    this.onboardingCompleted,
    this.profilePicture,
    this.name,
  });

  factory ClientMeUser.fromApiPrivateMeUser(ApiPrivateUser apiPrivateUser) {
    return ClientMeUser(
      id: apiPrivateUser.id,
      phoneNumber: apiPrivateUser.phoneNumber,
      unixCreatedAt: apiPrivateUser.unixCreatedAt,
      onboardingCompleted: apiPrivateUser.onboardingCompleted,
      profilePicture: apiPrivateUser.profilePicture,
      name: apiPrivateUser.name,
    );
  }

  // Convert ClientMeUser object to JSON string
  String toJsonString() {
    return jsonEncode({
      'id': id,
      'phoneNumber': phoneNumber,
      'unixCreatedAt': unixCreatedAt,
      'onboardingCompleted': onboardingCompleted,
      'profilePicture': profilePicture,
      'name': name,
    });
  }

  // Create ClientMeUser object from JSON string
  factory ClientMeUser.fromJsonString(String jsonString) {
    Map<String, dynamic> jsonMap = jsonDecode(jsonString);
    return ClientMeUser(
      id: jsonMap['id'],
      phoneNumber: jsonMap['phoneNumber'],
      unixCreatedAt: jsonMap['unixCreatedAt'],
      onboardingCompleted: jsonMap['onboardingCompleted'],
      profilePicture: jsonMap['profilePicture'],
      name: jsonMap['name'],
    );
  }

}
