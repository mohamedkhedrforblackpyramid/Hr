import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hr/modules/organizationmodel.dart';
import 'package:hr/screens/request_permission.dart';
import 'package:hr/screens/switchpermitandvacan.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:rive/rive.dart';

import '../network/local/cache_helper.dart';
import '../network/remote/dio_helper.dart';
import 'attendance.dart';
import 'holiday_permission.dart';


class ChooseList extends StatefulWidget {
  int? userId;
  OrganizationsList oranizaionsList;
   ChooseList({required this.userId,
     required this.oranizaionsList
   });

  @override
  State<ChooseList> createState() => _ChooseListState();
}

class _ChooseListState extends State<ChooseList> {
  bool shouldPop = false;
  late  String status ='';
  bool isSignInDialogShown = false;
  late RiveAnimationController _btnAnimationController;
  int? dropdownvalue = null;


  Future<void> checkAttendace() async {
    await DioHelper.getData(
      url: "api/organizations/1/attendance/check",
    ).then((response) {
      status = response.data['status'];
      setState(() {
      });
    }).catchError((error){
    });

  }

  @override
  void initState() {
    _btnAnimationController = OneShotAnimation("active", autoplay: false);
    checkAttendace();


    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return shouldPop;
      },
      child: Scaffold(
        bottomSheet: Container(
          color:  Color(0xffC9A9A6),
          child: DropdownButton(
            borderRadius: BorderRadius.circular(50),
              dropdownColor: Color(0xffFAACB4),
              isExpanded: true,
              value: dropdownvalue,
              hint:  Text(
                "Choose Organizations",
                style: TextStyle(
                    fontSize: 20,
                    color:
                    Colors.black,
                    fontWeight: FontWeight.bold
                ),
              ),
              // Down Arrow Icon
              icon: const Icon(Icons
                  .keyboard_arrow_down),
              // Array list of items
              items: widget.oranizaionsList.organizationsList
                  ?.map((items) {
                return DropdownMenuItem(
                  enabled: true,
                  value: items.organizations_id,
                  child: Text(
                    '${items.name}',
                    style:
                    const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                );
              }).toList(),
              onChanged:
                  (int? newValue) {
                setState(() {
                  dropdownvalue =
                      newValue;
                });
              }),
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
                                            MaterialPageRoute(builder: (context) =>  RequestPermission(userId: widget.userId,)));
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
                                            MaterialPageRoute(builder: (context) =>  HolidayPermission(userId: widget.userId,)));
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
                                        ),onTap: () async {
                                          checkAttendace();
                                          if(status=='NOACTION'||status.isEmpty){
                                            setState(() {

                                            });
                                            await Alert(
                                            context: context,
                                            // title: "RFLUTTER ALERT",
                                            desc: "Try again later",
                                            ).show();
                                          }else {
                                            setState(() {

                                            });
                                            Navigator.push(context,
                                                MaterialPageRoute(
                                                    builder: (context) {
                                                      return  Attendance(userId: widget.userId,);
                                                    }));
                                          }
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
                                        child: Image.asset('assets/icons/requset.png',
                                          width: 150,
                                          height: 150,
                                        ),
                                      onTap:(){
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) =>  SwitchShowpermitAndVacan()));
                                      }
                                      ,
                                    ),
                                    SizedBox(height: 10,),
                                    Text("Requsets",
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
