import 'dart:ui';

import 'package:another_flushbar/flushbar.dart';
import 'package:fancy_containers/fancy_containers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hr/modules/chooseusers.dart';
import 'package:hr/modules/organizationmodel.dart';
import 'package:hr/modules/phases.dart';
import 'package:hr/modules/tasks.dart';
import 'package:hr/screens/excusepermission.dart';
import 'package:hr/screens/projects.dart';
import 'package:hr/screens/switchpermitandvacan.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:rive/rive.dart';

import '../../calender.dart';
import '../../network/local/cache_helper.dart';
import '../../network/remote/dio_helper.dart';
import '../attendance.dart';
import '../holiday_permission.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'multiscreenfortasks.dart';

class CloseTasks extends StatefulWidget {
  int projectId;
  int organization_id;
  int? phase_id;
  int? userId;
  late OrganizationsList oranizaionsList;
  String? organizationsName;
  String? organizationsArabicName;
  String? phaseName;



  CloseTasks(
      {required this.projectId,
      required this.organization_id,
      required this.phase_id,
      required this.userId,
      required this.organizationsArabicName,
      required this.organizationsName,
      required this.oranizaionsList,
      required this.phaseName});
  @override
  State<CloseTasks> createState() => _CloseTasksState();
}

class _CloseTasksState extends State<CloseTasks> {
  late ChooseUserList chooseList;
  List<int?> users = [];
  bool showLoading = false;
  late TasksList task_list;
  var taskName = TextEditingController();
  var taskDescription = TextEditingController();
  bool clickAdd = false;

  getTasks() async {
    showLoading = true;
    await DioHelper.getData(
      url:
          "api/current-tasks?organization_id=${widget.organization_id}&phase_id=${widget.phase_id}",
    ).then((response) {
      task_list = TasksList.fromJson(response.data);
      print(response.data);
      setState(() {
        showLoading = false;
      });
    }).catchError((error) {
      print(error.response.data);
    });
  }
  getUsers() {
    DioHelper.getData(
      url: "api/organizations/${widget.organization_id}/employees",
    ).then((response) {
      chooseList = ChooseUserList.fromJson(response.data['data']);
      print(response.data);
      setState(() {});
    }).catchError((error) {
      print('hhhhhhhhhhhhhhhh');
      print(error);
    });
  }
  @override
  void initState() {
    print(widget.phase_id);
    getTasks();
    getUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff1A6293),
      body: Stack(
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
          Container(
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.tasks,
                          style: TextStyle(
                              fontSize: 40,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        CircleAvatar(
                          child: IconButton(
                              onPressed: () {
                                /*  if(widget.phaseName!.isEmpty){
                              widget.phase_id =null;
                            }*/
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            MultiScreenForTasks(
                                              projectId: widget.projectId,
                                              organization_id:
                                                  widget.organization_id,
                                              currentIndex: 2,
                                              organizationsArabicName: widget
                                                  .organizationsArabicName,
                                              oranizaionsList:
                                                  widget.oranizaionsList,
                                              userId: widget.userId,
                                              organizationsName:
                                                  widget.organizationsName,
                                              phaseName: widget.phaseName,
                                              phaseId: widget.phase_id,
                                            )));
                              },
                              icon: Icon(
                                Icons.add,
                                color: Colors.white,
                              )),
                          backgroundColor: Colors.black45,
                        )
                      ],
                    ),
                  ),
                  Column(children: [
                    showLoading == false
                        ? Column(
                            children: [
                              task_list.tasksList!.isNotEmpty
                                  ? SizedBox(
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        physics: const ScrollPhysics(),
                                        scrollDirection: Axis.vertical,
                                        itemBuilder:
                                            (BuildContext context, int index) =>
                                                buildCloseTasks(
                                          task: task_list.tasksList![index],
                                          index: index,
                                        ),
                                        itemCount: task_list.tasksList!.length,
                                      ),
                                    )
                                  : Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 300),
                                      child: Center(
                                        child: Text(
                                          AppLocalizations.of(context)!.noTask,
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                            ],
                          )
                        : const Padding(
                            padding: EdgeInsets.symmetric(vertical: 300),
                            child: Center(
                              child: CircularProgressIndicator(
                                color: Colors.indigo,
                              ),
                            ),
                          ),
                  ]),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCloseTasks({
    required TasksModel task,
    required int index,
  }) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF0E3311).withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              children: [
                Center(
                  child: Text(
                    '${task.task_name}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Text(
                      AppLocalizations.of(context)!.startTask,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      '${task.fromDate}',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      AppLocalizations.of(context)!.endDay,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      '${task.toDate}',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                        onPressed: () {
                          users = task.assignees as List<int>;
                          taskName.text = task.task_name!;
                          if (task.description == null) {
                            taskDescription.text = '';
                          } else {
                            taskDescription.text = task.description!;
                          }
                          showModalBottomSheet<void>(
                            isScrollControlled: true,
                            context: context,
                            builder: (BuildContext context) {
                              return StatefulBuilder(builder:
                                  (BuildContext context, StateSetter setState) {
                                return Padding(
                                  padding: EdgeInsets.only(
                                      top: 20,
                                      right: 20,
                                      left: 20,
                                      bottom: MediaQuery.of(context)
                                          .viewInsets
                                          .bottom),
                                  child: Container(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              2,
                                      width: MediaQuery.of(context).size.width /
                                          1.1,
                                      child: SingleChildScrollView(
                                        child: Column(
                                          children: [
                                            const Padding(
                                              padding: EdgeInsets.all(15.0),
                                              child: Text(
                                                "Edit Task Name",
                                                style: TextStyle(
                                                    fontSize: 30,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 20),
                                              child: SizedBox(
                                                width: 300,
                                                child: TextFormField(
                                                  controller: taskName,
                                                  decoration: InputDecoration(
                                                    labelText: "New Task Name",
                                                    fillColor: Colors.white,
                                                    border:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius
                                                              .circular(25.0),
                                                      borderSide:
                                                           const BorderSide(),
                                                    ),
                                                    //fillColor: Colors.green
                                                  ),
                                                  keyboardType:
                                                      TextInputType.emailAddress,
                                                  style: const TextStyle(
                                                    fontFamily: "Poppins",
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            SizedBox(
                                              width: 300,
                                              child: TextFormField(
                                                controller: taskDescription,
                                                decoration: InputDecoration(
                                                  labelText:
                                                      "Task Description",
                                                  fillColor: Colors.white,
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25.0),
                                                    borderSide: BorderSide(),
                                                  ),
                                                  //fillColor: Colors.green
                                                ),
                                                keyboardType:
                                                    TextInputType.emailAddress,
                                                style: const TextStyle(
                                                  fontFamily: "Poppins",
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                chooseList
                                                    .chooseuserList!.isNotEmpty
                                                    ? showModalBottomSheet<void>(
                                                  context: context,
                                                  backgroundColor:
                                                  Color(0xffFAACB4),
                                                  builder:
                                                      (BuildContext context) {
                                                    return Padding(
                                                      padding:
                                                      const EdgeInsets
                                                          .all(20.0),
                                                      child: ListView.builder(
                                                        shrinkWrap: true,
                                                        itemBuilder: (BuildContext
                                                        context,
                                                            int index) =>
                                                            buildChooseUsers(
                                                                user: chooseList
                                                                    .chooseuserList![
                                                                index],
                                                                index: index),
                                                        itemCount: chooseList
                                                            .chooseuserList!
                                                            .length,
                                                      ),
                                                    );
                                                  },
                                                ).whenComplete(() {
                                                  setState(() {});
                                                })
                                                    : Flushbar(
                                                  message:
                                                  AppLocalizations.of(
                                                      context)!
                                                      .noEmployee,
                                                  icon: Icon(
                                                    Icons.info_outline,
                                                    size: 30.0,
                                                    color: Colors.black,
                                                  ),
                                                  duration:
                                                  Duration(seconds: 3),
                                                  leftBarIndicatorColor:
                                                  Colors.blue[300],
                                                  backgroundColor: Colors.red,
                                                ).show(context);
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 40),
                                                child: Theme(
                                                  data: Theme.of(context).copyWith(
                                                      splashColor:
                                                      Colors.transparent),
                                                  child: TextField(
                                                    enabled: false,
                                                    autofocus: false,
                                                    style: TextStyle(
                                                        fontSize: 22.0,
                                                        color: Color(0xFFbdc6cf)),
                                                    decoration: InputDecoration(
                                                      filled: true,
                                                      fillColor: Color(0xFCED3FF),
                                                      label: Padding(
                                                        padding:
                                                        const EdgeInsets.all(
                                                            10),
                                                        child: users.isEmpty
                                                            ? Text(
                                                          "Add this project to",
                                                          style: TextStyle(
                                                              fontWeight:
                                                              FontWeight
                                                                  .bold,
                                                              color: Colors
                                                                  .black45),
                                                        )
                                                            : Text(
                                                          'You Selected ${users.length} Employee',
                                                          style: const TextStyle(
                                                              fontWeight:
                                                              FontWeight
                                                                  .bold,
                                                              color: Colors
                                                                  .green),
                                                        ),
                                                      ),
                                                      contentPadding:
                                                      const EdgeInsets.only(
                                                          left: 14.0,
                                                          bottom: 8.0,
                                                          top: 8.0,
                                                          right: 14),
                                                      focusedBorder:
                                                      OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Colors.white),
                                                        borderRadius:
                                                        BorderRadius.circular(
                                                            25.7),
                                                      ),
                                                      enabledBorder:
                                                      UnderlineInputBorder(
                                                        borderSide:
                                                        const BorderSide(
                                                            color:
                                                            Colors.white),
                                                        borderRadius:
                                                        BorderRadius.circular(
                                                            25.7),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                        
                                            Center(
                                              child: SizedBox(
                                                height: 50,
                                                width: 200,
                                                child: clickAdd == false
                                                    ? FancyContainer(
                                                        textColor: Colors.white,
                                                        onTap: () async {
                                                          setState(() {
                                                            clickAdd = true;
                                                          });
                                                          await DioHelper
                                                              .patchData(
                                                            url:
                                                                "api/tasks/${task.task_id}",
                                                            data: {
                                                              "name":
                                                                  taskName.text,
                                                              "description":
                                                                  taskDescription
                                                                      .text,
                                                              "assignees": users,

                                                            },
                                                          ).then((value) {
                                                            print(taskName.text);
                                                            print(taskDescription
                                                                .text);
                                                            print(value.data);
                                                            print(
                                                                "Tmaaaaaaaaaaaaaaaaaaaaaaaaam");
                                                            setState(() {});
                                                            clickAdd = false;
                                                            getTasks();
                                        
                                                            Navigator.pop(
                                                                context);
                                                            print(
                                                                "Shaaaaaaaaatr");
                                                          }).catchError((error) {
                                                            clickAdd = false;
                                        
                                                            setState(() {});
                                                            if (taskName
                                                                .text.isEmpty) {
                                                              Flushbar(
                                                                backgroundColor:
                                                                    Colors.red,
                                                                message: AppLocalizations
                                                                        .of(context)!
                                                                    .projectNameisEmpty,
                                                                icon: Icon(
                                                                  Icons
                                                                      .info_outline,
                                                                  size: 30.0,
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                                duration:
                                                                    Duration(
                                                                        seconds:
                                                                            3),
                                                                leftBarIndicatorColor:
                                                                    Colors.blue[
                                                                        300],
                                                              ).show(context);
                                                            }
                                                            else {
                                                              Flushbar(
                                                                message: '${error.response.data['message']}',
                                                                icon: Icon(
                                                                  Icons
                                                                      .info_outline,
                                                                  size: 30.0,
                                                                  color: Colors
                                                                      .blue[300],
                                                                ),
                                                                duration:
                                                                    Duration(
                                                                        seconds:
                                                                            3),
                                                                leftBarIndicatorColor:
                                                                    Colors.blue[
                                                                        300],
                                                              ).show(context);
                                                            }
                                        
                                                            print(error
                                                                .response.data);
                                                          });
                                                        },
                                                        title:
                                                            'Save',
                                                        color1: Colors.purple,
                                                        color2: Colors.lightBlue,
                                                      )
                                                    : Center(
                                                        child:
                                                            CircularProgressIndicator(
                                                          color: Colors.indigo,
                                                        ),
                                                      ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )),
                                );
                              });
                            },
                          );
                        },
                        icon: Icon(
                          Icons.edit,
                          color: Colors.white,
                        )),
                    IconButton(
                        onPressed: () async {
                          showDialog<void>(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                //  title: const Text('Basic dialog title'),
                                content: Text(
                                  'Delete this task ?',
                                ),
                                actions: [
                                  Row(
                                    children: [
                                      TextButton(
                                        style: TextButton.styleFrom(
                                          textStyle: Theme.of(context)
                                              .textTheme
                                              .labelLarge,
                                        ),
                                        child: Text(
                                            AppLocalizations.of(context)!.yes),
                                        onPressed: () async {
                                          setState(() {});
                                          await DioHelper.deleteData(
                                            url: "api/tasks/${task.task_id}",
                                          ).then((value) {
                                            Navigator.pop(context);
                                            setState(() {
                                              task_list
                                                ..tasksList?.removeAt(index);
                                            });
                                            print('mbroook');
                                            Flushbar(
                                              messageColor: Colors.black,
                                              backgroundColor: Colors.green,
                                              message: "Task deleted",
                                              icon: Icon(
                                                Icons.verified,
                                                size: 30.0,
                                                color: Colors.white,
                                              ),
                                              duration: Duration(seconds: 3),
                                              leftBarIndicatorColor:
                                                  Colors.blue[300],
                                            )..show(context);
                                          }).catchError((error) {
                                            Navigator.pop(context);
                                            setState(() {});
                                            Flushbar(
                                              message:
                                                  "${error.response.data['message']}",
                                              icon: Icon(
                                                Icons.info_outline,
                                                size: 30.0,
                                                color: Colors.blue[300],
                                              ),
                                              duration: Duration(seconds: 3),
                                              leftBarIndicatorColor:
                                                  Colors.blue[300],
                                            )..show(context);
                                          });
                                        },
                                      ),
                                      TextButton(
                                        style: TextButton.styleFrom(
                                          textStyle: Theme.of(context)
                                              .textTheme
                                              .labelLarge,
                                        ),
                                        child: Text(
                                            AppLocalizations.of(context)!.no),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                    // crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        icon: Icon(
                          Icons.delete,
                          color: Colors.white,
                        )),
                  ],
                ),
              ],
            ),
          ),
          Checkbox(
            checkColor: Colors.black,
            fillColor: MaterialStateProperty.all(Colors.white),
            value: task.close,
            onChanged: (value) {
              if (task.close = value!) {
                showDialog(
                  context: (context),
                  builder: (contextop) => AlertDialog(
                    content: Text(
                      AppLocalizations.of(context)!.finishTask,
                      style: TextStyle(fontSize: 20),
                    ),
                    actions: [
                      TextButton(
                        child: Text(AppLocalizations.of(context)!.yes),
                        onPressed: () {
                          DioHelper.patchData(
                              url:
                                  "api/tasks/${task.task_id}",
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
                        child: Text(AppLocalizations.of(context)!.no),
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
        ],
      ),
    );
  }
  Widget buildChooseUsers({required ChooseUserModel user, required int index}) {
    return StatefulBuilder(builder:
        (BuildContext context, void Function(void Function()) setState) {
      return Row(
        children: [
          Expanded(
            child: Text(
              "${user.name}",
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Checkbox(
              checkColor: Colors.white,
              value: users.contains(user.userId),
              onChanged: (bool? value) {
                if (!users.contains(user.userId)) {
                  setState(
                        () {
                      users.add(user.userId);
                    },
                  );
                } else {
                  setState(
                        () {
                      users.remove(user.userId);
                    },
                  );
                }
                print(users);
              },
            ),
          ),
        ],
      );
    });
  }

}
