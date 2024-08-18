import 'dart:convert';

import 'package:laber_app/types/client_chat.dart';
import 'package:laber_app/types/client_message.dart';

class ClientContact {
  final String id;
  final String? name;
  final String? phoneNumber;
  final String? profilePicture;
  final String? status;

  ClientChat? chat;

  ClientContact({
    required this.id,
    this.name,
    this.phoneNumber,
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

  static Future<ClientContact> createChat(ClientContact contact) async {
    return contact.copyWith(
      chat: contact.chat ?? ClientChat(rawMessages: []),
    );
  }

  static Future<ClientContact> sendMessage(
      ClientContact contact, String message, String userId) async {
    contact = await createChat(contact);

    final rawMessage = ClientRawMessage(
      // TODO
      chatId: '',
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: {'message': message},
      senderUserId: userId,
      unixTime: DateTime.now().millisecondsSinceEpoch,
      type: RawMessageTypes.textMessage,
    );

    return contact.copyWith(
      chat: contact.chat?.copyWith(
        rawMessages: [...contact.chat!.rawMessages, rawMessage],
      ),
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

  static Future<ClientContact> fromJsonString(String jsonString) async {
    final json = jsonDecode(jsonString);

    return ClientContact(
      id: json['id'],
      name: json['name'],
      phoneNumber: json['phoneNumber'],
      profilePicture: json['profilePicture'],
      status: json['status'],
      chat: json['chat'] == null
          ? null
          : await ClientChat.fromJsonString(json['chat']),
    );
  }
}
