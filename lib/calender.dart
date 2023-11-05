import 'package:flutter/material.dart';

import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:hr/screens/request_permission.dart';
import 'package:intl/intl.dart' show DateFormat;


DateTime _currentDate = DateTime.now();
DateTime _currentDate2 = DateTime.now();
String? dateToSend;
class Calender extends StatefulWidget {
  Function onSubmit;
 Calender({
   required this.onSubmit
 });

  @override
  _CalenderState createState() => new _CalenderState();
}

class _CalenderState extends State<Calender> {

  String _currentMonth = DateFormat.yMMM().format(DateTime.now());
  DateTime _targetDateTime = DateTime.now();
//  List<DateTime> _markedDate = [DateTime(2018, 9, 20), DateTime(2018, 10, 11)];
  static Widget _eventIcon = new Container(
    decoration: new BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(1000)),
        border: Border.all(color: Colors.blue, width: 2.0)),
    child: new Icon(
      Icons.person,
      color: Colors.amber,
    ),
  );



  @override
  void initState() {
    dateToSend =  DateFormat('MM/dd/yyyy').format(_currentDate2);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {


    /// Example Calendar Carousel without header and custom prev & next button
    final _calendarCarouselNoHeader = CalendarCarousel<Event>(
      todayBorderColor: Colors.green,
      onDayPressed: (date, events) {
        this.setState(() => _currentDate2 = date);
        events.forEach((event) => print(event.title));
        dateToSend =  DateFormat('MM/dd/yyyy').format(_currentDate2);
        print(dateToSend);

      },
      daysHaveCircularBorder: true,
      showOnlyCurrentMonthDate: false,
      weekendTextStyle: TextStyle(
        color: Colors.red,
      ),
      thisMonthDayBorderColor: Colors.grey,
      weekFormat: false,
//      firstDayOfWeek: 4,
      height: 300.0,
      selectedDateTime: _currentDate2,
      targetDateTime: _targetDateTime,
      customGridViewPhysics: NeverScrollableScrollPhysics(),
      markedDateCustomShapeBorder:
      CircleBorder(side: BorderSide(color: Colors.yellow)),
      markedDateCustomTextStyle: TextStyle(
        fontSize: 18,
        color: Colors.blue,
      ),
      showHeader: false,
      todayTextStyle: TextStyle(
        color: Colors.blue,
      ),
      todayButtonColor: Colors.yellow,
      selectedDayTextStyle: TextStyle(
        color: Colors.yellow,
      ),
      minSelectedDate: _currentDate.subtract(Duration(days: 360)),
      maxSelectedDate: _currentDate.add(Duration(days: 360)),
      prevDaysTextStyle: TextStyle(
        fontSize: 16,
        color: Colors.pinkAccent,
      ),
      inactiveDaysTextStyle: TextStyle(
        color: Colors.tealAccent,
        fontSize: 16,
      ),
      onCalendarChanged: (DateTime date) {
        this.setState(() {
          _targetDateTime = date;
          _currentMonth = DateFormat.yMMM().format(_targetDateTime);
        });
      },
      onDayLongPressed: (DateTime date) {
        print('long pressed date $date');
      },
    );

    return
         Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            //custom icon
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16.0),
            ), // This trailing comma makes auto-formatting nicer for build methods.
            //custom icon without header
            new Row(
              children: <Widget>[
                Expanded(
                    child: Text(
                      _currentMonth,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24.0,
                      ),
                    )),
                TextButton(
                  child: Text('PREV'),
                  onPressed: () {
                    setState(() {
                      _targetDateTime = DateTime(
                          _targetDateTime.year, _targetDateTime.month - 1);
                      _currentMonth =
                          DateFormat.yMMM().format(_targetDateTime);
                    });
                  },
                ),
                TextButton(
                  child: Text('NEXT'),
                  onPressed: () {
                    setState(() {
                      _targetDateTime = DateTime(
                          _targetDateTime.year, _targetDateTime.month + 1);
                      _currentMonth =
                          DateFormat.yMMM().format(_targetDateTime);
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
                  color:Color(0xff1A6293),
                  borderRadius: BorderRadius.circular(30)

                ),
                child: TextButton(
                    onPressed: (){
                  widget.onSubmit(dateToSend.toString());
                  Navigator.pop(context);

                },
                    child: Text('OK',
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.white
                      ),
                    )),
              ),
            )
          ],
        );
  }
}