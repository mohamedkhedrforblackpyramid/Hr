import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hr/screens/request_permission.dart';
import 'package:rive/rive.dart';

import 'attendance.dart';
import 'holiday_permission.dart';


class ChooseList extends StatefulWidget {
  const ChooseList({super.key});

  @override
  State<ChooseList> createState() => _ChooseListState();
}

class _ChooseListState extends State<ChooseList> {
  bool shouldPop = false;

  bool isSignInDialogShown = false;
  late RiveAnimationController _btnAnimationController;

  @override
  void initState() {
    _btnAnimationController = OneShotAnimation("active", autoplay: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return shouldPop;
      },
      child: Scaffold(
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      child: Image.asset('assets/icons/time-tracking.png',
                                        width: 150,
                                        height: 150,
                                      ),
                                      onTap: (){
                                        Navigator.push(context,
                                            MaterialPageRoute(builder: (context) =>  RequestPermission()));
                                      },
                                    ),
                                    Text("Excuse",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 22
                                      ),
                                    ),

                                  ]),
                            ),
                            SizedBox(width: 20,),
                            Expanded(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                        child: Image.asset('assets/icons/holiday.png',
                                          width: 150,
                                          height: 150,
                                        ),
                                      onTap: (){
                                        Navigator.push(context,
                                            MaterialPageRoute(builder: (context) =>  HolidayPermission()));
                                      },
                                    ),
                                    Text("Vacation",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 22,
                                        color: Colors.white,

                                      ),
                                    ),


                                  ]),
                            ),
                          ],
                        ),
                        SizedBox(height: 40,),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                        child: Image.asset('assets/icons/machine.png',
                                          width: 150,
                                          height: 150,
                                        ),onTap: (){
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) => const Attendance()));
                                    },
                                    ),
                                    Text("Attendance",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 22
                                      ),
                                    ),

                                  ]),
                            ),
                            SizedBox(width: 20,),
                            Expanded(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                        child: Image.asset('assets/icons/profile.png',
                                          width: 150,
                                          height: 150,
                                        )),
                                    SizedBox(height: 10,),
                                    Text("Profile",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 22,
                                        color: Colors.white,

                                      ),
                                    ),


                                  ]),
                            ),
                          ],
                        ),
                      ],
                    ),

                  ),
                ),
              ),

            ],
          )),
    );
  }
}
