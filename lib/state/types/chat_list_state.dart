import 'package:intl/intl.dart';

enum ChatListStateEnum { loading, none, success }

class ChatListState {
  final ChatListStateEnum state;
  final String? error;
  final List<Chat>? chats;

  const ChatListState({
    this.state = ChatListStateEnum.none,
    this.error,
    this.chats,
  });

  // copy with
  ChatListState copyWith({
    ChatListStateEnum? state,
    String? error,
    List<Chat>? chats,
  }) {
    return ChatListState(
      state: state ?? this.state,
      error: error ?? this.error,
      chats: chats ?? this.chats,
    );
  }

  // search by name
  List<Chat> searchByName(String query) {
    return chats!.where((chat) {
      return chat.name.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }
}

class Chat {
  final String name;
  final List<Message> messages;
  final String avatarUrl;

  const Chat({
    required this.name,
    required this.messages,
    required this.avatarUrl,
  });

  Chat copyWith({
    String? name,
    List<Message>? messages,
    String? time,
    String? avatarUrl,
  }) {
    return Chat(
      name: name ?? this.name,
      messages: messages ?? this.messages,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }

  Chat addMessage(Message message) {
    return Chat(
      name: name,
      messages: [...messages, message],
      avatarUrl: avatarUrl,
    );
  }

  // get latest message
  Message get latestMessage {
    messages.sort((a, b) => a.unixTime.compareTo(b.unixTime));
    return messages.last;
  }
}

class Message {
  final String message;
  final int unixTime;
  final String senderId;
  final String receiverId;

  const Message({
    required this.message,
    required this.unixTime,
    required this.senderId,
    required this.receiverId,
  });

  Message copyWith({
    String? message,
    int? unixTime,
    String? senderId,
    String? receiverId,
  }) {
    return Message(
      message: message ?? this.message,
      unixTime: unixTime ?? this.unixTime,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
    );
  }

  String get formattedTime {
    var time = DateTime.fromMillisecondsSinceEpoch(unixTime);
    var timediff = calculateDifference(time);

    if(timediff == 0) {
      return DateFormat('HH:mm').format(time);
    } else if(timediff == 1) {
      return 'Yesterday';
    } else if(timediff < 5) {
      return DateFormat('EEEE').format(time);
    } else {
      return DateFormat('dd.MM.yyyy').format(time);
    }
  }
}

int calculateDifference(DateTime date) {
  DateTime now = DateTime.now();
  DateTime dateToCompare = DateTime(date.year, date.month, date.day);
  return now.difference(dateToCompare).inDays;
}
