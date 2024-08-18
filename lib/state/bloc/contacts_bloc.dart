import 'package:laber_app/api/models/types/public_user.dart';
import 'package:laber_app/state/types/contacts_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laber_app/types/client_contact.dart';

sealed class ContactsEvent {}

final class LoadContactsContactsEvent extends ContactsEvent {}

final class FetchSingleContactByIdContactsEvent extends ContactsEvent {
  final String id;

  FetchSingleContactByIdContactsEvent(this.id);
}

final class SendMessageContactsEvent extends ContactsEvent {
  final String contactId;
  final String message;

  SendMessageContactsEvent(this.contactId, this.message);
}

final class AddContactEvent extends ContactsEvent {
  final ApiPublicUser contact;

  AddContactEvent(this.contact);
}

class ContactsBloc extends Bloc<ContactsEvent, ContactsState> {
  ContactsBloc() : super(const ContactsState()) {
    on<LoadContactsContactsEvent>((event, emit) async {
      await _onLoadContacts(event, emit);
    });
    on<FetchSingleContactByIdContactsEvent>((event, emit) async {
      await _onFetchSingleContactById(event, emit);
    });
    on<SendMessageContactsEvent>((event, emit) async {
      await _onSendMessage(event, emit);
    });
    on<AddContactEvent>((event, emit) async {
      await _onAddContact(event, emit);
    });
  }

  _onLoadContacts(
      LoadContactsContactsEvent event, Emitter<ContactsState> emit) async {
    emit(state.copyWith(state: ContactsStateEnum.loading, error: null));

    // TODO
    var contacts = <ClientContact>[];

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
        // TODO

        emit(state.copyWith(
          state: ContactsStateEnum.success,
          error: null,
          contacts: [...(state.contacts ?? [])],
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

        emit(state.copyWith(
          state: ContactsStateEnum.success,
          error: null,
        ));
      } else {
        throw Exception("Contact not found");
      }
    }
  }

  _onAddContact(AddContactEvent event, Emitter<ContactsState> emit) {
    if (state.contacts != null) {
      var foundContacts = state.contacts!.where((contact) {
        return contact.id == event.contact.id;
      });

      if (foundContacts.isEmpty) {
        var newContact = ClientContact(
          profilePicture: event.contact.profilePicture,
          id: event.contact.id!,
          name: event.contact.name,
          phoneNumber: event.contact.phoneNumberHash!,
        );

        emit(state.copyWith(
          state: ContactsStateEnum.success,
          error: null,
          contacts: [...(state.contacts ?? []), newContact],
        ));
      } else {
        throw Exception("Contact already exists");
      }
    }
  }
}
