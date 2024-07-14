// none = no token, no error
// loading = loading
// loggedIn = token, no error
enum AuthStateEnum { none, loading, loggedIn }

class AuthState {
  final AuthStateEnum state;
  final String? error;

  final String token;

  const AuthState({
    this.state = AuthStateEnum.none,
    this.error,
    this.token = '',
  });

  // copy with
  AuthState copyWith({
    AuthStateEnum? state,
    String? error,
    String? token,
  }) {
    return AuthState(
      state: state ?? this.state,
      error: error ?? this.error,
      token: token ?? this.token,
    );
  }
}
