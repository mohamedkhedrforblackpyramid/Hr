import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hr/screens/timepicker.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:rive/rive.dart';
import 'package:table_calendar/table_calendar.dart';

import '../calender.dart';
import '../network/remote/dio_helper.dart';

class RequestPermission extends StatefulWidget {
  int?userId;
  RequestPermission({required this.userId});
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
  var notesController = TextEditingController();
  String valueClosed = '0';
  bool isOpen = false;
   String permit_type = 'MORNING';
  bool loadingSend = false;
  bool isFirst = true;
  bool isEnd = false;



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
                  child: loadingSend==false?Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 30),
                          child: Text(
                            "Excuse Request",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 30,
                                color: Colors.grey),
                          ),
                        ),
                        SizedBox(height: 20,),
                        Row(
                          children: [
                            Expanded(
                              child: RadioListTile(

                                title: Text("First Day"),
                                value: '0',
                                groupValue: valueClosed,
                                onChanged: (value) {
                                  setState(() {

                                  });
                                  isFirst = true;
                                  isEnd = false;
                                  permit_type = 'MORNING';
                                  isOpen = false;
                                  valueClosed =
                                      value.toString();
                                  setState(() {
                                    valueClosed =
                                        value.toString();
                                  });
                                },
                                fillColor:MaterialStateProperty.all(
                                    Colors.white
                                ) ,
                              ),
                            ),
                            Expanded(
                              child: RadioListTile(
                                title: Text("Mid Day"),
                                value: '1',
                                groupValue: valueClosed,
                                onChanged: (value) {
                                  setState(() {

                                  });
                                  isEnd = false;
                                  isFirst=false;
                                  permit_type = 'MIDDAY';
                                  isOpen = false;
                                  valueClosed =
                                      value.toString();
                                  setState(() {
                                    valueClosed =
                                        value.toString();
                                  });
                                },
                                fillColor:MaterialStateProperty.all(
                                    Colors.white
                                ) ,
                              ),
                            ),

                          ],
                        ),
                        Expanded(
                          child: RadioListTile(
                            title: Text("End Of Day"),
                            value: '2',
                            groupValue: valueClosed,
                            onChanged: (value) {
                              isEnd = true;
                              isFirst=false;
                              permit_type = 'EVENING';

                              isOpen = false;
                              valueClosed =
                                  value.toString();
                              setState(() {
                                valueClosed =
                                    value.toString();
                              });
                            },
                            fillColor:MaterialStateProperty.all(
                                Colors.white
                            ) ,
                          ),
                        ),

                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Theme(
                                  data: Theme.of(context).copyWith(
                                      splashColor: Colors.transparent),
                                  child: TextField(
                                    enabled: false,
                                    controller: dateController,
                                    autofocus: false,
                                    style: TextStyle(
                                        fontSize: 22.0,
                                        color: Color(0xFFbdc6cf)),
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
                            IconButton(
                                icon: Icon(
                                  Icons.calendar_month,
                                  color: Colors.black,
                                ),
                                onPressed: () {
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
                                              print("Heeeeeeloooooo");
                                              print(data);
                                              print("Heeeeeeloooooo");
                                              dateController.text = data;
                                              setState(() {});
                                            }),
                                          ),
                                        );
                                      },
                                    );
                                  });
                                }),
                          ],
                        ),
                        isFirst==false?Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Theme(
                                  data: Theme.of(context).copyWith(
                                      splashColor: Colors.transparent),
                                  child: TextField(
                                    enabled: false,
                                    controller: timeFromController,
                                    autofocus: false,
                                    style: TextStyle(
                                        fontSize: 22.0,
                                        color: Color(0xFFbdc6cf)),
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
                                        content: TimePicker(onPressed: (data) {
                                        /*  print(data);
                                          print("Heeeeeeloooooo");
                                          print(data);
                                          print("Heeeeeeloooooo");*/
                                          timeFromController.text = data;
                                          setState(() {});
                                        }),
                                      );
                                    },
                                  );
                                }),
                          ],
                        ):SizedBox(),
                        isEnd == false?Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Theme(
                                  data: Theme.of(context).copyWith(
                                      splashColor: Colors.transparent),
                                  child: TextField(
                                    enabled: false,
                                    controller: timeToController,
                                    autofocus: false,
                                    style: TextStyle(
                                        fontSize: 22.0,
                                        color: Color(0xFFbdc6cf)),
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
                                        content: TimePicker(onPressed: (data) {
                                          print(data);
                                          print("Heeeeeeloooooo");
                                          print(data);
                                          print("Heeeeeeloooooo");
                                          timeToController.text = data;
                                          setState(() {});
                                        }),
                                      );
                                    },
                                  );
                                }),
                          ],
                        ):SizedBox(),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Theme(
                              data: Theme.of(context)
                                  .copyWith(splashColor: Colors.transparent),
                              child: TextField(
                                controller: notesController,
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
                                    setState(() {

                                    });
                                    loadingSend = true;
                                    sendExcuse();
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
                      ]):
                  Center(
                    child: CircularProgressIndicator(
                      color: Colors.indigo,
                    ),
                  )
                  ,
                ),
              ),
            ),
          ],
        ));
  }

  sendExcuse() async {
    await DioHelper.postData(
      url: "api/vacancies",
      formData: {
        "from": '${dateController.text} ${timeFromController.text}',
        "to": '${dateController.text} ${timeToController.text}' ,
        'is_permit' : true,
        "notes": notesController.text,
        'permit_type' : permit_type,
        'type':'ORDINARY',
        'organization_id':1,
        'user_id':widget.userId
      },
    ).then((value) {
      loadingSend = false;
    }).catchError((error){
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              backgroundColor: Color(0xff93D0FC),
            content: Text('You can not send right now , Try again later'),
          );
        },
      );
      setState(() {

      });
      loadingSend = false;
      print(permit_type);
      print(widget.userId);
      print(error.response.data);

    });
    print(dateController.text + " " + timeFromController.text);
  }
}
