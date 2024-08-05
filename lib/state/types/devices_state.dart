import 'package:laber_app/api/models/types/private_device.dart';


enum DevicesStateEnum { loading, none, success, error }

class DevicesState {
  final List<ApiPrivateDevice> devices;
  final DevicesStateEnum state;

  const DevicesState({
    this.devices = const [],
    this.state = DevicesStateEnum.none,
  });

  DevicesState copyWith({
    List<ApiPrivateDevice>? devices,
    DevicesStateEnum? state,
  }) {
    return DevicesState(
      devices: devices ?? this.devices,
      state: state ?? this.state,
    );
  }

  getSortedDevices (String logedInDeviceId) {
    List<ApiPrivateDevice> devices = [];

    for (var device in this.devices) {
      if (device.id == logedInDeviceId) {
        devices.add(device);
        break;
      }
    }

    for (var device in this.devices) {
      if (device.id != logedInDeviceId) {
        devices.add(device);
      }
    }

    //TODO sort by last created

    return devices;
  }
}
