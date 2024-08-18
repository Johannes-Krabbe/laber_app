import 'package:laber_app/api/models/types/public_user.dart';
import 'package:laber_app/state/types/contacts_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laber_app/types/client_contact.dart';
import 'package:laber_app/utils/contacts_store_repository.dart';

sealed class ContactsEvent {}

final class LoadContactsContactsEvent extends ContactsEvent {
  final String userId;

  LoadContactsContactsEvent(this.userId);
}

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
  final String? phoneNumber;

  AddContactEvent(this.contact, this.phoneNumber);
}

final class SaveAllContactEvent extends ContactsEvent {}

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
    on<SaveAllContactEvent>((event, emit) async {
      await _onSaveAllContact(event, emit);
    });
  }

  _onLoadContacts(
      LoadContactsContactsEvent event, Emitter<ContactsState> emit) async {
    emit(state.copyWith(state: ContactsStateEnum.loading, error: null, userId: event.userId));
    final contactsStore =
        await ContactsStoreRepository.getContactsStore(event.userId);

    emit(state.copyWith(
      state: ContactsStateEnum.success,
      error: null,
      contacts: contactsStore.contacts,
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

  _onSendMessage(SendMessageContactsEvent event, Emitter<ContactsState> emit) async {
    if (state.contacts != null) {
      var foundContacts = state.contacts!.where((contact) {
        return contact.id == event.contactId;
      });

      if (foundContacts.length == 1) {
        var contact = foundContacts.first;

        if(state.userId == null) {
          throw Exception("User id is null");
        }

        contact = await ClientContact.sendMessage(contact, event.message, state.userId!);

        List<ClientContact> newContacts = [];

        for (var c in state.contacts!) {
          if (c.id == contact.id) {
            newContacts.add(contact);
          } else {
            newContacts.add(c);
          }
        }

        emit(state.copyWith(
          contacts: newContacts,
          state: ContactsStateEnum.success,
          error: null,
        ));

        add(SaveAllContactEvent());
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
          phoneNumber: event.phoneNumber,
        );

        List<ClientContact> newContacts = state.contacts ?? [];
        newContacts.add(newContact);

        emit(state.copyWith(
          state: ContactsStateEnum.success,
          error: null,
          contacts: newContacts,
        ));

        add(SaveAllContactEvent());
      } else {
        throw Exception("Contact already exists");
      }
    }
  }

  _onSaveAllContact(SaveAllContactEvent event, Emitter<ContactsState> emit) async {
    if(state.userId == null) {
      throw Exception("User id is null");
    }

    if (state.contacts != null) {
      await _saveAll(state.userId!, state.contacts!);
    } else {
      await _saveAll(state.userId!, []);
    }
  }

  _saveAll(String userId, List<ClientContact> contacts) async {
    await ContactsStoreRepository.store(userId, contacts);
  }
}
