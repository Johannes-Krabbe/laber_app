import 'package:cryptography_flutter/cryptography_flutter.dart';
import 'package:cryptography/cryptography.dart';
import 'dart:convert';

class Ed25519Util {
  static final ed25519 = Ed25519();
  static final flutterEd25519 = FlutterEd25519(ed25519);

  static Future<SimpleKeyPair> generateKeyPair() async {
    final keyPair = await flutterEd25519.newKeyPair();
    return keyPair;
  }

  static Future<Signature> sign(SimpleKeyPair keyPair, String content) async {
    final message = utf8.encode(content);
    final signature = await flutterEd25519.sign(
      message,
      keyPair: keyPair,
    );

    return signature;
  }

  static Future<bool> verify({
    required String content,
    required Signature signature,
  }) async {
    final message = base64Decode(content);

    final isVerified = await flutterEd25519.verify(
      message,
      signature: signature,
    );
    return isVerified;
  }

  static Future<String> keyPairToString(SimpleKeyPair keyPair) async {
    final keyPairData = await keyPair.extractPrivateKeyBytes();
    return base64Encode(keyPairData);
  }

  static Future<SimpleKeyPair> stringToKeyPair(String keyPairString) async {
    final keyPairData = base64Decode(keyPairString);
    return flutterEd25519.newKeyPairFromSeed(keyPairData);
  }

  static Future<SimplePublicKey> stringToPublicKey(String publicKeyString) async {
    final publicKeyData = base64Decode(publicKeyString);
    return SimplePublicKey(publicKeyData, type: KeyPairType.ed25519);
  }

  static Future<String> publicKeyToString(SimplePublicKey publicKey) async {
    final publicKeyData = publicKey.bytes;
    return base64Encode(publicKeyData);
  }
}
