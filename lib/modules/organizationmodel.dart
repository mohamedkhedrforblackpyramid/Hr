class OrganizationsModel {
  int? organizations_id;
  String? name;
  String? arabicName;
  OrganizationsModel({
     this.organizations_id,
     this.name,
    this.arabicName

  });
  OrganizationsModel.fromJson(Map<String, dynamic> json) {
    organizations_id = json['id'];
    print(organizations_id);
    name = json['name'];
    print(name);
    arabicName=json['name_ar'];


  }
}

class OrganizationsList {
  List<OrganizationsModel>? organizationsListt;
  OrganizationsList({this.organizationsListt});
  factory OrganizationsList.fromJson(List<dynamic> parsedJson) {
    List<OrganizationsModel> organizations;
    organizations = parsedJson.map((i) => OrganizationsModel.fromJson(i)).toList();
    return OrganizationsList(organizationsListt: organizations);
  }
}
