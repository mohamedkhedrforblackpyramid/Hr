import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hr/modules/organizationmodel.dart';
import 'package:hr/screens/excusepermission.dart';
import 'package:hr/screens/multiscreen_tasks/addphase.dart';
import 'package:hr/screens/multiscreen_tasks/addtask.dart';
import 'package:hr/screens/multiscreen_tasks/showtasks.dart';
import 'package:hr/screens/projects.dart';
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
  String? phaseName;
  int?phaseId;
  MultiScreenForTasks(
      {
   required this.projectId,
    required this.organization_id,
        required this.currentIndex,
        required this.userId,
        required this.organizationsArabicName,
        required this.organizationsName,
        required this.oranizaionsList,
        required this.phaseName,
         this.phaseId
  }
  );
  @override
  State<MultiScreenForTasks> createState() => _MultiScreenForTasksState();
}

class _MultiScreenForTasksState extends State<MultiScreenForTasks> {



  @override
  void initState() {
    print(widget.phaseName);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget>screens=[
      ShowTasks(projectId: widget.projectId,
        organization_id: widget.organization_id,
        organizationsArabicName: widget.organizationsArabicName,
        oranizaionsList: widget.oranizaionsList,
        userId: widget.userId,
        organizationsName: widget.organizationsName,
        phaseId: widget.phaseId,
        phaseName: widget.phaseName,
      ),
      Addphase(
        projectId: widget.projectId,
        organization_id: widget.organization_id,
        organizationsArabicName: widget.organizationsArabicName,
        oranizaionsList: widget.oranizaionsList,
        userId: widget.userId,
        organizationsName: widget.organizationsName,
        phaseId: widget.phaseId,
        phaseName: widget.phaseName,


      ),
      AddTasks(projectId: widget.projectId,
        organization_id: widget.organization_id,
        organizationsArabicName: widget.organizationsArabicName,
        oranizaionsList: widget.oranizaionsList,
        userId: widget.userId,
        organizationsName: widget.organizationsName,
    phaseName: widget.phaseName!,
        phaseId: widget.phaseId,

      )


    ];
    return Scaffold(
      resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: screens[widget.currentIndex],
          ),
        ));
  }
}
