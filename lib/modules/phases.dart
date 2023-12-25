class PhasesModel {
  int? phase_id;
  String? phaseName;
  String? phaseDesc;
  String?due_date;
  PhasesModel({
    this.phase_id,
    this.phaseName,
    this.phaseDesc,
    this.due_date

  });
  PhasesModel.fromJson(Map<String, dynamic> json) {
    phase_id = json['id'];
    phaseName = json['name'];
    phaseDesc=json['description'];
    due_date=json['due_date'];


  }
}

class PhaseList {
  List<PhasesModel>? phaseList;
  PhaseList({this.phaseList});
  factory PhaseList.fromJson(List<dynamic> parsedJson) {
    List<PhasesModel> phases;
    phases = parsedJson.map((i) => PhasesModel.fromJson(i)).toList();
    return PhaseList(phaseList: phases);
  }
}
