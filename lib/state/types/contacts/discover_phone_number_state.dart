import 'package:laber_app/api/models/types/public_user.dart';

enum DiscoverPhoneNumberStateEnum {
  none,
  searching,
  notFound,
  found,

  error,
  success,
}

class DiscoverPhoneNumberState {
  final DiscoverPhoneNumberStateEnum state;
  final String? error;
  final String? phoneNumber;
  final String? phoneNumberHash;
  final ApiPublicUser? contact;

  DiscoverPhoneNumberState({
    required this.state,
    this.error,
    this.phoneNumber,
    this.phoneNumberHash,
    this.contact,
  });

  DiscoverPhoneNumberState copyWith({
    DiscoverPhoneNumberStateEnum? state,
    String? error,
    String? phoneNumber,
    String? phoneNumberHash,
    ApiPublicUser? contact,
  }) {
    return DiscoverPhoneNumberState(
      state: state ?? this.state,
      error: error ?? this.error,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      phoneNumberHash: phoneNumberHash ?? this.phoneNumberHash,
      contact: contact ?? this.contact,
    );
  }
}
