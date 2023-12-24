class ChooseUserModel {
  int? userId;
  String? name;
  bool isChecked = false;
  ChooseUserModel({
    this.userId,
    this.name,


  });
  ChooseUserModel.fromJson(Map<String, dynamic> json) {
    userId = json['id'];
    name = json['name'];
  }
}

class ChooseUserList {
  List<ChooseUserModel>? chooseuserList;
  ChooseUserList({this.chooseuserList});
  factory ChooseUserList.fromJson(List<dynamic> parsedJson) {
    List<ChooseUserModel> chooseusers;
    chooseusers = parsedJson.map((i) => ChooseUserModel.fromJson(i)).toList();
    return ChooseUserList(chooseuserList: chooseusers);
  }
}
