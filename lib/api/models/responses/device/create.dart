import 'package:laber_app/api/models/types/private_device.dart';

class DeviceCreateResponse {
  String? message;
  ApiPrivateDevice? device;

  DeviceCreateResponse({this.message, required this.device});

  DeviceCreateResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['device'] != null) {
      device = ApiPrivateDevice.fromJson(json['device']);
    }
  }
}
