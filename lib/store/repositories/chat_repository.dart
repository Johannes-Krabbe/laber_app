import 'package:isar/isar.dart';
import 'package:laber_app/isar.dart';
import 'package:laber_app/store/types/chat.dart';
import 'package:laber_app/store/types/contact.dart';


class ChatRepository {
  static Future<List<Chat>> getAllChats() async {
    final isar = await getIsar();
    final chats = await isar.chats.where().findAll();
    return chats;
  }

  static Future<Chat?> getChat({required String contactApiId}) async {
    final isar = await getIsar();
    final contact = await isar.contacts
        .where()
        .filter()
        .apiIdEqualTo(contactApiId)
        .findFirst();
    return contact?.chat.value;
  }

}
