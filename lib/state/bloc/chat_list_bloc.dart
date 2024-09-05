import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isar/isar.dart';
import 'package:laber_app/isar.dart';
import 'package:laber_app/state/types/chat_list_state.dart';
import 'package:laber_app/store/types/chat.dart';

sealed class ChatListEvent {}

final class FetchChatListEvent extends ChatListEvent {}

final class RefetchChatListEvent extends ChatListEvent {}

class ChatListBloc extends Bloc<ChatListEvent, ChatListState> {
  ChatListBloc() : super(const ChatListState()) {
    on<FetchChatListEvent>((event, emit) async {
      await _onFetchChatList(event, emit);
    });
    on<RefetchChatListEvent>((event, emit) async {
      await _onRefetchChatList(event, emit);
    });
  }

  _onFetchChatList(
      FetchChatListEvent event, Emitter<ChatListState> emit) async {
    emit(
      state.copyWith(
        state: ChatListStateEnum.loading,
      ),
    );

    final isar = await getIsar();
    final chats = await isar.chats.where().findAll();

    emit(
      state.copyWith(
        state: ChatListStateEnum.loaded,
        chats: chats,
      ),
    );
  }

  _onRefetchChatList(
      RefetchChatListEvent event, Emitter<ChatListState> emit) async {
    emit(
      state.copyWith(
        state: ChatListStateEnum.loading,
      ),
    );

    final isar = await getIsar();
    final chats = await isar.chats.where().findAll();

    emit(
      state.copyWith(
        state: ChatListStateEnum.loaded,
        chats: chats,
      ),
    );
  }
}
