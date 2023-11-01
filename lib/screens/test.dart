import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:time_picker_spinner_pop_up/time_picker_spinner_pop_up.dart';
import 'package:intl/intl.dart';



class TimePicker extends StatefulWidget {
  Function onPressed;
  TimePicker({
   required this.onPressed
});

  @override
  State<TimePicker> createState() => _TimePickerState();
}

class _TimePickerState extends State<TimePicker> {
  DateTime dateNow = DateTime.now();
  String? dateToSend;

  @override
  Widget build(BuildContext context) {
    return 
         Container(
           height: 150,
           child: Stack(
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
              Positioned(
                left: 30,
                top: 60,
                child: TimePickerSpinnerPopUp(
                  mode: CupertinoDatePickerMode.time,
                  minuteInterval: 1,
                  textStyle: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,

                  ),

                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                  cancelText: 'Cancel',
                  confirmText: 'OK',
                  pressType: PressType.singlePress,
                  timeFormat: 'jm',
                  iconSize: 30,

                  // Customize your time widget
                  // timeWidgetBuilder: (dateTime) {},
                  onChange: (dateTime) {
                    setState(() {
                      dateToSend =  DateFormat('hh:mm').format(dateTime);
                      print(dateToSend);
                      widget.onPressed(dateToSend.toString());

                    });
                    Navigator.pop(context);
                  },
                ),
              ),
            ],


    ),
         );
  }
}