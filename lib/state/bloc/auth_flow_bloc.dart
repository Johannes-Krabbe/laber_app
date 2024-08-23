import 'package:cryptography/cryptography.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laber_app/api/repositories/auth_repository.dart';
import 'package:laber_app/api/repositories/device_repository.dart';
import 'package:laber_app/state/types/auth_flow_state.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:laber_app/types/client_me_device.dart';
import 'package:laber_app/types/client_me_user.dart';
import 'package:laber_app/utils/auth_store_repository.dart';
import 'package:laber_app/utils/crypto_reopsitory.dart';
import 'package:laber_app/utils/curve/ed25519_util.dart';
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

final class InitAuthFlowEvent extends AuthFlowEvent {}

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
    on<InitAuthFlowEvent>((event, emit) async {
      await _onInit(event, emit);
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

    final res = await AuthRepository().login(event.phoneNumber.phoneNumber!);

    if (res.status == 200 || res.status == 201) {
      emit(state.copyWith(
        state: AuthFlowStateEnum.successPhone,
        error: '',
      ));
    } else {
      emit(
        state.copyWith(
            state: AuthFlowStateEnum.error,
            error: res.body?.message ?? 'Invalid phone number, CODE:2'),
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

    final res = await AuthRepository()
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
          error: res.body?.message ?? 'Invalid OTP'));
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
    final identityKeyPair = await Ed25519Util.generateKeyPair();
    final base64PublicIdentityKey = await Ed25519Util.publicKeyToString(
        await identityKeyPair.extractPublicKey());

    // --- Signed Pre Key ---
    final signedPreKey =
        await cryptoRepository.createNewSignedPreKeyPair(identityKeyPair);
    final base64UnsignedPublicKey = await X25519Util.publicKeyToString(
        await signedPreKey.keyPair.extractPublicKey());

    // --- One Time Pre Keys ---
    final List<SimpleKeyPair> oneTimePreKeys = [];
    for (var i = 0; i < 10; i++) {
      final keyPair = await Ed25519Util.generateKeyPair();
      oneTimePreKeys.add(keyPair);
    }

    final List<String> oneTimePrePublicPreKeyStrings = [];
    for (var key in oneTimePreKeys) {
      final keyPair = key;
      final base64PublicKey =
          await X25519Util.publicKeyToString(await keyPair.extractPublicKey());
      oneTimePrePublicPreKeyStrings.add(base64PublicKey);
    }

    // --- Create Device ---

    final res = await DeviceRepository().create(
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
          final base64PublicKey = await X25519Util.publicKeyToString(
              await keyPair.extractPublicKey());

          if (base64PublicKey == apiKey.key) {
            foundCreatedKeyPair = key;
            break;
          }
        }

        if(foundCreatedKeyPair == null){
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
      final authStateStore = AuthStateStoreRepository(
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
      await AuthStateStoreRepository.saveAsCurrentToSecureStorage(authStateStore);

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
          error: res.body?.message ?? 'Something went wrong!',
        ),
      );
    }
  }

  _onInit(InitAuthFlowEvent event, Emitter<AuthFlowState> emit) async {
    final authStateStore = await AuthStateStoreRepository.getAllFromSecureStorage();
    emit(state.copyWith(
      authStateStoreList: authStateStore,
    ));
    
  }
}
