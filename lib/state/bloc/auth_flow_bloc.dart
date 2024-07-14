import 'package:flutter_bloc/flutter_bloc.dart';
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

class AuthFlowBloc extends Bloc<AuthFlowEvent, AuthFlowState>{
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

  _onEnterPhoneNumber(EnterPhoneNumberAuthFlowEvent event, Emitter<AuthFlowState> emit) async {
    emit(state.copyWith(state: AuthFlowStateEnum.loading, phoneNumber: event.phoneNumber));
    emit(state.copyWith(state: AuthFlowStateEnum.none));
  }

  _onVerifyOtp(VerifyOtpAuthFlowEvent event, Emitter<AuthFlowState> emit) async {
    emit(state.copyWith(state: AuthFlowStateEnum.loading, otp: event.otp));
    if(event.otp == '123456') {
      emit(state.copyWith(state: AuthFlowStateEnum.success));
    } else {
      emit(state.copyWith(state: AuthFlowStateEnum.error, error: 'Invalid OTP'));
    }
  }

  _onResendOtp(ResendOtpAuthFlowEvent event, Emitter<AuthFlowState> emit) async {
    emit(state.copyWith(state: AuthFlowStateEnum.loading));
    emit(state.copyWith(state: AuthFlowStateEnum.none));
  }

}
