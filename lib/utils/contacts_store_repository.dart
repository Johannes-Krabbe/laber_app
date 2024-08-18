import 'dart:convert';
import 'package:laber_app/types/client_contact.dart';
import 'package:laber_app/utils/secure_storage_repository.dart';

class ContactsStoreRepository {
  static Future<void> store(String userId, List<ClientContact> contacts) async {
    final allExistingContactsStores = await getAllContactsStores();

    var futureContactsStores = allExistingContactsStores
        .where((contactsStore) => contactsStore.userId != userId)
        .toList();

    futureContactsStores.add(ContactsStore(userId: userId, contacts: contacts));

    final secureStorage = SecureStorageRepository();

    await secureStorage.write(
      SecureStorageKeys.contactsStore,
      jsonEncode(
        await Future.wait(
          futureContactsStores.map((store) => store.toJsonString()).toList(),
        ),
      ),
    );
  }

  static Future<ContactsStore> getContactsStore(userId) async {
    final all = await getAllContactsStores();

    var found = all.where((store) => store.userId == userId).toList();

    if (found.isNotEmpty) {
      return found.first;
    }

    return ContactsStore(userId: userId, contacts: []);
  }

  static Future<List<ContactsStore>> getAllContactsStores() async {
    final secureStorage = SecureStorageRepository();

    final contactsStoreString =
        await secureStorage.read(SecureStorageKeys.contactsStore);

    if (contactsStoreString == null) {
      return [];
    }

    final contactsStoreArray = jsonDecode(contactsStoreString);

    final List<ContactsStore> contactsStores = [];
    for (final contactsStore in contactsStoreArray) {
      contactsStores.add(await ContactsStore.fromJsonString(contactsStore));
    }

    return contactsStores;
  }
}

class ContactsStore {
  String userId;
  List<ClientContact> contacts;

  ContactsStore({required this.userId, required this.contacts});

  static Future<ContactsStore> fromJsonString(String jsonString) async {
    final json = jsonDecode(jsonString);
    List<ClientContact> contacts = [];
    for (final contact in json['contacts']) {
      contacts.add(await ClientContact.fromJsonString(contact));
    }

    return ContactsStore(
      userId: json['userId'],
      contacts: contacts,
    );
  }

  Future<String> toJsonString() async {
    List<String> contactsJson = [];
    for (var contact in contacts) {
      contactsJson.add(await contact.toJson());
    }

    return jsonEncode({
      'userId': userId,
      'contacts': contactsJson,
    });
  }
}
