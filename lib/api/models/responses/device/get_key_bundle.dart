import 'package:laber_app/api/models/types/public_device.dart';

class DeviceGetKeyBundleResponse {
  ApiPublicDevice? device;

  DeviceGetKeyBundleResponse({this.device});

  DeviceGetKeyBundleResponse.fromJson(Map<String, dynamic> json) {
    device = json['device'] != null
        ? ApiPublicDevice.fromJson(json['device'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (device != null) {
      data['device'] = device!.toJson();
    }
    return data;
  }
}
