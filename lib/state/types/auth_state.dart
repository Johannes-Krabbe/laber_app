// none = no token, no error
// loading = loading
// loggedIn = token, no error
import 'package:laber_app/api/models/types/private_device.dart';
import 'package:laber_app/api/models/types/private_user.dart';

enum AuthStateEnum { none, loading, loggedIn }

class AuthState {
  final AuthStateEnum state;
  final String? error;

  final String? token;
  final ApiPrivateUser? meUser;
  final ApiPrivateDevice? meDevice;

  const AuthState({
    this.state = AuthStateEnum.none,
    this.error,
    this.token,
    this.meUser,
    this.meDevice
  });

  // copy with
  AuthState copyWith({
    AuthStateEnum? state,
    String? error,
    String? token,
    ApiPrivateUser? meUser,
    ApiPrivateDevice? meDevice,
  }) {
    return AuthState(
      state: state ?? this.state,
      error: error ?? this.error,
      token: token ?? this.token,
      meUser: meUser ?? this.meUser,
      meDevice: meDevice ?? this.meDevice,
    );
  }
}
