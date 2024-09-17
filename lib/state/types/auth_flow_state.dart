import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:laber_app/api/models/types/private_device.dart';
import 'package:laber_app/api/models/types/private_user.dart';
import 'package:laber_app/store/secure/auth_store_service.dart';

enum AuthFlowStateEnum {
  none,
  loading,
  error,
  successPhone,
  successOtp,
  successDevice,
  successUsername,
  successSecurity,
}

class AuthFlowState {
  final AuthFlowStateEnum state;
  final String error;
  final PhoneNumber? phoneNumber;
  final String? otp;
  final String? token;
  final String? deviceName;

  final ApiPrivateUser? meUser;
  final ApiPrivateDevice? meDevice;

  final AuthStateStoreService? authStateStore;

  //userdata
  final String? username;
  final String? name;
  final bool? phoneNumberDiscoveryEnabled;
  final bool? usernameDiscoveryEnabled;

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
    this.username,
    this.name,
    this.phoneNumberDiscoveryEnabled,
    this.usernameDiscoveryEnabled,
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
    AuthStateStoreService? authStateStore,
    String? username,
    String? name,
    bool? phoneNumberDiscoveryEnabled,
    bool? usernameDiscoveryEnabled,
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
      username: username ?? this.username,
      name: name ?? this.name,
      phoneNumberDiscoveryEnabled:
          phoneNumberDiscoveryEnabled ?? this.phoneNumberDiscoveryEnabled,
      usernameDiscoveryEnabled:
          usernameDiscoveryEnabled ?? this.usernameDiscoveryEnabled,
    );
  }
}
