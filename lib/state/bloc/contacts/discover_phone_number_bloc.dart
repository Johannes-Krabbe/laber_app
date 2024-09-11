import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laber_app/services/contact_service.dart';
import 'package:laber_app/state/bloc/auth_bloc.dart';
import 'package:laber_app/state/bloc/contacts/contacts_bloc.dart';
import 'package:laber_app/state/types/contacts/discover_phone_number_state.dart';

sealed class DiscoverPhoneNumberEvent {}

final class SearchDiscoverPhoneNumberEvent extends DiscoverPhoneNumberEvent {
  String phoneNumber;

  AuthBloc authBloc;
  ContactsBloc contactsBloc;

  SearchDiscoverPhoneNumberEvent(
      this.phoneNumber, this.authBloc, this.contactsBloc);
}

final class ClearDiscoverPhoneNumberEvent extends DiscoverPhoneNumberEvent {}

class DiscoverPhoneNumberBloc
    extends Bloc<DiscoverPhoneNumberEvent, DiscoverPhoneNumberState> {
  DiscoverPhoneNumberBloc()
      : super(DiscoverPhoneNumberState(
            state: DiscoverPhoneNumberStateEnum.none)) {
    on<SearchDiscoverPhoneNumberEvent>((event, emit) async {
      await _onSearch(event, emit);
    });
  }

  _onSearch(SearchDiscoverPhoneNumberEvent event,
      Emitter<DiscoverPhoneNumberState> emit) async {
    emit(state.copyWith(
      state: DiscoverPhoneNumberStateEnum.loading,
      phoneNumber: event.phoneNumber,
    ));

    try {
      final foundUser =
          await ContactService.discoverByPhoneNumber(event.phoneNumber);
      emit(state.copyWith(
        state: DiscoverPhoneNumberStateEnum.found,
        contact: foundUser,
      ));
    } catch (e) {
      emit(state.copyWith(
        state: DiscoverPhoneNumberStateEnum.error,
        error: e.toString(),
      ));
    }
  }
}
