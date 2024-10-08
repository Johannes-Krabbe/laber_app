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

    final dh2 =
        await X25519Util.getSharedSecret(meEphemeralKey, contactIdentityKey);

    final dh3 = await X25519Util.getSharedSecret(meEphemeralKey, contactPreKey);

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

    final sharedSecretBytes =
        await X25519Util.keyDerivation([dh1, dh2, dh3, dh4]);

    return (
      sharedSecret: SecretKey(sharedSecretBytes),
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

    final dh2 =
        await X25519Util.getSharedSecret(meIdentityKey, contactEphemeralKey);

    final dh3 = await X25519Util.getSharedSecret(mePreKey, contactEphemeralKey);

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

    final sharedSecretBytes =
        await X25519Util.keyDerivation([dh1, dh2, dh3, dh4]);
    return (
      sharedSecret: SecretKey(sharedSecretBytes),
      safetyNumber: safetyNumber,
      version: SharedSecretVersion.v_1_2
    );
  }
}
