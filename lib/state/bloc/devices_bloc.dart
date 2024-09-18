import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laber_app/services/key_agreement_service.dart';
import 'package:laber_app/state/types/devices_state.dart';
import 'package:laber_app/api/repositories/device_repository.dart';
import 'package:laber_app/store/secure/account_device_store_service.dart';
import 'package:laber_app/utils/curve/crypto_util.dart';

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
    if (event.artificialDelay) {
      await Future.delayed(const Duration(seconds: 1));
    }

    if (allDevices.status == 200 && allDevices.body?.devices != null) {
      for (var device in allDevices.body!.devices!) {
        if (await AccountDeviceStoreService.get(device.id!) != null) {
          continue;
        }

        final result =
            await KeyAgreementService.creteInitializationMessage(device.id!);
        if (result == null) {
          continue;
        }
        await AccountDeviceStoreService.store(
          AccountDeviceStore(
            secret: await CryptoUtil.secretKeyToString(result.sharedSecret),
            apiId: device.id!,
          ),
        );
      }

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
