import 'package:isar/isar.dart';
import 'package:laber_app/api/repositories/device_repository.dart';
import 'package:laber_app/api/repositories/user_repository.dart';
import 'package:laber_app/isar.dart';
import 'package:laber_app/store/repositories/contact_repository.dart';
import 'package:laber_app/store/types/contact.dart';
import 'package:laber_app/api/models/types/public_user.dart';
import 'package:laber_app/store/secure/auth_store_service.dart';
import 'package:laber_app/utils/phone_number.dart';
import 'package:laber_app/utils/sha.dart';

class ContactService {
  static Future<List<Contact>> refetchAllContacts() async {
    final isar = await getIsar();
    final contacts = await isar.contacts.where().findAll();

    for (var contact in contacts) {
      await refetchContact(contact.apiId);
    }

    return contacts;
  }

  static Future<Contact> refetchContact(String apiId) async {
    final contact = await ContactStoreRepository.getContact(apiId);

    if (contact == null) {
      throw Exception('Contact not found in local database');
    }

    return (await fetchContact(apiId))!;
  }

  static Future<Contact?> fetchContact(String apiId) async {
    var contact = await ContactStoreRepository.getContact(apiId);

    final apiResponse = await UserRepository().getById(apiId);

    if (apiResponse.status != 200) {
      print('Failed to fetch contact');
      throw Exception('Failed to fetch contact');
    }

    contact ??= Contact()..apiId = apiId;

    var fetchDevicesRes = await DeviceRepository().getIds(contact.apiId);

    if (fetchDevicesRes.status != 200) {
      return contact;
    }

    final deviceIds = fetchDevicesRes.body!.ids;

    contact
      ..name = apiResponse.body?.user?.name
      ..username = apiResponse.body?.user?.username
      ..profilePicture = apiResponse.body?.user?.profilePicture
      ..deviceApiIds = deviceIds ?? [];
    // ..status = apiResponse.body?.user?.status;

    final isar = await getIsar();

    await isar.writeTxn(() async {
      await isar.contacts.put(contact!);
    });

    return contact;
  }

  static Future<ApiPublicUser> discoverByPhoneNumber(String phoneNumber) async {
    final cleanedPhoneNumber = validateAndCleanPhoneNumber(phoneNumber);

    if (cleanedPhoneNumber == null) {
      throw Exception('Invalid phone number');
    }

    final authState = await AuthStateStoreService.readFromSecureStorage();

    if (authState?.meUser.phoneNumber == cleanedPhoneNumber) {
      throw Exception('You cannot add yourself as a contact');
    }

    final isar = await getIsar();

    final existingContact = await isar.contacts
        .where()
        .filter()
        .phoneNumberEqualTo(cleanedPhoneNumber)
        .findFirst();

    if (existingContact != null) {
      throw Exception('This contact is already in your contacts');
    }

    final hashedPhoneNumber = hashStringSha256(cleanedPhoneNumber);

    final userRepository = UserRepository();

    final discoverResponse = await userRepository
        .discoverByPhoneNumber(hashedPhoneNumber.substring(0, 5));

    if (discoverResponse.status != 200) {
      throw Exception('An error occurred while searching for the phone number');
    }

    if (discoverResponse.body?.users == null ||
        discoverResponse.body?.users?.isEmpty == true) {
      throw Exception('Contact not found');
    }

    var foundUser = discoverResponse.body!.users!.where((user) {
      return user.phoneNumberHash == hashedPhoneNumber;
    });

    if (foundUser.isEmpty) {
      throw Exception('Contact not found');
    }

    if (foundUser.length > 1) {
      throw Exception('Multiple contacts found => internal error');
    }

    final user = foundUser.first;

    return user;
  }
}
