class DeviceGetIdsResponse {
  List<String>? ids;

  DeviceGetIdsResponse({this.ids});

  DeviceGetIdsResponse.fromJson(Map<String, dynamic> json) {
    ids = json['ids'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if(ids != null) {
      data['ids'] = ids;
    }
    return data;
  }
}
