import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hr/modules/permitmodel.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:rive/rive.dart';

import '../network/local/cache_helper.dart';
import '../network/remote/dio_helper.dart';
import 'hr.dart';
import 'onboding/components/animated_btn.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Showpermit extends StatefulWidget {
  int? userId;
  int? organizationId;
  String? personType;
  int? vacancesCount;
  int? permitsPermission;
  final dynamic oranizaionsList;
  String? organizationsName;
  String? organizationsArabicName;

  Showpermit(
      {required this.userId,
        required this.personType,
        required this.organizationId,
        required this.vacancesCount,
        required this.permitsPermission,
        required this.oranizaionsList,
        required this.organizationsName,
        required this.organizationsArabicName});

  @override
  State<Showpermit> createState() => _ShowpermitState();
}

class _ShowpermitState extends State<Showpermit> {
  bool shouldPop = false;
  bool isSignInDialogShown = false;
  late RiveAnimationController _btnAnimationController;
  late PermitList permits;
  bool permitLoading = false;
  String valueClosed = '0';
  bool isOpen = false;
  String permit_type = 'Permissions';
  bool clickVacances = false;
  bool clickPermission = true;

  bool clickperPending = false;
  bool clickperApproved = false;
  bool clickperRefused = false;

  String perPending = 'PENDING';
  String perApproved = 'APPROVED';
  String perRefused = 'REFUSED';

  bool clickVacPending = false;
  bool clickVacApproved = false;
  bool clickVacRefused = false;

  dynamic total_monthly_timeoff_hours;
  dynamic month_timeoffs;
  dynamic year_dayoffs;
  dynamic month_dayoffs;
  int? usrId;
  late int monthNumber;
  late int yearNumber;
  getPermissions() {
    permitLoading = true;
    Map<String, dynamic> query = {};
    if (clickperPending == true) {
      query['status'] = perPending;
      clickperPending = true;
    }
    if (clickperApproved == true) {
      query['status'] = perApproved;
    }
    if (clickperRefused == true) {
      query['status'] = perRefused;
    }
    if (query['status'] == null) {
      clickperPending = true;
      query['status'] = perPending;
    }

    DioHelper.getData(
        url:
        "api/vacancies?organization_id=${widget.organizationId}&is_permit=1",
        query: query)
        .then((response) {
      print(response.data);
      permits = PermitList.fromJson(response.data['data']);
      if (clickperPending == true || clickVacPending == true)
        widget.permitsPermission = permits.permitList!.length;
      else {}
      print(response.data);

      setState(() {
        permitLoading = false;
      });
    }).catchError((error) {
      print('hhhhhhhhhhhhhhhh');
      print(error);
    });
  }

  getVecan() {
    CacheHelper.getData(key: 'token');
    permitLoading = true;
    Map<String, dynamic> query = {};
    if (clickVacPending == true) {
      query['status'] = perPending;
    }
    if (clickVacApproved == true) {
      query['status'] = perApproved;
    }
    if (clickVacRefused == true) {
      query['status'] = perRefused;
    }
    if (query['status'] == null) {
      clickVacPending = true;
      query['status'] = perPending;
    }
    DioHelper.getData(
        url:
        "api/vacancies?organization_id=${widget.organizationId}&is_permit=0",
        query: query)
        .then((response) {
      permits = PermitList.fromJson(response.data['data']);
      if (clickperPending == true || clickVacPending == true)
        widget.vacancesCount = permits.permitList!.length;
      else {}
      setState(() {
        permitLoading = false;
      });
    }).catchError((error) {
      print(error.response);
    });
  }

  returnPage() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Hr(
              userId: widget.userId,
              oranizaionsList: widget.oranizaionsList,
              organizationId: widget.organizationId,
              organizationsName: widget.organizationsName,
              organizationsArabicName: widget.organizationsArabicName,
              personType: widget.personType,
            )));
  }

  getRequestInfo() async {
    CacheHelper.getData(key: 'token');

    await DioHelper.getData(
      url:
      "api/user/time-offs/?user_id=${usrId}&organization_id=${widget.organizationId}&month=${monthNumber}&year=${yearNumber}",
    ).then((response) {
      total_monthly_timeoff_hours =
      response.data['total_monthly_timeoff_hours'];
      month_timeoffs = response.data['month_timeoffs'];
      year_dayoffs = response.data['year_dayoffs'];
      month_dayoffs = response.data['month_dayoffs'];
      print(response.data);
      setState(() {});
    }).catchError((error) {
      print(error.response);
    });
  }

  @override
  void initState() {
    getRequestInfo();
    // clickperPending = true;
    // clickVacPending = true;
    print(CacheHelper.getData(key: 'token'));
    _btnAnimationController = OneShotAnimation("active", autoplay: false);

    getPermissions();

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
                child: SingleChildScrollView(
                  child: permitLoading == false
                      ? Column(
                    children: [
                      Padding(
                          padding: const EdgeInsets.all(15),
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      clickPermission = true;
                                      clickVacances = false;
                                      getPermissions();
                                      setState(() {});
                                      clickVacPending = false;
                                      clickVacApproved = false;
                                      clickVacRefused = false;
                                    },
                                    child: AnimatedContainer(
                                      duration: const Duration(milliseconds: 300),
                                      height: clickPermission == true ? 130 : 110, // تصغير الكارت قليلاً
                                      width: 120, // عرض الكارت أصغر
                                      margin: const EdgeInsets.only(right: 16),
                                      decoration: BoxDecoration(
                                        color: Colors.yellow.shade100,
                                        borderRadius: BorderRadius.circular(12), // زوايا منحنية أصغر
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.1),
                                            spreadRadius: 2,
                                            blurRadius: 5,
                                          )
                                        ],
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0), // تقليل التباعد الداخلي
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  AppLocalizations.of(context)!.permissionsReq,
                                                  style: TextStyle(
                                                    color: Colors.grey[700],
                                                    fontSize: 13, // حجم النص أصغر قليلاً
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ],
                                            ),
                                            if (widget.personType == 'MANAGER' &&
                                                widget.permitsPermission != 0)
                                              Positioned(
                                                top: 0,
                                                right: 0,
                                                child: Container(
                                                  padding: const EdgeInsets.all(5),
                                                  decoration: BoxDecoration(
                                                    color: Colors.red.shade200,
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Text(
                                                    '${widget.permitsPermission}',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 11, // حجم الرقم أصغر
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  GestureDetector(
                                    onTap: () {
                                      clickVacances = true;
                                      clickPermission = false;
                                      getVecan();
                                      setState(() {});
                                      clickperPending = false;
                                      clickperRefused = false;
                                      clickperApproved = false;
                                    },
                                    child: AnimatedContainer(
                                      duration: const Duration(milliseconds: 300),
                                      height: clickVacances == true ? 130 : 110,
                                      width: 120,
                                      margin: const EdgeInsets.only(right: 16),
                                      decoration: BoxDecoration(
                                        color: Colors.red.shade100,
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.1),
                                            spreadRadius: 2,
                                            blurRadius: 5,
                                          )
                                        ],
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  AppLocalizations.of(context)!.vacancesReq,
                                                  style: TextStyle(
                                                    color: Colors.grey[700],
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ],
                                            ),
                                            if (widget.personType == 'MANAGER' &&
                                                widget.vacancesCount != 0)
                                              Positioned(
                                                top: 0,
                                                right: 0,
                                                child: Container(
                                                  padding: const EdgeInsets.all(5),
                                                  decoration: BoxDecoration(
                                                    color: Colors.red.shade200,
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Text(
                                                    '${widget.vacancesCount}',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 11,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )

                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            child: TextButton(
                              onPressed: () {
                                if (clickPermission == true) {
                                  clickperPending = true;
                                  clickperRefused = false;
                                  clickperApproved = false;
                                  getPermissions();
                                } else {
                                  clickperPending = false;
                                  clickperRefused = false;
                                  clickperApproved = false;
                                  clickVacPending = true;
                                  clickVacApproved = false;
                                  clickVacRefused = false;
                                  getVecan();
                                }
                                setState(() {});
                              },
                              child: Text(
                                '${AppLocalizations.of(context)!.pending}',
                              ),
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: clickPermission == true
                                  ? clickperPending == true ||
                                  clickVacPending == true
                                  ? Colors.yellow.shade100
                                  : Colors.teal.shade100
                                  : clickperPending == true ||
                                  clickVacPending == true
                                  ? Colors.red.shade100
                                  : Colors.teal.shade100,
                            ),
                            height: clickperPending || clickVacPending == true
                                ? 80
                                : 50,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                              child: TextButton(
                                onPressed: () {
                                  if (clickPermission == true) {
                                    permits.permitList!.length = 0;

                                    clickperPending = false;
                                    clickperRefused = false;
                                    clickperApproved = true;

                                    getPermissions();
                                    setState(() {});
                                  } else {
                                    clickperPending = false;
                                    clickperRefused = false;
                                    clickperApproved = false;
                                    clickVacPending = false;
                                    clickVacApproved = true;
                                    clickVacRefused = false;
                                    getVecan();
                                  }
                                  setState(() {});
                                },
                                child: Text(
                                    '${AppLocalizations.of(context)!.approved}'),
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: clickPermission == true
                                    ? clickperApproved == true ||
                                    clickVacApproved == true
                                    ? Colors.yellow.shade100
                                    : Colors.teal.shade100
                                    : clickperApproved == true ||
                                    clickVacApproved == true
                                    ? Colors.red.shade100
                                    : Colors.teal.shade100,
                              ),
                              height:
                              clickperApproved || clickVacApproved == true
                                  ? 80
                                  : 50,
                            ),
                          ),
                          Container(
                            child: TextButton(
                              onPressed: () {
                                if (clickPermission == true) {
                                  clickperPending = false;
                                  clickperRefused = true;
                                  clickperApproved = false;
                                  getPermissions();
                                } else {
                                  clickperPending = false;
                                  clickperRefused = false;
                                  clickperApproved = false;
                                  clickVacPending = false;
                                  clickVacApproved = false;
                                  clickVacRefused = true;
                                  getVecan();
                                }
                                setState(() {});
                              },
                              child: Text(
                                  '${AppLocalizations.of(context)!.refuse}'),
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: clickPermission == true
                                  ? clickperRefused == true ||
                                  clickVacRefused == true
                                  ? Colors.yellow.shade100
                                  : Colors.teal.shade100
                                  : clickperRefused == true ||
                                  clickVacRefused == true
                                  ? Colors.red.shade100
                                  : Colors.teal.shade100,
                            ),
                            height: clickperRefused || clickVacRefused == true
                                ? 80
                                : 50,
                          ),
                        ],
                      ),
                      permits.permitList!.isNotEmpty
                          ? SizedBox(
                        //height: MediaQuery.of(context).size.height,
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context,
                              int index) =>
                          clickPermission == true
                              ? buildPermitList(
                              per: permits.permitList![index],
                              index: index,
                              context: context)
                              : buildVacanList(
                              per: permits.permitList![index],
                              index: index,
                              context: context),
                          itemCount: permits.permitList!.length,
                        ),
                      )
                          : Padding(
                        padding:
                        const EdgeInsets.symmetric(vertical: 200),
                        child: Center(
                          child: Text(
                            "No Requests ",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  )
                      : Padding(
                    padding: const EdgeInsets.symmetric(vertical: 300),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Colors.indigo,
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ));
  }

  Widget buildPermitList({
    required PermitModel per,
    required int index,
    required BuildContext context,
  }) {
    // Function to format a given time string to the local timezone
    String formatToLocalTime(String timeString) {
      try {
        // Ensure the time string is in UTC by adding 'Z' at the end
        DateTime utcTime = DateTime.parse("${timeString}Z").toUtc();
        // Convert UTC time to local time
        DateTime localTime = utcTime.toLocal();
        // Format the new local time
        return DateFormat('yyyy-MM-dd HH:mm').format(localTime);
      } catch (e) {
        // In case of an error (invalid format), return the original string
        return timeString;
      }
    }

    // Format date and time using the local time format function
    String formattedFrom = per.from != null
        ? formatToLocalTime(per.from!)
        : '____';
    String formattedTo = per.to != null
        ? formatToLocalTime(per.to!)
        : '____';

    return Container(
      margin: EdgeInsets.all(20),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.yellow.shade100,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(40.0),
          bottomLeft: Radius.circular(40.0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${AppLocalizations.of(context)!.userName} : ${per.name} ',
            style: TextStyle(
              fontSize: 15,
              color: Colors.black45,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '${AppLocalizations.of(context)!.timeFrom} : $formattedFrom',
            style: TextStyle(
              fontSize: 15,
              color: Colors.black45,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '${AppLocalizations.of(context)!.timeTo} : $formattedTo',
            style: TextStyle(
              fontSize: 15,
              color: Colors.black45,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '${AppLocalizations.of(context)!.notesView} : ${per.notes ?? '____'}',
            style: TextStyle(
              fontSize: 15,
              color: Colors.black45,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${AppLocalizations.of(context)!.status} : ',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black45,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${per.status}',
                style: TextStyle(
                  fontSize: 15,
                  color: per.status == 'APPROVED'
                      ? Colors.green
                      : per.status == "REFUSED"
                      ? Colors.red
                      : Color(0xffFFA500),
                  fontWeight: FontWeight.bold,
                ),
              ),
              widget.personType == 'MANAGER'
                  ? IconButton(
                onPressed: () async {
                  // Extract month and year numbers
                  monthNumber = per.from != null
                      ? DateTime.parse(per.from!)
                      .toLocal()
                      .month
                      : -1; // -1 if date is null
                  yearNumber = per.from != null
                      ? DateTime.parse(per.from!)
                      .toLocal()
                      .year
                      : -1; // -1 if date is null
                  usrId = per.user_id;
                  await getRequestInfo();
                  setState(() {});

                  // Print month and year numbers to console
                  print('Month Number: $monthNumber');
                  print('Year Number: $yearNumber');
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "About this Employee",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red),
                            ),
                            Text(
                              "Total Monthly (time off hours) : ${total_monthly_timeoff_hours}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Month Time Off : ${month_timeoffs}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Year Day Off : ${year_dayoffs}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Month Day off : ${month_dayoffs}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                icon: Icon(Icons.info_outline),
              )
                  : SizedBox(),
            ],
          ),
          SizedBox(height: 15),
          widget.personType == 'MANAGER'
              ? per.status == 'PENDING'
              ? Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Color(0xff49796B),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: TextButton(
                  onPressed: () {
                    showDialog<void>(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: Text(
                            '${AppLocalizations.of(context)!.accept_permission}',
                          ),
                          actions: [
                            Row(
                              children: [
                                TextButton(
                                  style: TextButton.styleFrom(
                                    textStyle: Theme.of(context)
                                        .textTheme
                                        .labelLarge,
                                  ),
                                  child: Text(
                                      '${AppLocalizations.of(context)!.yes}'),
                                  onPressed: () async {
                                    await DioHelper.postData(
                                      url:
                                      "api/update-status/${per.id}",
                                      data: {
                                        "status": true,
                                      },
                                    ).then((value) {
                                      setState(() {
                                        getPermissions();
                                        // permits.permitList?.removeAt(index);
                                      });
                                      print('Accepted');
                                    }).catchError((error) {
                                      print('Error: $error');
                                    });
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  style: TextButton.styleFrom(
                                    textStyle: Theme.of(context)
                                        .textTheme
                                        .labelLarge,
                                  ),
                                  child: Text(
                                      '${AppLocalizations.of(context)!.no}'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                              mainAxisAlignment:
                              MainAxisAlignment.center,
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Text(
                    '${AppLocalizations.of(context)!.accept}',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10),
              Container(
                decoration: BoxDecoration(
                  color: Color(0xff49796B),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: TextButton(
                  onPressed: () {
                    showDialog<void>(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: Text(
                            '${AppLocalizations.of(context)!.are_denyPermission}',
                          ),
                          actions: [
                            Row(
                              children: [
                                TextButton(
                                  style: TextButton.styleFrom(
                                    textStyle: Theme.of(context)
                                        .textTheme
                                        .labelLarge,
                                  ),
                                  child: Text(
                                      '${AppLocalizations.of(context)!.yes}'),
                                  onPressed: () async {
                                    await DioHelper.postData(
                                      url:
                                      "api/update-status/${per.id}",
                                      data: {
                                        "status": false,
                                      },
                                    ).then((value) {
                                      setState(() {
                                        getPermissions();
                                        // permits.permitList?.removeAt(index);
                                      });
                                      print('Rejected');
                                    }).catchError((error) {
                                      print('Error: $error');
                                    });
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  style: TextButton.styleFrom(
                                    textStyle: Theme.of(context)
                                        .textTheme
                                        .labelLarge,
                                  ),
                                  child: Text(
                                      '${AppLocalizations.of(context)!.no}'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                              mainAxisAlignment:
                              MainAxisAlignment.center,
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Text(
                    '${AppLocalizations.of(context)!.refuse}',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          )
              : SizedBox()
              : SizedBox(),
        ],
      ),
    );
  }


  Widget buildVacanList({
    required PermitModel per,
    required int index,
    required BuildContext context,
  }) {
    // Function to format a given time string to the local timezone
    String formatToLocalTime(String timeString) {
      try {
        // Ensure the time string is in UTC by adding 'Z' at the end
        DateTime utcTime = DateTime.parse("${timeString}Z").toUtc();
        // Convert UTC time to local time
        DateTime localTime = utcTime.toLocal();
        // Format the new local time
        return DateFormat('yyyy-MM-dd').format(localTime);
      } catch (e) {
        // In case of an error (invalid format), return the original string
        return timeString;
      }
    }

    // Format date and time using the local time format function
    String formattedFrom = per.from != null
        ? formatToLocalTime(per.from!)
        : '____';
    String formattedTo = per.to != null
        ? formatToLocalTime(per.to!)
        : '____';

    return Container(
      margin: EdgeInsets.all(20),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.red.shade100,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(40.0),
          bottomLeft: Radius.circular(40.0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${AppLocalizations.of(context)!.userName} : ${per.name} ',
            style: TextStyle(
                fontSize: 15,
                color: Colors.black45,
                fontWeight: FontWeight.bold),
          ),
          Text(
            '${AppLocalizations.of(context)!.timeFrom} : $formattedFrom',
            style: TextStyle(
                fontSize: 15,
                color: Colors.black45,
                fontWeight: FontWeight.bold),
          ),
          Text(
            '${AppLocalizations.of(context)!.timeTo} : $formattedTo',
            style: TextStyle(
                fontSize: 15,
                color: Colors.black45,
                fontWeight: FontWeight.bold),
          ),
          Text(
            '${AppLocalizations.of(context)!.notesView} : ${per.notes ?? '____'}',
            style: TextStyle(
              fontSize: 15,
              color: Colors.black45,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${AppLocalizations.of(context)!.status} : ',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black45,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${per.status}',
                style: TextStyle(
                  fontSize: 15,
                  color: per.status == 'APPROVED'
                      ? Colors.green
                      : per.status == "REFUSED"
                      ? Colors.red
                      : Color(0xffFFA500),
                  fontWeight: FontWeight.bold,
                ),
              ),
              widget.personType == 'MANAGER'
                  ? IconButton(
                  onPressed: () async {
                    // Extract month and year numbers
                    monthNumber = per.from != null
                        ? DateTime.parse(per.from!)
                        .toLocal()
                        .month
                        : -1; // -1 if date is null
                    yearNumber = per.from != null
                        ? DateTime.parse(per.from!)
                        .toLocal()
                        .year
                        : -1; // -1 if date is null
                    usrId = per.user_id;
                    await getRequestInfo();
                    setState(() {});
                    print('Month Number: $monthNumber');
                    print('Year Number: $yearNumber');
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "About this Employee",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red),
                              ),
                              Text(
                                "Total Monthly (time off hours) : ${total_monthly_timeoff_hours}",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "Month Time Off : ${month_timeoffs}",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "Year Day Off : ${year_dayoffs}",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "Month Day off : ${month_dayoffs}",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  icon: Icon(Icons.info_outline))
                  : SizedBox(),
            ],
          ),
          SizedBox(height: 15),
          widget.personType == 'MANAGER'
              ? per.status == 'PENDING'
              ? Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Color(0xff49796B),
                    borderRadius: BorderRadius.circular(30)),
                child: TextButton(
                    onPressed: () {
                      showDialog<void>(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content: Text(
                              '${AppLocalizations.of(context)!.accept_excuse}',
                            ),
                            actions: [
                              Row(
                                children: [
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .labelLarge,
                                    ),
                                    child: Text(
                                        '${AppLocalizations.of(context)!.yes}'),
                                    onPressed: () async {
                                      await DioHelper.postData(
                                        url:
                                        "api/update-status/${per.id}",
                                        data: {
                                          "status": true,
                                        },
                                      ).then((value) {
                                        setState(() {
                                          getVecan();
                                        });
                                        print('mbroook');
                                      }).catchError((error) {});
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .labelLarge,
                                    ),
                                    child: Text(
                                        '${AppLocalizations.of(context)!.no}'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Text(
                      '${AppLocalizations.of(context)!.accept}',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    )),
              ),
              SizedBox(width: 10),
              Container(
                decoration: BoxDecoration(
                    color: Color(0xff49796B),
                    borderRadius: BorderRadius.circular(30)),
                child: TextButton(
                    onPressed: () {
                      showDialog<void>(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content: Text(
                              '${AppLocalizations.of(context)!.are_denyExcuse}',
                            ),
                            actions: [
                              Row(
                                children: [
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .labelLarge,
                                    ),
                                    child: Text(
                                        '${AppLocalizations.of(context)!.yes}'),
                                    onPressed: () async {
                                      await DioHelper.postData(
                                        url:
                                        "api/update-status/${per.id}",
                                        data: {
                                          "status": false,
                                        },
                                      ).then((value) {
                                        setState(() {
                                          getVecan();
                                        });
                                        print('mbroook');
                                      }).catchError((error) {});
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .labelLarge,
                                    ),
                                    child: Text(
                                        '${AppLocalizations.of(context)!.no}'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Text(
                      '${AppLocalizations.of(context)!.refuse}',
                      style: TextStyle(color: Colors.white),
                    )),
              ),
            ],
          )
              : SizedBox()
              : SizedBox()
        ],
      ),
    );
  }

}