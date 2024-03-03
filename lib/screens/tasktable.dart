import 'dart:ui';

import 'package:another_flushbar/flushbar.dart';
import 'package:fancy_containers/fancy_containers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hr/modules/projects.dart';
import 'package:hr/screens/multiscreen_tasks/multiscreenfortasks.dart';
import 'package:rive/rive.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../modules/tasks.dart';
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
  String permit_type = 'MY TASKS';

  getTasksActive() async {
    showLoading = true;
    await DioHelper.getData(
      url:
          "api/current-tasks?organization_id=${widget.organizationId}&user_id=${widget.userId}",
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

  getTasksInActive() async {
    showLoading = true;
    await DioHelper.getData(
      url: "api/current-tasks?organization_id=${widget.organizationId}",
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

  @override
  void initState() {
    getTasksActive();
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
                child: showLoading == false
                    ? task_list.tasksList!.isNotEmpty
                        ? Column(
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
                                      tileColor: Colors.redAccent,
                                      value: '0',
                                      groupValue: valueClosed,
                                      onChanged: (value) {
                                        getTasksActive();
                                        setState(() {});
                                        permit_type = 'active';
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
                                        tileColor: Colors.teal,
                                        value: '1',
                                        groupValue: valueClosed,
                                        onChanged: (value) {
                                          getTasksInActive();
                                          setState(() {});

                                          permit_type = 'INACTIVE';
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
                                      Center(
                                          child: Text(
                                        'Phase',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.indigo,
                                        ),
                                      )),
                                      Center(
                                          child: Text(
                                        'Project',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.indigo,
                                        ),
                                      )),
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
                              SizedBox(
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
                              )
                            ],
                          )
                        : Padding(
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
          TableRow(
              children: [
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: Text(
                '${task.task_name}',
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: Text(
                '${task.phase_name}',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: Text(
                '${task.project_name}',
                textAlign: TextAlign.center,
              ),
            ),
            Checkbox(
              checkColor: Colors.indigo,
              fillColor: MaterialStateProperty.all(Colors.transparent),
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
            ),
          ]),
          /////////////////
        ],
      ),
    );
  }
}
