// none = no token, no error
// loading = loading
// loggedIn = token, no error
import 'package:laber_app/types/client_me_device.dart';
import 'package:laber_app/types/client_me_user.dart';

enum AuthStateEnum { initial, loading, loggedIn, loggedOut, error }

class AuthState {
  final AuthStateEnum state;
  final String? error;

  final String? token;
  final ClientMeUser? meUser;
  final ClientMeDevice? meDevice;

  const AuthState({
    this.state = AuthStateEnum.initial,
    this.error,
    this.token,
    this.meUser,
    this.meDevice,
  });

  // copy with
  AuthState copyWith({
    AuthStateEnum? state,
    String? error,
    String? token,
    ClientMeUser? meUser,
    ClientMeDevice? meDevice,
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
