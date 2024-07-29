import 'dart:math';
import 'dart:ui';

import 'package:another_flushbar/flushbar.dart';
import 'package:fancy_containers/fancy_containers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hr/modules/projects.dart';
import 'package:hr/screens/multiscreen_tasks/multiscreenfortasks.dart';
import 'package:rive/rive.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../modules/phases.dart';
import '../modules/tasks.dart';
import '../network/local/cache_helper.dart';
import '../network/remote/dio_helper.dart';

class TaskTable extends StatefulWidget {
  int? organizationId;
  int? userId;
  TaskTable({required this.organizationId, required this.userId});

  @override
  State<TaskTable> createState() => _TaskTableState();
}

class _TaskTableState extends State<TaskTable> {
  bool showLoading = false;
  late TasksList task_list;
  String valueClosed = '0';
  bool isOpen = false;
  String permit_type = 'myTasks';
  bool myTask = false;
  late PhaseList phase_list;
  int? phaseId;
  int? projectId;
  late ProjectsList projects;
  bool projectLoading = false;

  getMyTasks() async {
    showLoading = true;
    Map<String, dynamic> query = {};
    if (widget.organizationId != null) {
      query['organization_id'] = widget.organizationId;
    }
    if (widget.userId != null) {
      query['user_id'] = widget.userId;
    }
    if (phaseId != null) {
      query['phase_id'] = phaseId;
    }
    if (projectId != null) {
      query['project_id'] = projectId;
    }
    await DioHelper.getData(url: "api/current-tasks", query: query).then((response) {
      task_list = TasksList.fromJson(response.data);
      print(response.data);
      setState(() {
        showLoading = false;
      });
    }).catchError((error) {
      print(error.response.data);
    });
  }

  getAllTasks() async {
    showLoading = true;
    Map<String, dynamic> query = {};
    if (widget.organizationId != null) {
      query['organization_id'] = widget.organizationId;
    }
    if (phaseId != null) {
      query['phase_id'] = phaseId;
    }
    if (projectId != null) {
      query['project_id'] = projectId;
    }
    await DioHelper.getData(url: "api/current-tasks", query: query).then((response) {
      task_list = TasksList.fromJson(response.data);
      setState(() {
        showLoading = false;
      });
    }).catchError((error) {
      print(error.response.data);
    });
  }

  getPhases() {
    DioHelper.getData(url: "api/phases", query: {
      'organization_id': widget.organizationId,
    }).then((response) {
      phase_list = PhaseList.fromJson(response.data);
      setState(() {});
    }).catchError((error) {
      print(error.response.data);
    });
  }

  getProjects() async {
    projectLoading = true;
    await DioHelper.getData(url: "api/projects", query: {'organization_id': widget.organizationId}).then((response) {
      projects = ProjectsList.fromJson(response.data);
      setState(() {
        projectLoading = false;
      });
    }).catchError((error) {
      print(error);
    });
  }

  @override
  void initState() {
    getMyTasks();
    getPhases();
    getProjects();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.teal.shade100,
                                borderRadius: BorderRadius.circular(10),  // Adjust the borderRadius as per your preference
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: Offset(0, 3), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: RadioListTile(
                                title: Text(
                                  "My Tasks",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                tileColor: Colors.transparent,  // Set tileColor to transparent to see the Container's decoration
                                value: '0',
                                groupValue: valueClosed,
                                onChanged: (value) {
                                  getMyTasks();
                                  setState(() {
                                    permit_type = 'myTasks';
                                    isOpen = false;
                                    valueClosed = value.toString();
                                  });
                                },
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),  // Match the borderRadius of the Container
                                ),
                                controlAffinity: ListTileControlAffinity.trailing,  // Align the radio button to the right
                              ),
                            )
                            ,
                          ),
                          SizedBox(width: 15),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.redAccent.shade100,
                                borderRadius: BorderRadius.circular(10), // Adjust the borderRadius as per your preference
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: Offset(0, 3), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: RadioListTile(
                                title: Text(
                                  "All Tasks",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                tileColor: Colors.transparent, // Set tileColor to transparent to see the Container's decoration
                                value: '1',
                                groupValue: valueClosed,
                                onChanged: (value) {
                                  getAllTasks();
                                  setState(() {
                                    permit_type = 'allTasks';
                                    isOpen = false;
                                    valueClosed = value.toString();
                                  });
                                },
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10), // Match the borderRadius of the Container
                                ),
                                controlAffinity: ListTileControlAffinity.trailing, // Align the radio button to the right
                              ),
                            )
                            ,
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      showLoading == false
                          ? task_list.tasksList!.isNotEmpty
                          ? buildTasksList()
                          : Padding(
                        padding: EdgeInsets.symmetric(vertical: 300),
                        child: Center(
                          child: Text(
                            "${AppLocalizations.of(context)!.noTask}",
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                          : const Padding(
                        padding: EdgeInsets.symmetric(vertical: 300),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: Colors.indigo,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTasksList() {
    Map<String, List<TasksModel>> tasksByProject = {};
    for (var task in task_list.tasksList!) {
      if (!tasksByProject.containsKey(task.project_name)) {
        tasksByProject[task.project_name!] = [];
      }
      tasksByProject[task.project_name]!.add(task);
    }

    return ListView(
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      children: tasksByProject.keys.map((projectName) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              projectName,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                var task = tasksByProject[projectName]![index];
                return buildTasks(task: task, index: index);
              },
              itemCount: tasksByProject[projectName]!.length,
              separatorBuilder: (BuildContext context, int index) => SizedBox(height: 10),
            ),
            SizedBox(height: 20),
          ],
        );
      }).toList(),
    );
  }

  Widget buildTasks({required TasksModel task, required int index}) {
    return ListTile(

      leading: Container(
        width: 10,
        height: 40,
        color: Colors.primaries[Random().nextInt(Colors.primaries.length)].shade500,
      ),
      title: Text('${task.task_name}'),
      trailing: Transform.scale(
        scale: 1.2,
        child: CircleAvatar(
          child: Checkbox(
            checkColor: Colors.black,
            fillColor: MaterialStateProperty.all(Colors.white),
            value: task.close,
            onChanged: (value) {
              if (task.close = value!) {
                showDialog(
                  context: (context),
                  builder: (contextop) => AlertDialog(
                    content: Text(
                      'Did you finish this task?',
                      style: TextStyle(fontSize: 20),
                    ),
                    actions: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            child: Text('Yes'),
                            onPressed: () {
                              DioHelper.patchData(url: "api/tasks/${task.task_id}", data: {
                                "status": "COMPLETED",
                              }).then((v) {
                                setState(() {
                                  task_list.tasksList!.removeAt(index);
                                });
                              }).catchError((e) {
                                setState(() {
                                  task.close = false;
                                });
                                showDialog(
                                  context: (context),
                                  builder: (contextotllp) => AlertDialog(
                                    content: Text(
                                      "${e.response.data['en']}",
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                                );
                              });
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: Text('No'),
                            onPressed: () {
                              Navigator.of(context).pop();
                              task.close = false;
                              setState(() {});
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
        ),
      ),
    );
  }

  Widget buildChoosePhaes({required PhasesModel phase, required int index}) {
    return Column(
      children: [
        TextButton(
          onPressed: () {
            phaseId = phase.phase_id;
            projectId = null;
            if (permit_type == 'myTasks') {
              getMyTasks();
            }
            if (permit_type == 'allTasks') {
              getAllTasks();
            }
            Navigator.pop(context);
          },
          child: Text(
            "${phase.phaseName}",
            style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget buildProjects({required ProjectsModel pr, required int index}) {
    return Column(
      children: [
        TextButton(
          onPressed: () {
            projectId = pr.id;
            phaseId = null;
            if (permit_type == 'myTasks') {
              getMyTasks();
            }
            if (permit_type == 'allTasks') {
              getAllTasks();
            }
            Navigator.pop(context);
          },
          child: Text(
            "${pr.name}",
            style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
