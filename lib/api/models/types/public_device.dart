import 'package:cryptography/cryptography.dart';
import 'package:laber_app/utils/curve/ed25519_util.dart';

class ApiPublicDevice {
  String? id;
  ApiSignedPreKey? signedPreKey;
  ApiOneTimePreKey? oneTimePreKey;
  ApiIdentityKey? identityKey;

  ApiPublicDevice(
      {this.id, this.signedPreKey, this.oneTimePreKey, this.identityKey});

  ApiPublicDevice.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    signedPreKey = json['signedPreKey'] != null
        ? ApiSignedPreKey.fromJson(json['signedPreKey'])
        : null;
    oneTimePreKey = json['oneTimePreKey'] != null
        ? ApiOneTimePreKey.fromJson(json['oneTimePreKey'])
        : null;
    identityKey = json['identityKey'] != null
        ? ApiIdentityKey.fromJson(json['identityKey'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};

    data['id'] = id;
    if (signedPreKey != null) {
      data['signedPreKey'] = signedPreKey!.toJson();
    }
    if (oneTimePreKey != null) {
      data['oneTimePreKey'] = oneTimePreKey!.toJson();
    }
    if (identityKey != null) {
      data['identityKey'] = identityKey!.toJson();
    }
    return data;
  }
}

class ApiSignedPreKey {
  String? id;
  int? unixCreatedAt;
  String? key;
  String? signature;

  ApiSignedPreKey({this.id, this.unixCreatedAt, this.key, this.signature});

  ApiSignedPreKey.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    unixCreatedAt = json['unixCreatedAt'];
    key = json['key'];
    signature = json['signature'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['unixCreatedAt'] = unixCreatedAt;
    data['key'] = key;
    data['signature'] = signature;
    return data;
  }

  Future<SimplePublicKey> get publicKey async {
    return Ed25519Util.stringToKeyPair(key!)
        .then((value) => value.extractPublicKey());
  }
}

class ApiOneTimePreKey {
  String? id;
  int? unixCreatedAt;
  String? key;

  ApiOneTimePreKey({id, unixCreatedAt, key});

  ApiOneTimePreKey.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    unixCreatedAt = json['unixCreatedAt'];
    key = json['key'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['unixCreatedAt'] = unixCreatedAt;
    data['key'] = key;
    return data;
  }

  Future<SimplePublicKey> get publicKey async {
    return Ed25519Util.stringToKeyPair(key!)
        .then((value) => value.extractPublicKey());
  }
}

class ApiIdentityKey {
  String? id;
  int? unixCreatedAt;
  String? key;

  ApiIdentityKey({id, unixCreatedAt, key});

  ApiIdentityKey.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    unixCreatedAt = json['unixCreatedAt'];
    key = json['key'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['unixCreatedAt'] = unixCreatedAt;
    data['key'] = key;
    return data;
  }

  Future<SimplePublicKey> get publicKey async {
    return Ed25519Util.stringToKeyPair(key!)
        .then((value) => value.extractPublicKey());
  }
}
