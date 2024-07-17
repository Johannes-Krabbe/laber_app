class LoginResponse {
  String? message;

  LoginResponse({this.message});

  LoginResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
  }
}
