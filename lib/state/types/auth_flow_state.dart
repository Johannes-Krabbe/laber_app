import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:laber_app/api/models/types/private_device.dart';
import 'package:laber_app/api/models/types/private_user.dart';
import 'package:laber_app/utils/auth_store_repository.dart';

enum AuthFlowStateEnum {
  none,
  loading,
  error,
  successPhone,
  successOtp,
  successDevice,
}

class AuthFlowState {
  final AuthFlowStateEnum state;
  final String error;
  final PhoneNumber? phoneNumber;
  final String? otp;
  final String? token;
  final ApiPrivateUser? meUser;
  final String? deviceName;
  final ApiPrivateDevice? meDevice;

  final AuthStateStoreRepository? authStateStore;

  const AuthFlowState({
    this.state = AuthFlowStateEnum.none,
    this.error = '',
    this.phoneNumber,
    this.otp,
    this.token,
    this.meUser,
    this.deviceName,
    this.meDevice,
    this.authStateStore,
  });

  AuthFlowState copyWith({
    AuthFlowStateEnum? state,
    String? error,
    PhoneNumber? phoneNumber,
    String? otp,
    String? token,
    ApiPrivateUser? meUser,
    String? deviceName,
    ApiPrivateDevice? meDevice,
    AuthStateStoreRepository? authStateStore,
  }) {
    return AuthFlowState(
      state: state ?? this.state,
      error: error ?? this.error,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      otp: otp ?? this.otp,
      token: token ?? this.token,
      meUser: meUser ?? this.meUser,
      deviceName: deviceName ?? this.deviceName,
      meDevice: meDevice ?? this.meDevice,
      authStateStore: authStateStore ?? this.authStateStore,
    );
  }
}
