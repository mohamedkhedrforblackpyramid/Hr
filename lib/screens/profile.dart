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

class Profile extends StatefulWidget {
  int?organizationId;
  Profile({required this.organizationId});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool showLoading =false;
  late TasksList task_list;
  getTasks() async {
    showLoading = true;
    await DioHelper.getData(
      url: "api/organizations/${widget.organizationId}/current-tasks",
    ).then((response) {
      task_list = TasksList.fromJson(response.data);
      print(response.data);
      setState(() {
        showLoading = false;
      });
    }).catchError((error){
      print('kkkkkkkkkkkkkkkkkk');
      print(error);
    });

  }

  @override
  void initState() {
    getTasks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: const Color(0xff1A6293),
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
                  child: Column(),
                ),
              )
            ],
          ),
        ));
  }


}
