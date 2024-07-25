// none = no token, no error
// loading = loading
// loggedIn = token, no error
import 'package:laber_app/api/models/types/private_user.dart';

enum AuthStateEnum { none, loading, loggedIn }

class AuthState {
  final AuthStateEnum state;
  final String? error;

  final String? token;
  final ApiPrivateUser? meUser;

  const AuthState({
    this.state = AuthStateEnum.none,
    this.error,
    this.token,
    this.meUser,
  });

  // copy with
  AuthState copyWith({
    AuthStateEnum? state,
    String? error,
    String? token,
    ApiPrivateUser? meUser,
  }) {
    return AuthState(
      state: state ?? this.state,
      error: error ?? this.error,
      token: token ?? this.token,
      meUser: meUser ?? this.meUser,
    );
  }
}
