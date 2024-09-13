import 'dart:typed_data';
import 'dart:math';

final Random _random = Random.secure();

Uint8List generateRandomBytes([int length = 32]) {
  final values = List<int>.generate(length, (i) => _random.nextInt(256));
  return Uint8List.fromList(values);
}
