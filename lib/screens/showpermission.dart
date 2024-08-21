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
import 'onboding/components/animated_btn.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class Showpermit extends StatefulWidget {
  int? userId;
  int?organizationId;
  String?personType;

  Showpermit({ required this.userId,
    required this.personType,
     required this.organizationId});

  @override
  State<Showpermit> createState() => _ShowpermitState();
}

class _ShowpermitState extends State<Showpermit> {
  bool shouldPop = false;
  bool isSignInDialogShown = false;
  late RiveAnimationController _btnAnimationController;
   late PermitList permits;
   late PermitList permitsPermissionsCount;
   late PermitList permitsVacancesCount;
  bool permitLoading = false;
  String valueClosed = '0';
  bool isOpen = false;
  String permit_type = 'Permissions';
  bool clickVacances = false;
  bool clickPermission = true;

  getPermissions() {
    permitLoading = true;
    DioHelper.getData(
      url: "api/organizations/${widget.organizationId}/vacancies?is_permit=1&status=1",
    ).then((response) {
      permits = PermitList.fromJson(response.data);
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
    DioHelper.getData(
      url: "api/organizations/${widget.organizationId}/vacancies?is_permit=0&status=1",
    ).then((response) {
      permits = PermitList.fromJson(response.data);
      setState(() {
        permitLoading = false;
      });
      print("hhhhhhhhhhhh");
      print(response.data);
      print("hhhhhhhhhhhh");
    }).catchError((error) {
      print(error.response);
    });
  }

  @override
  void initState() {
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
                  child: permitLoading==false?Column(
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
                                  onTap: (){
                                    clickPermission =true;
                                    clickVacances = false;
                                    getPermissions();
                                    setState(() {

                                    });
                                  },
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    height:  130,
                                    width:  130,
                                    margin: const EdgeInsets.only(right: 16),
                                    child: Card(
                                      color:
                                      Colors.teal.shade100,
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Center(
                                          child: Text(
                                            'Permissions',
                                            style: TextStyle(color: Colors.grey[700], fontSize: 15,
                                              fontWeight: FontWeight.bold
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                  SizedBox(width: 10,),
                                GestureDetector(
                                  onTap: (){
                                    clickVacances = true;
                                    clickPermission = false;
                                    getVecan();
                                    setState(() {

                                    });
                                  },

                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    height:  130,
                                    width:  130,
                                    margin: const EdgeInsets.only(right: 16),
                                    child: Card(
                                      color: Colors.deepPurple.shade100,
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Center(
                                          child: Text(
                                            'Vacances',
                                            style: TextStyle(color: Colors.grey[700], fontSize: 15,
                                                fontWeight: FontWeight.bold

                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),

                      permits.permitList!.isNotEmpty
                          ? SizedBox(
                              height: MediaQuery.of(context).size.height,
                              child: ListView.builder(
                                 shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder:
                                    (BuildContext context, int index) =>
                                       clickPermission==true? buildPermitList(
                                            per: permits.permitList![index],
                                            index: index, context: context):buildVacanList(
                                           per: permits.permitList![index],
                                           index: index, context: context),
                                itemCount: permits.permitList!.length,
                              ),
                            )
                          : Padding(
                            padding: const EdgeInsets.symmetric(vertical: 200),
                            child: Center(
                              child: Text(
                                  "No Requests ",
                                  style: TextStyle(
                                      fontSize: 20, fontWeight: FontWeight.bold),
                                ),
                            ),
                          ),
                    ],
                  ):Padding(
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
  }Widget buildPermitList({
    required PermitModel per,
    required int index,
    required BuildContext context,
  }) {
    // Define date format
    final DateFormat dateFormat = DateFormat('yyyy-MM-dd HH:mm');

    // Format date and time with added 3 hours
    String formattedFrom = per.from != null
        ? dateFormat.format(DateTime.parse(per.from!).add(Duration(hours: 3)))
        : '____';
    String formattedTo = per.to != null
        ? dateFormat.format(DateTime.parse(per.to!).add(Duration(hours: 3)))
        : '____';

    return Container(
      margin: EdgeInsets.all(20),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors
            .primaries[Random().nextInt(Colors.primaries.length)].shade100,
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
            '${AppLocalizations.of(context)!.notesView} : ${per.notes == null ? '____' : per.notes}',
            style: TextStyle(
              fontSize: 15,
              color: Colors.black45,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 15,),
          widget.personType=='MANAGER'? Row(
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
                                    textStyle: Theme.of(context).textTheme.labelLarge,
                                  ),
                                  child: Text('${AppLocalizations.of(context)!.yes}'),
                                  onPressed: () async {
                                    await DioHelper.postData(
                                      url: "api/update-status/${per.id}",
                                      data: {
                                        "status": true,
                                      },
                                    ).then((value) {
                                      setState(() {
                                        permits.permitList?.removeAt(index);
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
                                    textStyle: Theme.of(context).textTheme.labelLarge,
                                  ),
                                  child: Text('${AppLocalizations.of(context)!.no}'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                              mainAxisAlignment: MainAxisAlignment.center,
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
              SizedBox(width: 10,),
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
                                    textStyle: Theme.of(context).textTheme.labelLarge,
                                  ),
                                  child: Text('${AppLocalizations.of(context)!.yes}'),
                                  onPressed: () async {
                                    await DioHelper.postData(
                                      url: "api/update-status/${per.id}",
                                      data: {
                                        "status": false,
                                      },
                                    ).then((value) {
                                      setState(() {
                                        permits.permitList?.removeAt(index);
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
                                    textStyle: Theme.of(context).textTheme.labelLarge,
                                  ),
                                  child: Text('${AppLocalizations.of(context)!.no}'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                              mainAxisAlignment: MainAxisAlignment.center,
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
          ):SizedBox()
        ],
      ),
    );
  }
  Widget buildVacanList({required PermitModel per, required int index, required BuildContext context, }) {
    final DateFormat dateFormat = DateFormat('yyyy-MM-dd');

    // Format date and time
    String formattedFrom = per.from != null ? dateFormat.format(DateTime.parse(per.from!)) : '____';
    String formattedTo = per.to != null ? dateFormat.format(DateTime.parse(per.to!)) : '____';
    print('naaaaaaaaaaaaaaaaaaaaaaame');
    print(per.name);
    print('naaaaaaaaaaaaaaaaaaaaaaame');

    return Container(
      margin: EdgeInsets.all(20),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors
            .primaries[Random().nextInt(Colors.primaries.length)].shade100,
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
                fontSize: 15, color: Colors.black45, fontWeight: FontWeight.bold),
          ),
          Text(
            '${AppLocalizations.of(context)!.timeFrom} : ${formattedFrom}',
            style: TextStyle(
                fontSize: 15, color: Colors.black45, fontWeight: FontWeight.bold),
          ),
          Text(
            '${AppLocalizations.of(context)!.timeTo} :${formattedTo}',
            style: TextStyle(
                fontSize: 15, color: Colors.black45, fontWeight: FontWeight.bold),
          ),
          /* Text(
            'Status : ${per.status}',
            style: TextStyle(
                fontSize: 15, color: Colors.black45, fontWeight: FontWeight.bold),
          ),*/
          Text(
            '${AppLocalizations.of(context)!.notesView} : ${per.notes==null?'____':per.notes}',
            style: TextStyle(
              fontSize: 15,
              color: Colors.black45,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 15,),
          widget.personType=='MANAGER'?Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Color(0xff49796B),
                    borderRadius: BorderRadius.circular(30)
                ),
                child: TextButton(onPressed: (){
                  showDialog<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        //  title: const Text('Basic dialog title'),
                        content:  Text(
                          '${AppLocalizations.of(context)!.accept_excuse}',
                        ),
                        actions:[
                          Row(
                            children: [
                              TextButton(
                                style: TextButton.styleFrom(
                                  textStyle: Theme.of(context).textTheme.labelLarge,
                                ),
                                child:  Text('${AppLocalizations.of(context)!.yes}'),
                                onPressed: () async {
                                  await DioHelper.postData(
                                    url: "api/update-status/${per.id}",
                                    data: {
                                      "status": true,
                                    },
                                  ).then((value) {
                                    setState(() {
                                      permits.permitList?.removeAt(index);
                                    });
                                    print('mbroook');
                                  }).catchError((error){});
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                style: TextButton.styleFrom(
                                  textStyle: Theme.of(context).textTheme.labelLarge,
                                ),
                                child:  Text('${AppLocalizations.of(context)!.no}'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                            mainAxisAlignment: MainAxisAlignment.center,

                          ),
                        ],
                      );
                    },
                  );
                },
                    child: Text('${AppLocalizations.of(context)!.accept}',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    )),
              ),
              SizedBox(width: 10,),
              Container(
                decoration: BoxDecoration(
                    color: Color(0xff49796B),
                    borderRadius: BorderRadius.circular(30)
                ),
                child: TextButton(onPressed: (){
                  showDialog<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        //  title: const Text('Basic dialog title'),
                        content:  Text(
                          '${AppLocalizations.of(context)!.are_denyExcuse}',
                        ),
                        actions: [
                          Row(
                            children: [
                              TextButton(
                                style: TextButton.styleFrom(
                                  textStyle: Theme.of(context).textTheme.labelLarge,
                                ),
                                child:  Text('${AppLocalizations.of(context)!.yes}'),
                                onPressed: () async {
                                  await DioHelper.postData(
                                    url: "api/update-status/${per.id}",
                                    data: {
                                      "status": false,
                                    },
                                  ).then((value) {
                                    setState(() {
                                      permits.permitList?.removeAt(index);
                                    });
                                    print('mbroook');
                                  }).catchError((error){});
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                style: TextButton.styleFrom(
                                  textStyle: Theme.of(context).textTheme.labelLarge,
                                ),
                                child:  Text('${AppLocalizations.of(context)!.no}'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                            // crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                          ),
                        ],
                      );
                    },
                  );
                },
                    child: Text('${AppLocalizations.of(context)!.refuse}',
                      style: TextStyle(
                          color: Colors.white
                      ),
                    )),
              ),
            ],
          ):SizedBox()
        ],
      ),
    );
  }


}

