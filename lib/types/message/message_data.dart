import 'dart:convert';

enum EncryptedMessageDataTypes {
  keyAgreement,
}

// === Agreement ===

class AgreementMessageData {
  final String? onetimePreKeyId;
  final String signedPreKeyId;
  final String ephemeralPublicKey;

  final String initiatorDeviceId;
  final String initiatorUserId;

  final EncryptedMessageDataTypes type;

  AgreementMessageData({
    this.onetimePreKeyId,
    required this.signedPreKeyId,
    required this.ephemeralPublicKey,
    required this.initiatorDeviceId,
    required this.initiatorUserId,
    required this.type,
  });

  static AgreementMessageData fromJson(Map<String, dynamic> json) {
    return AgreementMessageData(
      onetimePreKeyId: json['onetimePreKeyId'],
      signedPreKeyId: json['signedPreKeyId'],
      ephemeralPublicKey: json['ephemeralPublicKey'],
      initiatorDeviceId: json['initiatorDeviceId'],
      initiatorUserId: json['initiatorUserId'],
      type: EncryptedMessageDataTypes.keyAgreement,
    );
  }

  String toJsonString() {
    return jsonEncode({
      'onetimePreKeyId': onetimePreKeyId,
      'signedPreKeyId': signedPreKeyId,
      'ephemeralPublicKey': ephemeralPublicKey,
      'initiatorDeviceId': initiatorDeviceId,
      'initiatorUserId': initiatorUserId,
      'type': type.toString(),
    });
  }
}

bool isAgreementMessageData(String data) {
  try {
    final json = jsonDecode(data);
    return json['type'] == EncryptedMessageDataTypes.keyAgreement.toString();
  } catch (e) {
    return false;
  }
}
