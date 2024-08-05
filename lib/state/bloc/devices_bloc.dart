import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laber_app/state/types/devices_state.dart';
import 'package:laber_app/api/repositories/device_repository.dart';

sealed class DevicesEvent {}

final class FetchDevicesDevicesEvent extends DevicesEvent {
  bool artificialDelay;
  FetchDevicesDevicesEvent({this.artificialDelay = false});
}

class DevicesBloc extends Bloc<DevicesEvent, DevicesState> {
  DevicesBloc() : super(const DevicesState()) {
    on<FetchDevicesDevicesEvent>((event, emit) async {
      await _onFetchDevices(event, emit);
    });
  }

  _onFetchDevices(
      FetchDevicesDevicesEvent event, Emitter<DevicesState> emit) async {
    emit(state.copyWith(state: DevicesStateEnum.loading));

    var allDevices = await DeviceRepository().getAll();
    if(event.artificialDelay) {
      await Future.delayed(const Duration(seconds: 1));
    }

    if (allDevices.status == 200) {
      emit(state.copyWith(
        state: DevicesStateEnum.success,
        devices: allDevices.body!.devices,
      ));
    } else {
      emit(state.copyWith(
        state: DevicesStateEnum.error,
      ));
    }
  }
}
