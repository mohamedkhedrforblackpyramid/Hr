class PermitModel {

   int? id;
   int? organization_id;
   String? from;
   String? to;
   String? status;
   String? notes;
   String? created_at;
   String? name;
   int? user_id;
  PermitModel({
    required this.id,
    required this.organization_id,
    required this.from,
    required this.to,
    required this.status,
    required this.notes,
    required this.created_at,
    required this.name,
    required this.user_id
  });
  PermitModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    organization_id = json['organization_id'];
    from = json['from'];
    to = json['to'];
    status = json['status'];
    notes = json['notes'];
    created_at = json['created_at'];
    name = json['user_name'];
    user_id = json['user_id'];

  }
}

class PermitList {
  List<PermitModel>? permitList;
  PermitList({this.permitList});
  factory PermitList.fromJson(List<dynamic> parsedJson) {
    List<PermitModel> permits;
    permits = parsedJson.map((i) => PermitModel.fromJson(i)).toList();
    return PermitList(permitList: permits);
  }
}
