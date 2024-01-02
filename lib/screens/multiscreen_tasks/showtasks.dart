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
import 'package:hr/screens/switchpermitandvacan.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:rive/rive.dart';

import '../../calender.dart';
import '../../network/local/cache_helper.dart';
import '../../network/remote/dio_helper.dart';
import '../attendance.dart';
import '../holiday_permission.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ShowTasks extends StatefulWidget {
  int projectId;
  int organization_id;

  ShowTasks({
    required this.projectId,
    required this.organization_id

  });
  @override
  State<ShowTasks> createState() => _ShowTasksState();
}

class _ShowTasksState extends State<ShowTasks> {
 bool showLoading =false;
 late TasksList task_list;
 late PhaseList phase_list;
 bool phaseLoading = false;


 getPhases() {
   phaseLoading = true;
   DioHelper.getData(
     url: "api/organizations/${widget.organization_id}/phases/?project_id=${widget.projectId}",
   ).then((response) {
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



  @override
  void initState() {
  //  getTasks();
    getPhases();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 100),
                      child: Text("${AppLocalizations.of(context)!.choosePhase}",
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ),

                    phaseLoading==false?Column(
                      children: [
                        phase_list.phaseList!.isNotEmpty ?
                        SizedBox(
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const ScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            itemBuilder:
                                (BuildContext context, int index) =>
                                buildTasks(
                                    task: phase_list.phaseList![index],
                                    index: index, ),
                            itemCount: phase_list.phaseList!.length,
                          ),
                        ):Padding(
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
    );

  }
 Widget buildTasks({required PhasesModel task, required int index,}) {

   return GestureDetector(
     onTap: (){
       Navigator.push(
           context,
           MaterialPageRoute(builder: (context) =>  CloseTasks(
             projectId: widget.projectId,
             organization_id: widget.organization_id,
             phase_id: task.phase_id,

           )));     },
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
               '${task.phaseName}',
               style: const TextStyle(
                 fontSize: 30,
                 fontWeight: FontWeight.bold,
                 color: Colors.white,
               ),
             ),
           ),

         ],
       ),


     ),
   );

 }


}
