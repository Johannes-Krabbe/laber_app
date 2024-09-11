import 'package:laber_app/services/contact_service.dart';
import 'package:laber_app/state/types/contacts/contacts_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laber_app/store/repositories/contact_repository.dart';

sealed class ContactsEvent {}

final class RefetchAllContactsEvent extends ContactsEvent {}

final class ApiRefetchAllContactsEvent extends ContactsEvent {}

class ContactsBloc extends Bloc<ContactsEvent, ContactsState> {
  ContactsBloc() : super(const ContactsState()) {
    on<RefetchAllContactsEvent>((event, emit) async {
      await _onRefetchAllContacts(event, emit);
    });
    on<ApiRefetchAllContactsEvent>((event, emit) async {
      await _onApiRefetchAllContacts(event, emit);
    });
  }

  _onRefetchAllContacts(
      RefetchAllContactsEvent event, Emitter<ContactsState> emit) async {
    emit(state.copyWith(state: ContactsStateEnum.loading));
    final contacts = await ContactRepository.getAllContacts();
    emit(state.copyWith(state: ContactsStateEnum.success, contacts: contacts));
  }

  _onApiRefetchAllContacts(
      ApiRefetchAllContactsEvent event, Emitter<ContactsState> emit) async {
    emit(state.copyWith(state: ContactsStateEnum.loading));
    final contacts = await ContactService.refetchAllContacts();
    emit(state.copyWith(state: ContactsStateEnum.success, contacts: contacts));
  }
}
