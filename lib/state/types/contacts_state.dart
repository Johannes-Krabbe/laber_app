import 'package:intl/intl.dart';

enum ContactsStateEnum { loading, none, success }

class ContactsState {
  final ContactsStateEnum state;
  final String? error;
  final List<Contact>? contacts;

  const ContactsState({
    this.state = ContactsStateEnum.none,
    this.error,
    this.contacts,
  });

  ContactsState copyWith({
    ContactsStateEnum? state,
    String? error,
    List<Contact>? contacts,
  }) {
    return ContactsState(
      state: state ?? this.state,
      error: error ?? this.error,
      contacts: contacts ?? this.contacts,
    );
  }

  List<Contact> search(String query) {
    if (contacts == null) return [];

    return contacts!.where((contact) {
      return contact.name.toLowerCase().contains(query.toLowerCase()) ||
          contact.phoneNumber.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  List<Contact> get sortedContacts {
    if (contacts == null) return [];
    contacts!.sort((a, b) => a.name.compareTo(b.name));
    return contacts!;
  }

  List<Contact> get sortedContactsByLastMessage {
    if (contacts == null) return [];
    List<Contact> contactsWithMessages = contacts!.where((contact) => contact.messages.isNotEmpty).toList();
    contactsWithMessages.sort((a, b) {
      if (a.latestMessage == null) return 1;
      if (b.latestMessage == null) return -1;
      return a.latestMessage!.unixTime.compareTo(b.latestMessage!.unixTime * -1);
    });
    return contactsWithMessages;
  }

  Contact? getById(String id) {
    if (contacts == null) return null;
    var foundContacts = contacts!.where((contact) => contact.id == id);
    if (foundContacts.isEmpty) return null;
    if (foundContacts.length > 1) return null;
    return foundContacts.first;
  }
}

class Contact {
  final String id;
  final String name;
  final String phoneNumber;
  final String profilePicture;
  final String status;
  final int unixLastSeen;

  final List<Message> messages;

  const Contact({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.profilePicture,
    required this.status,
    required this.unixLastSeen,
    this.messages = const [],
  });

  Contact copyWith({
    String? id,
    String? name,
    String? phoneNumber,
    String? profilePicture,
    String? status,
    int? unixLastSeen,
    List<Message>? messages,
  }) {
    return Contact(
      id: id ?? this.id,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profilePicture: profilePicture ?? this.profilePicture,
      status: status ?? this.status,
      unixLastSeen: unixLastSeen ?? this.unixLastSeen,
      messages: messages ?? this.messages,
    );
  }

  Message? get latestMessage {
    if(messages.isEmpty) return null;
    messages.sort((a, b) => a.unixTime.compareTo(b.unixTime));
    return messages.last;
  }

  List<Message> get sortedMessages {
    List<Message> sortedMessages = messages;
    sortedMessages.sort((a, b) => a.unixTime.compareTo(b.unixTime));
    return sortedMessages.reversed.toList();
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

  String get formattedLongTime {
    var time = DateTime.fromMillisecondsSinceEpoch(unixTime);
    var timediff = calculateDayDifference(time);

    if (timediff == 0) {
      return DateFormat('HH:mm').format(time);
    } else if (timediff == 1) {
      return 'Yesterday';
    } else if (timediff < 5) {
      return DateFormat('EEEE').format(time);
    } else {
      return DateFormat('dd.MM.yyyy').format(time);
    }
  }
}

int calculateDayDifference(DateTime date) {
  DateTime now = DateTime.now();
  DateTime dateToCompare = DateTime(date.year, date.month, date.day);
  return now.difference(dateToCompare).inDays;
}
