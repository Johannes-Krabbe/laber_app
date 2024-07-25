import 'package:faker/faker.dart';
import 'package:laber_app/state/types/contacts_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laber_app/utils/id_generator.dart';

sealed class ContactsEvent {}

final class FetchContactsContactsEvent extends ContactsEvent {}

final class FetchSingleContactByIdContactsEvent extends ContactsEvent {
  final String id;

  FetchSingleContactByIdContactsEvent(this.id);
}

final class SendMessageContactsEvent extends ContactsEvent {
  final String contactId;
  final String message;

  SendMessageContactsEvent(this.contactId, this.message);
}

class ContactsBloc extends Bloc<ContactsEvent, ContactsState> {
  ContactsBloc() : super(const ContactsState()) {
    on<FetchContactsContactsEvent>((event, emit) async {
      await _onFetchContacts(event, emit);
    });
    on<FetchSingleContactByIdContactsEvent>((event, emit) async {
      await _onFetchSingleContactById(event, emit);
    });
    on<SendMessageContactsEvent>((event, emit) async {
      await _onSendMessage(event, emit);
    });
  }

  _onFetchContacts(
      FetchContactsContactsEvent event, Emitter<ContactsState> emit) async {
    emit(state.copyWith(state: ContactsStateEnum.loading, error: null));

    var contacts = <Contact>[];

    for (var i = 0; i < 10; i++) {
      var unix = DateTime(2024, 07, 10, 10, 10).millisecondsSinceEpoch;

      contacts.add(
        Contact(
          id: newCuid(),
          name: faker.person.name(),
          phoneNumber: faker.phoneNumber.de(),
          status: faker.lorem.word(),
          unixLastSeen: unix,
          profilePicture:
              "https://randomuser.me/api/portraits/med/women/${i.toString()}.jpg",
        ),
      );
    }

    emit(state.copyWith(
      state: ContactsStateEnum.success,
      error: null,
      contacts: contacts,
    ));
  }

  _onFetchSingleContactById(
      FetchSingleContactByIdContactsEvent event, Emitter<ContactsState> emit) {
    emit(state.copyWith(state: ContactsStateEnum.loading, error: null));

    if (state.contacts != null) {
      var foundContacts = state.contacts!.where((contact) {
        return contact.id == event.id;
      });

      if (foundContacts.length == 1) {
        emit(state.copyWith(state: ContactsStateEnum.success, error: null));
      } else if (foundContacts.isEmpty) {
        var contact = Contact(
          id: newCuid(),
          name: faker.person.name(),
          phoneNumber: faker.phoneNumber.us(),
          status: faker.lorem.word(),
          unixLastSeen: DateTime(2024, 07, 10, 10, 10).millisecondsSinceEpoch,
          profilePicture: "https://randomuser.me/api/portraits/med/men/2.jpg",
        );

        emit(state.copyWith(
          state: ContactsStateEnum.success,
          error: null,
          contacts: [...(state.contacts ?? []), contact],
        ));
      } else {
        throw Exception("More than one contact found with the same id");
      }
    }
  }

  _onSendMessage(SendMessageContactsEvent event, Emitter<ContactsState> emit) {
    if (state.contacts != null) {
      var foundContacts = state.contacts!.where((contact) {
        return contact.id == event.contactId;
      });

      if (foundContacts.length == 1) {
        var contact = foundContacts.first;
        var message = Message(
          receiverId: contact.id,
          senderId: "",
          message: event.message,
          unixTime: DateTime.now().millisecondsSinceEpoch,
        );

        List<Message> newMessages = [message, ...(contact.messages ?? [])];

        var newContact = contact.copyWith(messages: newMessages);

        var newContacts = state.contacts!.map((c) {
          if (c.id == contact.id) {
            return newContact;
          }
          return c;
        }).toList();

        emit(state.copyWith(
          state: ContactsStateEnum.success,
          error: null,
          contacts: newContacts,
        ));
      } else {
        throw Exception("Contact not found");
      }
    }
  }
}
