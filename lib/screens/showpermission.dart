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
  int?organizationId;
  String?personType;
   int? vacancesCount;
   int? permitsPermission;
  final dynamic oranizaionsList;
  String? organizationsName;
  String? organizationsArabicName;





  Showpermit({ required this.userId,
    required this.personType,
     required this.organizationId,
    required this.vacancesCount,
    required this.permitsPermission,
    required this.oranizaionsList,
    required this.organizationsName,
    required this.organizationsArabicName
  });

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

  getPermissions() {
    permitLoading = true;
    DioHelper.getData(
      url: "api/vacancies?organization_id=${widget.organizationId}&is_permit=1",
    ).then((response) {
      permits = PermitList.fromJson(response.data['data']);
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
      url: "api/vacancies?organization_id=${widget.organizationId}&is_permit=0",
    ).then((response) {
      permits = PermitList.fromJson(response.data['data']);
      setState(() {
        permitLoading = false;
      });

    }).catchError((error) {
      print(error.response);
    });
  }


  @override
  void initState() {
    print(CacheHelper.getData(key: 'token'));
    _btnAnimationController = OneShotAnimation("active", autoplay: false);
    print('jjjjjjjjjjjjjjjjjjjjjjjjjjjj');
    print(widget.vacancesCount);
    print(widget.permitsPermission);
    print('jjjjjjjjjjjjjjjjjjjjjjjjjjjj');

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
                                          child: Column(
                                            children: [
                                              Text(
                                                'Permissions',
                                                style: TextStyle(color: Colors.grey[700], fontSize: 15,
                                                  fontWeight: FontWeight.bold
                                                ),
                                              ),
                                              SizedBox(height: 20,),
                                           widget.personType=='MANAGER'?   Text(
                                                '${widget.permitsPermission!=0?widget.permitsPermission:''}',
                                                style: TextStyle(color: Colors.deepPurple, fontSize: 20,
                                                    fontWeight: FontWeight.bold
                                                ),
                                              ):SizedBox(),
                                            ],
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
                                          child: Column(
                                            children: [
                                              Text(
                                                'Vacances',
                                                style: TextStyle(color: Colors.grey[700], fontSize: 15,
                                                    fontWeight: FontWeight.bold

                                                ),
                                              ),
                                              SizedBox(height: 20,),

                                             widget.personType=='MANAGER'? Text(
                                                '${widget.vacancesCount!=0? widget.vacancesCount:''}',
                                                style: TextStyle(color: Colors.deepPurple, fontSize: 20,
                                                    fontWeight: FontWeight.bold

                                                ),
                                              ):SizedBox(),
                                            ],
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
                              //height: MediaQuery.of(context).size.height,
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
  }
  Widget buildPermitList({
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
          SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Status : ',
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
                  color:per.status=='APPROVED'? Colors.green:per.status=="REFUSED"?Colors.red:Color(0xffFFA500),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 15,),
          widget.personType=='MANAGER'?
          per.status=='PENDING'?Row(
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
                                        getPermissions();
                                      //  permits.permitList?.removeAt(index);
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
              :SizedBox()
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
          SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Status : ',
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
                  color:per.status=='APPROVED'? Colors.green:per.status=="REFUSED"?Colors.red:Color(0xffFFA500),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          SizedBox(height: 15,),
          widget.personType=='MANAGER'?
         per.status=='PENDING'? Row(
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
                                      getVecan();
                                    //  permits.permitList?.removeAt(index);
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
                                      getVecan();
                                     // permits.permitList?.removeAt(index);
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
             :SizedBox()
        ],
      ),
    );
  }


}

