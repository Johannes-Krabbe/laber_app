import 'package:isar/isar.dart';
import 'package:laber_app/store/types/chat.dart';

part 'device.g.dart';

@collection
class Device {
  Id id = Isar.autoIncrement;

  @Index(type: IndexType.hash)
  late String apiId;

  @Backlink(to: 'devices')
  final chat = IsarLink<Chat>();

  late String safetyNumber;
  @enumerated
  late SharedSecretVersion version;
  // store secret in secure storage
  late String secret;
}

enum SharedSecretVersion {
  // X25519 excluding ONE TIME PREKEY,
  v_1_1,
  // X25519 including ONE TIME PREKEY,
  v_1_2
}
