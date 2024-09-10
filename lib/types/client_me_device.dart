import 'dart:convert';
import 'package:cryptography/cryptography.dart';
import 'package:laber_app/utils/curve/crypto_util.dart';
import 'package:laber_app/utils/curve/ed25519_util.dart';
import 'package:laber_app/utils/curve/x25519_util.dart';

class ClientMeDevice {
  final String id;
  final String name;
  final ClientIdentityKeyPair identityKeyPair;
  final List<ClientOnetimePreKeyPair> onetimePreKeyPairs;
  final List<ClientSignedPreKeyPair> signedPreKeyPairs;

  ClientMeDevice(
    this.id,
    this.name,
    this.identityKeyPair,
    this.onetimePreKeyPairs,
    this.signedPreKeyPairs,
  );

  Future<String> toJsonString() async {
    return jsonEncode({
      'id': id,
      'name': name,
      'identityKeyPair': await identityKeyPair.toJson(),
      'onetimePreKeyPairs': await Future.wait(
          onetimePreKeyPairs.map((pair) => pair.toJson()).toList()),
      'signedPreKeyPairs': await Future.wait(
          signedPreKeyPairs.map((pair) => pair.toJson()).toList()),
    });
  }

  static Future<ClientMeDevice> fromJsonString(String jsonString) async {
    final json = jsonDecode(jsonString);
    List<ClientOnetimePreKeyPair> oneTimePreKeyPairs = [];
    for (var pairString in json['onetimePreKeyPairs']) {
      oneTimePreKeyPairs
          .add(await ClientOnetimePreKeyPair.fromJson(pairString));
    }

    List<ClientSignedPreKeyPair> signedPreKeyPairs = [];
    for (var pairString in json['signedPreKeyPairs']) {
      signedPreKeyPairs
          .add(await ClientSignedPreKeyPair.fromJson(pairString));
    }

    return ClientMeDevice(
      json['id'],
      json['name'],
      await ClientIdentityKeyPair.fromJson(json['identityKeyPair']),
      oneTimePreKeyPairs,
      signedPreKeyPairs
    );
  }
}

class ClientIdentityKeyPair {
  final SimpleKeyPair keyPair;

  ClientIdentityKeyPair(this.keyPair);

  Future<Map<String, dynamic>> toJson() async {
    return {
      'keyPair': await CryptoUtil.keyPairToString(keyPair),
    };
  }

  static Future<ClientIdentityKeyPair> fromJson(
      Map<String, dynamic> json) async {
    return ClientIdentityKeyPair(
      await CryptoUtil.stringToKeyPair(json['keyPair']),
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
      'keyPair': await CryptoUtil.keyPairToString(keyPair),
      'id': id,
      'unixCreatedAt': unixCreatedAt,
    };
  }

  static Future<ClientOnetimePreKeyPair> fromJson(
      Map<String, dynamic> json) async {
    return ClientOnetimePreKeyPair(
      await CryptoUtil.stringToKeyPair(json['keyPair']),
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
      'keyPair': await CryptoUtil.keyPairToString(keyPair),
      'id': id,
      'unixCreatedAt': unixCreatedAt,
      'signature': signature,
    };
  }

  static Future<ClientSignedPreKeyPair> fromJson(
      Map<String, dynamic> json) async {
    return ClientSignedPreKeyPair(
      await CryptoUtil.stringToKeyPair(json['keyPair']),
      json['id'],
      json['signature'],
      unixCreatedAt: json['unixCreatedAt'],
    );
  }
}
