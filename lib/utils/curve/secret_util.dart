import 'package:cryptography/cryptography.dart';
import 'package:laber_app/store/types/device.dart';
import 'package:laber_app/utils/curve/fingerprint_util.dart';
import 'package:laber_app/utils/curve/x25519_util.dart';

class SecretUtil {
  static Future<
      ({
        SecretKey sharedSecret,
        String safetyNumber,
        SharedSecretVersion version
      })> initiatorKeyCalculation({
    required SimpleKeyPair meIdentityKey,
    required SimpleKeyPair meEphemeralKey,
    required SimplePublicKey contactIdentityKey,
    required SimplePublicKey contactPreKey,
    SimplePublicKey? contactOneTimePreKey,
  }) async {
    final dh1 = await X25519Util.getSharedSecret(meIdentityKey, contactPreKey);
    print('dh1bytes');
    print(await dh1.extractBytes());

    final dh2 =
        await X25519Util.getSharedSecret(meEphemeralKey, contactIdentityKey);
    print('dh2bytes');
    print(await dh2.extractBytes());

    final dh3 = await X25519Util.getSharedSecret(meEphemeralKey, contactPreKey);
    print('dh2bytes');
    print(await dh2.extractBytes());

    final myFingerprint =
        await getPublicKeyFingerprint(await meIdentityKey.extractPublicKey());
    final contactFingerprint =
        await getPublicKeyFingerprint(contactIdentityKey);

    final safetyNumber = '$contactFingerprint$myFingerprint';

    // NO ONE TIME PRE KEY
    if (contactOneTimePreKey == null) {
      final sharedSecrets = [dh1, dh2, dh3];
      final sharedSecret = await X25519Util.keyDerivation(sharedSecrets);

      return (
        sharedSecret: SecretKey(sharedSecret),
        safetyNumber: safetyNumber,
        version: SharedSecretVersion.v_1_1
      );
    }

    // WITH ONE TIME PRE KEY

    final dh4 =
        await X25519Util.getSharedSecret(meEphemeralKey, contactOneTimePreKey);
    print('dh4bytes');
    print(await dh4.extractBytes());

    return (
      sharedSecret:
          SecretKey(await X25519Util.keyDerivation([dh1, dh2, dh3, dh4])),
      safetyNumber: safetyNumber,
      version: SharedSecretVersion.v_1_2
    );
  }

  static Future<
      ({
        SecretKey sharedSecret,
        String safetyNumber,
        SharedSecretVersion version
      })> recipientKeyCalculation({
    required SimplePublicKey contactIdentityKey,
    required SimplePublicKey contactEphemeralKey,
    required SimpleKeyPair meIdentityKey,
    required SimpleKeyPair mePreKey,
    SimpleKeyPair? meOneTimePreKey,
  }) async {
    final dh1 = await X25519Util.getSharedSecret(mePreKey, contactIdentityKey);
    print('dh1bytes');
    print(await dh1.extractBytes());

    final dh2 =
        await X25519Util.getSharedSecret(meIdentityKey, contactEphemeralKey);
    print('dh2bytes');
    print(await dh2.extractBytes());

    final dh3 = await X25519Util.getSharedSecret(mePreKey, contactEphemeralKey);
    print('dh2bytes');
    print(await dh2.extractBytes());

    final contactFingerprint =
        await getPublicKeyFingerprint(contactIdentityKey);
    final myFingerprint =
        await getPublicKeyFingerprint(await meIdentityKey.extractPublicKey());

    final safetyNumber = '$myFingerprint$contactFingerprint';


    // NO ONE TIME PRE KEY
    if (meOneTimePreKey == null) {
      final sharedSecrets = [dh1, dh2, dh3];
      final sharedSecret = await X25519Util.keyDerivation(sharedSecrets);

      return (
        sharedSecret: SecretKey(sharedSecret),
        safetyNumber: safetyNumber,
        version: SharedSecretVersion.v_1_1
      );
    }

    // WITH ONE TIME PRE KEY

    final dh4 =
        await X25519Util.getSharedSecret(meOneTimePreKey, contactEphemeralKey);
    print('dh4bytes');
    print(await await dh4.extractBytes());

    return (
      sharedSecret:
          SecretKey(await X25519Util.keyDerivation([dh1, dh2, dh3, dh4])),
      safetyNumber: safetyNumber,
      version: SharedSecretVersion.v_1_2
    );


  }
}

/*
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
*/
