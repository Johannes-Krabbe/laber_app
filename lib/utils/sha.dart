import 'dart:convert';
import 'package:crypto/crypto.dart';

String hashStringSha256(String input) {
  final bytes = utf8.encode(input);
  final digest = sha256.convert(bytes);
  return base64.encode(digest.bytes);
}
