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
 late PhaseList phase_list;

 getProjects() async {
    showLoading = true;
    await DioHelper.getData(
      url: "api/organizations/${widget.organization_id}/tasks",
    ).then((response) {
      print(response.data);
      setState(() {
        showLoading = false;
      });
    }).catchError((error){
      print(error.response.data);
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
          Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView.separated(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder:
                (BuildContext context, int index) =>
                buildChoosePhaes(
                    phase: phase_list.phaseList![index],
                    index: index),
            itemCount:   phase_list.phaseList!.length,
            separatorBuilder:(BuildContext context, int index) =>SizedBox(height: 20) ,
          ),
                )
            ],
          ),
        ),
      ),
    );

  }
 Widget buildChoosePhaes({required PhasesModel phase,required int index}){
   return Column(

     children: [
       Container(
         width: MediaQuery.of(context).size.width,
         height: MediaQuery.of(context).size.height/4,

         decoration: BoxDecoration(
           color: const Color(0xff7c94b6),
           border: Border.all(
             width: 8,
           ),
           borderRadius: BorderRadius.circular(12),
         ),
         child: Text(
           textAlign: TextAlign.center,
             "${phase.phaseName}",
           style: TextStyle(),
         ),
       )
     ],
   );
 }


}
