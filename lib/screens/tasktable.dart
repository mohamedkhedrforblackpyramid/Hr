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
  int?phaseId;
  int?projectId;
  late ProjectsList projects;
  bool projectLoading = false;
  getMyTasks() async {
    showLoading = true;
    Map<String, dynamic> query = {};
    if(widget.organizationId !=null){
      query['organization_id']=widget.organizationId;
    }
    if(widget.userId !=null){
      query['user_id']=widget.userId;
    }
    if(phaseId !=null){
      query['phase_id'] = phaseId;
    }
    if(projectId !=null){
      query['project_id'] = projectId;
    }
    await DioHelper.getData(
      url:
          "api/current-tasks",query: query

    ).then((response) {
      task_list = TasksList.fromJson(response.data);
      print("hhhhhhhhhhhhhhhhhhhhhhhhhhh");
      print(response.data);
      print("hhhhhhhhhhhhhhhhhhhhhhhhhhh");

      setState(() {
        showLoading = false;
      });
    }).catchError((error) {
      print('kkkkkkkkkkkkkkkkkk');
      print(error.response.data);
    });
  }

  getAllTasks() async {
    showLoading = true;
    Map<String, dynamic> query = {};
    if(widget.organizationId !=null){
      query['organization_id']=widget.organizationId;
    }
    if(phaseId !=null){
      query['phase_id'] = phaseId;
    }
    if(projectId !=null){
      query['project_id'] = projectId;
    }
    await DioHelper.getData(
      url: "api/current-tasks",query: query

    ).then((response) {
      task_list = TasksList.fromJson(response.data);
      print("hhhhhhhhhhhhhhhhhhhhhhhhhhh");
      print(response.data);
     // print(response.data[0]['assignees']);
      print("hhhhhhhhhhhhhhhhhhhhhhhhhhh");

      setState(() {
        showLoading = false;
      });
    }).catchError((error) {
      print('kkkkkkkkkkkkkkkkkk');
      print(error.response.data);
    });
  }
  getPhases() {
    DioHelper.getData(url: "api/phases", query: {
      'organization_id': widget.organizationId,
    }).then((response) {
      phase_list = PhaseList.fromJson(response.data);

      print(response.data);
      setState(() {});
    }).catchError((error) {
      print('hhhhhhhhhhhhhhhh');
      print(error.response.data);
    });
  }

  getProjects() async {
    projectLoading = true;
    await DioHelper.getData(
        url: "api/projects",
        query: {'organization_id': widget.organizationId}).then((response) {
      // print(response.data);
      projects = ProjectsList.fromJson(response.data);
      //  print(projects);
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
        // backgroundColor: const Color(0xff1A6293),
        body: SafeArea(
      child: Stack(
        children: [
          Positioned(
              width: MediaQuery.of(context).size.width * 1.7,
              bottom: 200,
              left: 100,
              child: Image.asset('assets/Backgrounds/Spline.png')),
          Positioned.fill(
              child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 10),
          )),
          const RiveAnimation.asset('assets/RiveAssets/shapes.riv'),
          Positioned.fill(
              child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 10),
            child: const SizedBox(),
          )),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child:  Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: RadioListTile(
                                      title: const Text(
                                        "My Tasks",
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      tileColor: Colors.teal,
                                      value: '0',
                                      groupValue: valueClosed,
                                      onChanged: (value) {
                                        getMyTasks();
                                        setState(() {});
                                        permit_type = 'myTasks';
                                        isOpen = false;
                                        valueClosed = value.toString();
                                        setState(() {
                                          valueClosed = value.toString();
                                        });
                                      },
                                      fillColor: MaterialStateProperty.all(
                                          Colors.white),
                                    ),
                                  ),
                                  Expanded(
                                    child: RadioListTile(
                                        fillColor: MaterialStateProperty.all(
                                            Colors.white),
                                        title: const Text(
                                          "All Tasks",
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        tileColor: Colors.redAccent,
                                        value: '1',
                                        groupValue: valueClosed,
                                        onChanged: (value) {
                                          getAllTasks();
                                          setState(() {});
                                          permit_type = 'allTasks';
                                          isOpen = false;
                                          valueClosed = value.toString();
                                          setState(() {
                                            valueClosed = value.toString();
                                          });
                                        }),
                                  )
                                ],
                              ),
                              Container(
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: Colors.transparent,
                                ),
                                padding: EdgeInsets.all(20.0),
                                child: Table(
                                  border: TableBorder.all(
                                      color: Colors.transparent),
                                  children: [
                                    TableRow(children: [
                                      Center(
                                          child: Text(
                                        'Tasks',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.indigo,
                                        ),
                                      )),
                                      GestureDetector(
                                        onTap: (){
                                           showModalBottomSheet<void>(
                                            context: context,
                                            backgroundColor: Color(0xffFAACB4),
                                            builder: (BuildContext context) {
                                              return Padding(
                                                padding: const EdgeInsets.all(20.0),
                                                child: ListView.builder(
                                                  shrinkWrap: true,
                                                  itemBuilder: (BuildContext context,
                                                      int index) =>
                                                      buildChoosePhaes(
                                                          phase: phase_list.phaseList![index],
                                                          index: index),
                                                  itemCount: phase_list.phaseList!.length,
                                                ),
                                              );
                                            },
                                          );

                                        },
                                        child: Center(
                                            child: Text(
                                          'Phase',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.indigo,
                                          ),
                                        )),
                                      ),
                                      GestureDetector(
                                        onTap: (){
                                          showModalBottomSheet<void>(
                                            context: context,
                                            backgroundColor: Color(0xffFAACB4),
                                            builder: (BuildContext context) {
                                              return Padding(
                                                padding: const EdgeInsets.all(20.0),
                                                child: ListView.builder(
                                                  shrinkWrap: true,
                                                  itemBuilder: (BuildContext context,
                                                      int index) =>
                                                      buildProjects(
                                                          pr: projects.projectList![index],
                                                          index: index),
                                                  itemCount: projects.projectList!.length,
                                                ),
                                              );
                                            },
                                          );

                                        },
                                        child: Center(
                                            child: Text(
                                          'Project',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.indigo,
                                          ),
                                        )),
                                      ),
                                      Center(
                                          child: Text(
                                        'Done',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.indigo,
                                        ),
                                      )),
                                    ]),
                                    /////////////////
                                  ],
                                ),
                              ),
                              showLoading == false
                                  ? task_list.tasksList!.isNotEmpty
                                  ?SizedBox(
                                child: ListView.separated(
                                  shrinkWrap: true,
                                  physics: const ScrollPhysics(),
                                  scrollDirection: Axis.vertical,
                                  itemBuilder:
                                      (BuildContext context, int index) =>
                                          buildTaskTabl(
                                    task: task_list.tasksList![index],
                                    index: index,
                                  ),
                                  itemCount: task_list.tasksList!.length,
                                  separatorBuilder:
                                      (BuildContext context, int index) =>
                                          SizedBox(
                                    height: 10,
                                  ),
                                ),
                              ) : Padding(
                                padding: EdgeInsets.symmetric(vertical: 300),
                                child: Center(
                                  child: Text(
                                    "${AppLocalizations.of(context)!.noTask}",
                                    style: TextStyle(
                                        fontSize: 20, fontWeight: FontWeight.bold),
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
                          )

              ),
            ),
          )
        ],
      ),
    ));
  }

  Widget buildTaskTabl({
    required TasksModel task,
    required int index,
  }) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
                backgroundColor: Color(0xff93D0FC),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Task : ',
                          style: TextStyle(
                              color: Colors.indigo,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                        Expanded(child: Text('${task.task_name}')),
                      ],
                    ),
                    Text('_________________________________'),
                    Row(
                      children: [
                        Text(
                          'Phase : ',
                          style: TextStyle(
                              color: Colors.indigo,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                        Expanded(child: Text('${task.phase_name}')),
                      ],
                    ),
                    Text('_________________________________'),
                    Row(
                      children: [
                        Text(
                          'Project : ',
                          style: TextStyle(
                              color: Colors.indigo,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                        Text('${task.project_name}'),
                      ],
                    ),
                    Text('_________________________________'),
                  ],
                ));
          },
        );
      },
      child: Table(
        border: TableBorder.all(
          color: Colors.black45,
        ),
        children: [
          TableRow(decoration: BoxDecoration(
            color:
            task.assignees_names!.contains(CacheHelper.getData(key: 'name'))?
            Color(0xff117F83):Color(0xffd14847)
          ),
              children: [
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: Text(
                '${task.task_name}',
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 17),
              ),
            ),
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: Text(
                '${task.phase_name}',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 17),

              ),
            ),
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: Text(
                '${task.project_name}',
                textAlign: TextAlign.center,
              ),
            ),
            task.assignees_names!.contains(CacheHelper.getData(key: 'name'))?Checkbox(
              checkColor: Colors.indigo,
              fillColor: MaterialStateProperty.all(Colors.white),
              value: task.close,
              onChanged: (value) {
                if (task.close = value!) {
                  showDialog(
                    context: (context),
                    builder: (contextop) => AlertDialog(
                      content: Text(
                        "${AppLocalizations.of(context)!.finishTask}",
                        style: TextStyle(fontSize: 20),
                      ),
                      actions: [
                        TextButton(
                          child: Text("${AppLocalizations.of(context)!.yes}"),
                          onPressed: () {
                            DioHelper.patchData(
                                url: "api/tasks/${task.task_id}",
                                data: {
                                  "status": "COMPLETED",
                                }).then((v) {
                              print("goooooooooooooooooood");
                              setState(() {
                                task_list.tasksList!.removeAt(index);
                              });
                            }).catchError((e) {
                              print(e);
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

                              // print('errrrrrrrrr');
                            });

                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: Text("${AppLocalizations.of(context)!.no}"),
                          onPressed: () {
                            Navigator.of(context).pop();
                            task.close = false;
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                  );
                  setState(() {});
                }
              },
            ):SizedBox(),
          ]),
          /////////////////
        ],
      ),
    );
  }
  Widget buildChoosePhaes({required PhasesModel phase, required int index}) {
    return Column(
      children: [
        TextButton(
          onPressed: () {
            //phaseController.text = phase.phaseName!;
            phaseId = phase.phase_id;
            projectId=null;
            if(permit_type == 'myTasks') {
              getMyTasks();
            }
            if(permit_type == 'allTasks'){
              getAllTasks();
            }
           // print(phaseID);
            Navigator.pop(context);
          },
          child: Text(
            "${phase.phaseName}",
            style: TextStyle(
                color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
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
            //phaseController.text = phase.phaseName!;
            projectId = pr.id;
            phaseId = null;
            print(projectId);
            if(permit_type == 'myTasks') {
              getMyTasks();
            }
            if(permit_type == 'allTasks'){
              getAllTasks();
            }
            // print(phaseID);
            Navigator.pop(context);
          },
          child: Text(
            "${pr.name}",
            style: TextStyle(
                color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }



}
