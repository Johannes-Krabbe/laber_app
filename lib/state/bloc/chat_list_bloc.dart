import 'package:faker/faker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laber_app/state/types/chat_list_state.dart';

sealed class ChatListEvent {}

final class FetchChatsChatListEvent extends ChatListEvent {}

class ChatListBloc extends Bloc<ChatListEvent, ChatListState> {
  ChatListBloc() : super(const ChatListState()) {
    on<FetchChatsChatListEvent>((event, emit) async {
      await _onFetchChats(event, emit);
    });
  }

  _onFetchChats(
      FetchChatsChatListEvent event, Emitter<ChatListState> emit) async {
    emit(state.copyWith(state: ChatListStateEnum.loading, error: null));

    var chats = <Chat>[];

    for (var i = 10; i < 30; i++) {
      var messageList = <Message>[];
      for (var j = 10; j < 30; j++) {
        // var unix = faker.date.dateTime(minYear: 2010, maxYear: 2024).toUtc().millisecondsSinceEpoch;
        var unix = DateTime(2024, 07, 10, 10, 10).millisecondsSinceEpoch;

        messageList.add(
          Message(
              message: faker.lorem.sentence(),
              unixTime: unix,
              senderId: "1234",
              receiverId: faker.guid.guid()),
        );
      }

      chats.add(
        Chat(
          name: faker.person.name(),
          messages: messageList,
          avatarUrl:
              "https://randomuser.me/api/portraits/med/men/${i.toString()}.jpg",
        ),
      );
    }

    emit(state.copyWith(
      state: ChatListStateEnum.none,
      error: null,
      chats: chats,
    ));
  }
}
