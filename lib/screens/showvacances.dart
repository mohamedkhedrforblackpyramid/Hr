import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hr/modules/permitmodel.dart';
import 'package:intl/intl.dart';
import 'package:rive/rive.dart';

import '../network/local/cache_helper.dart';
import '../network/remote/dio_helper.dart';
import 'onboding/components/animated_btn.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class ShowVacances extends StatefulWidget {
  int? userId;
  int?organizationId;
   ShowVacances({
   required this.userId,
   required this.organizationId});

  @override
  State<ShowVacances> createState() => _ShowVacancesState();
}

class _ShowVacancesState extends State<ShowVacances> {
  bool shouldPop = false;
  bool isSignInDialogShown = false;
  late RiveAnimationController _btnAnimationController;
  late PermitList permits;
  bool permitLoading = false;

  getinfo() {
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
    getinfo();
    print(    CacheHelper.getData(key: 'token'));

    _btnAnimationController = OneShotAnimation("active", autoplay: false);

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
                      permits.permitList!.isNotEmpty
                          ? SizedBox(
                        height: MediaQuery.of(context).size.height,
                        child: ListView.builder(
                          // shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemBuilder:
                              (BuildContext context, int index) =>
                              buildpermitList(
                                  per: permits.permitList![index],
                                  index: index,
                                context: context
                              ),
                          itemCount: permits.permitList!.length,
                        ),
                      )
                          : Padding(
                        padding: const EdgeInsets.symmetric(vertical: 300),
                        child: Center(
                          child: Text(
                            "No Requests Vacances",
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
  Widget buildpermitList({required PermitModel per, required int index, required BuildContext context, }) {
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
        color: Colors.green.shade100,
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Colors.brown.shade300,
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
                    color: Colors.brown.shade300,
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
          )
        ],
      ),
    );
  }

}

