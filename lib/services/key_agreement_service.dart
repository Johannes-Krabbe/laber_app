import 'dart:async';
import 'dart:convert';

import 'package:cryptography/cryptography.dart';
import 'package:laber_app/api/repositories/device_repository.dart';
import 'package:laber_app/store/repositories/outgoing_message_repository.dart';
import 'package:laber_app/store/secure/auth_store_service.dart';
import 'package:laber_app/store/types/device.dart';
import 'package:laber_app/types/message/api_message.dart';
import 'package:laber_app/types/message/message_data.dart';
import 'package:laber_app/utils/curve/crypto_util.dart';
import 'package:laber_app/utils/curve/secret_util.dart';
import 'package:laber_app/utils/curve/x25519_util.dart';
import 'package:laber_app/utils/curve/xeddsa_util.dart';

class KeyAgreementService {
  static FutureOr<
      ({
        String safetyNumber,
        SecretKey sharedSecret,
        SharedSecretVersion version
      })?> creteInitializationMessage(String deviceId) async {
    final authStore = await AuthStateStoreService.readFromSecureStorage();

    var deviceRes = await DeviceRepository().getKeyBundle(deviceId);

    if (deviceRes.status != 200) {
      // TODO error
      return null;
    }

    var meIdentityKey = authStore!.meDevice.identityKeyPair;
    var meEphemeralKey = await X25519Util.generateKeyPair();

    // verify signature
    var signature = deviceRes.body!.device!.signedPreKey!.signature;

    var contactIdentityKey =
        await deviceRes.body!.device!.identityKey!.publicKey;

    final signedPreKeyBytes = (await CryptoUtil.stringToPublicKey(
            deviceRes.body!.device!.signedPreKey!.key!))
        .bytes;

    var isValid = await XeddsaUtil.verifyX25519(
      content: signedPreKeyBytes,
      publicKeyBytes: contactIdentityKey.bytes,
      signature: base64Decode(signature!),
    );

    if (!isValid) {
      print('Signature is not valid');
      // TODO error
      return null;
    }

    var sharedSecretRes = await SecretUtil.initiatorKeyCalculation(
      meIdentityKey: meIdentityKey.keyPair,
      meEphemeralKey: meEphemeralKey,
      contactIdentityKey: await deviceRes.body!.device!.identityKey!.publicKey,
      contactPreKey: await deviceRes.body!.device!.signedPreKey!.publicKey,
      contactOneTimePreKey:
          await deviceRes.body!.device!.oneTimePreKey!.publicKey,
    );

    final meEphemeralPublicKey = await meEphemeralKey.extractPublicKey();

    final agreementMessageData = AgreementMessageData(
      onetimePreKeyId: deviceRes.body!.device!.oneTimePreKey!.id!,
      signedPreKeyId: deviceRes.body!.device!.signedPreKey!.id!,
      ephemeralPublicKey: await CryptoUtil.publicKeyToString(
          meEphemeralPublicKey, KeyPairType.x25519),
      initiatorDeviceId: authStore.meDevice.id,
      initiatorUserId: authStore.meUser.id,
      type: EncryptedMessageDataTypes.keyAgreement,
    );

    final apiMessageData = ApiMessageData(
      encryptedMessage: agreementMessageData.toJsonString(),
      enctyptionContext: '',
      type: ApiMessageDataTypes.keyAgreement,
    );

    final apiMessage = ApiMessage(
      messageData: apiMessageData,
      apiSenderDeviceId: authStore.meDevice.id,
      apiRecipientDeviceId: deviceId,
    );

    await OutgoingMessageRepository.create(
      content: apiMessage,
      recipientDeviceId: deviceId,
    );

    return sharedSecretRes;
  }

  static FutureOr<
          ({
            String safetyNumber,
            SecretKey sharedSecret,
            SharedSecretVersion version
          })?>
      processInitializationMessage(
          AgreementMessageData agreementMessageData) async {
        

    final apiDevice = await DeviceRepository()
        .getPublic(agreementMessageData.initiatorDeviceId);

    if (apiDevice.body == null) {
      throw Exception('Device not found');
    }

    final contactIdentityKey =
        await apiDevice.body?.device?.identityKey?.publicKey;

    if (contactIdentityKey == null) {
      throw Exception('Identity key not found');
    }

    final authStateStore = await AuthStateStoreService.readFromSecureStorage();

    if (authStateStore == null) {
      throw Exception('AuthStateStore is null');
    }

    final contactEphemeralKey = await CryptoUtil.stringToPublicKey(
      agreementMessageData.ephemeralPublicKey,
    );
    final meIdentityKey = authStateStore.meDevice.identityKeyPair.keyPair;
    final mePreKey = authStateStore.meDevice.signedPreKeyPairs
        .where((element) {
          return element.id == agreementMessageData.signedPreKeyId;
        })
        .first
        .keyPair;

    SimpleKeyPair? meOneTimePreKey;

    if (agreementMessageData.onetimePreKeyId != null) {
      final meOneTimePreKeys =
          authStateStore.meDevice.onetimePreKeyPairs.where((element) {
        return element.id == agreementMessageData.onetimePreKeyId;
      });

      if (meOneTimePreKeys.isEmpty) {
        print('One time pre key not found');
        throw Exception('One time pre key not found');
      } else if (meOneTimePreKeys.length > 1) {
        print('More than one one time pre key found');
        throw Exception('More than one one time pre key found');
      }
      meOneTimePreKey = meOneTimePreKeys.first.keyPair;
    }

    final result = await SecretUtil.recipientKeyCalculation(
      contactIdentityKey: contactIdentityKey,
      contactEphemeralKey: contactEphemeralKey,
      meIdentityKey: meIdentityKey,
      mePreKey: mePreKey,
      meOneTimePreKey: meOneTimePreKey,
    );

    return result;
  }
}
