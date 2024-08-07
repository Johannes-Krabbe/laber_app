import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laber_app/api/models/types/private_device.dart';
import 'package:laber_app/api/models/types/private_user.dart';
import 'package:laber_app/api/repositories/auth_repository.dart';
import 'package:laber_app/state/types/auth_state.dart';
import 'package:laber_app/types/client_me_device.dart';
import 'package:laber_app/types/client_me_user.dart';
import 'package:laber_app/utils/auth_store_repository.dart';
import 'package:laber_app/utils/secure_storage_repository.dart';

sealed class AuthEvent {}

final class LoggedInAuthEvent extends AuthEvent {
  AuthStateStore authStateStore;

  LoggedInAuthEvent(this.authStateStore);
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
    emit(
      state.copyWith(
        state: AuthStateEnum.loggedIn,
        token: event.authStateStore.token,
        meUser: event.authStateStore.meUser,
        meDevice: event.authStateStore.meDevice,
      ),
    );
  }

  _onAppStarted(AppStartedAuthEvent event, Emitter<AuthState> emit) async {
    final authStateStore = await AuthStateStore.getCurrentFromSecureStorage();

    if (authStateStore == null) {
      state.copyWith(
        state: AuthStateEnum.error,
        error: 'Something went wrong',
      );
    }

    if (authStateStore != null) {
      var response = await AuthRepository().fetchMe(authStateStore.token);

      if (response.status == 200) {
        final clientMeUserFromApi =
            ClientMeUser.fromApiPrivateMeUser(response.body!.user!);

        if (clientMeUserFromApi != authStateStore.meUser) {
          await AuthStateStore.updateInSecureStorageByUserId(AuthStateStore(
            authStateStore.token,
            clientMeUserFromApi,
            authStateStore.meDevice,
          ));
        }

        emit(state.copyWith(
          state: AuthStateEnum.loggedIn,
          meUser: clientMeUserFromApi,
          meDevice: authStateStore.meDevice,
          token: authStateStore.token,
        ));

        return;
      }
    }

    emit(state.copyWith(state: AuthStateEnum.none));
  }

  _onLogout(LogoutAuthEvent event, Emitter<AuthState> emit) async {
    AuthStateStore.deleteCurrentFromSecureStorage();
    emit(state.copyWith(state: AuthStateEnum.none));
  }
}
