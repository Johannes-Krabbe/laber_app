import 'dart:typed_data';

import 'package:cryptography_flutter/cryptography_flutter.dart';
import 'package:cryptography/cryptography.dart';
import 'dart:convert';

class Ed25519Util {
  static final ed25519 = Ed25519();
  static final flutterEd25519 = FlutterEd25519(ed25519);

  static Future<SimpleKeyPair> generateKeyPair() async {
    final keyPair = await flutterEd25519.newKeyPair();
    return keyPair;
  }

  static Future<Signature> sign(SimpleKeyPair keyPair, String content) async {
    final message = utf8.encode(content);
    final signature = await flutterEd25519.sign(
      message,
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
