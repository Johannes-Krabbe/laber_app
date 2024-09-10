import 'dart:convert';

class ApiMessage {
  final ApiMessageData messageData;

  final String apiSenderDeviceId;
  final String apiRecipientDeviceId;

  ApiMessage({
    required this.messageData,
    required this.apiSenderDeviceId,
    required this.apiRecipientDeviceId,
  });

  static ApiMessage fromJsonString(String jsonString) {
    final json = jsonDecode(jsonString);
    return ApiMessage(
      messageData: ApiMessageData.fromJsonString(json['message']),
      apiSenderDeviceId: json['apiSenderDeviceId'],
      apiRecipientDeviceId: json['apiRecipientDeviceId'],
    );
  }

  String toJsonString() {
    return jsonEncode({
      'message': messageData.toJsonString(),
      'apiSenderDeviceId': apiSenderDeviceId,
      'apiRecipientDeviceId': apiRecipientDeviceId,
    });
  }
}

class ApiMessageData {
  final ApiMessageDataTypes type;
  final String enctyptionContext;
  final String encryptedMessage;

  ApiMessageData({
    required this.enctyptionContext,
    required this.encryptedMessage,
    required this.type,
  });

  static ApiMessageData fromJsonString(String jsonString) {
    final json = jsonDecode(jsonString);

    ApiMessageDataTypes type = ApiMessageDataTypes.message;
    if (json['type'] == ApiMessageDataTypes.keyAgreement.toString()) {
      type = ApiMessageDataTypes.keyAgreement;
    }

    return ApiMessageData(
      enctyptionContext: json['enctyptionContext'],
      encryptedMessage: json['encryptedMessage'],
      type: type,
    );
  }

  String toJsonString() {
    return jsonEncode({
      'enctyptionContext': enctyptionContext,
      'encryptedMessage': encryptedMessage,
      'type': type.toString(),
    });
  }
}

enum ApiMessageDataTypes {
  keyAgreement,
  message,
}
