import 'dart:ui';

import 'package:another_flushbar/flushbar.dart';
import 'package:fancy_containers/fancy_containers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hr/modules/chooseusers.dart';
import 'package:hr/modules/organizationmodel.dart';
import 'package:hr/modules/phases.dart';
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

class AddTasks extends StatefulWidget {
  int projectId;
  int organization_id;

  AddTasks({
    required this.projectId,
    required this.organization_id

  });
  @override
  State<AddTasks> createState() => _AddTasksState();
}

class _AddTasksState extends State<AddTasks> {
  int currentIndex = 0;
  var taskName = TextEditingController();
  var taskdesc = TextEditingController();
  var phaseController = TextEditingController();
  bool clickAdd = false;
  late ChooseUserList chooseList;
  late PhaseList phase_list;
  List<int>users=[];
  var dateController = TextEditingController();
  int? phaseID;

  getUsers() {
    DioHelper.getData(
      url: "api/organizations/${widget.organization_id}/employees",
    ).then((response) {
      chooseList = ChooseUserList.fromJson(response.data['data']);
      setState(() {
      });
    }).catchError((error) {
      print('hhhhhhhhhhhhhhhh');
      print(error);
    });
  }
  getPhases() {
    DioHelper.getData(
      url: "api/organizations/${widget.organization_id}/phases/?project_id=${widget.projectId}",
    ).then((response) {
      phase_list = PhaseList.fromJson(response.data);

      print(response.data);
      setState(() {
      });
    }).catchError((error) {
      print('hhhhhhhhhhhhhhhh');
      print(error.response.data);
    });
  }


  @override
  void initState() {
    getUsers();
    getPhases();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Text("Add Task",
                style: TextStyle(color: Colors.white70,
                    fontSize: 30,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: Theme(
                data: Theme.of(context)
                    .copyWith(splashColor: Colors.transparent),
                child: TextField(
                  controller: taskName,
                  autofocus: false,
                  style: TextStyle(
                      fontSize: 22.0, color: Color(0xFFbdc6cf)),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color(0xFCED3FF),
                    label: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        'Task Name',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                    contentPadding: const EdgeInsets.only(
                        left: 14.0, bottom: 8.0, top: 8.0,right: 14),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(25.7),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(25.7),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: Theme(
                data: Theme.of(context)
                    .copyWith(splashColor: Colors.transparent),
                child: TextField(
                  controller: taskdesc,
                  autofocus: false,
                  style: TextStyle(
                      fontSize: 22.0, color: Color(0xFFbdc6cf)),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color(0xFCED3FF),
                    label: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        'Task Description',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                    contentPadding: const EdgeInsets.only(
                        left: 14.0, bottom: 8.0, top: 8.0,right: 14),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(25.7),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(25.7),
                    ),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: (){
               chooseList.chooseuserList!.isNotEmpty?showModalBottomSheet<void>(
                  context: context,
                  backgroundColor: Color(0xffFAACB4),
                  builder: (BuildContext context) {
                    return Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemBuilder:
                            (BuildContext context, int index) =>
                            buildChooseUsers(
                                user: chooseList.chooseuserList![index],
                                index: index),
                        itemCount:  chooseList.chooseuserList!.length,
                      ),
                    );

                  },
                ).whenComplete(() {
                  setState(() {

                  });
                }):Flushbar(
                message: "No Employee is Found",
                icon: Icon(
                Icons.info_outline,
                size: 30.0,
                color: Colors.black,
                ),
                duration: Duration(seconds: 3),
                leftBarIndicatorColor: Colors
                    .blue[300],
                backgroundColor: Colors.red,

                )
                    .show(context);
              },
              child: Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: Theme(
                  data: Theme.of(context)
                      .copyWith(splashColor: Colors.transparent),
                  child: TextField(
                    enabled: false,
                    autofocus: false,
                    style: TextStyle(
                        fontSize: 22.0, color: Color(0xFFbdc6cf)),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color(0xFCED3FF),
                      label: Padding(
                        padding: const EdgeInsets.all(10),
                        child: users.isEmpty?Text(
                          'Add this task to ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ):Text(
                          'You Selected ${users.length} Employee',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green),
                        ),
                      ),
                      contentPadding: const EdgeInsets.only(
                          left: 14.0, bottom: 8.0, top: 8.0,right: 14),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(25.7),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(25.7),
                      ),
                    ),
                  ),
                ),
              ),

            ),
            GestureDetector(
              onTap: (){
                phase_list.phaseList!.isNotEmpty?showModalBottomSheet<void>(
                  context: context,
                  backgroundColor: Color(0xffFAACB4),
                  builder: (BuildContext context) {
                    return Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemBuilder:
                            (BuildContext context, int index) =>
                            buildChoosePhaes(
                                phase: phase_list.phaseList![index],
                                index: index),
                        itemCount:   phase_list.phaseList!.length,
                      ),
                    );
                  },
                ):Flushbar(
                  message: "No Phase is Found",
                  icon: Icon(
                    Icons.info_outline,
                    size: 30.0,
                    color: Colors.black,
                  ),
                  duration: Duration(seconds: 3),
                  leftBarIndicatorColor: Colors
                      .blue[300],
                  backgroundColor: Colors.red,

                )
                    .show(context);
              },
              child: Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: Theme(
                  data: Theme.of(context)
                      .copyWith(splashColor: Colors.transparent),
                  child: TextField(
                    controller: phaseController,
                    enabled: false,
                    autofocus: false,
                    style: TextStyle(
                        fontSize: 22.0, color: Color(0xFFbdc6cf)),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color(0xFCED3FF),
                      label: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          'Choose Phase ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                      contentPadding: const EdgeInsets.only(
                          left: 14.0, bottom: 8.0, top: 8.0,right: 14),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(25.7),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(25.7),
                      ),
                    ),
                  ),
                ),
              ),

            ),
            Padding(
              padding: const EdgeInsets.only(
                  bottom: 40),
              child: Theme(
                data: Theme.of(context).copyWith(
                    splashColor:
                    Colors.transparent),
                child: GestureDetector(
                  onTap: (){
                    setState(() {
                      showDialog(
                        context: context,
                        builder:
                            (BuildContext context) {
                          return AlertDialog(
                            //  backgroundColor: Color(0xff93D0FC),
                            content: Container(
                              width: 500,
                              height: 450,
                              child: Calender(
                                  onSubmit: (data) {
                                    print("Heeeeeeloooooo");
                                    print(data);
                                    print("Heeeeeeloooooo");
                                    dateController.text =
                                        data;
                                    setState(() {});
                                  }),
                            ),
                          );
                        },
                      );
                    });
                  },
                  child: TextFormField(
                    validator: (value) {},
                    enabled: false,
                    controller: dateController,
                    autofocus: false,
                    style: TextStyle(
                        fontSize: 22.0,
                        color: Color(0xFFbdc6cf)),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color(0xFCED3FF),
                      label: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          'Due Date',
                          style: TextStyle(
                              fontWeight:
                              FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                      contentPadding:
                      const EdgeInsets.only(
                          left: 14.0,
                          bottom: 8.0,
                          top: 8.0),
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
                        borderSide: BorderSide(
                            color: Colors.white),
                        borderRadius:
                        BorderRadius.circular(
                            25.7),
                      ),
                    ),
                  ),
                ),
              ),
            ),


            clickAdd==false? Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: Center(
                child:  Container(
                  height: 50,
                  width: 200,
                  child: FancyContainer(
                    textColor: Colors.white,
                    title: 'Add',
                    color1: Colors.purple,
                    color2: Colors.lightBlue,
                    onTap: () async {
                      setState(() {
                      });
                      clickAdd = true;
                      await DioHelper.postData(
                        url: "api/organizations/${widget.organization_id}/tasks",
                        formData: {
                          "name": "${taskName.text}" ,
                          "description": "${taskdesc.text}" ,
                          "phase_id": phaseID ,
                          "due_date":dateController.text,
                          "assignees":users,
                          "status":"PENDING"

                        },
                      ).then((value) {
                        setState(() {

                        });
                        clickAdd = false;

                        taskName.text='';
                        taskdesc.text='';
                        Flushbar(
                          message: "Added Task Successfully",
                          icon: Icon(
                            Icons.verified_outlined,
                            size: 30.0,
                            color: Colors.green,
                          ),
                          duration: Duration(seconds: 3),
                          leftBarIndicatorColor: Colors
                              .blue[300],
                          backgroundColor: Colors.green,
                        )
                          ..show(context);
                      }).catchError((error){
                        setState(() {

                        });
                        clickAdd=false;
                        if(taskName.text.isEmpty) {
                          Flushbar(
                            message: "Task name is empty !",
                            icon: Icon(
                              Icons.info_outline,
                              size: 30.0,
                              color: Colors.black,
                            ),
                            duration: Duration(seconds: 3),
                            leftBarIndicatorColor: Colors
                                .blue[300],
                            backgroundColor: Colors.red,

                          )
                            ..show(context);
                        }
                        else if(taskdesc.text.isEmpty){
                          Flushbar(
                            message: "Task Description is empty !",
                            icon: Icon(
                              Icons.info_outline,
                              size: 30.0,
                              color: Colors.blue[300],
                            ),
                            duration: Duration(seconds: 3),
                            leftBarIndicatorColor: Colors
                                .blue[300],
                            backgroundColor: Colors.red,
                          )
                            ..show(context);

                        }
                        else if(users.isEmpty){
                          Flushbar(
                            message: "You Must Choose employee",
                            icon: Icon(
                              Icons.info_outline,
                              size: 30.0,
                              color: Colors.blue[300],
                            ),
                            duration: Duration(seconds: 3),
                            leftBarIndicatorColor: Colors
                                .blue[300],
                            backgroundColor: Colors.red,
                          )
                            ..show(context);

                        }
                        else if(phaseController.text.isEmpty){
                          Flushbar(
                            message: "You Must Choose Phase",
                            icon: Icon(
                              Icons.info_outline,
                              size: 30.0,
                              color: Colors.blue[300],
                            ),
                            duration: Duration(seconds: 3),
                            leftBarIndicatorColor: Colors
                                .blue[300],
                            backgroundColor: Colors.red,
                          )
                            ..show(context);

                        }
                        else if(dateController.text.isEmpty){
                          Flushbar(
                            message: "Date is empty !",
                            icon: Icon(
                              Icons.info_outline,
                              size: 30.0,
                              color: Colors.blue[300],
                            ),
                            duration: Duration(seconds: 3),
                            leftBarIndicatorColor: Colors
                                .blue[300],
                            backgroundColor: Colors.red,
                          )
                            ..show(context);

                        }


                        else{
                          Flushbar(
                            message: "Sorry! try again later",
                            icon: Icon(
                              Icons.info_outline,
                              size: 30.0,
                              color: Colors.blue[300],
                            ),
                            duration: Duration(seconds: 3),
                            leftBarIndicatorColor: Colors
                                .blue[300],
                          )
                            ..show(context);
                        }
                        print(error.response.data);
                      });
                    },
                  ),
                ),
              ),
            ):Center(
              child: CircularProgressIndicator(
                color: Colors.indigo,
              ),
            ),


          ],
        ),
      ),
    );

  }
  Widget buildChooseUsers({required ChooseUserModel user,required int index}){
    return StatefulBuilder(
      builder: (BuildContext context, void Function(void Function()) setState) {
      return Row(
        children: [
          Expanded(
            child: Text(
              "${user.name}",
              style: TextStyle(
                  color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Checkbox(
              checkColor: Colors.white,
              value: users.contains(user.userId),
              onChanged: (bool? value) {
                  user.isChecked = value!;
                  if(user.isChecked==true) {
                    setState(() {
                      users.add(user.userId!);
                    },);
                  }
                  else{
                    setState(() {
                      users.remove(user.userId!);
                    },);
                  }
                print(users);

              },
            ),
          ),
        ],
      );}
    );
  }
  Widget buildChoosePhaes({required PhasesModel phase,required int index}){
    return Column(
      children: [
        TextButton(
          onPressed: (){
            phaseController.text = phase.phaseName!;
            phaseID = phase.phase_id;
            print(phaseID);
            Navigator.pop(context);
          },
          child: Text(
            "${phase.phaseName}",
            style: TextStyle(
                color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

}
