class MeUpdateResponse {
  String? message;

  MeUpdateResponse({this.message});

  MeUpdateResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
  }
}

