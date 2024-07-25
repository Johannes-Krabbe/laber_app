import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laber_app/api/repositories/auth_repository.dart';
import 'package:laber_app/api/repositories/device_repository.dart';
import 'package:laber_app/state/types/auth_flow_state.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
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
  final String deviceName;

  CreateDeviceAuthFlowEvent(this.deviceName);
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
  }

  _onEnterPhoneNumber(
      EnterPhoneNumberAuthFlowEvent event, Emitter<AuthFlowState> emit) async {
    emit(state.copyWith(
      state: AuthFlowStateEnum.loading,
      phoneNumber: event.phoneNumber,
      error: null,
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
        error: null,
      ));
    } else {
      emit(state.copyWith(
          state: AuthFlowStateEnum.error,
          error: res.body?.message ?? 'Invalid phone number, CODE:2'));
    }
  }

  _onVerifyOtp(
      VerifyOtpAuthFlowEvent event, Emitter<AuthFlowState> emit) async {
    emit(state.copyWith(
      state: AuthFlowStateEnum.loading,
      otp: event.otp,
      error: null,
    ));

    final res = await AuthRepository()
        .verify(state.phoneNumber!.phoneNumber!, event.otp);

    if ((res.status == 200 || res.status == 201) &&
        res.body?.token?.isNotEmpty == true) {
      emit(state.copyWith(
        state: AuthFlowStateEnum.successOtp,
        token: res.body?.token,
        meUser: res.body?.user,
        error: null,
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
      error: null,
    ));

    if (state.meUser?.id?.isNotEmpty != true) {
      emit(state.copyWith(
          state: AuthFlowStateEnum.error, error: 'Invalid user id'));
      return;
    }

    final cryptoRepository = CryptoRepository();

    final identityKey =
        await cryptoRepository.getIdentityKeyPair(state.meUser!.id!);
    final base64PublicIdentityKey = await Ed25519Util.publicKeyToString(
        await identityKey.extractPublicKey());

    final signedPreKey =
        await cryptoRepository.createNewSignedPreKeyPair(state.meUser!.id!);

    final base64UnsignedPublicKey = await X25519Util.publicKeyToString(
        await signedPreKey.keyPair.extractPublicKey());

    final oneTimePreKeys =
        await cryptoRepository.createOnetimePreKeyPairs(state.meUser!.id!, 10);

    final List<String> oneTimePrePublicPreKeyStrings = [];
    for (var key in oneTimePreKeys) {
      final keyPair = key.keyPair;
      final base64PublicKey =
          await X25519Util.publicKeyToString(await keyPair.extractPublicKey());
      oneTimePrePublicPreKeyStrings.add(base64PublicKey);
    }

    final res = await DeviceRepository().create(
      state.token!,
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

      if(res.body?.device?.signedPreKey?.key == null) {
        emit(
          state.copyWith(
            state: AuthFlowStateEnum.error,
            error: 'Invalid signed pre key',
          ),
        );
        return;
      }

      final apiSignedPreKey = SignedPreKeyPair(
        signedPreKey.keyPair,
        res.body!.device!.signedPreKey!.key!,
        apiDevice.signedPreKey!.signature!,
      );

      await cryptoRepository
          .saveSignedPreKeyPairs(state.meUser!.id!, [apiSignedPreKey]);

      final apiOneTimePreKeys = <OnetimePreKeyPair>[];

      for (var apiKey in apiDevice.oneTimePreKeys!) {
        OnetimePreKeyPair? foundCreatedKeyPair;

        for (var key in oneTimePreKeys) {
          final keyPair = key.keyPair;
          final base64PublicKey = await X25519Util.publicKeyToString(
              await keyPair.extractPublicKey());

          if (base64PublicKey == apiKey.key) {
            foundCreatedKeyPair = key;
            break;
          }
        }

        final keyPair = OnetimePreKeyPair(
          foundCreatedKeyPair!.keyPair,
          apiKey.id!,
          unixCreatedAt: apiKey.unixCreatedAt!,
        );

        apiOneTimePreKeys.add(keyPair);
      }

      emit(
        state.copyWith(
          state: AuthFlowStateEnum.successDevice,
          error: null,
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
}
