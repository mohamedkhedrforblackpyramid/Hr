import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hr/main.dart';
import 'package:hr/modules/organizationmodel.dart';
import 'package:hr/screens/excusepermission.dart';
import 'package:hr/screens/profile.dart';
import 'package:hr/screens/projects.dart';
import 'package:hr/screens/showpermission.dart';
import 'package:hr/screens/tasktable.dart';
import 'package:hr/screens/taskmanagement.dart';
import 'package:hr/screens/attendingToday.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:rive/rive.dart';

import '../network/local/cache_helper.dart';
import '../network/remote/dio_helper.dart';
import 'attendance.dart';
import 'vacancespermissions.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';



class ChooseList extends StatefulWidget {
  int? userId;
   dynamic oranizaionsList;
  int?organizationId;
  String? organizationsName;
  String?organizationsArabicName;
  String?personType;
   ChooseList({required this.userId,
     required this.oranizaionsList,
     required this.organizationId,
     required this.organizationsName,
     required this.organizationsArabicName,
     required this.personType
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
  String? dropdownValue;

  getOrganizations() {
    DioHelper.getData(
      url: "api/organizations",
    ).then((response) {
      print(response.data);
    });

  }
  Future<void> checkAttendace() async {
    await DioHelper.getData(
      url: "api/organizations/${widget.organizationId}/attendance/check",
    ).then((response) {
      status = response.data['status'];
      setState(() {
      });
    }).catchError((error){
      print(error.response.data);
      if (error.response?.statusCode != 200) {
        status = '';
        print('hnaaaaaaaaaaaaaa');
      } else {
        print(error);
      }
    });
  }

  @override
  void initState() {
    print('hhhhhhhhhhhhhhojhipihiphp');
    print(CacheHelper.getData(key: 'token'));
    getOrganizations();
    _btnAnimationController = OneShotAnimation("active", autoplay: false);
    checkAttendace();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<String> list =[
      'Profile Setting',
      'LogOut',
      'Attending today'


    ];
    return WillPopScope(
      onWillPop: () async {
        return shouldPop;
      },
      child: Scaffold(
          appBar: AppBar(
            leadingWidth: double.infinity,
            leading: DropdownButton<String>(
              dropdownColor: Colors.indigo,
              icon:  Text(
                "${CacheHelper.getData(key: 'name')}"
              ),
              elevation: 16,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
              underline: Container(
                color: Colors.deepPurpleAccent,
              ),
              onChanged: (String? value) {
                setState(() {
                  dropdownValue = value!;
                  if(dropdownValue == 'Profile Setting'){
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) =>  Profile(
                            organizationId: widget.organizationId,
                            userId: widget.userId

                        )));
                  }
                   if(dropdownValue == 'LogOut'){
                     Navigator.push(context,
                         MaterialPageRoute(builder: (context) =>  MyApp(
                           lang: '${CacheHelper.getData(key: 'language')}',

                         )));
                  }
                  if(dropdownValue == 'Attending today'){
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Attending(
                        organizationId: widget.organizationId,
                        userId: widget.userId

                    )));
                  }

                });
              },
              items: list.map<DropdownMenuItem<String>>(
                      (String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
            ),
            backgroundColor: Colors.transparent,
          ),

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
             /* Positioned(
                  width: MediaQuery.of(context).size.width * 1.7,
                  bottom: 200,
                  left: 100,
                  child: Image.asset('assets/Backgrounds/Spline.png')),*/
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
                  padding: const EdgeInsets.all(40),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
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
                                                    personType: widget.personType,
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
                                            MaterialPageRoute(builder: (context) =>  Showpermit(
                                              organizationId: widget.organizationId,
                                              userId: widget.userId, personType: widget.personType, vacancesCount: null, permitsPermission: null, oranizaionsList: null, organizationsName: '', organizationsArabicName: '',
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
                                            MaterialPageRoute(builder: (context) =>  VacancesPermissions(userId: widget.userId,
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
                                      child: Image.asset('assets/icons/project-management.png',
                                        width: 150,
                                        height: 120,
                                      ),
                                      onTap: (){
                                        /*Navigator.push(context,
                                            MaterialPageRoute(builder: (context) =>  Projects(
                                              userId: widget.userId,
                                              organizationId: widget.organizationId,
                                              organizationsName: widget.organizationsName,
                                              oranizaionsList: widget.oranizaionsList,
                                              organizationsArabicName: widget.organizationsArabicName,
                                            )));*/
                                        Navigator.push(context,
                                            MaterialPageRoute(builder: (context) =>  TaskManagement(
                                              userId: widget.userId,
                                              organizationId: widget.organizationId,
                                              organizationsName: widget.organizationsName,
                                              oranizaionsList: widget.oranizaionsList,
                                              organizationsArabicName: widget.organizationsArabicName,

                                            )));
                                      },
                                    ),
                                    Text("${AppLocalizations.of(context)!.myProject}",
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
                                      child: Image.asset('assets/icons/check-list.png',
                                        width: 150,
                                        height: 120,
                                      ),
                                      onTap: (){
                                        Navigator.push(context,
                                            MaterialPageRoute(builder: (context) =>  TaskTable(
                                              organizationId: widget.organizationId,
                                              userId: widget.userId,

                                            )));
                                      },
                                    ),
                                    Text("${AppLocalizations.of(context)!.tasks}",
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
                        SizedBox(height: 15,),
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
