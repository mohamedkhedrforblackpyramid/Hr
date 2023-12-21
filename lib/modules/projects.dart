class ProjectsModel {
  int? project_id;
  String? name;
  String? description;
  ProjectsModel({
    this.project_id,
    this.name,
    this.description

  });
  ProjectsModel.fromJson(Map<String, dynamic> json) {
    project_id = json['id'];
    name = json['name'];
    description=json['description'];


  }
}

class ProjectsList {
  List<ProjectsModel>? projectList;
  ProjectsList({this.projectList});
  factory ProjectsList.fromJson(List<dynamic> parsedJson) {
    List<ProjectsModel> projects;
    projects = parsedJson.map((i) => ProjectsModel.fromJson(i)).toList();
    return ProjectsList(projectList: projects);
  }
}
