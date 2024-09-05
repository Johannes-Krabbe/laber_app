import 'package:laber_app/store/types/contact.dart';

enum ContactsStateEnum { loading, none, success }

class ContactsState {
  final ContactsStateEnum state;
  final List<Contact> contacts;

  const ContactsState({
    this.state = ContactsStateEnum.none,
    this.contacts = const [],
  });

  ContactsState copyWith({
    ContactsStateEnum? state,
    List<Contact>? contacts,
  }) {
    return ContactsState(
      state: state ?? this.state,
      contacts: contacts ?? this.contacts,
    );
  }

  List<Contact> get sortedContacts {
    List<Contact> contacts = List.from(this.contacts);
    contacts.sort((a, b) {
      if (a.chat.value?.latestMessage == null) return 1;
      if (b.chat.value?.latestMessage == null) return -1;
      return a.chat.value!.latestMessage!.unixTime
          .compareTo(b.chat.value!.latestMessage!.unixTime * -1);
    });
    return contacts;
  }
}
