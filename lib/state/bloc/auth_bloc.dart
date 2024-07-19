import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laber_app/state/types/auth_state.dart';
import 'package:laber_app/utils/secure_storage_repository.dart';

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
    on<LogoutAuthEvent>((event, emit) async {
      await _onLogout(event, emit);
    });
  }

  _onLogin(LoggedInAuthEvent event, Emitter<AuthState> emit) async {
    await SecureStorageRepository().write('token', event.token);
    emit(state.copyWith(state: AuthStateEnum.loggedIn));
  }

  _onAppStarted(AppStartedAuthEvent event, Emitter<AuthState> emit) async {
    var exisingToken = await SecureStorageRepository().read('token');

    if (exisingToken != null) {
      // TODO fetchme to check if token is valid
      emit(state.copyWith(state: AuthStateEnum.loggedIn));
    } else {
      emit(state.copyWith(state: AuthStateEnum.none));
    }
  }

  _onLogout(LogoutAuthEvent event, Emitter<AuthState> emit) async {
    await SecureStorageRepository().delete('token');
    emit(state.copyWith(state: AuthStateEnum.none));
  }
}
