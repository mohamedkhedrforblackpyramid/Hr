class ProfileModel {
  int? id;
  String? name;
  dynamic avatar;
  ProfileModel({
    this.id,
    this.name,
    this.avatar,

  });
  ProfileModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    avatar=json['avatar'];


  }
}

class ProfileList {
  List<ProfileModel>? profleList;
  ProfileList({this.profleList});
  factory ProfileList.fromJson(List<dynamic> parsedJson) {
    List<ProfileModel> profiles;
    profiles = parsedJson.map((i) => ProfileModel.fromJson(i)).toList();
    return ProfileList(profleList: profiles);
  }
}
