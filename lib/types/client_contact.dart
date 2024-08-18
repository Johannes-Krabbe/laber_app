import 'dart:convert';

import 'package:laber_app/types/client_chat.dart';

class ClientContact {
  final String id;
  final String? name;
  final String phoneNumber;
  final String? profilePicture;
  final String? status;

  ClientChat? chat;

  ClientContact({
    required this.id,
    this.name,
    required this.phoneNumber,
    this.profilePicture,
    this.status,
    this.chat,
  });

  ClientContact copyWith({
    String? id,
    String? name,
    String? phoneNumber,
    String? profilePicture,
    String? status,
    int? unixLastSeen,
    ClientChat? chat,
  }) {
    return ClientContact(
      id: id ?? this.id,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profilePicture: profilePicture ?? this.profilePicture,
      status: status ?? this.status,
      chat: chat ?? this.chat,
    );
  }

  Future<String> toJson() async {
    return jsonEncode({
      'id': id,
      'name': name,
      'phoneNumber': phoneNumber,
      'profilePicture': profilePicture,
      'status': status,
      'chat': await chat?.toJson(),
    });
  }
}
