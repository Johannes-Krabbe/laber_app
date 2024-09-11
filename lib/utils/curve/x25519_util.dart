import 'dart:typed_data';
import 'dart:convert';
import 'package:cryptography_flutter/cryptography_flutter.dart';
import 'package:cryptography/cryptography.dart';

class X25519Util {
  static final x25519 = X25519();
  static final flutterX25519 = FlutterX25519(x25519);

  static Future<SimpleKeyPair> generateKeyPair() async {
    final keyPair = await flutterX25519.newKeyPair();
    return keyPair;
  }

  static Future<SecretKey> getSharedSecret(
      SimpleKeyPair keyPair, SimplePublicKey publicKey) async {
    final sharedSecret = await flutterX25519.sharedSecretKey(
        keyPair: keyPair, remotePublicKey: publicKey);
    return sharedSecret;
  }

  static Future<List<int>> keyDerivation(
      List<SecretKey> keys) async {
    // Concatenate the secret keys into a single byte array
    final kmBytes = <int>[];
    for (var key in keys) {
      final keyBytes = await key.extractBytes();
      kmBytes.addAll(keyBytes);
    }

    // Define the F byte sequence
    Uint8List f = Uint8List(32)..fillRange(0, 32, 0xFF);

    // Concatenate F and KM
    final ikm = Uint8List.fromList(f + kmBytes);

    // HKDF parameters
    final hashAlgorithm = Sha256();
    final salt = Uint8List(
        32); // Zero-filled byte sequence with length of 32 bytes for SHA-256
    final info = Uint8List.fromList(
        utf8.encode("LABER_APP")); // Convert infoString to byte array

    // Derive key using HKDF
    final hkdf = Hkdf(
      hmac: Hmac(hashAlgorithm),
      outputLength: 32,
    );

    final key = await hkdf.deriveKey(
      secretKey: SecretKey(ikm),
      nonce: salt,
      info: info,
    );

    return key.extractBytes();
  }
}
