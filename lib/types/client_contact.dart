import 'dart:convert';
import 'package:cryptography/cryptography.dart';
import 'package:laber_app/api/repositories/device_repository.dart';
import 'package:laber_app/types/client_chat.dart';
import 'package:laber_app/types/client_device.dart';
import 'package:laber_app/types/client_message.dart';
import 'package:laber_app/utils/auth_store_repository.dart';
import 'package:laber_app/utils/curve/ed25519_util.dart';
import 'package:laber_app/utils/curve/x25519_util.dart';

class ClientContact {
  final String id;
  final String? name;
  final String? username;
  final String? phoneNumber;
  final String? profilePicture;
  final String? status;

  final List<ClientDevice> devices;
  final List<String> clientDeviceIds;

  ClientChat? chat;

  ClientContact({
    required this.id,
    this.name,
    this.username,
    this.phoneNumber,
    this.profilePicture,
    this.status,
    this.devices = const [],
    this.clientDeviceIds = const [],
    this.chat,
  });

  ClientContact copyWith({
    String? id,
    String? name,
    String? username,
    String? phoneNumber,
    String? profilePicture,
    String? status,
    int? unixLastSeen,
    List<ClientDevice>? devices,
    List<String>? clientDeviceIds,
    ClientChat? chat,
  }) {
    return ClientContact(
      id: id ?? this.id,
      name: name ?? this.name,
      username: username ?? this.username,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profilePicture: profilePicture ?? this.profilePicture,
      status: status ?? this.status,
      devices: devices ?? this.devices,
      clientDeviceIds: clientDeviceIds ?? this.clientDeviceIds,
      chat: chat ?? this.chat,
    );
  }

  static Future<ClientContact> createChat(ClientContact contact) async {
    // TODO continue here => init chat
    contact = await fetchDeviceIds(contact);
    contact = await createSecrets(contact);

    return contact.copyWith(
      chat: contact.chat ?? ClientChat(rawMessages: []),
    );
  }

  static Future<ClientContact> createSecrets(
    ClientContact contact,
  ) async {
    final authStore = await AuthStateStoreRepository.getCurrentFromSecureStorage();
    if (authStore?.meDevice == null) {
      throw Exception('No device found');
    }
    for (var deviceId in contact.clientDeviceIds) {
      var exisitingDevices = contact.devices.where((device) {
        return device.id == deviceId;
      });

      if (exisitingDevices.isEmpty || exisitingDevices.length > 1) {
        continue;
      }

      var deviceRes = await DeviceRepository().getKeyBundle(deviceId);

      if (deviceRes.status != 200) {
        continue;
      }

      var meIdentityKey = authStore!.meDevice.identityKeyPair;
      var meEphemeralKey = await X25519Util.generateKeyPair();

      // verify signature
      var signature = deviceRes.body!.device!.signedPreKey!.signature;

      var contactIdentityKey =
          await deviceRes.body!.device!.identityKey!.publicKey;

      var isValid = await Ed25519Util.verify(
        content: deviceRes.body!.device!.signedPreKey!.key!,
        signature:
            Signature(utf8.encode(signature!), publicKey: contactIdentityKey),
      );

      if (!isValid) {
        continue;
      }

      var sharedSecretRes = await X25519Util.getSharedSecretForChat(
        meIdentityKey: meIdentityKey.keyPair,
        meEphemeralKey: meEphemeralKey,
        contactIdentityKey:
            await deviceRes.body!.device!.identityKey!.publicKey,
        contactPreKey: await deviceRes.body!.device!.signedPreKey!.publicKey,
        contactOneTimePreKey:
            await deviceRes.body!.device!.oneTimePreKey!.publicKey,
      );

      contact = contact.copyWith(
        devices: [
          ...contact.devices,
          ClientDevice(
            id: deviceId,
            sharedSecret: sharedSecretRes.sharedSecret,
            safetyNumber: sharedSecretRes.safetyNumber,
            version: sharedSecretRes.version,
          ),
        ],
      );
    }
    return contact;
  }

  static Future<ClientContact> fetchDeviceIds(ClientContact contact) async {
    var fetchDevicesRes = await DeviceRepository().getIds(contact.id);

    if (fetchDevicesRes.status != 200) {
      return contact;
    }

    final deviceIds = fetchDevicesRes.body!.ids;

    return contact.copyWith(
      clientDeviceIds: deviceIds,
    );
  }

  static Future<ClientContact> sendMessage(
      ClientContact contact, String message, String userId) async {
    contact = await createChat(contact);

    final rawMessage = ClientRawMessage(
      // TODO
      chatId: '',
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: {'message': message},
      senderUserId: userId,
      unixTime: DateTime.now().millisecondsSinceEpoch,
      type: RawMessageTypes.textMessage,
    );

    return contact.copyWith(
      chat: contact.chat?.copyWith(
        rawMessages: [...contact.chat!.rawMessages, rawMessage],
      ),
    );
  }

  Future<String> toJson() async {
    return jsonEncode({
      'id': id,
      'name': name,
      'username': username,
      'phoneNumber': phoneNumber,
      'profilePicture': profilePicture,
      'status': status,
      'chat': await chat?.toJson(),
    });
  }

  static Future<ClientContact> fromJsonString(String jsonString) async {
    final json = jsonDecode(jsonString);

    return ClientContact(
      id: json['id'],
      name: json['name'],
      username: json['username'],
      phoneNumber: json['phoneNumber'],
      profilePicture: json['profilePicture'],
      status: json['status'],
      chat: json['chat'] == null
          ? null
          : await ClientChat.fromJsonString(json['chat']),
    );
  }
}
