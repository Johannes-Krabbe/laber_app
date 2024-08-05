import 'dart:convert';
import 'package:cryptography/cryptography.dart';
import 'package:laber_app/utils/curve/ed25519_util.dart';
import 'package:laber_app/utils/curve/x25519_util.dart';

class ClientMeDevice {
  final ClientIdentityKeyPair identityKeyPair;
  final List<ClientOnetimePreKeyPair> onetimePreKeyPairs;
  final List<ClientSignedPreKeyPair> signedPreKeyPairs;

  ClientMeDevice(
    this.identityKeyPair,
    this.onetimePreKeyPairs,
    this.signedPreKeyPairs,
  );

  String toJsonString() {
    return jsonEncode({
      'identityKeyPair': identityKeyPair.toJson(),
      'onetimePreKeyPairs':
          onetimePreKeyPairs.map((pair) => pair.toJson()).toList(),
      'signedPreKeyPairs':
          signedPreKeyPairs.map((pair) => pair.toJson()).toList(),
    });
  }

  static Future<ClientMeDevice> fromJsonString(String jsonString) async {
    final json = jsonDecode(jsonString);
    return ClientMeDevice(
      await ClientIdentityKeyPair.fromJson(json['identityKeyPair']),
      await Future.wait(
          json['onetimePreKeyPairs'].map((pair) => ClientOnetimePreKeyPair.fromJson(pair))),
      await Future.wait(
          json['signedPreKeyPairs'].map((pair) => ClientSignedPreKeyPair.fromJson(pair))),
    );
  }
}

class ClientIdentityKeyPair {
  final SimpleKeyPair keyPair;
  final String id;

  ClientIdentityKeyPair(this.keyPair, this.id);

  Map<String, dynamic> toJson() {
    return {
      'keyPair': X25519Util.keyPairToString(keyPair),
      'id': id,
    };
  }

  static Future<ClientIdentityKeyPair> fromJson(Map<String, dynamic> json) async {
    return ClientIdentityKeyPair(
      await Ed25519Util.stringToKeyPair(json['keyPair']),
      json['id'],
    );
  }
}

class ClientOnetimePreKeyPair {
  final SimpleKeyPair keyPair;
  final String id;
  final int unixCreatedAt;

  ClientOnetimePreKeyPair(this.keyPair, this.id, {int? unixCreatedAt})
      : unixCreatedAt = unixCreatedAt ?? DateTime.now().millisecondsSinceEpoch;

  Future<Map<String, dynamic>> toJson() async {
    return {
      'keyPair': await Ed25519Util.keyPairToString(keyPair),
      'id': id,
      'unixCreatedAt': unixCreatedAt,
    };
  }

  static Future<ClientOnetimePreKeyPair> fromJson(Map<String, dynamic> json) async {
    return ClientOnetimePreKeyPair(
      await Ed25519Util.stringToKeyPair(json['keyPair']),
      json['id'],
      unixCreatedAt: json['unixCreatedAt'],
    );
  }
}

class ClientSignedPreKeyPair {
  final SimpleKeyPair keyPair;
  final String id;
  final int unixCreatedAt;
  final String signature;

  ClientSignedPreKeyPair(this.keyPair, this.id, this.signature,
      {int? unixCreatedAt})
      : unixCreatedAt = unixCreatedAt ?? DateTime.now().millisecondsSinceEpoch;

  Future<Map<String, dynamic>> toJson() async {
    return {
      'keyPair': await Ed25519Util.keyPairToString(keyPair),
      'id': id,
      'unixCreatedAt': unixCreatedAt,
      'signature': signature,
    };
  }

  static Future<ClientSignedPreKeyPair> fromJson(Map<String, dynamic> json) async {
    return ClientSignedPreKeyPair(
      await Ed25519Util.stringToKeyPair(json['keyPair']),
      json['id'],
      json['signature'],
      unixCreatedAt: json['unixCreatedAt'],
    );
  }
}
