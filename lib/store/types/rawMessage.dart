import 'package:isar/isar.dart';

part 'rawMessage.g.dart';

@collection
class RawMessage {
  Id id = Isar.autoIncrement;

  @Index(type: IndexType.hash)
  late String apiId;

  @enumerated
  late RawMessageTypes type;

  late String senderUserId;
  late String senderDeviceId;

  late int unixTime;

  late String content;
}

enum RawMessageTypes {
  initMessage,
  textMessage,
  reaction,
}
