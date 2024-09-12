import 'dart:convert';
import 'package:cryptography/cryptography.dart';
import 'package:laber_app/utils/curve/ed25519_util.dart';
import 'package:laber_app/utils/curve/x25519_util.dart';

// General crypto functions
class CryptoUtil {
  // === KeyPair functions ===
  static Future<String> keyPairToString(
      SimpleKeyPair keyPair, KeyPairType type) async {
    final keyPairData = await keyPair.extract();

    final keyStore = KeyPairStore(
      type,
      base64Encode(keyPairData.publicKey.bytes),
      base64Encode(keyPairData.bytes),
    );
    return jsonEncode(keyStore.toJson());
  }

  static Future<SimpleKeyPair> stringToKeyPair(String keyPairString) async {
    final keyStore = KeyPairStore.fromJson(jsonDecode(keyPairString));

    switch (keyStore.type) {
      case KeyPairType.x25519:
        final keyPair = await X25519Util.keyPairFromBytes(
          base64Decode(keyStore.privateKey),
        );
        return keyPair;
      case KeyPairType.ed25519:
        final keyPair = await Ed25519Util.keyPairFromBytes(
          base64Decode(keyStore.privateKey),
        );
        return keyPair;
      default:
        throw Exception('Invalid key pair type: ${keyStore.type}');
    }
  }

  // === Public key functions ===
  static Future<SimplePublicKey> stringToPublicKey(
      String publicKeyString) async {
    final keyStore = PublicKeyStore.fromJson(jsonDecode(publicKeyString));
    final publicKeyData = base64Decode(keyStore.publicKey);
    return SimplePublicKey(publicKeyData, type: keyStore.type);
  }

  static Future<String> publicKeyToString(
      SimplePublicKey publicKey, KeyPairType type) async {
    final keyStore = PublicKeyStore(type, base64Encode(publicKey.bytes));
    return jsonEncode(keyStore.toJson());
  }

  // === Secret key functions ===
  static Future<SecretKey> stringToSecretKey(String secretKeyString) async {
    final secretKeyData = base64Decode(secretKeyString);
    return SecretKey(secretKeyData);
  }

  static Future<String> secretKeyToString(SecretKey secretKey) async {
    return base64Encode(await secretKey.extractBytes());
  }
}

// === Store types ===
class PublicKeyStore {
  final KeyPairType type;
  final String publicKey;

  PublicKeyStore(this.type, this.publicKey);

  factory PublicKeyStore.fromJson(Map<String, dynamic> json) {
    KeyPairType type = keyPairTypeFromString(json['type']);

    return PublicKeyStore(type, json['publicKey']);
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type.name,
      'publicKey': publicKey,
    };
  }
}

class KeyPairStore {
  final KeyPairType type;
  final String publicKey;
  final String privateKey;

  KeyPairStore(this.type, this.publicKey, this.privateKey);

  factory KeyPairStore.fromJson(Map<String, dynamic> json) {
    KeyPairType type = keyPairTypeFromString(json['type']);

    return KeyPairStore(type, json['publicKey'], json['privateKey']);
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type.name,
      'publicKey': publicKey,
      'privateKey': privateKey,
    };
  }
}

// == helper functions ==

KeyPairType keyPairTypeFromString(String keyPairTypeString) {
  switch (keyPairTypeString) {
    case 'ed25519':
      return KeyPairType.ed25519;
    case 'x25519':
      return KeyPairType.x25519;
    default:
      throw Exception('Invalid key pair type: $keyPairTypeString');
  }
}
