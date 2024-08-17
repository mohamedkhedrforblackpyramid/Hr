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
         TimePickerSpinnerPopUp(

           mode: CupertinoDatePickerMode.time,
           minuteInterval: 1,
           textStyle: TextStyle(
             fontSize: 40,
             fontWeight: FontWeight.bold,
             color: Colors.green

           ),

         //  padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
           cancelText: 'Cancel',
           confirmText: 'OK',
           pressType: PressType.singlePress,
           timeFormat: 'Hm',
           iconSize: 30,


           // Customize your time widget
           // timeWidgetBuilder: (dateTime) {},
           onChange: (dateTime) {

             setState(() {
               dateToSend =  DateFormat('Hm').format(dateTime);
               print(dateToSend);
               widget.onPressed(dateToSend.toString());

             });
             Navigator.pop(context);
           },
         );
  }
}