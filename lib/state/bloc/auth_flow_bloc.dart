import 'package:cryptography/cryptography.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laber_app/api/repositories/api_auth_repository.dart';
import 'package:laber_app/api/repositories/api_device_repository.dart';
import 'package:laber_app/state/types/auth_flow_state.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:laber_app/store/secure/auth_store_service.dart';
import 'package:laber_app/types/client_me_device.dart';
import 'package:laber_app/types/client_me_user.dart';
import 'package:laber_app/utils/crypto_reopsitory.dart';
import 'package:laber_app/utils/curve/crypto_util.dart';
import 'package:laber_app/utils/curve/x25519_util.dart';

sealed class AuthFlowEvent {}

final class EnterPhoneNumberAuthFlowEvent extends AuthFlowEvent {
  final PhoneNumber phoneNumber;

  EnterPhoneNumberAuthFlowEvent(this.phoneNumber);
}

final class VerifyOtpAuthFlowEvent extends AuthFlowEvent {
  final String otp;

  VerifyOtpAuthFlowEvent(this.otp);
}

final class ResendOtpAuthFlowEvent extends AuthFlowEvent {}

final class CreateDeviceAuthFlowEvent extends AuthFlowEvent {
  final String token;
  final String deviceName;

  CreateDeviceAuthFlowEvent(this.token, this.deviceName);
}

final class EnterUserdataAuthFlowEvent extends AuthFlowEvent {
  final String username;
  final String name;

  EnterUserdataAuthFlowEvent(this.username, this.name);
}

final class EnterSecurityAuthFlowEvent extends AuthFlowEvent {
  final bool switchUsernameDiscoveryValue;
  final bool switchPhonenumberDiscoveryValue;

  EnterSecurityAuthFlowEvent(
    this.switchUsernameDiscoveryValue,
    this.switchPhonenumberDiscoveryValue,
  );
}

class AuthFlowBloc extends Bloc<AuthFlowEvent, AuthFlowState> {
  AuthFlowBloc() : super(const AuthFlowState()) {
    on<EnterPhoneNumberAuthFlowEvent>((event, emit) async {
      await _onEnterPhoneNumber(event, emit);
    });
    on<VerifyOtpAuthFlowEvent>((event, emit) async {
      await _onVerifyOtp(event, emit);
    });
    on<ResendOtpAuthFlowEvent>((event, emit) async {
      await _onResendOtp(event, emit);
    });
    on<CreateDeviceAuthFlowEvent>((event, emit) async {
      await _onCreateDevice(event, emit);
    });
    on<EnterUserdataAuthFlowEvent>((event, emit) async {
      await _onEnterUserdata(event, emit);
    });
    on<EnterSecurityAuthFlowEvent>((event, emit) async {
      await _onEnterSecurity(event, emit);
    });
  }

  _onEnterPhoneNumber(
      EnterPhoneNumberAuthFlowEvent event, Emitter<AuthFlowState> emit) async {
    emit(state.copyWith(
      state: AuthFlowStateEnum.loading,
      phoneNumber: event.phoneNumber,
      error: '',
    ));

    if (event.phoneNumber.phoneNumber?.isEmpty == true) {
      emit(state.copyWith(
          state: AuthFlowStateEnum.error,
          error: 'Invalid phone number, CODE:1'));
      return;
    }

    final res = await ApiAuthRepository().login(event.phoneNumber.phoneNumber!);

    if (res.status == 200 || res.status == 201) {
      emit(state.copyWith(
        state: AuthFlowStateEnum.successPhone,
        error: '',
      ));
    } else {
      emit(
        state.copyWith(
            state: AuthFlowStateEnum.error,
            error: res.error ?? 'Invalid phone number, CODE:2'),
      );
    }
  }

  _onVerifyOtp(
      VerifyOtpAuthFlowEvent event, Emitter<AuthFlowState> emit) async {
    emit(state.copyWith(
      state: AuthFlowStateEnum.loading,
      otp: event.otp,
      error: '',
    ));

    final res = await ApiAuthRepository()
        .verify(state.phoneNumber!.phoneNumber!, event.otp);

    if ((res.status == 200 || res.status == 201) &&
        res.body?.token?.isNotEmpty == true) {
      emit(state.copyWith(
        state: AuthFlowStateEnum.successOtp,
        token: res.body?.token,
        meUser: res.body?.user,
        error: '',
      ));
    } else {
      emit(state.copyWith(
          state: AuthFlowStateEnum.error,
          error: res.error ?? 'Invalid OTP'));
    }
  }

  // TODO implement
  _onResendOtp(
      ResendOtpAuthFlowEvent event, Emitter<AuthFlowState> emit) async {
    emit(state.copyWith(state: AuthFlowStateEnum.loading));
    emit(state.copyWith(state: AuthFlowStateEnum.none));
  }

  _onCreateDevice(
      CreateDeviceAuthFlowEvent event, Emitter<AuthFlowState> emit) async {
    emit(state.copyWith(
      state: AuthFlowStateEnum.loading,
      deviceName: event.deviceName,
      error: '',
    ));

    if (state.meUser?.id?.isNotEmpty != true) {
      emit(state.copyWith(
          state: AuthFlowStateEnum.error, error: 'Invalid user id'));
      return;
    }

    final cryptoRepository = CryptoRepository();

    // --- Identity Key ---
    final identityKeyPair = await X25519Util.generateKeyPair();
    final identityKeyPublicKey = await identityKeyPair.extractPublicKey();
    final base64PublicIdentityKey = await CryptoUtil.publicKeyToString(
        identityKeyPublicKey, KeyPairType.ed25519);

    // --- Signed Pre Key ---
    final signedPreKey =
        await cryptoRepository.createNewSignedPreKeyPair(identityKeyPair);
    final signedPreKeyPublicKey = await signedPreKey.keyPair.extractPublicKey();
    final base64UnsignedPublicKey = await CryptoUtil.publicKeyToString(
        signedPreKeyPublicKey, KeyPairType.x25519);

    // --- One Time Pre Keys ---
    final List<SimpleKeyPair> oneTimePreKeys = [];
    for (var i = 0; i < 10; i++) {
      final keyPair = await X25519Util.generateKeyPair();
      oneTimePreKeys.add(keyPair);
    }

    final List<String> oneTimePrePublicPreKeyStrings = [];
    for (var key in oneTimePreKeys) {
      final keyPair = key;
      final base64PublicKey = await CryptoUtil.publicKeyToString(
          await keyPair.extractPublicKey(), KeyPairType.x25519);
      oneTimePrePublicPreKeyStrings.add(base64PublicKey);
    }

    // --- Create Device ---

    final res = await ApiDeviceRepository().create(
      event.token,
      deviceName: event.deviceName,
      identityKey: base64PublicIdentityKey,
      signedPreKey: {
        'key': base64UnsignedPublicKey,
        'signature': signedPreKey.signature,
      },
      oneTimePreKeys: oneTimePrePublicPreKeyStrings,
    );

    if (res.status == 200 || res.status == 201) {
      final apiDevice = res.body!.device!;

      // --- Signed Pre Key ---
      if (res.body?.device?.signedPreKey?.key == null) {
        emit(
          state.copyWith(
            state: AuthFlowStateEnum.error,
            error: 'Invalid signed pre key',
          ),
        );
        return;
      }

      final clientSignedPreKeyPair = ClientSignedPreKeyPair(
        signedPreKey.keyPair,
        res.body!.device!.signedPreKey!.id!,
        apiDevice.signedPreKey!.signature!,
        unixCreatedAt: res.body!.device!.signedPreKey!.unixCreatedAt!,
      );

      final clientSignedPreKeyPairList = [clientSignedPreKeyPair];

      // --- Identity Key ---

      final clientIdentityKeyPair = ClientIdentityKeyPair(
        identityKeyPair,
      );

      // --- One Time Pre Keys ---

      final clientOneTimePreKeys = <ClientOnetimePreKeyPair>[];

      for (var apiKey in apiDevice.oneTimePreKeys!) {
        SimpleKeyPair? foundCreatedKeyPair;

        for (var key in oneTimePreKeys) {
          final keyPair = key;
          final base64PublicKey = await CryptoUtil.publicKeyToString(
              await keyPair.extractPublicKey(), KeyPairType.x25519);

          if (base64PublicKey == apiKey.key) {
            foundCreatedKeyPair = key;
            break;
          }
        }

        if (foundCreatedKeyPair == null) {
          throw Exception('One time pre key not found');
        }

        final keyPair = ClientOnetimePreKeyPair(
          foundCreatedKeyPair,
          apiKey.id!,
          unixCreatedAt: apiKey.unixCreatedAt!,
        );

        clientOneTimePreKeys.add(keyPair);
      }

      // store

      final clientMeUser = ClientMeUser.fromApiPrivateMeUser(state.meUser!);
      final authStateStore = AuthStateStoreService(
        state.token!,
        clientMeUser,
        ClientMeDevice(
          apiDevice.id!,
          apiDevice.deviceName!,
          clientIdentityKeyPair,
          clientOneTimePreKeys,
          clientSignedPreKeyPairList,
        ),
      );
      await AuthStateStoreService.saveToSecureStorage(authStateStore);

      emit(
        state.copyWith(
          state: AuthFlowStateEnum.successDevice,
          meDevice: apiDevice,
          authStateStore: authStateStore,
          error: '',
        ),
      );
    } else {
      emit(
        state.copyWith(
          state: AuthFlowStateEnum.error,
          error: res.error ?? 'Something went wrong!',
        ),
      );
    }
  }

  _onEnterUserdata(
      EnterUserdataAuthFlowEvent event, Emitter<AuthFlowState> emit) async {
    emit(state.copyWith(
      state: AuthFlowStateEnum.loading,
      username: event.username,
      name: event.name,
      error: '',
    ));

    if (state.token?.isEmpty != false) {
      emit(state.copyWith(
        state: AuthFlowStateEnum.error,
        error: 'Invalid token',
      ));
      return;
    }

    final res = await ApiAuthRepository().updateMe(
      token: state.token,
      username: event.username,
      name: event.name,
    );

    if (res.status == 200 || res.status == 201) {
      final meUserResponse = await ApiAuthRepository().fetchMe(state.token!);

      emit(
        state.copyWith(
          state: AuthFlowStateEnum.successUsername,
          meUser: meUserResponse.body?.user,
          error: '',
        ),
      );
    } else {
      emit(
        state.copyWith(
          state: AuthFlowStateEnum.error,
          error: res.error ?? 'Something went wrong!',
        ),
      );
    }
  }

  _onEnterSecurity(
      EnterSecurityAuthFlowEvent event, Emitter<AuthFlowState> emit) async {
    emit(state.copyWith(
      state: AuthFlowStateEnum.loading,
      usernameDiscoveryEnabled: event.switchUsernameDiscoveryValue,
      phoneNumberDiscoveryEnabled: event.switchPhonenumberDiscoveryValue,
      error: '',
    ));

    if (state.token?.isEmpty != false) {
      emit(state.copyWith(
        state: AuthFlowStateEnum.error,
        error: 'Invalid token',
      ));
      return;
    }

    final res = await ApiAuthRepository().updateMe(
      token: state.token,
      usernameDiscoveryEnabled: event.switchUsernameDiscoveryValue,
      phoneNumberDiscoveryEnabled: event.switchPhonenumberDiscoveryValue,
    );

    if (res.status == 200 || res.status == 201) {
      final meUserResponse = await ApiAuthRepository().fetchMe(state.token!);

      emit(
        state.copyWith(
          state: AuthFlowStateEnum.successSecurity,
          meUser: meUserResponse.body?.user,
          error: '',
        ),
      );
    } else {
      emit(
        state.copyWith(
          state: AuthFlowStateEnum.error,
          error: res.error ?? 'Something went wrong!',
        ),
      );
    }
  }
}
