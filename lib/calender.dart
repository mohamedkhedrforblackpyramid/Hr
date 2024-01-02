import 'package:flutter/material.dart';

import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:intl/intl.dart' show DateFormat;


DateTime _currentDate = DateTime.now();
class Calender extends StatefulWidget {
  Function onSubmit;
 Calender({
   required this.onSubmit
 });

  @override
  _CalenderState createState() => new _CalenderState();
}

class _CalenderState extends State<Calender> {
  DateTime _targetDateTime = DateTime.now();
//  List<DateTime> _markedDate = [DateTime(2018, 9, 20), DateTime(2018, 10, 11)];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    /// Example Calendar Carousel without header and custom prev & next button
    final _calendarCarouselNoHeader = CalendarCarousel<Event>(
      todayBorderColor: Colors.green,
      onDayPressed: (date, events) {
        setState(() => _currentDate = date);
      },
      daysHaveCircularBorder: true,
      showOnlyCurrentMonthDate: false,
      weekendTextStyle: const TextStyle(
        color: Colors.red,
      ),
      thisMonthDayBorderColor: Colors.grey,
      weekFormat: false,
//      firstDayOfWeek: 4,
      height: 300.0,
      selectedDateTime: _currentDate,
      targetDateTime: _targetDateTime,
      customGridViewPhysics: const NeverScrollableScrollPhysics(),
      markedDateCustomShapeBorder:
      const CircleBorder(side: BorderSide(color: Colors.yellow)),
      markedDateCustomTextStyle: const TextStyle(
        fontSize: 18,
        color: Colors.blue,
      ),
      showHeader: false,
      todayTextStyle: const TextStyle(
        color: Colors.blue,
      ),
      todayButtonColor: Colors.yellow,
      selectedDayTextStyle: const TextStyle(
        color: Colors.yellow,
      ),
      minSelectedDate: DateTime.now(),
      maxSelectedDate: DateTime.now().add(const Duration(days: 30)),
      prevDaysTextStyle: const TextStyle(
        fontSize: 16,
        color: Colors.pinkAccent,
      ),
      inactiveDaysTextStyle: const TextStyle(
        color: Colors.tealAccent,
        fontSize: 16,
      ),
      onCalendarChanged: (DateTime date) {
        setState(() {
          _targetDateTime = date;
        });
      },
    );

    return
         SingleChildScrollView(
           child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              //custom icon
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16.0),
              ), // This trailing comma makes auto-formatting nicer for build methods.
              //custom icon without header
              Row(
                children: <Widget>[
                  Expanded(
                      child: Text(
                        DateFormat.yMMM().format(_targetDateTime),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24.0,
                        ),
                      )),
                  TextButton(
                    child: const Text('PREV'),
                    onPressed: () {
                      setState(() {
                        _targetDateTime = DateTime(
                            _targetDateTime.year, _targetDateTime.month - 1);
                      });
                    },
                  ),
                  TextButton(
                    child: const Text('NEXT'),
                    onPressed: () {
                      setState(() {
                        _targetDateTime = DateTime(
                            _targetDateTime.year, _targetDateTime.month + 1);
                      });
                    },
                  )
                ],
              ),
              Container(
              //  margin: EdgeInsets.symmetric(horizontal: 16.0),
                child: _calendarCarouselNoHeader,
              ), //
              Center(
                child: Container(
                  width: 100,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  decoration: BoxDecoration(
                    color:const Color(0xff1A6293),
                    borderRadius: BorderRadius.circular(30)
           
                  ),
                  child: TextButton(
                      onPressed: (){
                    widget.onSubmit(DateFormat('yyyy-MM-dd').format(_currentDate));
                    Navigator.pop(context);
                  },
                      child: const Text('OK',
                        style: TextStyle(
                          fontSize: 25,
                          color: Colors.white
                        ),
                      )),
                ),
              )
            ],
                   ),
         );
  }
}