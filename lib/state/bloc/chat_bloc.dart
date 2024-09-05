import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laber_app/state/types/chat_state.dart';
import 'package:laber_app/store/services/chat_service.dart';

sealed class ChatEvent {}

final class LoadChatEvent extends ChatEvent {}

final class SendMessageEvent extends ChatEvent {
  final String message;
  SendMessageEvent(this.message);
}

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc(String apiContactId) : super(ChatState(contactApiId: apiContactId)) {
    on<LoadChatEvent>((event, emit) async {
      await _onLoadChat(event, emit);
    });
    on<SendMessageEvent>((event, emit) async {
      await _onSendMessage(event, emit);
    });
  }

  _onLoadChat(LoadChatEvent event, Emitter<ChatState> emit) async {
    emit(state.copyWith(state: ChatStateEnum.loading));
    var chat = await ChatService.getChat(contactApiId: state.contactApiId);
    if (chat == null) {
      try {
        await ChatService.createChat(contactApiId: state.contactApiId);
        chat = await ChatService.getChat(contactApiId: state.contactApiId);
      } catch (e) {
        emit(state.copyWith(state: ChatStateEnum.error, error: e.toString()));
      }
    }

    if (chat == null) {
      emit(state.copyWith(
          state: ChatStateEnum.error, error: 'Error loading chat'));
    } else {
      emit(state.copyWith(state: ChatStateEnum.success, chat: chat));
    }
  }

  _onSendMessage(SendMessageEvent event, Emitter<ChatState> emit) async {
    emit(state.copyWith(state: ChatStateEnum.loading));
    await ChatService.sendMessage(
        contactApiId: state.contactApiId, message: event.message);
    emit(state.copyWith(state: ChatStateEnum.success));
  }
}
