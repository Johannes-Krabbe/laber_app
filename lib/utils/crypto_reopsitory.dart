import 'package:cryptography/cryptography.dart';
import 'package:laber_app/utils/curve/ed25519_util.dart';
import 'package:laber_app/utils/id_generator.dart';
import 'package:laber_app/utils/secure_storage_repository.dart';
import 'dart:convert';

class CryptoRepository {
  final secureStorage = SecureStorageRepository();

  Future<SimpleKeyPair> getIdentityKeyPair() async {
    const name = 'identityKeyPair';
    final identityKeyPairString = await secureStorage.read(name);

    if (identityKeyPairString != null) {
      return Ed25519Util.stringToKeyPair(identityKeyPairString);
    } else {
      final keyPair = await Ed25519Util.generateKeyPair();
      secureStorage.write(name, await Ed25519Util.keyPairToString(keyPair));
      return keyPair;
    }
  }

  Future<List<SignedPreKeyPair>> getSignedPreKeyPairs() async {
    const name = 'signedPreKeyPair';
    final signedPreKeyPairString = await secureStorage.read(name);

    if (signedPreKeyPairString != null) {
      var keypairs = json.decode(signedPreKeyPairString);
      List<SignedPreKeyPair> signedPreKeyPairs = [];
      for (var keypair in keypairs) {
        signedPreKeyPairs.add(await SignedPreKeyPair.fromJson(keypair));
      }
      return signedPreKeyPairs;
    } else {
      final keyPair = await Ed25519Util.generateKeyPair();
      return [SignedPreKeyPair(keyPair, newCuid())];
    }
  }

  Future<List<SignedPreKeyPair>> addSignedPreKeyPairs(int count) async {
    List<SignedPreKeyPair> signedPreKeyPairs = [];
    for (var i = 0; i < count; i++) {
      final keyPair = await Ed25519Util.generateKeyPair();
      signedPreKeyPairs.add(SignedPreKeyPair(keyPair, newCuid()));
    }
    return signedPreKeyPairs;
  }
}

class SignedPreKeyPair {
  final SimpleKeyPair keyPair;
  DateTime timestamp;
  String id;

  SignedPreKeyPair(this.keyPair, this.id, {DateTime? timestamp})
      : timestamp = timestamp ?? DateTime.now();

  setId(String id) => {this.id = id};

  static Future<SignedPreKeyPair> fromJson(Map<String, dynamic> json) async {
    final keyPair = await Ed25519Util.stringToKeyPair(json['keyPair']);
    final id = json['id'];
    final timestamp = DateTime.parse(json['timestamp']);
    final signedPreKeyPair =
        SignedPreKeyPair(keyPair, id, timestamp: timestamp);
    return signedPreKeyPair;
  }

  static String toJson(SignedPreKeyPair signedPreKeyPair) {
    return '''
    {
      "keyPair": "${Ed25519Util.keyPairToString(signedPreKeyPair.keyPair)}",
      "id": "${signedPreKeyPair.id}",
      "timestamp": "${signedPreKeyPair.timestamp.toIso8601String()}"
    }
    ''';
  }
}
