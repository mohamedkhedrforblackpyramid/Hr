import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hr/modules/organizationmodel.dart';
import 'package:hr/screens/excusepermission.dart';
import 'package:hr/screens/projects.dart';
import 'package:hr/screens/switchpermitandvacan.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:rive/rive.dart';

import '../network/local/cache_helper.dart';
import '../network/remote/dio_helper.dart';
import 'attendance.dart';
import 'holiday_permission.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';



class ChooseList extends StatefulWidget {
  int? userId;
  late OrganizationsList oranizaionsList;
  int?organizationId;
  String? organizationsName;
  String?organizationsArabicName;
   ChooseList({required this.userId,
     required this.oranizaionsList,
     required this.organizationId,
     required this.organizationsName,
     required this.organizationsArabicName
   });

  @override
  State<ChooseList> createState() => _ChooseListState();
}

class _ChooseListState extends State<ChooseList> {
  bool shouldPop = false;
  String status='';
  bool isSignInDialogShown = false;
  late RiveAnimationController _btnAnimationController;
  int? dropdownvalue = null;


  Future<void> checkAttendace() async {
    await DioHelper.getData(
      url: "api/organizations/${widget.organizationId}/attendance/check",
    ).then((response) {
      status = response.data['status'];
      setState(() {
      });
    }).catchError((error){
      if (error.response?.statusCode != 200) {
        status = '';
      } else {
        print(error);
      }
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
    List<String> list =[
      '${AppLocalizations.of(context)!.ordinary}',
      '${AppLocalizations.of(context)!.casual}',
      '${AppLocalizations.of(context)!.sick}',
    ];
    return WillPopScope(
      onWillPop: () async {
        return shouldPop;
      },
      child: Scaffold(
  /*      bottomSheet: Container(
          color:  Color(0xffC9A9A6),
          child: DropdownButton(
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
             *//* icon: const Icon(Icons
                  .keyboard_arrow_down),*//*
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
        );*/

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
                  padding: const EdgeInsets.all(50),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Text(AppLocalizations.of(context)!.localeName == 'ar'?widget.organizationsArabicName!:
                                    widget.organizationsName!
                                  ,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 22
                                  ),
                                ),
                                flex: 3,
                              ),
                              Expanded(
                                child: CircleAvatar(
                                  backgroundColor: Colors.black45,
                                  child: IconButton(onPressed: (){
                                    showModalBottomSheet<void>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return ListView.builder(
                                          shrinkWrap: true,
                                          itemBuilder:
                                              (BuildContext context, int index) =>
                                              buildOranizationsList(
                                                  organizations: widget.oranizaionsList.organizationsListt![index],
                                                  index: index),
                                          itemCount: widget.oranizaionsList.organizationsListt!.length,
                                        );
                                      },
                                    );
                                  },
                                      icon: Icon(
                                          Icons.edit,
                                        color: Colors.white,
                                      )),
                                ),
                              )
                            ],
                          ),
                        ),
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
                                      await checkAttendace();
                                      if(status=='NOACTION'||status.isEmpty){
                                        Alert(
                                          context: context,
                                          // title: "RFLUTTER ALERT",
                                          desc: "${AppLocalizations.of(context)!.tryAgain}",
                                        ).show();
                                      }else {
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                                  return  Attendance(userId: widget.userId,
                                                    organizationId: widget.organizationId,
                                                    organizationsName: widget.organizationsName,
                                                    oranizaionsList: widget.oranizaionsList,
                                                    organizationsArabicName: widget.organizationsArabicName,
                                                  );
                                                }));
                                      }
                                    },
                                    ),
                                    Text("${AppLocalizations.of(context)!.attendance}",
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
                                            MaterialPageRoute(builder: (context) =>  SwitchShowpermitAndVacan(
                                              userId: widget.userId,
                                              organizationId: widget.organizationId,
                                            )));
                                      }
                                      ,
                                    ),
                                    SizedBox(height: 10,),
                                    Text("${AppLocalizations.of(context)!.requests}",
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
                                      child: Image.asset('assets/icons/time-tracking.png',
                                        width: 150,
                                        height: 150,
                                      ),
                                      onTap: (){
                                        Navigator.push(context,
                                            MaterialPageRoute(builder: (context) =>  ExcusePrmission(userId: widget.userId,
                                              organizationId: widget.organizationId,
                                            )));
                                      },
                                    ),
                                    Text("${AppLocalizations.of(context)!.excuse}",
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
                                            MaterialPageRoute(builder: (context) =>  HolidayPermission(userId: widget.userId,
                                              organizationId: widget.organizationId,
                                            )));
                                      },
                                    ),
                                    Text("${AppLocalizations.of(context)!.vacation}",
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
                                      child: Image.asset('assets/icons/check-list.png',
                                        width: 150,
                                        height: 120,
                                      ),
                                      onTap: (){
                                        Navigator.push(context,
                                            MaterialPageRoute(builder: (context) =>  Projects(
                                              organizationId:widget.organizationId ,
                                            )));
                                      },
                                    ),
                                    Text("${AppLocalizations.of(context)!.tasks}",
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
                                        height: 120,
                                      ),
                                     /* onTap: (){
                                        Navigator.push(context,
                                            MaterialPageRoute(builder: (context) =>  HolidayPermission(userId: widget.userId,
                                              organizationId: widget.organizationId,
                                            )));
                                      },*/
                                    ),
                                    Text("${AppLocalizations.of(context)!.profile}",
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
 Widget buildOranizationsList({required OrganizationsModel organizations,required int index}){
    return Column(
      children:[
        Container(
          width: double.infinity,
          child: TextButton(
            child:  Text(AppLocalizations.of(context)!.localeName == 'ar'?
            organizations.arabicName!:organizations.name!,
              style: TextStyle(
                color: Colors.black
              ),
            ),
            onPressed: () {
              setState(() {
              });
              widget.organizationsName = organizations.name!;
              widget.organizationsArabicName=organizations.arabicName;
              widget.organizationId = organizations.organizations_id;
              Navigator.pop(context);
            },
          ),
        ),
      ],
    );
  }
}
