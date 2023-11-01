import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hr/screens/test.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:rive/rive.dart';
import 'package:table_calendar/table_calendar.dart';

import '../calender.dart';

class RequestPermission extends StatefulWidget {
  @override
  State<RequestPermission> createState() => _RequestPermissionState();
}

class _RequestPermissionState extends State<RequestPermission> {
  bool shouldPop = false;
  bool isSignInDialogShown = false;
  late RiveAnimationController _btnAnimationController;
  var dateController = TextEditingController();
  var timeFromController = TextEditingController();
  var timeToController = TextEditingController();

  @override
  void initState() {
    _btnAnimationController = OneShotAnimation("active", autoplay: false);
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
            AnimatedPositioned(
              duration: Duration(milliseconds: 240),
              top: isSignInDialogShown ? -50 : 0,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(50),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 30),
                            child: Text(
                              "Excuse Request",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30,
                                  color: Colors.grey),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                child: Theme(
                                  data: Theme.of(context)
                                      .copyWith(splashColor: Colors.transparent),
                                  child: TextField(
                                    enabled: false,
                                    controller: dateController,
                                    autofocus: false,
                                    style: TextStyle(
                                        fontSize: 22.0, color: Color(0xFFbdc6cf)),
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Color(0xFCED3FF),
                                      label: Text(
                                        'Date',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                      contentPadding: const EdgeInsets.only(
                                          left: 14.0, bottom: 8.0, top: 8.0),
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
                            IconButton(
                                icon: Icon(
                                  Icons.calendar_month,
                                  color: Colors.black,
                                ),
                                onPressed: () {
                                  setState(() {
                                    Alert(
                                      content: Container(
                                        width: 100,
                                        child: Calender(onSubmit: (data) {
                                          print("Heeeeeeloooooo");
                                          print(data);
                                          print("Heeeeeeloooooo");
                                          dateController.text = data;
                                          setState(() {});
                                        }),
                                      ),
                                      context: context,
                                      // title: "RFLUTTER ALERT",
                                    ).show();
                                  });
                                }),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                child: Theme(
                                  data: Theme.of(context)
                                      .copyWith(splashColor: Colors.transparent),
                                  child: TextField(
                                    enabled: false,

                                    controller: timeFromController,
                                    autofocus: false,
                                    style: TextStyle(
                                        fontSize: 22.0, color: Color(0xFFbdc6cf)),
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Color(0xFCED3FF),
                                      label: Text(
                                        'Time From',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                      contentPadding: const EdgeInsets.only(
                                          left: 14.0, bottom: 8.0, top: 8.0),
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
                            IconButton(
                                icon: Icon(
                                  Icons.more_time_outlined,
                                  color: Colors.black,
                                ),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        //  backgroundColor: Color(0xff93D0FC),
                                        content:  TimePicker(
                                            onPressed: (data) {
                                              print(data);
                                              print("Heeeeeeloooooo");
                                              print(data);
                                              print("Heeeeeeloooooo");
                                              timeFromController.text = data;
                                              setState(() {
                                              });
                                            }
                                        ),
                                      );
                                    },
                                  );
                                }),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                child: Theme(
                                  data: Theme.of(context)
                                      .copyWith(splashColor: Colors.transparent),
                                  child: TextField(
                                    enabled: false,
                                    controller: timeToController,
                                    autofocus: false,
                                    style: TextStyle(
                                        fontSize: 22.0, color: Color(0xFFbdc6cf)),
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Color(0xFCED3FF),
                                      label: Text(
                                        'Time To',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                      contentPadding: const EdgeInsets.only(
                                          left: 14.0, bottom: 8.0, top: 8.0),
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
                            IconButton(
                                icon: Icon(
                                  Icons.more_time_outlined,
                                  color: Colors.black,
                                ),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        //  backgroundColor: Color(0xff93D0FC),
                                        content:  TimePicker(
                                            onPressed: (data) {
                                              print(data);
                                              print("Heeeeeeloooooo");
                                              print(data);
                                              print("Heeeeeeloooooo");
                                              timeToController.text = data;
                                              setState(() {

                                              });

                                            }
                                        ),

                                      );
                                    },
                                  );
                                }),
                          ],
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Theme(
                              data: Theme.of(context)
                                  .copyWith(splashColor: Colors.transparent),
                              child: TextField(
                                autofocus: false,
                                style: TextStyle(
                                    fontSize: 22.0, color: Color(0xFFbdc6cf)),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Color(0xFCED3FF),
                                  label: Text(
                                    'Notes (Optional)',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                  contentPadding: const EdgeInsets.only(
                                      left: 14.0, bottom: 8.0, top: 8.0),
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
                        Expanded(
                          child: Container(
                            width: 150,
                            height: 100,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 8.0, bottom: 24),
                              child: ElevatedButton.icon(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF9397B7),
                                      minimumSize:
                                          const Size(double.infinity, 56),
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                              topRight: Radius.circular(25),
                                              bottomRight: Radius.circular(25),
                                              bottomLeft:
                                                  Radius.circular(25)))),
                                  icon: const Icon(
                                    CupertinoIcons.arrow_right,
                                    color: Color(0xFFFE0037),
                                  ),
                                  label: const Text("Send")),
                            ),
                          ),
                        )
                      ]),
                ),
              ),
            ),
          ],
        ));
  }
}
