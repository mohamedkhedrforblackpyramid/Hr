import '../network/local/cache_helper.dart';

class TasksModel {
  int? task_id;
  int? phase_id;
  String? task_name;
  String? phase_name;
  String? project_name;
  bool close = false;
  String? fromDate;
  String? toDate;
  String? description;
  List?assignees_names;
  late List<int> assignees;

  TasksModel({
    this.task_id,
    this.task_name,
    this.phase_name,
    this.project_name,
    this.phase_id,
    this.fromDate,
    this.toDate,
    this.assignees_names,
    required this.close,
    required this.assignees,
    required this.description,


  });
  TasksModel.fromJson(Map<String, dynamic> json) {
    task_id = json['id'];
    phase_id = json['phase_id'];
    task_name = json['name'];
    phase_name = json['phase_name'];
    project_name = json['project_name'];
    fromDate = json['from_date'];
    toDate = json['due_date'];
    description = json['description'];
     assignees_names = json['assignees_names'];
    assignees = (json['assignees'] ?? []).cast<int>();
    assignees = (json['assignees'] ?? []).cast<int>();

    //list?.contains(CacheHelper.getData(key: 'name'));



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
