import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laber_app/services/chat_service.dart';
import 'package:laber_app/services/message_create_service.dart';
import 'package:laber_app/state/types/chat_state.dart';
import 'package:laber_app/store/repositories/chat_repository.dart';

sealed class ChatEvent {}

final class LoadChatEvent extends ChatEvent {}

final class CreateChatEvent extends ChatEvent {}

final class SendTextMessageEvent extends ChatEvent {
  final String message;
  SendTextMessageEvent(this.message);
}

final class RawMessageChangeChatEvent extends ChatEvent {}

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc(String apiContactId) : super(ChatState(contactApiId: apiContactId)) {
    on<LoadChatEvent>((event, emit) async {
      await _onLoadChat(event, emit);
    });
    on<SendTextMessageEvent>((event, emit) async {
      await _onSendTextMessage(event, emit);
    });
    on<CreateChatEvent>((event, emit) async {
      await _onCreateChat(event, emit);
    });
    on<RawMessageChangeChatEvent>((event, emit) async {
      await _onRawMessageChangeChat(event, emit);
    });
  }

  _onLoadChat(LoadChatEvent event, Emitter<ChatState> emit) async {
    print('loading chat1');
    emit(state.copyWith(state: ChatStateEnum.loading));
    var chat = await ChatRepository.getChat(contactApiId: state.contactApiId);
    if (chat == null) {
      emit(state.copyWith(state: ChatStateEnum.notCreated));
    } else {
      emit(state.copyWith(state: ChatStateEnum.success, chat: chat));
    }
  }

  _onSendTextMessage(
      SendTextMessageEvent event, Emitter<ChatState> emit) async {
    await MessageCreateService.sendTextMessage(
        contactApiId: state.contactApiId, message: event.message);
    emit(state.copyWith(state: ChatStateEnum.success));
  }

  _onCreateChat(CreateChatEvent event, Emitter<ChatState> emit) async {
    emit(state.copyWith(state: ChatStateEnum.loading));
    // try {
    var chat = await ChatRepository.getChat(contactApiId: state.contactApiId);
    if (chat != null) {
      emit(state.copyWith(state: ChatStateEnum.success, chat: chat));
      return;
    }

    await ChatService.createChat(contactApiId: state.contactApiId);
    chat = await ChatRepository.getChat(contactApiId: state.contactApiId);
    if (chat == null) {
      emit(state.copyWith(
          state: ChatStateEnum.error, error: 'Error loading chat'));
    } else {
      emit(state.copyWith(state: ChatStateEnum.success, chat: chat));
    }
    /*
    } catch (e) {
      emit(state.copyWith(state: ChatStateEnum.error, error: e.toString()));
    }
    */
  }

  _onRawMessageChangeChat(
      RawMessageChangeChatEvent event, Emitter<ChatState> emit) async {
    var fetchedChat =
        await ChatRepository.getChat(contactApiId: state.contactApiId);

    if (fetchedChat == null || state.chat == null) {
      emit(state.copyWith(state: ChatStateEnum.notCreated));
      return;
    }

    if (fetchedChat.messages.length != state.chat!.messages.length) {
      emit(
        state.copyWith(state: ChatStateEnum.success, chat: fetchedChat),
      );
      print('message status updated');
      return;
    }

    for (var message in fetchedChat.messages) {
      final exisitngMessage =
          state.chat!.messages.where((m) => m.id == message.id);
      if (exisitngMessage.isEmpty) {
        emit(
          state.copyWith(state: ChatStateEnum.success, chat: fetchedChat),
        );
        print('message status updated');
        return;
      } else if (exisitngMessage.first.status != message.status) {
        // update message
        emit(
          state.copyWith(state: ChatStateEnum.success, chat: fetchedChat),
        );
        print('message status updated');
        return;
      }
      return;
    }
  }
}
