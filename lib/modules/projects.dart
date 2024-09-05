class ProjectsModel {
  late int id;
  late String name;
  late String? description;
  late List<int> assignees;
  late List<String> assignee_avatars; // Updated to List<String>
  bool isSelected = false;

  ProjectsModel({
    required this.id,
    required this.name,
    this.description,
    required this.assignees,
    required this.isSelected,
    required this.assignee_avatars,
  });

  ProjectsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    assignees = (json['assignees'] ?? []).cast<int>();
    assignee_avatars = (json['assignee_avatars'] ?? []).cast<String>(); // Updated
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
