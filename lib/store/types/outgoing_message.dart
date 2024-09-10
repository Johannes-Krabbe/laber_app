import 'package:isar/isar.dart';
part 'outgoing_message.g.dart';

@collection
class OutgoingMessage {
  Id id = Isar.autoIncrement;

  late String content;
  late String recipientDeviceId;

  @enumerated
  late OutgoingStatus status;
  late int retryCount;

  late DateTime createdAt;
  DateTime? sentAt;
  DateTime? failedAt;
}

enum OutgoingStatus {
  pending,
  sent,
  failed,
}
