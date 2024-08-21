import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laber_app/api/repositories/user_repository.dart';
import 'package:laber_app/state/bloc/auth_bloc.dart';
import 'package:laber_app/state/bloc/contacts_bloc.dart';
import 'package:laber_app/state/types/contacts/discover_phone_number_state.dart';
import 'package:laber_app/utils/phone_number.dart';
import 'package:laber_app/utils/sha.dart';

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
      state: DiscoverPhoneNumberStateEnum.searching,
      phoneNumber: event.phoneNumber,
    ));

    var cleanedPhoneNumber = validateAndCleanPhoneNumber(event.phoneNumber);

    if (cleanedPhoneNumber == null) {
      emit(state.copyWith(
        state: DiscoverPhoneNumberStateEnum.error,
        error: 'Invalid phone number',
      ));
      return;
    }

    if (event.authBloc.state.meUser?.phoneNumber == cleanedPhoneNumber) {
      emit(state.copyWith(
        state: DiscoverPhoneNumberStateEnum.error,
        error: 'You cannot add yourself as a contact',
      ));
      return;
    }

    var foundContact = event.contactsBloc.state.contacts?.where((contact) {
      return contact.phoneNumber == cleanedPhoneNumber;
    }).toList();

    if (foundContact?.isNotEmpty == true) {
      emit(state.copyWith(
        state: DiscoverPhoneNumberStateEnum.error,
        error: 'This contact is already in your contacts',
      ));
      return;
    }

    final hashedPhoneNumber = await hashStringSha256(cleanedPhoneNumber);

    emit(state.copyWith(
      state: DiscoverPhoneNumberStateEnum.searching,
      phoneNumberHash: hashedPhoneNumber,
    ));

    final userRepository = UserRepository();

    final discoverResponse = await userRepository
        .discoverByPhoneNumber(hashedPhoneNumber.substring(0, 5));

    if (discoverResponse.status != 200) {
      emit(state.copyWith(
        state: DiscoverPhoneNumberStateEnum.error,
        error: 'An error occurred while searching for the phone number',
      ));
      return;
    }

    if (discoverResponse.body?.users == null ||
        discoverResponse.body?.users?.isEmpty == true) {
      emit(state.copyWith(
        state: DiscoverPhoneNumberStateEnum.notFound,
      ));
      return;
    }

    var foundUser = discoverResponse.body!.users!.where((user) {
      return user.phoneNumberHash == hashedPhoneNumber;
    });

    if (foundUser.isEmpty) {
      emit(state.copyWith(
        state: DiscoverPhoneNumberStateEnum.notFound,
      ));
      return;
    }

    if (foundUser.length > 1) {
      emit(state.copyWith(
        state: DiscoverPhoneNumberStateEnum.error,
        error:
            'Multiple users found with the same phone number (internal error)',
      ));
      return;
    }

    emit(state.copyWith(
      state: DiscoverPhoneNumberStateEnum.found,
      contact: foundUser.first,
    ));
  }
}
