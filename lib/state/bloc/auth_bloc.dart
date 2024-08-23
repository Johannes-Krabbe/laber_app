import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laber_app/api/repositories/auth_repository.dart';
import 'package:laber_app/state/types/auth_state.dart';
import 'package:laber_app/types/client_me_user.dart';
import 'package:laber_app/utils/auth_store_repository.dart';

sealed class AuthEvent {}

final class LoggedInAuthEvent extends AuthEvent {
  AuthStateStoreRepository authStateStore;

  LoggedInAuthEvent(this.authStateStore);
}

final class LogoutAuthEvent extends AuthEvent {}

final class AppStartedAuthEvent extends AuthEvent {}

final class FetchMeAuthEvent extends AuthEvent {}

final class SelectSignedInUserAuthEvent extends AuthEvent {
  final String userId;

  SelectSignedInUserAuthEvent(this.userId);
}

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
    on<SelectSignedInUserAuthEvent>((event, emit) async {
      await _onSelectSignedInUser(event, emit);
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
    final authStateStore =
        await AuthStateStoreRepository.getCurrentFromSecureStorage();

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
          await AuthStateStoreRepository.updateInSecureStorageByUserId(
              AuthStateStoreRepository(
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

    emit(state.copyWith(state: AuthStateEnum.loggedOut));
  }

  _onLogout(LogoutAuthEvent event, Emitter<AuthState> emit) async {
    AuthStateStoreRepository.deleteCurrentFromSecureStorage();
    emit(state.copyWith(state: AuthStateEnum.loggedOut));
  }

  _onSelectSignedInUser(
      SelectSignedInUserAuthEvent event, Emitter<AuthState> emit) async {
    final foundUser = (await AuthStateStoreRepository.getAllFromSecureStorage())
        .where((element) => element.meUser.id == event.userId);

    if (foundUser.isEmpty) {
      emit(state.copyWith(
        state: AuthStateEnum.error,
        error: 'Something went wrong',
      ));
    } else {
      await AuthStateStoreRepository.selectFromSecureStorage(event.userId);
      add(AppStartedAuthEvent());
    }
  }
}
