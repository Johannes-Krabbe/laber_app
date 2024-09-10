import 'dart:convert';
import 'package:cryptography/cryptography.dart';

// General crypto functions
class CryptoUtil {
  // === KeyPair functions ===
  static Future<String> keyPairToString(SimpleKeyPair keyPair) async {
    final keyPairData = await keyPair.extract();

    final keyStore = KeyPairStore(
      keyPairData.type,
      base64Encode(keyPairData.publicKey.bytes),
      base64Encode(keyPairData.bytes),
    );
    return jsonEncode(keyStore.toJson());
  }

  static Future<SimpleKeyPair> stringToKeyPair(String keyPairString) async {
    final keyStore = KeyPairStore.fromJson(jsonDecode(keyPairString));

    final publicKey = SimplePublicKey(
      base64Decode(keyStore.publicKey),
      type: keyStore.type,
    );

    final keyPairData = SimpleKeyPairData(
      base64Decode(keyStore.privateKey),
      publicKey: publicKey,
      type: keyStore.type,
    );

    return keyPairData;
  }

  // === Public key functions ===
  static Future<SimplePublicKey> stringToPublicKey(
      String publicKeyString) async {
    final keyStore = PublicKeyStore.fromJson(jsonDecode(publicKeyString));
    final publicKeyData = base64Decode(keyStore.publicKey);
    return SimplePublicKey(publicKeyData, type: keyStore.type);
  }

  static Future<String> publicKeyToString(SimplePublicKey publicKey) async {
    final keyStore =
        PublicKeyStore(publicKey.type, base64Encode(publicKey.bytes));
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
      'type': type.toString(),
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
      'type': type.toString(),
      'publicKey': publicKey,
      'privateKey': privateKey,
    };
  }
}

// == helper functions ==

keyPairTypeFromString(String keyPairTypeString) {
  if (keyPairTypeString == KeyPairType.ed25519.toString()) {
    return KeyPairType.ed25519;
  } else if (keyPairTypeString == KeyPairType.x25519.toString()) {
    return KeyPairType.x25519;
  } else {
    throw Exception('Invalid key pair type');
  }
}
