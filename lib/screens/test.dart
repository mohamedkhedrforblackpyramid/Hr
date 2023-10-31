import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_picker_spinner_pop_up/time_picker_spinner_pop_up.dart';



class TimePicker extends StatefulWidget {
  Function onPressed;
  TimePicker({
   required this.onPressed
});

  @override
  State<TimePicker> createState() => _TimePickerState();
}

class _TimePickerState extends State<TimePicker> {
  @override
  Widget build(BuildContext context) {
    return 
         Stack(
          children: [
            Positioned(
              left: 30,
              top: 60,
              child: TimePickerSpinnerPopUp(
                mode: CupertinoDatePickerMode.time,
                minuteInterval: 1,
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                cancelText: 'Cancel',
                confirmText: 'OK',
                pressType: PressType.singlePress,
                timeFormat: 'jms',
                // Customize your time widget
                // timeWidgetBuilder: (dateTime) {},
                onChange: (dateTime) {
                  // Implement your logic with select dateTime
                },
              ),
            ),
          ],


    );
  }
}