import 'package:crypto/crypto.dart';
import 'package:cryptography/cryptography.dart';

Future<String> getPublicKeyFingerprint(SimplePublicKey publicKey) async {
  final keyBytes = publicKey.bytes;
  final digest = sha256.convert(keyBytes);
  String fingerprint = digest.bytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join();

  return fingerprint;
}
