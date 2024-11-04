import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../network/remote/dio_helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class Attending extends StatefulWidget {
  int? organizationId;
  int? userId;

  Attending({
    required this.organizationId,
    required this.userId,
  });

  @override
  State<Attending> createState() => _AttendingState();
}

class _AttendingState extends State<Attending> {
  bool showLoading = false;
  var password = TextEditingController();
  var confirmPassword = TextEditingController();
  bool clickAdd = false;
  List<dynamic> users = [];

  getAttendUser() async {
    showLoading = true;
    await DioHelper.getData(
        url: "api/current-users",
        query: {'organization_id': widget.organizationId}).then((response) {
      users = response.data;
      print(response.data);
      setState(() {
        showLoading = false;
      });
    }).catchError((error) {
      print(error.response.data);
    });
  }

  @override
  void initState() {
    getAttendUser();
    super.initState();
  }

  // Function to format a given time string to the local timezone
  String formatToLocalTime(String timeString) {
    try {
      // Ensure the time string is in UTC by adding 'Z' at the end
      DateTime utcTime = DateTime.parse("${timeString}Z").toUtc();
      // Convert UTC time to local time
      DateTime localTime = utcTime.toLocal();
      // Format the new local time
      return DateFormat('HH:mm').format(localTime);
    } catch (e) {
      // In case of an error (invalid format), return the original string
      return timeString;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0E1D36),
      body: SafeArea(
        child: Stack(
          children: [
            // الخلفية المتدرجة مع الألوان المتناسقة
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xff0F2027), Color(0xff203A43), Color(0xff2C5364)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            // إضافة أشكال خفيفة للإضاءة وزيادة التباين
            Positioned(
              top: -50,
              left: -50,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.05),
                ),
              ),
            ),
            Positioned(
              bottom: -50,
              right: -50,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.03),
                ),
              ),
            ),
            // الخلفية الضبابية الناعمة
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: const SizedBox(),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Text(
                      '${AppLocalizations.of(context)!.attendingToday}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 36, // زيادة حجم النص
                        foreground: Paint()..shader = LinearGradient(
                          colors: <Color>[Colors.white, Colors.white],
                        ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                        shadows: [
                          Shadow(
                            blurRadius: 10.0,
                            color: Colors.black,
                            offset: Offset(2.0, 2.0),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Expanded(
                      child: ListView.builder(
                        itemCount: users.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Card(
                              elevation: 8,
                              shadowColor: Colors.black54,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: ListTile(
                                leading: ClipOval(
                                  child: Image.network(
                                    users[index]['avatar'],
                                    fit: BoxFit.cover,
                                    width: 55,
                                    height: 55,
                                  ),
                                ),
                                title: Text(
                                  users[index]['name'],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22,
                                    color: Colors.black87,
                                  ),
                                ),
                                subtitle: Row(
                                  children: [
                                    Text(
                                      "${AppLocalizations.of(context)!.attendIn}",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.deepPurple
                                      ),
                                    ),
                                    Text(
                                      "${formatToLocalTime(users[index]['first_attendance'])}",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}