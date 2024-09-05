/*
import 'dart:convert';

import 'package:cryptography/cryptography.dart';

class ClientDevice {
  final String id;
  final SecretKey sharedSecret;
  final String safetyNumber;
  final SharedSecretVersion version;

  ClientDevice({
    required this.id,
    required this.sharedSecret,
    required this.safetyNumber,
    required this.version,
  });

  //from json
  factory ClientDevice.fromJson(Map<String, dynamic> json) {
    var sharedSecret = SecretKey(base64.decode(json['sharedSecret']));

    return ClientDevice(
      id: json['id'],
      sharedSecret: sharedSecret,
      safetyNumber: json['safetyNumber'],
      version: json['version'] == 'V1_X25519_WITHOUT_ONE_TIME_PREKEY'
          ? SharedSecretVersion.V1_X25519_WITHOUT_ONE_TIME_PREKEY
          : SharedSecretVersion.V1_X25519_WITH_ONE_TIME_PREKEY,
    );
  }

  //to json
  Future<String> toJson() async {
    var sharedSecretString = base64.encode(await sharedSecret.extractBytes());

    return jsonEncode({
      'id': id,
      'sharedSecret': sharedSecretString,
      'safetyNumber': safetyNumber,
      'version': version.toString(),
    });
  }
}
*/
