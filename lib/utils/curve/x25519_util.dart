import 'dart:typed_data';
import 'dart:convert';
import 'package:cryptography_flutter/cryptography_flutter.dart';
import 'package:cryptography/cryptography.dart';
import 'package:laber_app/store/types/device.dart';
import 'package:laber_app/utils/curve/fingerprint_util.dart';

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

  // used to calculate a shared secret from an agreement message
  static Future<
      ({
        SecretKey sharedSecret,
        String safetyNumber,
        SharedSecretVersion version
      })> calculateSecret({
    required SimplePublicKey contactIdentityKey,
    required SimplePublicKey contactEphemeralKey,
    required SimpleKeyPair meIdentityKey,
    required SimpleKeyPair mePreKey,
    SimpleKeyPair? meOneTimePreKey,
  }) async {
    final sharedSecret1 = await getSharedSecret(mePreKey, contactIdentityKey);
    final sharedSecret2 =
        await getSharedSecret(meIdentityKey, contactEphemeralKey);
    final sharedSecret3 = await getSharedSecret(mePreKey, contactEphemeralKey);

    final myFingerprint =
        await getPublicKeyFingerprint(await meIdentityKey.extractPublicKey());
    final contactFingerprint =
        await getPublicKeyFingerprint(contactIdentityKey);

    final safetyNumber = '$contactFingerprint$myFingerprint';

    if (meOneTimePreKey == null) {
      final sharedSecrets = [sharedSecret1, sharedSecret2, sharedSecret3];
      final sharedSecret = await keyDerivation(sharedSecrets, 'X25519');

      return (
        sharedSecret: SecretKey(sharedSecret),
        safetyNumber: safetyNumber,
        version: SharedSecretVersion.v_1_1
      );
    } else {
      final sharedSecret4 =
          await getSharedSecret(meOneTimePreKey, contactEphemeralKey);

      final sharedSecrets = [
        sharedSecret1,
        sharedSecret2,
        sharedSecret3,
        sharedSecret4
      ];

      final sharedSecret = await keyDerivation(sharedSecrets, 'X25519');

      return (
        sharedSecret: SecretKey(sharedSecret),
        safetyNumber: safetyNumber,
        version: SharedSecretVersion.v_1_2
      );
    }
  }

  // used to initialize a chat
  static Future<
      ({
        SecretKey sharedSecret,
        String safetyNumber,
        SharedSecretVersion version
      })> getSharedSecretForChat({
    required SimpleKeyPair meIdentityKey,
    required SimpleKeyPair meEphemeralKey,
    required SimplePublicKey contactIdentityKey,
    required SimplePublicKey contactPreKey,
    SimplePublicKey? contactOneTimePreKey,
  }) async {
    final sharedSecret1 = await getSharedSecret(meIdentityKey, contactPreKey);

    final sharedSecret2 =
        await getSharedSecret(meEphemeralKey, contactIdentityKey);

    final sharedSecret3 = await getSharedSecret(meEphemeralKey, contactPreKey);

    // Generate fingerprints for both parties' identity keys
    final myFingerprint =
        await getPublicKeyFingerprint(await meIdentityKey.extractPublicKey());
    final contactFingerprint =
        await getPublicKeyFingerprint(contactIdentityKey);

    // Concatenate fingerprints to create the safety number
    final safetyNumber = '$myFingerprint$contactFingerprint';

    if (contactOneTimePreKey == null) {
      final sharedSecrets = [sharedSecret1, sharedSecret2, sharedSecret3];
      final sharedSecret = await keyDerivation(sharedSecrets, 'X25519');

      return (
        sharedSecret: SecretKey(sharedSecret),
        safetyNumber: safetyNumber,
        version: SharedSecretVersion.v_1_1
      );
    } else {
      final sharedSecret4 =
          await getSharedSecret(meEphemeralKey, contactOneTimePreKey);

      final sharedSecrets = [
        sharedSecret1,
        sharedSecret2,
        sharedSecret3,
        sharedSecret4
      ];

      final sharedSecret = await keyDerivation(sharedSecrets, 'X25519');

      return (
        sharedSecret: SecretKey(sharedSecret),
        safetyNumber: safetyNumber,
        version: SharedSecretVersion.v_1_2
      );
    }
  }

  static Future<List<int>> keyDerivation(
      List<SecretKey> keys, String curve) async {
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
