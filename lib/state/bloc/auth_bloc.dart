import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laber_app/state/types/auth_state.dart';

sealed class AuthEvent {}

final class LoginAuthEvent extends AuthEvent {
  final String emailOrUsername;
  final String password;

  LoginAuthEvent(this.emailOrUsername, this.password);
}

final class SignupAuthEvent extends AuthEvent {
  final String username;
  final String email;
  final String password;

  SignupAuthEvent(this.username, this.email, this.password);
}

final class LogoutAuthEvent extends AuthEvent {}

final class AppStartedAuthEvent extends AuthEvent {}

final class FetchMeAuthEvent extends AuthEvent {}

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(const AuthState()) {
    on<LoginAuthEvent>((event, emit) async {
      await _onLogin(event, emit);
    });
    on<AppStartedAuthEvent>((event, emit) async {
      await _onAppStarted(event, emit);
    });
  }

  _onLogin(LoginAuthEvent event, Emitter<AuthState> emit) async {}

  _onAppStarted(AppStartedAuthEvent event, Emitter<AuthState> emit) async {
    // is there a local token?

    // if so, try to fetch me

    // if not, emit none

    emit(state.copyWith(state: AuthStateEnum.loading));
    await Future.delayed(const Duration(seconds: 0));
    emit(state.copyWith(state: AuthStateEnum.none));

  }
}
