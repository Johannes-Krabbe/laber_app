import 'package:laber_app/store/types/chat.dart';

enum ChatStateEnum { none, loading, success, error }

class ChatState {
  final ChatStateEnum state;

  final String contactApiId;
  final Chat? chat;

  final String? error;

  const ChatState(
      {this.state = ChatStateEnum.none, this.chat, required this.contactApiId, this.error});

  ChatState copyWith({ChatStateEnum? state, Chat? chat, String? contactApiId, String? error}) {
    return ChatState(
      state: state ?? this.state,
      contactApiId: contactApiId ?? this.contactApiId,
      chat: chat ?? this.chat,
      error: error ?? this.error,
    );
  }
}
