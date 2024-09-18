import 'package:isar/isar.dart';
import 'package:laber_app/api/models/types/public_user.dart';
import 'package:laber_app/isar.dart';
import 'package:laber_app/store/types/contact.dart';

class ContactStoreRepository {
  static Future<List<Contact>> getAllContacts() async {
    final isar = await getIsar();
    final contacts = isar.contacts.where().findAll();
    return contacts;
  }

  static Future<Contact?> getContact(String apiId) async {
    final isar = await getIsar();
    final contact =
        isar.contacts.where().filter().apiIdEqualTo(apiId).findFirst();
    return contact;
  }

  static Future<Contact> addContactFromApiUser(
      ApiPublicUser user, String? phoneNumber) async {
    final isar = await getIsar();

    final existingContact =
        await isar.contacts.where().filter().apiIdEqualTo(user.id!).findFirst();

    if (existingContact != null) {
      throw Exception('Contact already exists');
    }

    final contact = Contact()
      ..apiId = user.id!
      ..name = user.name
      ..username = user.username
      ..phoneNumber = phoneNumber
      ..profilePicture = user.profilePicture;

    await isar.writeTxn(() async {
      await isar.contacts.put(contact);
    });

    return contact;
  }
}
