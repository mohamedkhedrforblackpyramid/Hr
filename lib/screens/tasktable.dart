import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../modules/phases.dart';
import '../modules/projects.dart';
import '../modules/tasks.dart';
import '../network/local/cache_helper.dart';
import '../network/remote/dio_helper.dart';

class TaskTable extends StatefulWidget {
  final int? organizationId;
  final int? userId;

  TaskTable({required this.organizationId, required this.userId});

  @override
  _TaskTableState createState() => _TaskTableState();
}

class _TaskTableState extends State<TaskTable> {
  bool showLoading = false;
  late TasksList task_list;
  String valueClosed = '0';
  bool isOpen = false;
  String permit_type = 'myTasks';
  late PhaseList phase_list;
  int? phaseId;
  int? projectId;
  late ProjectsList projects;
  bool projectLoading = false;

  @override
  void initState() {
    super.initState();
    getMyTasks();
    getPhases();
    getProjects();
  }

  Future<void> getMyTasks() async {
    setState(() => showLoading = true);
    final query = {
      if (widget.organizationId != null) 'organization_id': widget.organizationId,
      if (widget.userId != null) 'user_id': widget.userId,
      if (phaseId != null) 'phase_id': phaseId,
      if (projectId != null) 'project_id': projectId,
    };
    try {
      final response = await DioHelper.getData(url: "api/current-tasks", query: query);
      task_list = TasksList.fromJson(response.data);
    } catch (error) {
      print(error);
    } finally {
      setState(() => showLoading = false);
    }
  }

  Future<void> getAllTasks() async {
    setState(() => showLoading = true);
    final query = {
      if (widget.organizationId != null) 'organization_id': widget.organizationId,
      if (phaseId != null) 'phase_id': phaseId,
      if (projectId != null) 'project_id': projectId,
    };
    try {
      final response = await DioHelper.getData(url: "api/current-tasks", query: query);
      task_list = TasksList.fromJson(response.data);
    } catch (error) {
      print(error);
    } finally {
      setState(() => showLoading = false);
    }
  }

  Future<void> getPhases() async {
    try {
      final response = await DioHelper.getData(url: "api/phases", query: {'organization_id': widget.organizationId});
      phase_list = PhaseList.fromJson(response.data);
    } catch (error) {
      print(error);
    }
  }

  Future<void> getProjects() async {
    setState(() => projectLoading = true);
    try {
      final response = await DioHelper.getData(url: "api/projects", query: {'organization_id': widget.organizationId});
      projects = ProjectsList.fromJson(response.data);
    } catch (error) {
      print(error);
    } finally {
      setState(() => projectLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal.shade100,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 5,
                        padding: EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: () {
                        setState(() {
                          permit_type = 'myTasks';
                          isOpen = false;
                          valueClosed = '0';
                        });
                        getMyTasks();
                      },
                      child: Text(
                        "${AppLocalizations.of(context)!.myTasks}",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade100,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 5,
                        padding: EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: () {
                        setState(() {
                          permit_type = 'allTasks';
                          isOpen = false;
                          valueClosed = '1';
                        });
                        getAllTasks();
                      },
                      child: Text(
                        "${AppLocalizations.of(context)!.allTasks}",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Expanded(
                child: showLoading
                    ? Center(child: CircularProgressIndicator(color: Colors.teal))
                    : task_list.tasksList!.isNotEmpty
                    ? buildTasksList()
                    : Center(
                  child: Text(
                    "${AppLocalizations.of(context)!.noTask}",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTasksList() {
    final tasksByProject = <String, List<TasksModel>>{};
    for (var task in task_list.tasksList!) {
      tasksByProject.putIfAbsent(task.project_name!, () => []).add(task);
    }

    return ListView(
      padding: EdgeInsets.zero,
      children: tasksByProject.keys.map((projectName) {
        final tasks = tasksByProject[projectName]!;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                projectName,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
              SizedBox(height: 8),
              ...tasks.map((task) => buildTasks(task: task)).toList(),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget buildTasks({required TasksModel task}) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        leading: Container(
          width: 10,
          height: 40,
          color: Colors.primaries[Random().nextInt(Colors.primaries.length)].shade500,
        ),
        title: Text(
          '${task.task_name}',
          style: TextStyle(fontSize: 16),
        ),
        trailing: task.assignees_names!.contains(CacheHelper.getData(key: 'name'))
            ? Transform.scale(
          scale: 1.2,
          child: Checkbox(
            checkColor: Colors.black,
            fillColor: MaterialStateProperty.all(Colors.white),
            value: task.close,
            onChanged: (value) {
              if (task.close = value!) {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    content: Text(
                      '${AppLocalizations.of(context)!.finishTask}',
                      style: TextStyle(fontSize: 18),
                    ),
                    actions: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            child: Text('${AppLocalizations.of(context)!.yes}'),
                            onPressed: () {
                              DioHelper.patchData(url: "api/tasks/${task.task_id}", data: {"status": "COMPLETED"})
                                  .then((_) {
                                setState(() => task_list.tasksList!.remove(task));
                              }).catchError((e) {
                                setState(() => task.close = false);
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    content: Text(
                                      "${e.response.data['en']}",
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ),
                                );
                              });
                              Navigator.of(context).pop();
                            },
                          ),
                          SizedBox(width: 8),
                          TextButton(
                            child: Text('${AppLocalizations.of(context)!.no}'),
                            onPressed: () {
                              Navigator.of(context).pop();
                              setState(() => task.close = false);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  barrierDismissible: false,
                );
                setState(() {});
              }
            },
          ),
        )
            : SizedBox(),
      ),
    );
  }
}
