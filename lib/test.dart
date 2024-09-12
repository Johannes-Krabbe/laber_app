import 'dart:convert';

import 'package:cryptography/cryptography.dart';
import 'package:laber_app/utils/curve/crypto_util.dart';
import 'package:laber_app/utils/curve/ed25519_util.dart';
import 'package:laber_app/utils/curve/secret_util.dart';
import 'package:laber_app/utils/curve/x25519_util.dart';

test() async {
  final keyPair = await X25519Util.generateKeyPair();
  final content = [123, 1, 88, 99, 01];

  final publicKey = await keyPair.extractPublicKey();

  final signature = await Ed25519Util.sign(keyPair, content);
  final signingKeyPair = await Ed25519Util.keyPairFromBytes(
      await keyPair.extractPrivateKeyBytes());

  final base64Signature = base64Encode(signature.bytes);
  print(publicKey.bytes);

  final signingPublicKey =
      SimplePublicKey(publicKey.bytes, type: KeyPairType.ed25519);

  var isValid = await Ed25519Util.verify(
    content: content,
    signature:
        Signature(base64Decode(base64Signature), publicKey: await signingKeyPair.extractPublicKey()),
  );

  print(isValid);
}

Future<void> test1() async {
  final keyPair = await X25519Util.generateKeyPair();
  final publicKey = await keyPair.extractPublicKey();
  final publicKeyBytes = await publicKey.bytes;

  final publicKeyString = await CryptoUtil.publicKeyToString(
    publicKey,
    KeyPairType.x25519,
  );

  final publicKeyFromString =
      await CryptoUtil.stringToPublicKey(publicKeyString);
  final publicKeyFromStringBytes = publicKeyFromString.bytes;

  print(publicKey.type == publicKeyFromString.type);
  print(publicKey.type);
  print(publicKeyFromString.type);
}

Future<bool> test2() async {
  // initiator
  final aliceIdentityKey = await X25519Util.generateKeyPair();
  final aliceEphemeralKey = await X25519Util.generateKeyPair();

  final aliceIdentityKeyString = await CryptoUtil.publicKeyToString(
    await aliceIdentityKey.extractPublicKey(),
    KeyPairType.ed25519,
  );
  final aliceEphemeralKeyString = await CryptoUtil.publicKeyToString(
    await aliceEphemeralKey.extractPublicKey(),
    KeyPairType.x25519,
  );

  // recipient
  final bobIdentityKey = await X25519Util.generateKeyPair();

  final bobOneTimePreKey = await X25519Util.generateKeyPair();
  final bobSignedPreKey = await X25519Util.generateKeyPair();

  final bobIdentityKeyString = await CryptoUtil.publicKeyToString(
    await bobIdentityKey.extractPublicKey(),
    KeyPairType.ed25519,
  );
  final bobOneTimePreKeyString = await CryptoUtil.publicKeyToString(
    await bobOneTimePreKey.extractPublicKey(),
    KeyPairType.x25519,
  );
  final bobSignedPreKeyString = await CryptoUtil.publicKeyToString(
    await bobSignedPreKey.extractPublicKey(),
    KeyPairType.x25519,
  );

  final initiatorSecret = await SecretUtil.initiatorKeyCalculation(
    meIdentityKey: aliceIdentityKey,
    meEphemeralKey: aliceEphemeralKey,
    contactIdentityKey:
        await CryptoUtil.stringToPublicKey(bobIdentityKeyString),
    contactPreKey: await CryptoUtil.stringToPublicKey(bobSignedPreKeyString),
    contactOneTimePreKey:
        await CryptoUtil.stringToPublicKey(bobOneTimePreKeyString),
  );

  final recipientSecret = await SecretUtil.recipientKeyCalculation(
    meIdentityKey: bobIdentityKey,
    mePreKey: bobSignedPreKey,
    meOneTimePreKey: bobOneTimePreKey,
    contactIdentityKey:
        await CryptoUtil.stringToPublicKey(aliceIdentityKeyString),
    contactEphemeralKey:
        await CryptoUtil.stringToPublicKey(aliceEphemeralKeyString),
  );

  print('===============');
  print('===============');
  print('===============');

  print(await initiatorSecret.sharedSecret.extractBytes());
  print(await recipientSecret.sharedSecret.extractBytes());

  return true;
}
