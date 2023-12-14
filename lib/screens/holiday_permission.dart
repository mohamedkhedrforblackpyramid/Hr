import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hr/screens/timepicker.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:rive/rive.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


import '../calender.dart';
import '../network/remote/dio_helper.dart';

class HolidayPermission extends StatefulWidget {
  int?userId;
  int?organizationId;

  HolidayPermission({
    required this.userId,
    required this.organizationId


  });
  @override
  State<HolidayPermission> createState() => _HolidayPermissionState();
}

class _HolidayPermissionState extends State<HolidayPermission> {


  bool loadingSend = false;
  String? dropdownValue;
  bool shouldPop = false;
  bool isSignInDialogShown = false;
  late RiveAnimationController _btnAnimationController;
  var dateFromController = TextEditingController();
  var dateToController = TextEditingController();
  var timeFromController = TextEditingController();
  var vacationtype = TextEditingController();
  var noteController = TextEditingController();
  String translateType ='';

  @override
  void initState() {
    _btnAnimationController = OneShotAnimation("active", autoplay: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<String> list =[
      '${AppLocalizations.of(context)!.ordinary}',
      '${AppLocalizations.of(context)!.casual}',
      '${AppLocalizations.of(context)!.sick}',
    ];
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
                  child:loadingSend==false? Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 30),
                            child: Text(
                              "${AppLocalizations.of(context)!.vacationRequest}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30,
                                  color: Colors.grey),
                            ),
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.symmetric(vertical: 10),
                          child: Theme(
                            data: Theme.of(context).copyWith(
                                splashColor: Colors.transparent),
                            child: GestureDetector(
                              onTap: (){
                                setState(() {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        //  backgroundColor: Color(0xff93D0FC),
                                        content: Container(
                                          width: 500,
                                          height: 450,
                                          child: Calender(onSubmit: (data) {
                                            dateFromController.text = data;
                                            setState(() {});
                                          }),
                                        ),
                                      );
                                    },
                                  );
                                });
                              },
                              child: TextField(
                                enabled: false,
                                controller: dateFromController,
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
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ),
                                  contentPadding: const EdgeInsets.only(
                                      left: 14.0, bottom: 8.0, top: 8.0),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.white),
                                    borderRadius:
                                        BorderRadius.circular(25.7),
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.white),
                                    borderRadius:
                                        BorderRadius.circular(25.7),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.symmetric(vertical: 10),
                          child: Theme(
                            data: Theme.of(context).copyWith(
                                splashColor: Colors.transparent),
                            child: GestureDetector(
                              onTap: (){
                                setState(() {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(

                                        //  backgroundColor: Color(0xff93D0FC),
                                        content: Container(
                                          width: 500,
                                          height: 450,
                                          child: Calender(onSubmit: (data) {
                                            dateToController.text = data;
                                            setState(() {});
                                          }),
                                        ),
                                      );
                                    },
                                  );
                                });
                              },
                              child: TextField(
                                enabled: false,
                                controller: dateToController,
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
                                      '${AppLocalizations.of(context)!.dateTo}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ),
                                  contentPadding: const EdgeInsets.only(
                                      left: 14.0, bottom: 8.0, top: 8.0),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.white),
                                    borderRadius:
                                        BorderRadius.circular(25.7),
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.white),
                                    borderRadius:
                                        BorderRadius.circular(25.7),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                                child: Theme(
                                  data: Theme.of(context).copyWith(
                                      splashColor: Colors.transparent),
                                  child: TextField(
                                    enabled: false,
                                    controller: vacationtype,
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
                                          '${AppLocalizations.of(context)!.vacationType}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              fontSize: 20),
                                        ),
                                      ),
                                      contentPadding: const EdgeInsets.only(
                                          left: 14.0, bottom: 8.0, top: 8.0),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.white),
                                        borderRadius:
                                            BorderRadius.circular(25.7),
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.white),
                                        borderRadius:
                                            BorderRadius.circular(25.7),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: DropdownButton<String>(
                                dropdownColor:  Color(0xffFAACB4),
                                icon: const Icon(
                                  Icons.add,
                                  color: Colors.black,
                                  size: 30,
                                ),
                                elevation: 16,
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                                underline: Container(
                                  color: Colors.deepPurpleAccent,
                                ),
                                onChanged: (String? value) {
                                  // This is called when the user selects an item.
                                  setState(() {
                                    dropdownValue = value!;
                                    vacationtype.text =
                                        dropdownValue.toString();

                                    if(vacationtype.text=="اعتيادي"){
                                      translateType = "ORDINARY";
                                    }
                                   else if(vacationtype.text=="عارضة"){
                                     translateType = "CASUAL";
                                    }
                                   else if(vacationtype.text=="مرضي") {
                                      translateType = 'SICK';
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
                            )                          ],
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Theme(
                              data: Theme.of(context)
                                  .copyWith(splashColor: Colors.transparent),
                              child: TextField(
                                controller: noteController,
                                autofocus: false,
                                style: TextStyle(
                                    fontSize: 22.0, color: Color(0xFFbdc6cf)),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Color(0xFCED3FF),
                                  label: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Text(
                                      '${AppLocalizations.of(context)!.notes}',
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
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).viewInsets.bottom/2,
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

                                    loadingSend = true;
                                    setState(() {
                                    });
                                    sendVacation();
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
                                  icon:  Icon(
                                    AppLocalizations.of(context)!.localeName=='en'?
                                    CupertinoIcons.arrow_right:CupertinoIcons.arrow_left,
                                    color: Color(0xFFFE0037),
                                  ),
                                  label:  Text("${AppLocalizations.of(context)!.send}")),
                            ),
                          ),
                        )
                      ]):  Center(
                    child: CircularProgressIndicator(
                      color: Colors.indigo,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ));
  }
  sendVacation() async {
    await DioHelper.postData(
      url: "api/vacancies",
      formData: {
        "from": '${dateFromController.text}',
        "to": '${dateToController.text}' ,
        'is_permit' : false,
        "notes": noteController.text,
         'type': translateType,
        'organization_id': widget.organizationId,
        'user_id':widget.userId
      },
    ).then((value) {
      print(translateType);
      if(dateFromController.text==''){
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Color(0xff93D0FC),
              content: Text(
                '${AppLocalizations.of(context)!.dateFrom}',
                textAlign: TextAlign.center,
              ),
            );
          },
        );
      }else if(dateToController.text==''){
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Color(0xff93D0FC),
              content: Text(
                '${AppLocalizations.of(context)!.dateToisEmpty}',
                textAlign: TextAlign.center,
              ),
            );
          },
        );
      }else if(vacationtype.text==''){
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Color(0xff93D0FC),
              content: Text(
                '${AppLocalizations.of(context)!.vacationTypeis}',
                textAlign: TextAlign.center,
              ),
            );
          },
        );
      }else{

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Color(0xff93D0FC),
            content: Text('${value.data['message']}',
              textAlign: TextAlign.center,
            ),
          );
        },
      );}
      loadingSend = false;
      setState(() {

      });
    }).catchError((error){
      if(dateFromController.text==''){
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Color(0xff93D0FC),
              content: Text(
                '${AppLocalizations.of(context)!.dateFromisEmpty}',
                textAlign: TextAlign.center,
              ),
            );
          },
        );
      }else if(dateToController.text==''){
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Color(0xff93D0FC),
              content: Text(
                '${AppLocalizations.of(context)!.dateToisEmpty}',
                textAlign: TextAlign.center,
              ),
            );
          },
        );
      }else if(vacationtype.text==''){
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Color(0xff93D0FC),
              content: Text(
                '${AppLocalizations.of(context)!.vacationTypeis}',
                textAlign: TextAlign.center,
              ),
            );
          },
        );
      }else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Color(0xff93D0FC),
              content: Text('${AppLocalizations.of(context)!.youCanNotSend}'),
            );
          },
        );
      }
      setState(() {

      });
      loadingSend = false;

      print(error.response.data);

    });
  }
}
