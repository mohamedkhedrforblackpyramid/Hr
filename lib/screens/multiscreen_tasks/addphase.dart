import 'dart:ui';

import 'package:another_flushbar/flushbar.dart';
import 'package:fancy_containers/fancy_containers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hr/modules/organizationmodel.dart';
import 'package:hr/screens/excusepermission.dart';
import 'package:hr/screens/projects.dart';
import 'package:hr/screens/switchpermitandvacan.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:rive/rive.dart';

import '../../calender.dart';
import '../../network/local/cache_helper.dart';
import '../../network/remote/dio_helper.dart';
import '../attendance.dart';
import '../holiday_permission.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Addphase extends StatefulWidget {
  int projectId;
  int organization_id;
  int? userId;
  late OrganizationsList oranizaionsList;
  String? organizationsName;
  String?organizationsArabicName;

  Addphase({
    required this.projectId,
    required this.organization_id,
    required this.userId,
    required this.organizationsArabicName,
    required this.organizationsName,
    required this.oranizaionsList

  });
  @override
  State<Addphase> createState() => _AddphaseState();
}

class _AddphaseState extends State<Addphase> {
  int currentIndex = 0;
  var phaseName = TextEditingController();
  var phasedesc = TextEditingController();
  var dueDateController = TextEditingController();
  var fromDateController = TextEditingController();

  bool clickAdd = false;
  returnPage(){
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) =>  Projects(
          userId: widget.userId,
          organizationId: widget.organization_id,
          organizationsName: widget.organizationsName,
          oranizaionsList: widget.oranizaionsList,
          organizationsArabicName: widget.organizationsArabicName,
        )
        ));
  }
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        return returnPage();
      },
      child: Center(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Text("${AppLocalizations.of(context)!.add_phase}",
                    style: TextStyle(color: Colors.white70,
                      fontSize: 30,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 40),
                  child: Theme(
                    data: Theme.of(context)
                        .copyWith(splashColor: Colors.transparent),
                    child: TextField(
                      controller: phaseName,
                      autofocus: false,
                      style: TextStyle(
                          fontSize: 22.0, color: Color(0xFFbdc6cf)),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Color(0xFCED3FF),
                        label: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            '${AppLocalizations.of(context)!.phase_name}',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                        contentPadding: const EdgeInsets.only(
                            left: 14.0, bottom: 8.0, top: 8.0,right: 14),
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

                Padding(
                  padding: const EdgeInsets.only(bottom: 40),
                  child: Theme(
                    data: Theme.of(context)
                        .copyWith(splashColor: Colors.transparent),
                    child: TextField(
                      controller: phasedesc,
                      autofocus: false,
                      style: TextStyle(
                          fontSize: 22.0, color: Color(0xFFbdc6cf)),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Color(0xFCED3FF),
                        label: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            '${AppLocalizations.of(context)!.phase_desc}',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                        contentPadding: const EdgeInsets.only(
                            left: 14.0, bottom: 8.0, top: 8.0,right: 14),
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
                Padding(
                  padding: const EdgeInsets.only(
                      bottom: 40),
                  child: Theme(
                    data: Theme.of(context).copyWith(
                        splashColor:
                        Colors.transparent),
                    child: GestureDetector(
                      onTap: (){
                        setState(() {
                          showDialog(
                            context: context,
                            builder:
                                (BuildContext context) {
                              return AlertDialog(
                                //  backgroundColor: Color(0xff93D0FC),
                                content: Container(
                                  width: 500,
                                  height: 450,
                                  child: Calender(
                                      onSubmit: (data) {
                                        print("Heeeeeeloooooo");
                                        print(data);
                                        print("Heeeeeeloooooo");
                                        fromDateController.text =
                                            data;
                                        setState(() {});
                                      }),
                                ),
                              );
                            },
                          );
                        });
                      },
                      child: TextFormField(
                        enabled: false,
                        controller: fromDateController,
                        autofocus: false,
                        style: TextStyle(
                            fontSize: 22.0,
                            color: Color(0xFFbdc6cf)),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Color(0xFCED3FF),
                          label: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              '${AppLocalizations.of(context)!.dateFrom}',
                              style: TextStyle(
                                  fontWeight:
                                  FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                          contentPadding:
                          const EdgeInsets.only(
                              left: 14.0,
                              bottom: 8.0,
                              top: 8.0),
                          focusedBorder:
                          OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.white),
                            borderRadius:
                            BorderRadius.circular(
                                25.7),
                          ),
                          enabledBorder:
                          UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.white),
                            borderRadius:
                            BorderRadius.circular(
                                25.7),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(
                      bottom: 40),
                  child: Theme(
                    data: Theme.of(context).copyWith(
                        splashColor:
                        Colors.transparent),
                    child: GestureDetector(
                      onTap: (){
                        setState(() {
                          showDialog(
                            context: context,
                            builder:
                                (BuildContext context) {
                              return AlertDialog(
                                //  backgroundColor: Color(0xff93D0FC),
                                content: Container(
                                  width: 500,
                                  height: 450,
                                  child: Calender(
                                      onSubmit: (data) {
                                        print("Heeeeeeloooooo");
                                        print(data);
                                        print("Heeeeeeloooooo");
                                        dueDateController.text =
                                            data;
                                        setState(() {});
                                      }),
                                ),
                              );
                            },
                          );
                        });
                      },
                      child: TextFormField(
                        validator: (value) {},
                        enabled: false,
                        controller: dueDateController,
                        autofocus: false,
                        style: TextStyle(
                            fontSize: 22.0,
                            color: Color(0xFFbdc6cf)),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Color(0xFCED3FF),
                          label: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              '${AppLocalizations.of(context)!.due_date}',
                              style: TextStyle(
                                  fontWeight:
                                  FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                          contentPadding:
                          const EdgeInsets.only(
                              left: 14.0,
                              bottom: 8.0,
                              top: 8.0),
                          focusedBorder:
                          OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.white),
                            borderRadius:
                            BorderRadius.circular(
                                25.7),
                          ),
                          enabledBorder:
                          UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.white),
                            borderRadius:
                            BorderRadius.circular(
                                25.7),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
               clickAdd==false? Padding(
                  padding: const EdgeInsets.only(bottom: 40),
                  child: Center(
                    child:  Container(
                      height: 50,
                      width: 200,
                      child: FancyContainer(
                        textColor: Colors.white,
                        title: '${AppLocalizations.of(context)!.add}',
                        color1: Colors.purple,
                        color2: Colors.lightBlue,
                        onTap: () async {
                          setState(() {

                          });
                          clickAdd = true;
                          await DioHelper.postData(
                            url: "api/organizations/${widget.organization_id}/phases",
                            formData: {
                              "name": "${phaseName.text}" ,
                              "description": "${phasedesc.text}" ,
                              "project_id": widget.projectId ,
                              "due_date":"${dueDateController.text}",
                              "from_date":"${fromDateController.text}"
                            },
                          ).then((value) {
                            setState(() {

                            });
                            clickAdd = false;

                            phaseName.text='';
                            phasedesc.text='';
                            dueDateController.text = '';
                            fromDateController.text = '';

                            Flushbar(
                              message: "${AppLocalizations.of(context)!.addedSuccessfully}",
                              icon: Icon(
                                Icons.verified_outlined,
                                size: 30.0,
                                color: Colors.green,
                              ),
                              duration: Duration(seconds: 3),
                              leftBarIndicatorColor: Colors
                                  .blue[300],
                              backgroundColor: Colors.green,
                            )
                              ..show(context);
                          }).catchError((error){
                            setState(() {

                            });
                            clickAdd=false;
                            if(phaseName.text.isEmpty) {
                              Flushbar(
                                message: "${AppLocalizations.of(context)!.phaseName_isEmpty}",
                                icon: Icon(
                                  Icons.info_outline,
                                  size: 30.0,
                                  color: Colors.black,
                                ),
                                duration: Duration(seconds: 3),
                                leftBarIndicatorColor: Colors
                                    .blue[300],
                                backgroundColor: Colors.red,

                              )
                                ..show(context);
                            }
                            else if(phasedesc.text.isEmpty){
                              Flushbar(
                                message: "${AppLocalizations.of(context)!.phaseDesc_isEmpty}",
                                icon: Icon(
                                  Icons.info_outline,
                                  size: 30.0,
                                  color: Colors.blue[300],
                                ),
                                duration: Duration(seconds: 3),
                                leftBarIndicatorColor: Colors
                                    .blue[300],
                                backgroundColor: Colors.red,
                              )
                                ..show(context);

                            }
                            else if(fromDateController.text.isEmpty){
                              Flushbar(
                                message: "${AppLocalizations.of(context)!.datefromIsEmpty}",
                                icon: Icon(
                                  Icons.info_outline,
                                  size: 30.0,
                                  color: Colors.blue[300],
                                ),
                                duration: Duration(seconds: 3),
                                leftBarIndicatorColor: Colors
                                    .blue[300],
                                backgroundColor: Colors.red,
                              )
                                ..show(context);

                            }
                            else if(dueDateController.text.isEmpty){
                              Flushbar(
                                message: "${AppLocalizations.of(context)!.due_dateIsEmpty}",
                                icon: Icon(
                                  Icons.info_outline,
                                  size: 30.0,
                                  color: Colors.blue[300],
                                ),
                                duration: Duration(seconds: 3),
                                leftBarIndicatorColor: Colors
                                    .blue[300],
                                backgroundColor: Colors.red,
                              )
                                ..show(context);

                            }


                            else{
                              Flushbar(
                                message: "${AppLocalizations.of(context)!.project_error}",
                                icon: Icon(
                                  Icons.info_outline,
                                  size: 30.0,
                                  color: Colors.blue[300],
                                ),
                                duration: Duration(seconds: 3),
                                leftBarIndicatorColor: Colors
                                    .blue[300],
                              )
                                ..show(context);
                            }
                            print(error.response.data);
                          });
                        },
                      ),
                    ),
                  ),
                ):Center(
                 child: CircularProgressIndicator(
                   color: Colors.indigo,
                 ),
               ),


              ],
            ),
          ),
        ),
      ),
    );
  }
}
