class ApiPrivateDevice {
  String? id;
  String? deviceName;
  ApiSignedPreKey? signedPreKey;
  List<ApiOneTimePreKey>? oneTimePreKeys;

  ApiPrivateDevice({
    this.id,
    this.deviceName,
    this.signedPreKey,
    this.oneTimePreKeys,
  });

  ApiPrivateDevice.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    deviceName = json['deviceName'];
    if (json['signedPreKey'] != null) {
      signedPreKey = ApiSignedPreKey.fromJson(json['signedPreKey']);
    }
    if (json['oneTimePreKeys'] != null) {
      oneTimePreKeys = [];
      json['oneTimePreKeys'].forEach((v) {
        oneTimePreKeys!.add(ApiOneTimePreKey.fromJson(v));
      });
    } else {
      oneTimePreKeys = [];
    }
  }
}

class ApiSignedPreKey {
  String? id;
  int? unixCreatedAt;
  String? signature;
  String? key;

  ApiSignedPreKey({
    this.id,
    this.unixCreatedAt,
    this.signature,
  });

  ApiSignedPreKey.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    unixCreatedAt = json['unixCreatedAt'];
    signature = json['signature'];
    key = json['key'];
  }
}

class ApiOneTimePreKey {
  String? id;
  int? unixCreatedAt;
  String? key;

  ApiOneTimePreKey({
    this.id,
    this.unixCreatedAt,
    this.key,
  });

  ApiOneTimePreKey.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    unixCreatedAt = json['unixCreatedAt'];
    key = json['key'];
  }
}
