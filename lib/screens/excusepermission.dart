import 'dart:ui';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hr/screens/timepicker.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:rive/rive.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


import '../calender.dart';
import '../network/remote/dio_helper.dart';

class ExcusePrmission extends StatefulWidget {
  int? userId;
  int?organizationId;

  ExcusePrmission({required this.userId,
    required this.organizationId
  });
  @override
  State<ExcusePrmission> createState() => _ExcusePrmissionState();
}

class _ExcusePrmissionState extends State<ExcusePrmission> {
  bool shouldPop = false;
  bool isSignInDialogShown = false;
  late RiveAnimationController _btnAnimationController;
  var dateController = TextEditingController();
  var dateControllerto = TextEditingController();
  var timeFromController = TextEditingController();
  var timeToController = TextEditingController();
  var notesController = TextEditingController(text: '');
  String valueClosed = '0';
  bool isOpen = false;
  String permit_type = 'START';
  bool loadingSend = false;
  bool isFirst = true;
  bool isEnd = false;
  bool isMid = false;
  var iskey = GlobalKey();

  @override
  void initState() {
    print(widget.userId);
    _btnAnimationController = OneShotAnimation("active", autoplay: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: [
            AnimatedPositioned(
              duration: Duration(milliseconds: 240),
              top: isSignInDialogShown ? -50 : 0,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(50),
                  child: loadingSend == false
                      ? Form(
                          child: SingleChildScrollView(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 30),
                                    child: Text(
                                      "${AppLocalizations.of(context)!.permissionRequest}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          color: Color(0xff7D5060)),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  RadioListTile(
                                    title: Text(
                                      "${AppLocalizations.of(context)!.first}",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    value: '0',
                                    groupValue: valueClosed,
                                    onChanged: (value) {
                                      setState(() {});
                                      timeFromController.text = '';
                                      isMid = false;
                                      isFirst = true;
                                      isEnd = false;
                                      permit_type = 'START';
                                      isOpen = false;
                                      valueClosed = value.toString();
                                      setState(() {
                                        valueClosed = value.toString();
                                      });
                                    },
                                    fillColor: MaterialStateProperty.all(
                                        Colors.green),
                                  ),
                                  RadioListTile(
                                    title: Text(
                                      "${AppLocalizations.of(context)!.mid}",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    value: '1',
                                    groupValue: valueClosed,
                                    onChanged: (value) {
                                      setState(() {});
                                      isMid = true;
                                      isEnd = false;
                                      isFirst = false;
                                      permit_type = 'MID';
                                      isOpen = false;
                                      valueClosed = value.toString();
                                      setState(() {
                                        valueClosed = value.toString();
                                      });
                                    },
                                    fillColor: MaterialStateProperty.all(
                                        Colors.green),
                                  ),
                                  RadioListTile(
                                    title: Text(
                                      "${AppLocalizations.of(context)!.end}",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    value: '2',
                                    groupValue: valueClosed,
                                    onChanged: (value) {
                                      timeToController.text = '';
                                      isMid = false;
                                      isEnd = true;
                                      isFirst = false;
                                      permit_type = 'END';
                                      isOpen = false;
                                      valueClosed = value.toString();
                                      setState(() {
                                        valueClosed = value.toString();
                                      });
                                    },
                                    fillColor:
                                        MaterialStateProperty.all(Colors.green),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
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
                                                          dateController.text =
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
                                          controller: dateController,
                                          autofocus: false,
                                          style: TextStyle(
                                              fontSize: 22.0,
                                              color: Colors.green),
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: Color(0xFCED3FF),
                                            label: Padding(
                                              padding: const EdgeInsets.all(10.0),
                                              child: Text(
                                                '${AppLocalizations.of(context)!.date}',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold,
                                                    color: Colors.black),
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
                                  isFirst == false
                                      ? Padding(
                                        padding:
                                            const EdgeInsets.symmetric(
                                                vertical: 10),
                                        child: Theme(
                                          data: Theme.of(context)
                                              .copyWith(
                                                  splashColor: Colors
                                                      .transparent),
                                          child: GestureDetector(
                                            onTap: (){
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return
                                                    //  backgroundColor: Color(0xff93D0FC),
                                                     AlertDialog(
                                                       content: TimePicker(
                                                          onPressed: (date) {
                                                            print(date);
                                                            print(
                                                                "Heeeeeeloooooo");
                                                            print(date);
                                                            print(
                                                                "Heeeeeeloooooo");
                                                            timeFromController
                                                                .text = date;
                                                            setState(() {});
                                                          },

                                                       ),
                                                     );

                                                },
                                              );
                                            },
                                            child: TextField(
                                              enabled: false,
                                              controller:
                                                  timeFromController,
                                              autofocus: false,
                                              style: TextStyle(
                                                  fontSize: 22.0,
                                                  color:
                                                      Colors.green),
                                              decoration: InputDecoration(
                                                filled: true,
                                                fillColor:
                                                    Color(0xFCED3FF),
                                                label: Padding(
                                                  padding: const EdgeInsets.all(10.0),
                                                  child: Text(
                                                    '${AppLocalizations.of(context)!.timeFrom}',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            Colors.black),
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
                                                      color:
                                                          Colors.white),
                                                  borderRadius:
                                                      BorderRadius
                                                          .circular(25.7),
                                                ),
                                                enabledBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color:
                                                          Colors.white),
                                                  borderRadius:
                                                      BorderRadius
                                                          .circular(25.7),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                      : SizedBox(),
                                  isEnd == false
                                      ? Padding(
                                        padding:
                                            const EdgeInsets.symmetric(
                                                vertical: 10),
                                        child: Theme(
                                          data: Theme.of(context)
                                              .copyWith(
                                                  splashColor: Colors
                                                      .transparent),
                                          child: GestureDetector(
                                            onTap: (){
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    //  backgroundColor: Color(0xff93D0FC),
                                                    content: TimePicker(
                                                        onPressed: (date) {
                                                          print(date);
                                                          print(
                                                              "Heeeeeeloooooo");
                                                          print(date);
                                                          print(
                                                              "Heeeeeeloooooo");
                                                          timeToController
                                                              .text = date;
                                                          setState(() {});
                                                        }),
                                                  );
                                                },
                                              );
                                            },
                                            child: TextField(
                                              enabled: false,
                                              controller:
                                                  timeToController,
                                              autofocus: false,
                                              style: TextStyle(
                                                  fontSize: 22.0,
                                                  color:
                                                      Colors.green),
                                              decoration: InputDecoration(
                                                filled: true,
                                                fillColor:
                                                    Color(0xFCED3FF),
                                                label: Padding(
                                                  padding: const EdgeInsets.all(10.0),
                                                  child: Text(
                                                    '${AppLocalizations.of(context)!.timeTo}',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            Colors.black),
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
                                                      color:
                                                          Colors.white),
                                                  borderRadius:
                                                      BorderRadius
                                                          .circular(25.7),
                                                ),
                                                enabledBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color:
                                                          Colors.white),
                                                  borderRadius:
                                                      BorderRadius
                                                          .circular(25.7),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                      : SizedBox(),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    child: Theme(
                                      data: Theme.of(context).copyWith(
                                          splashColor: Colors.transparent),
                                      child: TextField(
                                        controller: notesController,
                                        autofocus: false,
                                        style: TextStyle(
                                            fontSize: 22.0,
                                            color: Colors.green),
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Color(0xFCED3FF),
                                          label: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Text(
                                              '${AppLocalizations.of(context)!.notes}',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black),
                                            ),
                                          ),
                                          contentPadding: const EdgeInsets.only(
                                            right: 14,
                                              left: 14.0,
                                              bottom: 8.0,
                                              top: 8.0),
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
                                  ),SizedBox(
                                    height: MediaQuery.of(context).viewInsets.bottom/2,
                                  ),
                                  Container(
                                    width: 150,
                                    height: 100,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 8.0, bottom: 24),
                                      child: ElevatedButton.icon(
                                          onPressed: () {
                                            print(widget.userId);
                                            setState(() {});
                                            loadingSend = true;
                                            if (isFirst == true) {
                                              print(widget.userId);
                                              sendExcuseNullFrom();
                                            } else if (isMid == true) {
                                              print(widget.userId);

                                              sendExcuseFromAndTo();
                                            } else if (isEnd == true) {
                                              print(widget.userId);

                                              print('hhhhhhhhhhh');
                                              sendExcuseNullTo();
                                              print('hhhhhhhhhhh');
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                   Colors.white,
                                              minimumSize: const Size(
                                                  double.infinity, 56),
                                              shape: const RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  10),
                                                          topRight:
                                                              Radius.circular(
                                                                  25),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  25),
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  25)))),

                                          label:  Text("${AppLocalizations.of(context)!.send}",
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold
                                            ),
                                          )),
                                    ),
                                  )
                                ]),
                          ),
                        )
                      : Center(
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

  sendExcuseNullFrom() async {
    print('${dateController.text} ${timeToController.text}');

    print(widget.userId);
    DateTime localDatetime = DateTime.now();
    int timezoneOffset = localDatetime.timeZoneOffset.inHours;

    String parsedTimezoneOffset = timezoneOffset >= 0 ? '+${timezoneOffset}' : timezoneOffset.toString();
    print(notesController.text);
    if (dateController.text == '') {
      Flushbar(
        message: '${AppLocalizations.of(context)!.dateisEmpty}',
        icon: Icon(
          Icons.info_outline,
          size: 30.0,
          color: Colors.black,
        ),
        duration: Duration(seconds: 3),
        leftBarIndicatorColor: Colors.blue[300],
        backgroundColor: Colors.red,
      )..show(context);
      loadingSend =false;

    } else if (timeToController.text == '') {
      Flushbar(
        message: '${AppLocalizations.of(context)!.timeToisEmpty}',
        icon: Icon(
          Icons.info_outline,
          size: 30.0,
          color: Colors.black,
        ),
        duration: Duration(seconds: 3),
        leftBarIndicatorColor: Colors.blue[300],
        backgroundColor: Colors.red,
      )..show(context);
      loadingSend =false;
    }
    else {
      await DioHelper.postData(
        url: "api/vacancies",
        data: {
          "to": '${dateController.text} ${timeToController
              .text}${parsedTimezoneOffset}',
          'is_permit': true,
          "notes": notesController.text,
          'type': permit_type,
          'organization_id': widget.organizationId,
          'user_id': widget.userId
        },
      ).then((value) {
        print(widget.organizationId);
        print(value.data);
        print(widget.userId);

        Flushbar(
          message: '${AppLocalizations.of(context)!.sentSuccessfully}',
          icon: Icon(
            Icons.verified_outlined,
            size: 30.0,
            color: Colors.black,
          ),
          duration: Duration(seconds: 3),
          leftBarIndicatorColor: Colors.blue[300],
          backgroundColor: Colors.green,
        )..show(context);
        dateController.text = '';
        timeToController.text = '';
        timeFromController.text = '';

        loadingSend = false;
        setState(() {});
      }).catchError((error) {
        print(error.response.data);
        print(widget.organizationId);


        Flushbar(
          message: '${AppLocalizations.of(context)!.youCanNotSend}',
          icon: Icon(
            Icons.info_outline,
            size: 30.0,
            color: Colors.black,
          ),
          duration: Duration(seconds: 3),
          leftBarIndicatorColor: Colors.blue[300],
          backgroundColor: Colors.red,
        )..show(context);

        setState(() {});
        loadingSend = false;
        print(permit_type);
        print(widget.userId);
        print(error);
      });
      print(dateController.text + " " + timeFromController.text);
    }
  }

  sendExcuseNullTo() async {
    setState(() {
      print(widget.userId);
    });
    DateTime localDatetime = DateTime.now();
    int timezoneOffset = localDatetime.timeZoneOffset.inHours;

    String parsedTimezoneOffset = timezoneOffset >= 0 ? '+${timezoneOffset}' : timezoneOffset.toString();
    print(notesController.text);
    if (dateController.text == '') {
      Flushbar(
        message: '${AppLocalizations.of(context)!.dateisEmpty}',
        icon: Icon(
          Icons.info_outline,
          size: 30.0,
          color: Colors.black,
        ),
        duration: Duration(seconds: 3),
        leftBarIndicatorColor: Colors.blue[300],
        backgroundColor: Colors.red,
      )..show(context);
      loadingSend=false;
    }
    else if (timeFromController.text == '') {
      Flushbar(
        message: '${AppLocalizations.of(context)!.timeFromisEmpty}',
        icon: Icon(
          Icons.info_outline,
          size: 30.0,
          color: Colors.black,
        ),
        duration: Duration(seconds: 3),
        leftBarIndicatorColor: Colors.blue[300],
        backgroundColor: Colors.red,
      )..show(context);
      loadingSend =false;
    }else{
    await DioHelper.postData(
      url: "api/vacancies",
      data: {
        "from": '${dateController.text} ${timeFromController.text}${parsedTimezoneOffset}',
        'is_permit': true,
        "notes": notesController.text,
        'type': permit_type,
        'organization_id':widget.organizationId,
        'user_id': widget.userId
      },
    ).then((value) {
      print(value.data);
      print(widget.userId);

      Flushbar(
        message: '${AppLocalizations.of(context)!.sentSuccessfully}',
        icon: Icon(
          Icons.verified_outlined,
          size: 30.0,
          color: Colors.black,
        ),
        duration: Duration(seconds: 3),
        leftBarIndicatorColor: Colors.blue[300],
        backgroundColor: Colors.green,
      )..show(context);

      loadingSend = false;
      setState(() {});
      dateController.text='';
      timeToController.text='';
      timeFromController.text='';
    }).catchError((error) {
      print(error);
         print(widget.userId);

      Flushbar(
        message: '${AppLocalizations.of(context)!.youCanNotSend}',
        icon: Icon(
          Icons.info_outline,
          size: 30.0,
          color: Colors.black,
        ),
        duration: Duration(seconds: 3),
        leftBarIndicatorColor: Colors.blue[300],
        backgroundColor: Colors.red,
      )..show(context);


      setState(() {});
      loadingSend = false;
      print(permit_type);
      print(widget.userId);
      print(error.response.data);
    });
    print(dateController.text + " " + timeFromController.text);
    }
  }

  sendExcuseFromAndTo() async {
    print(widget.userId);

    setState(() {

    });
    DateTime localDatetime = DateTime.now();
    int timezoneOffset = localDatetime.timeZoneOffset.inHours;

    String parsedTimezoneOffset = timezoneOffset >= 0
        ? '+${timezoneOffset}'
        : timezoneOffset.toString();
    print(notesController.text);
    if (dateController.text == '') {
      Flushbar(
        message: '${AppLocalizations.of(context)!.dateisEmpty}',
        icon: Icon(
          Icons.info_outline,
          size: 30.0,
          color: Colors.black,
        ),
        duration: Duration(seconds: 3),
        leftBarIndicatorColor: Colors.blue[300],
        backgroundColor: Colors.red,
      )
        ..show(context);
      loadingSend = false;
    } else if (timeFromController.text == '') {
      Flushbar(
        message: '${AppLocalizations.of(context)!.timeFromisEmpty}',
        icon: Icon(
          Icons.info_outline,
          size: 30.0,
          color: Colors.black,
        ),
        duration: Duration(seconds: 3),
        leftBarIndicatorColor: Colors.blue[300],
        backgroundColor: Colors.red,
      )
        ..show(context);
      loadingSend = false;
    } else if (timeToController.text == '') {
      Flushbar(
        message: '${AppLocalizations.of(context)!.timeToisEmpty}',
        icon: Icon(
          Icons.info_outline,
          size: 30.0,
          color: Colors.black,
        ),
        duration: Duration(seconds: 3),
        leftBarIndicatorColor: Colors.blue[300],
        backgroundColor: Colors.red,
      )
        ..show(context);
      loadingSend = false;
    } else {
      await DioHelper.postData(
        url: "api/vacancies",
        data: {
          "from": '${dateController.text} ${timeFromController
              .text}${parsedTimezoneOffset}',
          "to": '${dateController.text} ${timeToController
              .text}${parsedTimezoneOffset}',
          'is_permit': true,
          "notes": notesController.text,
          'type': permit_type,
          'organization_id': widget.organizationId,
          'user_id': widget.userId
        },
      ).then((value) {
        print(value.data);
        print(widget.userId);
        Flushbar(
          message: '${AppLocalizations.of(context)!.sentSuccessfully}',
          icon: Icon(
            Icons.verified_outlined,
            size: 30.0,
            color: Colors.black,
          ),
          duration: Duration(seconds: 3),
          leftBarIndicatorColor: Colors.blue[300],
          backgroundColor: Colors.green,
        )
          ..show(context);

        loadingSend = false;
        setState(() {});
        dateController.text = '';
        timeToController.text = '';
        timeFromController.text = '';
      }).catchError((error) {
        Flushbar(
          message: '${AppLocalizations.of(context)!.youCanNotSend}',
          icon: Icon(
            Icons.info_outline,
            size: 30.0,
            color: Colors.black,
          ),
          duration: Duration(seconds: 3),
          leftBarIndicatorColor: Colors.blue[300],
          backgroundColor: Colors.red,
        )
          ..show(context);
        setState(() {});
        loadingSend = false;
        print(permit_type);
        print(widget.userId);
        print(error.response.data);
      });
      print(dateController.text + " " + timeFromController.text);
    }
  }
}
