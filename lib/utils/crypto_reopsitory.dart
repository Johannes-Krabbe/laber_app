import 'package:cryptography/cryptography.dart';
import 'package:laber_app/utils/curve/ed25519_util.dart';
import 'package:laber_app/utils/secure_storage_repository.dart';

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

  Future<SimpleKeyPair> getSignedPreKeyPairs() async {
    const name = 'signedPreKeyPair';
    final signedPreKeyPairString = await secureStorage.read(name);

    if (signedPreKeyPairString != null) {
      return Ed25519Util.stringToKeyPair(signedPreKeyPairString);
    } else {
      final keyPair = await Ed25519Util.generateKeyPair();
      secureStorage.write(name, await Ed25519Util.keyPairToString(keyPair));
      return keyPair;
    }
  }
}

class SignedPreKeyPair {
  final SimpleKeyPair keyPair;
  DateTime timestamp;
  String? id;

  SignedPreKeyPair(this.keyPair, this.id, {DateTime? timestamp})
      : timestamp = timestamp ?? DateTime.now();

  setId(String id) => {this.id = id};

  Future<SignedPreKeyPair> fromJson(Map<String, dynamic> json) async {
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
