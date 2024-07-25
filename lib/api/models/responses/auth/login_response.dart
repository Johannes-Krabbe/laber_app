class AuthLoginResponse {
  String? message;

  AuthLoginResponse({this.message});

  AuthLoginResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
  }
}
