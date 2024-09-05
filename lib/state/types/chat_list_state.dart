import 'package:laber_app/store/types/chat.dart';

enum ChatListStateEnum { initial, loading, loaded, error }

class ChatListState {
  final List<Chat> chats;

  final ChatListStateEnum state;

  const ChatListState({
    this.chats = const [],
    this.state = ChatListStateEnum.initial,
  });

  ChatListState copyWith({
    List<Chat>? chats,
    ChatListStateEnum? state,
  }) {
    return ChatListState(
      chats: chats ?? this.chats,
      state: state ?? this.state,
    );
  }

  List<Chat> search(String query) {
    return chats.where((chat) {
      return chat.contact.value?.name?.toLowerCase().contains(query.toLowerCase()) ==
              true ||
          chat.contact.value?.phoneNumber?.toLowerCase().contains(query.toLowerCase()) ==
              true;
    }).toList();

  }
}
