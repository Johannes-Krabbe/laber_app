import 'package:isar/isar.dart';
part 'outgoing_message.g.dart';

@collection
class OutgoingMessage {
  Id id = Isar.autoIncrement;

  late String content;
  late String recipientDeviceId;

  @enumerated
  OutgoingStatus status = OutgoingStatus.pending;
  int retryCount = 0;

  DateTime createdAt = DateTime.now();
  DateTime? sentAt;
  DateTime? failedAt;
}

enum OutgoingStatus {
  pending,
  retrying,
  sent,
  failed,
}
