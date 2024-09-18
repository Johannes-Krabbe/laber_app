import 'package:isar/isar.dart';
import 'package:laber_app/isar.dart';
import 'package:laber_app/services/chat_service.dart';
import 'package:laber_app/services/contact_service.dart';
import 'package:laber_app/store/repositories/contact_repository.dart';
import 'package:laber_app/store/secure/auth_store_service.dart';
import 'package:laber_app/store/types/raw_message.dart';

class RawMessageStoreRepository {
  Future<void> saveRawMessage(RawMessage rawMessage) async {
    final authStore = await AuthStateStoreService.readFromSecureStorage();
    final meUser = authStore!.meUser;
    final contactId = rawMessage.senderUserId == meUser.id
        ? rawMessage.recipientUserId
        : rawMessage.senderUserId;

    var contact = await ContactStoreRepository.getContact(contactId);

    contact ??= await ContactService.fetchContact(contactId);

    if (contact != null) {
      await ChatService.createChat(contactApiId: contactId);
    } else {
      throw Exception('Contact not found');
    }

    final chat = contact.chat.value;

    if (chat == null) {
      throw Exception('Chat not found');
    }

    if (await getByUniqueId(rawMessage.uniqueId) != null) {
      return;
    }

    rawMessage.chat.value = chat;

    final isar = await getIsar();

    await isar.writeTxn(() async {
      await isar.rawMessages.put(rawMessage);
      await rawMessage.chat.save();
    });
  }

  Future<RawMessage?> getByUniqueId(String uniqueId) async {
    final isar = await getIsar();

    return isar.rawMessages.where().uniqueIdEqualTo(uniqueId).findFirst();
  }
}
