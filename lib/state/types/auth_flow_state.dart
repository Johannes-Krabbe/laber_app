import 'package:intl_phone_number_input/intl_phone_number_input.dart';

enum AuthFlowStateEnum {
  none,
  loading,
  error,
  success,
}

class AuthFlowState {
  final AuthFlowStateEnum state;
  final String? error;
  final PhoneNumber? phoneNumber;
  final String? otp;

  const AuthFlowState({
    this.state = AuthFlowStateEnum.none,
    this.error,
    this.phoneNumber,
    this.otp,
  });

  AuthFlowState copyWith({
    AuthFlowStateEnum? state,
    String? error,
    PhoneNumber? phoneNumber,
    String? otp,
  }) {
    return AuthFlowState(
      state: state ?? this.state,
      error: error ?? this.error,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      otp: otp ?? this.otp,
    );
  }
}
