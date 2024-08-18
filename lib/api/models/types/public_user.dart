// generated with https://javiercbk.github.io/json_to_dart/

class ApiPublicUser {
  String? id;
  String? phoneNumberHash;
  String? profilePicture;
  String? name;
  String? username;

  ApiPublicUser({
    this.id,
    this.phoneNumberHash,
    this.profilePicture,
    this.name,
    this.username,
  });

  ApiPublicUser.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    phoneNumberHash = json['phoneNumberHash'];
    profilePicture = json['profilePicture'];
    name = json['name'];
    username = json['username'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['phoneNumberHash'] = phoneNumberHash;
    data['profilePicture'] = profilePicture;
    data['name'] = name;
    data['username'] = username;
    return data;
  }
}
