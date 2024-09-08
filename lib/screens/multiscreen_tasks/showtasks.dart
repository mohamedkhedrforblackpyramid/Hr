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
import 'package:hr/screens/multiscreen_tasks/closeandshow_task.dart';
import 'package:hr/screens/projects.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:rive/rive.dart';

import '../../calender.dart';
import '../../network/local/cache_helper.dart';
import '../../network/remote/dio_helper.dart';
import '../attendance.dart';
import '../vacancespermissions.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'multiscreenfortasks.dart';

class ShowTasks extends StatefulWidget {
  int projectId;
  int organization_id;
  int? userId;
  late OrganizationsList oranizaionsList;
  String? organizationsName;
  String? organizationsArabicName;
  int? phaseId;
  String? phaseName;

  ShowTasks(
      {required this.projectId,
      required this.organization_id,
      required this.userId,
      required this.organizationsArabicName,
      required this.organizationsName,
      required this.oranizaionsList,
      required this.phaseId,
      required this.phaseName});
  @override
  State<ShowTasks> createState() => _ShowTasksState();
}

class _ShowTasksState extends State<ShowTasks> {
  bool showLoading = false;
  late TasksList task_list;
  late PhaseList phase_list;
  bool phaseLoading = false;
  var taskName = TextEditingController();
  var phaseDescription = TextEditingController();
  bool clickAdd = false;

  getPhases() {
    phaseLoading = true;
    DioHelper.getData(url: "api/phases/", query: {
      'organization_id': widget.organization_id,
      'project_id': widget.projectId
    }).then((response) {
      phase_list = PhaseList.fromJson(response.data);

      print(response.data);
      setState(() {
        phaseLoading = false;
      });
    }).catchError((error) {
      print('hhhhhhhhhhhhhhhh');
      print(error.response.data);
    });
  }

  returnPage() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Projects(
                  userId: widget.userId,
                  organizationId: widget.organization_id,
                  organizationsName: widget.organizationsName,
                  oranizaionsList: widget.oranizaionsList,
                  organizationsArabicName: widget.organizationsArabicName,
                )));
  }

  @override
  void initState() {
    //  getTasks();
    getPhases();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return returnPage();
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "${AppLocalizations.of(context)!.choosePhase}",
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white70),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  CircleAvatar(
                    child: IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MultiScreenForTasks(
                                        projectId: widget.projectId,
                                        organization_id: widget.organization_id,
                                        currentIndex: 1,
                                        organizationsName:
                                            widget.organizationsName,
                                        userId: widget.userId,
                                        oranizaionsList: widget.oranizaionsList,
                                        organizationsArabicName:
                                            widget.organizationsArabicName,
                                        phaseName: '',
                                        phaseId: widget.phaseId,
                                    projectName: '',
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
              phaseLoading == false
                  ? Column(
                      children: [
                        phase_list.phaseList!.isNotEmpty
                            ? SizedBox(
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: const ScrollPhysics(),
                                  scrollDirection: Axis.vertical,
                                  itemBuilder:
                                      (BuildContext context, int index) =>
                                          buildTasks(
                                    task: phase_list.phaseList![index],
                                    index: index,
                                  ),
                                  itemCount: phase_list.phaseList!.length,
                                ),
                              )
                            : Padding(
                                padding: EdgeInsets.symmetric(vertical: 300),
                                child: Center(
                                  child: Text(
                                    "${AppLocalizations.of(context)!.noPhase}",
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
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTasks({
    required PhasesModel task,
    required int index,
  }) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CloseTasks(
                          projectId: widget.projectId,
                          organization_id: widget.organization_id,
                          phase_id: task.phase_id,
                          organizationsName: widget.organizationsName,
                          userId: widget.userId,
                          oranizaionsList: widget.oranizaionsList,
                          organizationsArabicName:
                              widget.organizationsArabicName,
                          phaseName: task.phaseName,
                        )));
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF0E3311).withOpacity(0.5),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Center(
                  child: Text(
                    textAlign: TextAlign.center,
                    '${task.phaseName}',
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                Center(
                  child: task.phaseDesc!=null?Text(
                    textAlign: TextAlign.center,
                    '${task.phaseDesc}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ):SizedBox(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                        onPressed: () {
                          taskName.text = task.phaseName!;
                          if(task.phaseDesc ==null){
                            phaseDescription.text='';
                          }else{
                            phaseDescription.text = task.phaseDesc!;

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
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(15.0),
                                            child: Text(
                                              "Edit Phase Name",
                                              style: TextStyle(
                                                  fontSize: 30,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 20),
                                            child: Container(
                                              width: 300,
                                              child: TextFormField(
                                                controller: taskName,
                                                decoration: new InputDecoration(
                                                  labelText: "Phase Name",
                                                  fillColor: Colors.white,
                                                  border:
                                                      new OutlineInputBorder(
                                                    borderRadius:
                                                        new BorderRadius
                                                            .circular(25.0),
                                                    borderSide:
                                                        new BorderSide(),
                                                  ),
                                                  //fillColor: Colors.green
                                                ),
                                                keyboardType:
                                                    TextInputType.emailAddress,
                                                style: new TextStyle(
                                                  fontFamily: "Poppins",
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Container(
                                            width: 300,
                                            child: TextFormField(
                                              controller: phaseDescription,
                                              decoration: new InputDecoration(
                                                labelText:
                                                    "Phase Description",
                                                fillColor: Colors.white,
                                                border: new OutlineInputBorder(
                                                  borderRadius:
                                                      new BorderRadius.circular(
                                                          25.0),
                                                  borderSide: new BorderSide(),
                                                ),
                                                //fillColor: Colors.green
                                              ),
                                              keyboardType:
                                                  TextInputType.emailAddress,
                                              style: new TextStyle(
                                                fontFamily: "Poppins",
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Center(
                                            child: Container(
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
                                                              "api/phases/${task.phase_id}",
                                                          data: {
                                                            "name":
                                                                "${taskName.text}",
                                                            "description":
                                                                phaseDescription
                                                                    .text
                                                          },
                                                        ).then((value) {
                                                          print(taskName.text);
                                                          print(phaseDescription
                                                              .text);
                                                          print(value.data);
                                                          print(
                                                              "Tmaaaaaaaaaaaaaaaaaaaaaaaaam");
                                                          setState(() {});
                                                          clickAdd = false;
                                                          getPhases();

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
                                                              message:
                                                                  "${AppLocalizations.of(context)!.projectNameisEmpty}",
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
                                                            )..show(context);
                                                          } else if (phaseDescription
                                                              .text.isEmpty) {
                                                            Flushbar(
                                                              message:
                                                                  "${AppLocalizations.of(context)!.projectDescisEmpty}",
                                                              backgroundColor:
                                                                  Colors.red,
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
                                                            )..show(context);
                                                          } else {
                                                            Flushbar(
                                                              message:
                                                                  "${AppLocalizations.of(context)!.project_error}",
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
                                                            )..show(context);
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
                                  'Delete this phase ?',
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
                                            '${AppLocalizations.of(context)!.yes}'),
                                        onPressed: () async {
                                          setState(() {});
                                          await DioHelper.deleteData(
                                            url: "api/phases/${task.phase_id}",
                                          ).then((value) {
                                            Navigator.pop(context);
                                            setState(() {
                                              phase_list.phaseList
                                                  ?.removeAt(index);
                                            });
                                            print('mbroook');
                                            Flushbar(
                                              messageColor: Colors.black,
                                              backgroundColor: Colors.green,
                                              message: "Phase deleted",
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
                                              backgroundColor: Colors.red,
                                              icon: Icon(
                                                Icons.info_outline,
                                                size: 30.0,
                                                color: Colors.blue[300],
                                              ),
                                              duration: Duration(seconds: 3),
                                              leftBarIndicatorColor:
                                                  Colors.blue[300],
                                            )..show(context);
                                            print(error.response.data);
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
                                            '${AppLocalizations.of(context)!.no}'),
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
        ),
      ],
    );
  }
}
