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
  String?organizationsArabicName;
  String?phaseName;


  CloseTasks({
    required this.projectId,
    required this.organization_id,
    required this.phase_id,
    required this.userId,
    required this.organizationsArabicName,
    required this.organizationsName,
    required this.oranizaionsList,
    required this.phaseName
  });
  @override
  State<CloseTasks> createState() => _CloseTasksState();
}

class _CloseTasksState extends State<CloseTasks> {
  bool showLoading =false;
  late TasksList task_list;

  getTasks() async {
    showLoading = true;
    await DioHelper.getData(
      url: "api/current-tasks?organization_id=${widget.organization_id}&phase_id=${widget.phase_id}",
    ).then((response) {
      task_list = TasksList.fromJson(response.data);
      print(response.data);
      setState(() {
        showLoading = false;
      });
    }).catchError((error){
      print(error.response.data);
    });

  }
  @override
  void initState() {
    print(widget.phase_id);
    getTasks();
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
                        Text("${AppLocalizations.of(context)!.tasks}",
                          style: TextStyle(
                              fontSize: 40,
                              color: Colors.white,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        SizedBox(width: 20,),
                        CircleAvatar(
                          child: IconButton(onPressed: (){
                          /*  if(widget.phaseName!.isEmpty){
                              widget.phase_id =null;
                            }*/
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) =>  MultiScreenForTasks(
                                  projectId: widget.projectId,
                                  organization_id: widget.organization_id,
                                  currentIndex: 2,
                                  organizationsArabicName: widget.organizationsArabicName,
                                  oranizaionsList: widget.oranizaionsList,
                                  userId: widget.userId,
                                  organizationsName: widget.organizationsName,
                                  phaseName: widget.phaseName,
                                  phaseId: widget.phase_id,

                                )
                                ));
                          }
                              , icon: Icon(Icons.add,color: Colors.white,)),
                          backgroundColor: Colors.black45,
                        )
                      ],
                    ),
                  ),
                  Column(
                      children: [
                        showLoading==false?Column(
                          children: [
                            task_list.tasksList!.isNotEmpty ?
                            SizedBox(
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: const ScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                itemBuilder:
                                    (BuildContext context, int index) =>
                                    buildCloseTasks(
                                      task: task_list.tasksList![index],
                                      index: index, ),
                                itemCount: task_list.tasksList!.length,
                              ),
                            ):  Padding(
                              padding: EdgeInsets.symmetric(vertical: 300),
                              child: Center(
                                child: Text(
                                  "${AppLocalizations.of(context)!.noTask}",
                                  style: TextStyle(
                                      fontSize: 20, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ):const Padding(
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
  Widget buildCloseTasks({required TasksModel task, required int index, }) {

    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF0E3311).withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
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
                      '${AppLocalizations.of(context)!.startTask}',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      '${task.fromDate}',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      '${AppLocalizations.of(context)!.endDay}',
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
                      content:  Text(
                        "${AppLocalizations.of(context)!.finishTask}",
                        style: TextStyle(fontSize: 20),
                      ),
                      actions: [
                        TextButton(
                          child:  Text("${AppLocalizations.of(context)!.yes}"),
                          onPressed: () {
                            DioHelper.patchData(
                                url: "api/organizations/${widget.organization_id}/tasks/${task.task_id}",
                                formData: {
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
                                builder: (contextotllp) =>  AlertDialog(
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
                          child:  Text("${AppLocalizations.of(context)!.no}"),
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


}
