import 'package:cryptography_flutter/cryptography_flutter.dart';
import 'package:cryptography/cryptography.dart';

class Ed25519Util {
  static final ed25519 = Ed25519();
  static final flutterEd25519 = FlutterEd25519(ed25519);

  static Future<SimpleKeyPair> generateKeyPair() async {
    final keyPair = await flutterEd25519.newKeyPair();
    return keyPair;
  }

  static Future<Signature> sign(SimpleKeyPair keyPair, List<int> content) async {
    final signature = await flutterEd25519.sign(
      content,
      keyPair: keyPair,
    );

    return signature;
  }

  static Future<bool> verify({
    required List<int> content,
    required Signature signature,
  }) async {
    final isVerified = await flutterEd25519.verify(
      content,
      signature: signature,
    );
    return isVerified;
  }
}
