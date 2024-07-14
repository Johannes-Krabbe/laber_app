import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laber_app/state/types/auth_state.dart';

sealed class AuthEvent {}

final class LoggedInAuthEvent extends AuthEvent {
  final String phoneNumber;
  final String token;

  LoggedInAuthEvent(this.phoneNumber, this.token);
}

final class LogoutAuthEvent extends AuthEvent {}

final class AppStartedAuthEvent extends AuthEvent {}

final class FetchMeAuthEvent extends AuthEvent {}

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(const AuthState()) {
    on<LoggedInAuthEvent>((event, emit) async {
      await _onLogin(event, emit);
    });
    on<AppStartedAuthEvent>((event, emit) async {
      await _onAppStarted(event, emit);
    });
  }

  _onLogin(LoggedInAuthEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(state: AuthStateEnum.loggedIn));
  }

  _onAppStarted(AppStartedAuthEvent event, Emitter<AuthState> emit) async {
    // is there a local token?

    // if so, try to fetch me

    // if not, emit none

    emit(state.copyWith(state: AuthStateEnum.loading));
    await Future.delayed(const Duration(seconds: 0));
    emit(state.copyWith(state: AuthStateEnum.none));

  }
}
