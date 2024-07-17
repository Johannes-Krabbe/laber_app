import 'package:intl_phone_number_input/intl_phone_number_input.dart';

enum AuthFlowStateEnum {
  none,
  loading,
  error,
  successPhone,
  successOtp,
}

class AuthFlowState {
  final AuthFlowStateEnum state;
  final String? error;
  final PhoneNumber? phoneNumber;
  final String? otp;
  final String? token;

  const AuthFlowState({
    this.state = AuthFlowStateEnum.none,
    this.error,
    this.phoneNumber,
    this.otp,
    this.token,
  });

  AuthFlowState copyWith({
    AuthFlowStateEnum? state,
    String? error,
    PhoneNumber? phoneNumber,
    String? otp,
    String? token,
  }) {
    return AuthFlowState(
      state: state ?? this.state,
      error: error ?? this.error,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      otp: otp ?? this.otp,
      token: token ?? this.token,
    );
  }
}
