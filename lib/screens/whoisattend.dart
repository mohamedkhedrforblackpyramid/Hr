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

class WhoIsAttend extends StatefulWidget {
  int? organizationId;
  int? userId;

  WhoIsAttend({
    required this.organizationId,
    required this.userId,
  });

  @override
  State<WhoIsAttend> createState() => _WhoIsAttendState();
}

class _WhoIsAttendState extends State<WhoIsAttend> {
  bool showLoading = false;
  var password = TextEditingController();
  var confirmPassword = TextEditingController();
  bool clickAdd = false;
  List users = [];

  getAttendUser() async {
    showLoading = true;
    await DioHelper.getData(
        url: "api/current-users",
        query: {'organization_id': widget.organizationId}).then((response) {
      users = response.data;
      print(users);
      setState(() {
        showLoading = false;
      });
    }).catchError((error) {
      print(error.response.data);
    });
  }

  @override
  void initState() {
    getAttendUser();
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
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Text(
                        'Attendance  today',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            color: Colors.white),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      ListView.builder(
                        itemCount: users.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Container(
                                color: Colors.teal,
                                child: Text(
                                  users[index],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 30,
                                  ),
                                )),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
