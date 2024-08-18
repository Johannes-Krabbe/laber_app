import 'dart:convert';

import 'package:laber_app/types/client_contact.dart';

class ContactsStoreRepository {
  final List<ClientContact> contacts;

  ContactsStoreRepository({required this.contacts});


  Future<String> toJson() async {

    List<String> contactsJson = [];
    for (var contact in contacts) {
      contactsJson.add(await contact.toJson());
    }

    return jsonEncode({
      'contacts': contactsJson,
    });

  }
}
