import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:laber_app/utils/curve/ed25519/ed25519.dart';
import 'package:laber_app/utils/curve/ed25519/util.dart';

class XeddsaUtil {
  static Future<List<int>> signX25519(
      SimpleKeyPair keyPair, List<int> content) async {
    final random = generateRandomBytes();

    final signature = sign(
      Uint8List.fromList(await keyPair.extractPrivateKeyBytes()),
      Uint8List.fromList(content),
      random,
    );

    return signature;
  }

  static Future<bool> verifyX25519({
    required List<int> content,
    required List<int> publicKeyBytes,
    required List<int> signature,
  }) async {
    final isValid = verifySig(Uint8List.fromList(publicKeyBytes),
        Uint8List.fromList(content), Uint8List.fromList(signature));
    return isValid;
  }
}
