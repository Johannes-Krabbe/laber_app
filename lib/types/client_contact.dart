import 'package:laber_app/types/client_chat.dart';

class ClientContact {
  final String id;
  final String name;
  final String phoneNumber;
  final String profilePicture;
  final String status;
  final int unixLastSeen;

  ClientChat? chat;

   ClientContact({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.profilePicture,
    required this.status,
    required this.unixLastSeen,
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
      unixLastSeen: unixLastSeen ?? this.unixLastSeen,
      chat: chat ?? this.chat,
    );
  }
}
