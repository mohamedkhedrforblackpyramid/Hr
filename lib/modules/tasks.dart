class TasksModel {
  int? task_id;
  int? phase_id;
  String? task_name;
  String? phase_name;
  String? project_name;
  bool close = false;
  String? fromDate;
  String? toDate;
  TasksModel({
    this.task_id,
    this.task_name,
    this.phase_name,
    this.project_name,
    this.phase_id,
    this.fromDate,
    this.toDate,
    required this.close,

  });
  TasksModel.fromJson(Map<String, dynamic> json) {
    task_id = json['id'];
    phase_id = json['phase_id'];
    task_name = json['name'];
    phase_name = json['phase_name'];
    project_name = json['project_name'];
    fromDate = json['from_date'];
    toDate = json['due_date'];




  }
}

class TasksList {
  List<TasksModel>? tasksList;
  TasksList({this.tasksList});
  factory TasksList.fromJson(List<dynamic> parsedJson) {
    List<TasksModel> tasks;
    tasks = parsedJson.map((i) => TasksModel.fromJson(i)).toList();
    return TasksList(tasksList: tasks);
  }
}
