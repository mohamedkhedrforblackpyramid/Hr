class OrganizationsModel {
  int? organizations_id;
  String? name;
  OrganizationsModel({
     this.organizations_id,
     this.name,

  });
  OrganizationsModel.fromJson(Map<String, dynamic> json) {
    organizations_id = json['id'];
    print(organizations_id);
    name = json['name'];
    print(name);


  }
}

class OrganizationsList {
  List<OrganizationsModel>? organizationsList;
  OrganizationsList({this.organizationsList});
  factory OrganizationsList.fromJson(List<dynamic> parsedJson) {
    List<OrganizationsModel> organizations;
    organizations = parsedJson.map((i) => OrganizationsModel.fromJson(i)).toList();
    return OrganizationsList(organizationsList: organizations);
  }
}
