import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hr/modules/permitmodel.dart';
import 'package:rive/rive.dart';

import '../network/local/cache_helper.dart';
import '../network/remote/dio_helper.dart';
import 'onboding/components/animated_btn.dart';

class ShowVacances extends StatefulWidget {
  const ShowVacances({super.key});

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
      url: "api/vacancies/",
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
                                  index: index),
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
}

Widget buildpermitList({required PermitModel per, required int index}) {
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
          'User Name : ',
          style: TextStyle(
              fontSize: 15, color: Colors.black45, fontWeight: FontWeight.bold),
        ),
        Text(
          'Time From : ${per.from}',
          style: TextStyle(
              fontSize: 15, color: Colors.black45, fontWeight: FontWeight.bold),
        ),
        Text(
          'Time To :${per.to}',
          style: TextStyle(
              fontSize: 15, color: Colors.black45, fontWeight: FontWeight.bold),
        ),
        Text(
          'Status : ${per.status}',
          style: TextStyle(
              fontSize: 15, color: Colors.black45, fontWeight: FontWeight.bold),
        ),
        Text(
          'Notes : ${per.notes==null?'____':per.notes}',
          style: TextStyle(
            fontSize: 15,
            color: Colors.black45,
            fontWeight: FontWeight.bold,
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Colors.indigo,
                  borderRadius: BorderRadius.circular(30)
              ),
              child: TextButton(onPressed: (){},
                  child: Text('Accept',
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
              child: TextButton(onPressed: (){},
                  child: Text('Refuse',
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
