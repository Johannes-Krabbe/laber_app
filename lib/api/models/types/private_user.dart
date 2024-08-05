// generated with https://javiercbk.github.io/json_to_dart/

class ApiPrivateUser {
  String? id;
  String? phoneNumber;
  int? unixCreatedAt;
  bool? onboardingCompleted;
  String? profilePicture;
  String? name;

  ApiPrivateUser({
    this.id,
    this.phoneNumber,
    this.unixCreatedAt,
    this.onboardingCompleted,
    this.profilePicture,
    this.name,
  });

  ApiPrivateUser.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    phoneNumber = json['phoneNumber'];
    unixCreatedAt = json['unixCreatedAt'];
    onboardingCompleted = json['onboardingCompleted'];
    profilePicture = json['profilePicture'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['phoneNumber'] = phoneNumber;
    data['unixCreatedAt'] = unixCreatedAt;
    data['onboardingCompleted'] = onboardingCompleted;
    data['profilePicture'] = profilePicture;
    data['name'] = name;
    return data;
  }
}
