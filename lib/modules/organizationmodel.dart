class OrganizationsModel {
  int? organizations_id;
  String? name;
  OrganizationsModel({
     this.organizations_id,
     this.name,

  });
  OrganizationsModel.fromJson(Map<String, dynamic> json) {
    organizations_id = json['data']['organizations']['id'];
    name = json['data']['organizations']['name'];


  }
}

class OrganizationsitList {
  List<OrganizationsModel>? organizationsList;
  OrganizationsitList({this.organizationsList});
  factory OrganizationsitList.fromJson(List<dynamic> parsedJson) {
    List<OrganizationsModel> organizations;
    organizations = parsedJson.map((i) => OrganizationsModel.fromJson(i)).toList();
    return OrganizationsitList(organizationsList: organizations);
  }
}
