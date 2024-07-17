// generated with https://javiercbk.github.io/json_to_dart/

class PrivateUser {
  String? id;
  String? phoneNumber;
  int? createdAt;
  bool? onboardingCompleted;
  String? profilePicture;

  PrivateUser({
    this.id,
    this.phoneNumber,
    this.createdAt,
    this.onboardingCompleted,
    this.profilePicture,
  });

  PrivateUser.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    phoneNumber = json['phoneNumber'];
    createdAt = json['createdAt'];
    onboardingCompleted = json['onboardingCompleted'];
    profilePicture = json['profilePicture'];
  }
}
