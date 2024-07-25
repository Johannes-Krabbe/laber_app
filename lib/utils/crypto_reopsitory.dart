import 'package:cryptography/cryptography.dart';
import 'package:laber_app/utils/curve/ed25519_util.dart';
import 'package:laber_app/utils/curve/x25519_util.dart';
import 'package:laber_app/utils/secure_storage_repository.dart';
import 'dart:convert';

enum SecureStorageType {
  identityKeyPair,
  onetimePreKeyPairs,
  signedPreKeyPairs
}

class CryptoRepository {
  final secureStorage = SecureStorageRepository();

  // ==== Identity Key Pair ====

  Future<SimpleKeyPair> getIdentityKeyPair(String accountId) async {
    final secureStorageIdentifyer =
        "${SecureStorageType.identityKeyPair}-$accountId";
    final identityKeyPairString =
        await secureStorage.read(secureStorageIdentifyer);

    if (identityKeyPairString != null) {
      return Ed25519Util.stringToKeyPair(identityKeyPairString);
    } else {
      final keyPair = await Ed25519Util.generateKeyPair();
      secureStorage.write(
          secureStorageIdentifyer, await Ed25519Util.keyPairToString(keyPair));
      return keyPair;
    }
  }

  // ==== Onetime Pre Key Pair ====

  Future<List<OnetimePreKeyPair>> getOnetimePreKeyPairs(
      String accountId) async {
    final secureStorageIdentifyer =
        "${SecureStorageType.onetimePreKeyPairs}-$accountId";
    final onetimePreKeyPairsString =
        await secureStorage.read(secureStorageIdentifyer);

    if (onetimePreKeyPairsString != null) {
      var keypairs = json.decode(onetimePreKeyPairsString);
      List<OnetimePreKeyPair> onetimePreKeyPairs = [];
      for (var keypair in keypairs) {
        onetimePreKeyPairs.add(await OnetimePreKeyPair.fromJson(keypair));
      }
      return onetimePreKeyPairs;
    } else {
      return [];
    }
  }

  // Create keypairs, but don't save them, because we need the ID from the server
  Future<List<OnetimePreKeyPair>> createOnetimePreKeyPairs(
      String accountId, int count) async {
    var onetimePreKeyPairs = await getOnetimePreKeyPairs(accountId);
    for (var i = 0; i < count; i++) {
      final keyPair = await Ed25519Util.generateKeyPair();
      onetimePreKeyPairs.add(OnetimePreKeyPair(keyPair, ''));
    }
    return onetimePreKeyPairs;
  }

  Future<List<OnetimePreKeyPair>> saveOnetimePreKeyPairs(
      String accountId, List<OnetimePreKeyPair> onetimePreKeyPairs) async {
    final secureStorageIdentifyer =
        "${SecureStorageType.onetimePreKeyPairs}-$accountId";
    var jsonStrings = onetimePreKeyPairs.map((keyPair) {
      return OnetimePreKeyPair.toJson(keyPair);
    }).toList();
    secureStorage.write(
        secureStorageIdentifyer, json.encode(jsonStrings.toString()));
    return onetimePreKeyPairs;
  }

  // ==== Signed Pre Key Pair ====

  Future<List<SignedPreKeyPair>> getSignedPreKeyPairs(String accountId) async {
    final secureStorageIdentifyer =
        "${SecureStorageType.signedPreKeyPairs}-$accountId";
    final signedPreKeyPairsString =
        await secureStorage.read(secureStorageIdentifyer);

    if (signedPreKeyPairsString != null) {
      var keypairs = json.decode(signedPreKeyPairsString);
      List<SignedPreKeyPair> signedPreKeyPairs = [];
      for (var keypair in keypairs) {
        signedPreKeyPairs.add(await SignedPreKeyPair.fromJson(keypair));
      }
      return signedPreKeyPairs;
    } else {
      return [];
    }
  }

  Future<List<SignedPreKeyPair>> saveSignedPreKeyPairs(
      String accountId, List<SignedPreKeyPair> signedPreKeyPairs) async {
    final secureStorageIdentifyer =
        "${SecureStorageType.signedPreKeyPairs}-$accountId";
    var jsonStrings = signedPreKeyPairs.map((keyPair) {
      return SignedPreKeyPair.toJson(keyPair);
    }).toList();
    secureStorage.write(
        secureStorageIdentifyer, json.encode(jsonStrings.toString()));
    return signedPreKeyPairs;
  }

  Future<SignedPreKeyPair> createNewSignedPreKeyPair(String accountId) async {
    final unsignedPreKey = await Ed25519Util.generateKeyPair();
    final identityKeyPair = await getIdentityKeyPair(accountId);

    final base64UnsignedPublicKey = await X25519Util.publicKeyToString(
        await unsignedPreKey.extractPublicKey());

    final signature =
        await Ed25519Util.sign(identityKeyPair, base64UnsignedPublicKey);
    final base64Signature = base64Encode(signature.bytes);

    final newSignedPreKeyPair =
        SignedPreKeyPair(unsignedPreKey, '', base64Signature);
    return newSignedPreKeyPair;
  }
}

// ==== Key Pair Classes ====

class OnetimePreKeyPair {
  final SimpleKeyPair keyPair;
  int unixCreatedAt;
  String id;

  OnetimePreKeyPair(this.keyPair, this.id, {int? unixCreatedAt})
      : unixCreatedAt =
            unixCreatedAt ?? DateTime.now().millisecondsSinceEpoch;

  static Future<OnetimePreKeyPair> fromJson(Map<String, dynamic> json) async {
    final keyPair = await Ed25519Util.stringToKeyPair(json['keyPair']);
    final id = json['id'];
    final unixCreatedAt = json['unixCreatedAt'];
    final onetimePreKeyPair =
        OnetimePreKeyPair(keyPair, id, unixCreatedAt: unixCreatedAt);
    return onetimePreKeyPair;
  }

  static String toJson(OnetimePreKeyPair onetimePreKeyPair) {
    return '''
    {
      "keyPair": "${Ed25519Util.keyPairToString(onetimePreKeyPair.keyPair)}",
      "id": "${onetimePreKeyPair.id}",
      "unixCreatedAt": "${onetimePreKeyPair.unixCreatedAt}"
    }
    ''';
  }
}

class SignedPreKeyPair {
  final SimpleKeyPair keyPair;
  final String id;
  final int unixCreatedAt;
  final String signature;

  SignedPreKeyPair(this.keyPair, this.id, this.signature,
      {int? unixCreatedAt})
      : unixCreatedAt =
            unixCreatedAt ?? DateTime.now().millisecondsSinceEpoch;

  static Future<SignedPreKeyPair> fromJson(Map<String, dynamic> json) async {
    final keyPair = await Ed25519Util.stringToKeyPair(json['keyPair']);
    final id = json['id'];
    final signature = json['signature'];
    final unixCreatedAt = json['unixCreatedAt'];
    final signedPreKeyPair =
        SignedPreKeyPair(keyPair, id, signature, unixCreatedAt: unixCreatedAt);
    return signedPreKeyPair;
  }

  static String toJson(SignedPreKeyPair signedPreKeyPair) {
    return '''
    {
      "keyPair": "${Ed25519Util.keyPairToString(signedPreKeyPair.keyPair)}",
      "id": "${signedPreKeyPair.id}",
      "signature": "${signedPreKeyPair.signature}",
      "unixCreatedAt": "${signedPreKeyPair.unixCreatedAt}"
    }
    ''';
  }
}
