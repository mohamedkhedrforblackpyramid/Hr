import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hr/modules/organizationmodel.dart';
import 'package:hr/screens/excusepermission.dart';
import 'package:hr/screens/multiscreen_tasks/addphase.dart';
import 'package:hr/screens/multiscreen_tasks/addtask.dart';
import 'package:hr/screens/multiscreen_tasks/showtasks.dart';
import 'package:hr/screens/projects.dart';
import 'package:hr/screens/switchpermitandvacan.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:rive/rive.dart';

import '../../network/local/cache_helper.dart';
import '../../network/remote/dio_helper.dart';
import '../attendance.dart';
import '../holiday_permission.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MultiScreenForTasks extends StatefulWidget {
  int projectId;
  int organization_id;
  int currentIndex = 0;
  int? userId;
  late OrganizationsList oranizaionsList;
  String? organizationsName;
  String?organizationsArabicName;
  MultiScreenForTasks(
      {
   required this.projectId,
    required this.organization_id,
        required this.currentIndex,
        required this.userId,
        required this.organizationsArabicName,
        required this.organizationsName,
        required this.oranizaionsList
  }
  );
  @override
  State<MultiScreenForTasks> createState() => _MultiScreenForTasksState();
}

class _MultiScreenForTasksState extends State<MultiScreenForTasks> {



  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget>screens=[
      Addphase(projectId: widget.projectId,
        organization_id: widget.organization_id,
        organizationsArabicName: widget.organizationsArabicName,
        oranizaionsList: widget.oranizaionsList,
        userId: widget.userId,
        organizationsName: widget.organizationsName,),
      AddTasks(projectId: widget.projectId,
        organization_id: widget.organization_id,
        organizationsArabicName: widget.organizationsArabicName,
        oranizaionsList: widget.oranizaionsList,
        userId: widget.userId,
        organizationsName: widget.organizationsName,),
      ShowTasks(projectId: widget.projectId,
          organization_id: widget.organization_id,
        organizationsArabicName: widget.organizationsArabicName,
        oranizaionsList: widget.oranizaionsList,
        userId: widget.userId,
        organizationsName: widget.organizationsName,
      ),
    ];
    return Scaffold(
      resizeToAvoidBottomInset: true,
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Colors.black,
        selectedItemColor: Colors.pinkAccent,
        currentIndex:widget.currentIndex,
        onTap: (int currentIndexOntap){
          setState(() {
            
          });
          widget.currentIndex = currentIndexOntap;
        },
        backgroundColor:  Colors.white.withOpacity(.8),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.create),
            label: "${AppLocalizations.of(context)!.add_phase}",
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.task),
              label: "${AppLocalizations.of(context)!.addTask}"

          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.task_outlined),
              label: "Phases"

          ),
        ],
      ),
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
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: screens[widget.currentIndex],
              ),
            ),
          ],
        ));
  }
}
