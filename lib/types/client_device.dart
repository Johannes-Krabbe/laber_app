

class ClientDevice {
  final String id;
  final String sharedSecret;

  ClientDevice({
    required this.id,
    required this.sharedSecret,
  });

  //from json
  factory ClientDevice.fromJson(Map<String, dynamic> json) {
    return ClientDevice(
      id: json['id'],
      sharedSecret: json['sharedSecret'],
    );
  }

  //to json
  Future<String> toJson() {
    return jsonEncode({
      'id': id,
      'sharedSecret': sharedSecret,
    });
  }
}
