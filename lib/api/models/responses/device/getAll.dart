import 'package:laber_app/api/models/types/private_device.dart';

class DeviceGetAllResponse {
  List<ApiPrivateDevice>? devices;

  DeviceGetAllResponse({this.devices});

  DeviceGetAllResponse.fromJson(Map<String, dynamic> json) {
    if (json['devices'] != null) {
      devices = [];
      json['devices'].forEach((v) {
        devices!.add(ApiPrivateDevice.fromJson(v));
      });
    } else {
      devices = [];
    }
  }
}
