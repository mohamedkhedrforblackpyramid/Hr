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
                                      "${AppLocalizations.of(context)!.excuseRequest}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 30,
                                          color: Colors.grey),
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
                                        Colors.white),
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
                                        Colors.white),
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
                                        MaterialStateProperty.all(Colors.white),
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
                                              color: Color(0xFFbdc6cf)),
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
                                                  return AlertDialog(
                                                    content: TimePicker(
                                                        onPressed: (data) {
                                                          timeFromController
                                                              .text = data;
                                                          setState(() {});
                                                        }),
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
                                                      Color(0xFFbdc6cf)),
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
                                                            Colors.white),
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
                                                        onPressed: (data) {
                                                          print(data);
                                                          print(
                                                              "Heeeeeeloooooo");
                                                          print(data);
                                                          print(
                                                              "Heeeeeeloooooo");
                                                          timeToController
                                                              .text = data;
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
                                                      Color(0xFFbdc6cf)),
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
                                                            Colors.white),
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
                                            color: Color(0xFFbdc6cf)),
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Color(0xFCED3FF),
                                          label: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Text(
                                              '${AppLocalizations.of(context)!.notes}',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
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
                                                  const Color(0xFF9397B7),
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
                                          icon:  Icon(
                                            AppLocalizations.of(context)!.localeName=='en'?
                                            CupertinoIcons.arrow_right:CupertinoIcons.arrow_left,
                                            color: Color(0xFFFE0037),
                                          ),
                                          label:  Text("${AppLocalizations.of(context)!.send}")),
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
    print(widget.userId);

    print(notesController.text);
    await DioHelper.postData(
      url: "api/vacancies",
      formData: {
        //"from": '${dateController.text} ${timeFromController.text}',
        "to": '${dateController.text} ${timeToController.text}',
        'is_permit': true,
        "notes": notesController.text,
        'type': permit_type,
        // 'type':'ORDINARY',
        'organization_id': widget.organizationId,
        'user_id':widget.userId
      },
    ).then((value) {
      print(widget.organizationId);

      print(value.data);
      print(widget.userId);
      if (dateController.text == '') {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Color(0xff93D0FC),
              content: Text(
                '${AppLocalizations.of(context)!.dateisEmpty}',
                textAlign: TextAlign.center,
              ),
            );
          },
        );
      } else if (timeToController.text == '') {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Color(0xff93D0FC),
              content: Text(
                '${AppLocalizations.of(context)!.timeToisEmpty}',
                textAlign: TextAlign.center,
              ),
            );
          },
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Color(0xff93D0FC),
              content: Text(
                '${value.data['message']}',
                textAlign: TextAlign.center,
              ),
            );
          },
        );
        dateController.text='';
        timeToController.text='';
        timeFromController.text='';
      }
      loadingSend = false;
      setState(() {});
    }).catchError((error) {
      print(error.response.data);
      print(widget.organizationId);

      if (dateController.text == '') {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Color(0xff93D0FC),
              content: Text(
                '${AppLocalizations.of(context)!.dateisEmpty}',
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
            content: Text('${AppLocalizations.of(context)!.youCanNotSend}'),

          );
        },
      );}
      setState(() {});
      loadingSend = false;
      print(permit_type);
      print(widget.userId);
      print(error);
    });
    print(dateController.text + " " + timeFromController.text);
  }

  sendExcuseNullTo() async {
    setState(() {
      print(widget.userId);
    });
    print(notesController.text);
    await DioHelper.postData(
      url: "api/vacancies",
      formData: {
        "from": '${dateController.text} ${timeFromController.text}',
        //  "to": '${dateController.text} ${timeToController.text}' ,
        'is_permit': true,
        "notes": notesController.text,
        'type': permit_type,
        // 'type':'ORDINARY',
        'organization_id':widget.organizationId,
        'user_id': widget.userId
      },
    ).then((value) {
      print(value.data);
      print(widget.userId);
      if (dateController.text == '') {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Color(0xff93D0FC),
              content: Text(
                '${AppLocalizations.of(context)!.dateisEmpty}',
                textAlign: TextAlign.center,
              ),
            );
          },
        );
      } else if (timeFromController.text == '') {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Color(0xff93D0FC),
              content: Text(
                '${AppLocalizations.of(context)!.timeFromisEmpty}',
                textAlign: TextAlign.center,
              ),
            );
          },
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Color(0xff93D0FC),
              content: Text(
                '${value.data['message']}',
                textAlign: TextAlign.center,
              ),
            );
          },
        );
      }
      loadingSend = false;
      setState(() {});
    }).catchError((error) {
      print(error);
      if (dateController.text == '') {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Color(0xff93D0FC),
              content: Text(
                '${AppLocalizations.of(context)!.dateisEmpty}',
                textAlign: TextAlign.center,
              ),
            );
          },
        );
      } else if (timeFromController.text == '') {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Color(0xff93D0FC),
              content: Text(
                '${AppLocalizations.of(context)!.timeFromisEmpty}',
                textAlign: TextAlign.center,
              ),
            );
          },
        );
      } else {print(widget.userId);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Color(0xff93D0FC),
              content: Text('You can not send right now , Try again later'),
            );
          },
        );
      }

      setState(() {});
      loadingSend = false;
      print(permit_type);
      print(widget.userId);
      print(error.response.data);
    });
    print(dateController.text + " " + timeFromController.text);
  }

  sendExcuseFromAndTo() async {
    print(widget.userId);

    setState(() {

    });
    print(notesController.text);
    await DioHelper.postData(
      url: "api/vacancies",
      formData: {
        "from": '${dateController.text} ${timeFromController.text}',
        "to": '${dateController.text} ${timeToController.text}',
        'is_permit': true,
        "notes": notesController.text,
        'type': permit_type,
        // 'type':'ORDINARY',
        'organization_id': widget.organizationId,
        'user_id': widget.userId
      },
    ).then((value) {
      print(value.data);
      print(widget.userId);
      if (dateController.text == '') {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Color(0xff93D0FC),
              content: Text(
                '${AppLocalizations.of(context)!.dateisEmpty}',
                textAlign: TextAlign.center,
              ),
            );
          },
        );
      } else if (timeFromController.text == '') {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Color(0xff93D0FC),
              content: Text(
                '${AppLocalizations.of(context)!.timeFromisEmpty}',
                textAlign: TextAlign.center,
              ),
            );
          },
        );
      } else if (timeToController.text == '') {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Color(0xff93D0FC),
              content: Text(
                '${AppLocalizations.of(context)!.timeToisEmpty}',
                textAlign: TextAlign.center,
              ),
            );
          },
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Color(0xff93D0FC),
              content: Text(
                '${value.data['message']}',
                textAlign: TextAlign.center,
              ),
            );
          },
        );
      }
      loadingSend = false;
      setState(() {});
    }).catchError((error) {
      if (dateController.text == '') {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Color(0xff93D0FC),
              content: Text(
                '${AppLocalizations.of(context)!.dateisEmpty}',
                textAlign: TextAlign.center,
              ),
            );
          },
        );
      }else if (timeFromController.text == '') {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Color(0xff93D0FC),
              content: Text(
                '${AppLocalizations.of(context)!.timeFromisEmpty}',
                textAlign: TextAlign.center,
              ),
            );
          },
        );
      }
      setState(() {});
      loadingSend = false;
      print(permit_type);
      print(widget.userId);
      print(error.response.data);
    });
    print(dateController.text + " " + timeFromController.text);
  }
}
