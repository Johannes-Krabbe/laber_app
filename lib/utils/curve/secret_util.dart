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
    print('meIdentityKey => pubkey');
    print((await meIdentityKey.extractPublicKey()).bytes);

    print('meEphemeralKey => pubkey');
    print((await meEphemeralKey.extractPublicKey()).bytes);

    print('contactIdentityKey');
    print(contactIdentityKey.bytes);

    print('contactPreKey');
    print(contactPreKey.bytes);

    print('contactOneTimePreKey');
    print(contactOneTimePreKey?.bytes);

    final dh1 = await X25519Util.getSharedSecret(meIdentityKey, contactPreKey);
    print('dh1bytes');
    print(await dh1.extractBytes());

    final dh2 =
        await X25519Util.getSharedSecret(meEphemeralKey, contactIdentityKey);
    print('dh2bytes');
    print(await dh2.extractBytes());

    final dh3 = await X25519Util.getSharedSecret(meEphemeralKey, contactPreKey);
    print('dh3bytes');
    print(await dh3.extractBytes());

    final myFingerprint =
        await getPublicKeyFingerprint(await meIdentityKey.extractPublicKey());
    final contactFingerprint =
        await getPublicKeyFingerprint(contactIdentityKey);

    final safetyNumber = '$contactFingerprint$myFingerprint';

    // NO ONE TIME PRE KEY
    if (contactOneTimePreKey == null) {
      final sharedSecrets = [dh1, dh2, dh3];
      final sharedSecretBytes = await X25519Util.keyDerivation(sharedSecrets);

      return (
        sharedSecret: SecretKey(sharedSecretBytes),
        safetyNumber: safetyNumber,
        version: SharedSecretVersion.v_1_1
      );
    }

    // WITH ONE TIME PRE KEY

    final dh4 =
        await X25519Util.getSharedSecret(meEphemeralKey, contactOneTimePreKey);
    print('dh4bytes');
    print(await dh4.extractBytes());

    final sharedSecretBytes = await X25519Util.keyDerivation([dh1, dh2, dh3, dh4]);

    print('sharedSecretBytes');
    print(sharedSecretBytes);

    return (
      sharedSecret:
          SecretKey(sharedSecretBytes),
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
    print('contactIdentityKey');
    print(contactIdentityKey.bytes);

    print('contactEphemeralKey');
    print(contactEphemeralKey.bytes);

    print('meIdentityKey => pubkey');
    print((await meIdentityKey.extractPublicKey()).bytes);

    print('mePreKey => pubkey');
    print((await mePreKey.extractPublicKey()).bytes);

    print('meOneTimePreKey => pubkey');
    print((await meOneTimePreKey?.extractPublicKey())?.bytes);

    final dh1 = await X25519Util.getSharedSecret(mePreKey, contactIdentityKey);
    print('dh1bytes');
    print(await dh1.extractBytes());

    final dh2 =
        await X25519Util.getSharedSecret(meIdentityKey, contactEphemeralKey);
    print('dh2bytes');
    print(await dh2.extractBytes());

    final dh3 = await X25519Util.getSharedSecret(mePreKey, contactEphemeralKey);
    print('dh3bytes');
    print(await dh3.extractBytes());

    final contactFingerprint =
        await getPublicKeyFingerprint(contactIdentityKey);
    final myFingerprint =
        await getPublicKeyFingerprint(await meIdentityKey.extractPublicKey());

    final safetyNumber = '$myFingerprint$contactFingerprint';

    // NO ONE TIME PRE KEY
    if (meOneTimePreKey == null) {
      final sharedSecrets = [dh1, dh2, dh3];
      final sharedSecretBytes = await X25519Util.keyDerivation(sharedSecrets);

      return (
        sharedSecret: SecretKey(sharedSecretBytes),
        safetyNumber: safetyNumber,
        version: SharedSecretVersion.v_1_1
      );
    }

    // WITH ONE TIME PRE KEY

    final dh4 =
        await X25519Util.getSharedSecret(meOneTimePreKey, contactEphemeralKey);
    print('dh4bytes');
    print(await await dh4.extractBytes());

    final sharedSecretBytes = await X25519Util.keyDerivation([dh1, dh2, dh3, dh4]);
    print('sharedSecretBytes');
    print(sharedSecretBytes);
    return (
      sharedSecret:
          SecretKey(sharedSecretBytes),
      safetyNumber: safetyNumber,
      version: SharedSecretVersion.v_1_2
    );
  }
}
