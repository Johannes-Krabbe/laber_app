import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laber_app/api/models/types/private_user.dart';
import 'package:laber_app/api/repositories/auth_repository.dart';
import 'package:laber_app/state/types/auth_state.dart';
import 'package:laber_app/utils/secure_storage_repository.dart';

sealed class AuthEvent {}

final class LoggedInAuthEvent extends AuthEvent {
  final String phoneNumber;
  final String token;
  final ApiPrivateUser meUser;

  LoggedInAuthEvent(this.phoneNumber, this.token, this.meUser);
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
    emit(state.copyWith(
        state: AuthStateEnum.loggedIn,
        meUser: event.meUser,
        token: event.token));
  }

  _onAppStarted(AppStartedAuthEvent event, Emitter<AuthState> emit) async {
    var exisingToken = await SecureStorageRepository().read('token');

    if (exisingToken != null) {
      var response = await AuthRepository().fetchMe(exisingToken);

      if (response.status == 200) {
        emit(state.copyWith(
            state: AuthStateEnum.loggedIn,
            meUser: response.body!.user,
            token: exisingToken));
      } else {
        emit(state.copyWith(state: AuthStateEnum.none));
      }
    } else {
      emit(state.copyWith(state: AuthStateEnum.none));
    }
  }

  _onLogout(LogoutAuthEvent event, Emitter<AuthState> emit) async {
    await SecureStorageRepository().delete('token');
    emit(state.copyWith(state: AuthStateEnum.none));
  }
}
