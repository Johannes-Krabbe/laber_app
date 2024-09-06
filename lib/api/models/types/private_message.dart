class ApiPrivateMessage {
  String apiId;
  String senderDeviceId;
  String senderUserId;
  String content;
  int unixCreatedAt;

  ApiPrivateMessage({
    required this.apiId,
    required this.senderDeviceId,
    required this.senderUserId,
    required this.content,
    required this.unixCreatedAt,
  });

  ApiPrivateMessage.fromJson(Map<String, dynamic> json)
      : apiId = json['id'],
        senderDeviceId = json['senderDeviceId'],
        senderUserId = json['senderUserId'],
        content = json['content'],
        unixCreatedAt = json['unixCreatedAt'];

  Map<String, dynamic> toJson() {
    return {
      'id': apiId,
      'senderDeviceId': senderDeviceId,
      'senderUserId': senderUserId,
      'content': content,
      'unixCreatedAt': unixCreatedAt,
    };
  }
}
