import 'package:isar/isar.dart';
import 'package:laber_app/isar.dart';
import 'package:laber_app/store/types/outgoing_message.dart';
import 'package:laber_app/types/message/api_message.dart';

class OutgoingMessageRepository {
  static Future<void> create({
    required ApiMessage content,
    required String recipientDeviceId,
  }) async {
    final outgoingMessage = OutgoingMessage()
      ..content = content.toJsonString()
      ..recipientDeviceId = recipientDeviceId
      ..createdAt = DateTime.now();

    final isar = await getIsar();

    await isar.writeTxn(() async {
      await isar.outgoingMessages.put(outgoingMessage);
    });
  }

  static Future<List<OutgoingMessage>> getPending() async {
    final isar = await getIsar();
    return await isar.outgoingMessages
        .filter()
        .statusEqualTo(OutgoingStatus.pending)
        .sortByCreatedAt()
        .findAll();
  }

  static Future<List<OutgoingMessage>> getRetryable() async {
    final isar = await getIsar();
    return await isar.outgoingMessages
        .filter()
        .statusEqualTo(OutgoingStatus.retrying)
        .sortByCreatedAt()
        .findAll();
  }
}
