import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laber_app/api/repositories/auth_repository.dart';
import 'package:laber_app/state/types/auth_flow_state.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

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
          state: AuthFlowStateEnum.error, error: 'Invalid phone number'));
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
          error: res.body?.message ?? 'Invalid phone number'));
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
        error: null,
      ));
    } else {
      print(res.body?.message);
      emit(state.copyWith(
          state: AuthFlowStateEnum.error,
          error: res.body?.message ?? 'Invalid OTP'));
    }
  }

  _onResendOtp(
      ResendOtpAuthFlowEvent event, Emitter<AuthFlowState> emit) async {
    emit(state.copyWith(state: AuthFlowStateEnum.loading));
    emit(state.copyWith(state: AuthFlowStateEnum.none));
  }
}
