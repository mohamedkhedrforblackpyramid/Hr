import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hr/modules/permitmodel.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:rive/rive.dart';

import '../network/local/cache_helper.dart';
import '../network/remote/dio_helper.dart';
import 'onboding/components/animated_btn.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class Showpermit extends StatefulWidget {
  int? userId;
  int?organizationId;
   Showpermit({ required this.userId,
     required this.organizationId});

  @override
  State<Showpermit> createState() => _ShowpermitState();
}

class _ShowpermitState extends State<Showpermit> {
  bool shouldPop = false;
  bool isSignInDialogShown = false;
  late RiveAnimationController _btnAnimationController;
   late PermitList permits;
  bool permitLoading = false;

  getinfo() {
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

  @override
  void initState() {
    print(CacheHelper.getData(key: 'token'));

    _btnAnimationController = OneShotAnimation("active", autoplay: false);
    getinfo();


    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xff1A6293),
        body: Stack(
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
                                            index: index, context: context),
                                itemCount: permits.permitList!.length,
                              ),
                            )
                          : Padding(
                            padding: const EdgeInsets.symmetric(vertical: 300),
                            child: Center(
                              child: Text(
                                  "No Requests permissions",
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
    print('naaaaaaaaaaaaaaaaaaaaaaame');
    print(per.name);
    print('naaaaaaaaaaaaaaaaaaaaaaame');

    return Container(
      margin: EdgeInsets.all(20),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.deepOrangeAccent[200],
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
            '${AppLocalizations.of(context)!.timeFrom} : ${per.from}',
            style: TextStyle(
                fontSize: 15, color: Colors.black45, fontWeight: FontWeight.bold),
          ),
          Text(
            '${AppLocalizations.of(context)!.timeTo} :${per.to}',
            style: TextStyle(
                fontSize: 15, color: Colors.black45, fontWeight: FontWeight.bold),
          ),
      /*    Text(
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
                    color: Colors.indigo,
                    borderRadius: BorderRadius.circular(30)
                ),
                child: TextButton(onPressed: (){
                  showDialog<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        //  title: const Text('Basic dialog title'),
                        content:  Text(
                          '${AppLocalizations.of(context)!.accept_permission}',
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
                                    formData: {
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
                    color: Colors.indigo,
                    borderRadius: BorderRadius.circular(30)
                ),
                child: TextButton(onPressed: (){
                  showDialog<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        //  title: const Text('Basic dialog title'),
                        content:  Text(
                          '${AppLocalizations.of(context)!.are_denyPermission}',
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
                                    formData: {
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

