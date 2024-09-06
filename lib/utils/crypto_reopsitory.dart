import 'package:cryptography/cryptography.dart';
import 'package:laber_app/utils/curve/ed25519_util.dart';
import 'package:laber_app/utils/curve/x25519_util.dart';
import 'package:laber_app/store/secure/secure_storage_service.dart';
import 'dart:convert';

enum SecureStorageType {
  identityKeyPair,
  onetimePreKeyPairs,
  signedPreKeyPairs
}

class CryptoRepository {
  final secureStorage = SecureStorageService();

  // ==== Signed Pre Key Pair ====
  Future<SignedPreKeyPair> createNewSignedPreKeyPair(
      SimpleKeyPair identityKeyPair) async {
    final unsignedPreKey = await Ed25519Util.generateKeyPair();

    final base64UnsignedPublicKey = await X25519Util.publicKeyToString(
        await unsignedPreKey.extractPublicKey());

    final signature =
        await Ed25519Util.sign(identityKeyPair, base64UnsignedPublicKey);
    final base64Signature = base64Encode(signature.bytes);

    final newSignedPreKeyPair =
        SignedPreKeyPair(unsignedPreKey, base64Signature);
    return newSignedPreKeyPair;
  }
}

// ==== Key Pair Classes ====

class SignedPreKeyPair {
  final SimpleKeyPair keyPair;
  final String signature;

  SignedPreKeyPair(this.keyPair, this.signature);

  static Future<SignedPreKeyPair> fromJson(Map<String, dynamic> json) async {
    final keyPair = await Ed25519Util.stringToKeyPair(json['keyPair']);
    final signature = json['signature'];
    final signedPreKeyPair = SignedPreKeyPair(keyPair, signature);
    return signedPreKeyPair;
  }

  static String toJson(SignedPreKeyPair signedPreKeyPair) {
    return '''
    {
      "keyPair": "${Ed25519Util.keyPairToString(signedPreKeyPair.keyPair)}",
      "signature": "${signedPreKeyPair.signature}",
    }
    ''';
  }
}
