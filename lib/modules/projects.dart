class ProjectsModel {
  late int id;
  late String name;
  late String? description;
  late List<int> assignees;

  ProjectsModel({
    required this.id,
    required this.name,
    this.description,
    required this.assignees,
  });
  ProjectsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description= json['description'];
    print(json['assignees']);
    assignees = (json['assignees'] ?? []).cast<int>();
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
