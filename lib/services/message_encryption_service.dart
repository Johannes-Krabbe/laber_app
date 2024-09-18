import 'dart:convert';

import 'package:cryptography/cryptography.dart';
import 'package:cryptography_flutter/cryptography_flutter.dart';
import 'package:laber_app/store/repositories/device_repository.dart';
import 'package:laber_app/store/secure/account_device_store_service.dart';
import 'package:laber_app/store/secure/auth_store_service.dart';

import 'package:laber_app/store/types/raw_message.dart';
import 'package:laber_app/types/message/api_message.dart';

class MessageEncryptionService {
  Future<ApiMessage> encryptMessage(
      {required RawMessage message,
      required String secret,
      required String apiRecipientDeviceId}) async {
    final meDevice =
        (await AuthStateStoreService.readFromSecureStorage())?.meDevice;
    if (meDevice == null) {
      throw Exception('Me device not found');
    }

    final algorithm = FlutterChacha20.poly1305Aead();

    final secretKey = SecretKey(
      base64Decode(secret),
    );

    final SecretBox secretBox = await algorithm.encrypt(
      utf8.encode(message.jsonString),
      secretKey: secretKey,
    );

    final encryptedMessage = base64Encode(secretBox.concatenation());

    final context = jsonEncode({
      'version': '1',
      'nonceLength': secretBox.nonce.length,
      'macLength': secretBox.mac.bytes.length,
    });

    final apiMessageData = ApiMessageData(
      enctyptionContext: context,
      encryptedMessage: encryptedMessage,
      type: ApiMessageDataTypes.applicationRawMessage,
    );

    final apiMessage = ApiMessage(
      messageData: apiMessageData,
      apiSenderDeviceId: meDevice.id,
      apiRecipientDeviceId: apiRecipientDeviceId,
    );

    return apiMessage;
  }

  Future<RawMessage> decryptMessage({
    required ApiMessage apiMessage,
  }) async {
    final authStateStore = await AuthStateStoreService.readFromSecureStorage();
    final meDevice = authStateStore?.meDevice;
    if (meDevice == null) {
      throw Exception('Me device not found');
    }

    final encryptionContext =
        jsonDecode(apiMessage.messageData.enctyptionContext);

    if (encryptionContext['version'] != '1') {
      throw Exception('Unsupported version');
    }

    final algorithm = FlutterChacha20.poly1305Aead();

    String secret;

    final device =
        await AccountDeviceStoreService.get(apiMessage.apiSenderDeviceId);

    if (device != null) {
      secret = device.secret;
    } else {
      final device = await DeviceStoreRepository()
          .getByApiId(apiMessage.apiSenderDeviceId);

      if (device == null) {
        throw Exception('Device not found');
      }
      secret = device.secret;
    }

    final secretKey = SecretKey(
      base64Decode(secret),
    );

    final encryptedMessage =
        base64Decode(apiMessage.messageData.encryptedMessage);

    final secretBox = SecretBox.fromConcatenation(
      encryptedMessage,
      nonceLength: encryptionContext['nonceLength'],
      macLength: encryptionContext['macLength'],
    );

    final decryptedMessage = await algorithm.decrypt(
      secretBox,
      secretKey: secretKey,
    );

    final rawMessage = RawMessage.fromJsonString(utf8.decode(decryptedMessage));

    return rawMessage;
  }
}
