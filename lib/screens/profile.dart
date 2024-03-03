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
  int? organizationId;
  int? userId;

  Profile({
    required this.organizationId,
    required this.userId,
  });

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool showLoading = false;
  late TasksList task_list;
  var password = TextEditingController();
  var confirmPassword = TextEditingController();
  var oldPassword = TextEditingController();
  var changeName = TextEditingController();
  bool clickAdd = false;

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
    }).catchError((error) {
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
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      FancyContainer(
                        height: 100,
                        width: double.infinity,
                        textColor: Colors.white,
                        onTap: () {
                          setState(() {});
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
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(15.0),
                                              child: Text(
                                                "Change Password",
                                                style: TextStyle(
                                                    fontSize: 30,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            Container(
                                              width: 300,
                                              child: TextFormField(
                                                controller: oldPassword,
                                                decoration: new InputDecoration(
                                                  labelText: "Old password",
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
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 20),
                                              child: Container(
                                                width: 300,
                                                child: TextFormField(
                                                  controller: password,
                                                  decoration:
                                                      new InputDecoration(
                                                    labelText: "New password",
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
                                                  keyboardType: TextInputType
                                                      .emailAddress,
                                                  style: new TextStyle(
                                                    fontFamily: "Poppins",
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Container(
                                              width: 300,
                                              child: TextFormField(
                                                controller: confirmPassword,
                                                decoration: new InputDecoration(
                                                  labelText:
                                                      "Confirm new pasword",
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
                                                          if (confirmPassword
                                                                  .text !=
                                                              password.text) {
                                                            clickAdd = false;
                                                            Flushbar(
                                                              backgroundColor:
                                                                  Colors.red,
                                                              message:
                                                                  "${AppLocalizations.of(context)!.passwordnotMatch}",
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
                                                            await DioHelper
                                                                .postData(
                                                              url:
                                                                  "api/user/${widget.userId}",
                                                              data: {
                                                                "password":
                                                                    password
                                                                        .text,
                                                                'old_password':
                                                                    oldPassword
                                                                        .text
                                                              },
                                                            ).then((value) {
                                                              setState(() {});
                                                              clickAdd = false;
                                                              password.text =
                                                                  '';
                                                              confirmPassword
                                                                  .text = '';
                                                              oldPassword.text =
                                                                  '';
                                                              Navigator.pop(
                                                                  context);
                                                            }).catchError(
                                                                (error) {
                                                              clickAdd = false;

                                                              setState(() {});
                                                              if (password.text
                                                                  .isEmpty) {
                                                                Flushbar(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .red,
                                                                  message:
                                                                      "New password is empty",
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
                                                                )..show(
                                                                    context);
                                                              } else if (confirmPassword
                                                                  .text
                                                                  .isEmpty) {
                                                                Flushbar(
                                                                  message:
                                                                      "Confirm password is empty",
                                                                  backgroundColor:
                                                                      Colors
                                                                          .red,
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
                                                                )..show(
                                                                    context);
                                                              } else {
                                                                Flushbar(
                                                                  message:
                                                                      "${AppLocalizations.of(context)!.project_error}",
                                                                  icon: Icon(
                                                                    Icons
                                                                        .info_outline,
                                                                    size: 30.0,
                                                                    color: Colors
                                                                            .blue[
                                                                        300],
                                                                  ),
                                                                  duration:
                                                                      Duration(
                                                                          seconds:
                                                                              3),
                                                                  leftBarIndicatorColor:
                                                                      Colors.blue[
                                                                          300],
                                                                )..show(
                                                                    context);
                                                              }

                                                              print(error
                                                                  .response
                                                                  .data);
                                                            });
                                                          }
                                                        },
                                                        title:
                                                            'Save',
                                                        color1: Colors.purple,
                                                        color2:
                                                            Colors.lightBlue,
                                                      )
                                                    : Center(
                                                        child:
                                                            CircularProgressIndicator(
                                                          color: Colors.indigo,
                                                        ),
                                                      ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 15,
                                            )
                                          ],
                                        ),
                                      )),
                                );
                              });
                            },
                          );
                        },
                        title: 'Change Password',
                        color1: Colors.purple,
                        color2: Colors.lightBlue,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      FancyContainer(
                        height: 100,
                        width: double.infinity,
                        textColor: Colors.white,
                        onTap: () {
                          setState(() {});
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
                                              4,
                                      width: MediaQuery.of(context).size.width /
                                          1.1,
                                      child: SingleChildScrollView(
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: TextFormField(
                                                controller: changeName,
                                                decoration: new InputDecoration(
                                                  labelText: "Change name",
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
                                                              .postData(
                                                            url:
                                                                "api/user/${widget.userId}",
                                                            data: {
                                                              "name": changeName
                                                                  .text,
                                                            },
                                                          ).then((value) {
                                                            setState(() {});
                                                            clickAdd = false;

                                                            Navigator.pop(
                                                                context);
                                                            changeName.text =
                                                                '';
                                                          }).catchError(
                                                              (error) {
                                                            clickAdd = false;
                                                            setState(() {});
                                                            print(error
                                                                .response.data);
                                                          });
                                                        },
                                                        title:
                                                            'Save',
                                                        color1: Colors.purple,
                                                        color2:
                                                            Colors.lightBlue,
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
                        title: 'Change Name',
                        color1: Colors.purple,
                        color2: Colors.lightBlue,
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
