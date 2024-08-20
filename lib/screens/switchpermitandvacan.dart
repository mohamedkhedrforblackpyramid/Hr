import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hr/screens/showpermission.dart';
import 'package:hr/screens/showvacances.dart';
import 'package:rive/rive.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


import 'onboding/components/animated_btn.dart';


class SwitchShowpermitAndVacan extends StatefulWidget {
  int? userId;
  int?organizationId;

  SwitchShowpermitAndVacan({
    required this.userId,
    required this.organizationId
});

  @override
  State<SwitchShowpermitAndVacan> createState() => _SwitchShowpermitAndVacanState();
}

class _SwitchShowpermitAndVacanState extends State<SwitchShowpermitAndVacan> {
  bool shouldPop = false;

  bool isSignInDialogShown = false;
  late RiveAnimationController _btnAnimationController;

  @override
  void initState() {
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
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 150),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Center(
                                  child: Container(
                                    width: double.infinity/2,
                                    color:  Color(0xFF0E3311).withOpacity(0.5),
                                    child: TextButton(onPressed: ()async{
                                     await   Navigator.push(context,
                                            MaterialPageRoute(builder: (context) =>  Showpermit(
                                              organizationId: widget.organizationId,
                                              userId: widget.userId, personType: '',
                                            )));

                                    },
                                        child: Text('${AppLocalizations.of(context)!.excuse}',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 35
                                          ),
                                        )),
                                  ),
                                ),
                              ),
                              SizedBox(height: 70,),
                              Padding(
                                padding: const EdgeInsets.all(20),
                                child: Center(
                                  child: Container(
                                    width: double.infinity/2,
                                    color:  Color(0xFF0E3311).withOpacity(0.5),
                                    child: TextButton(onPressed: () async {
                                      await   Navigator.push(context,
                                          MaterialPageRoute(builder: (context) =>  ShowVacances(
                                            userId: widget.userId,
                                            organizationId: widget.organizationId,
                                          )));
                                    },
                                        child: Text('${AppLocalizations.of(context)!.vacances}',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 35
                                          ),
                                        )),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ]),
                ),
              ),
            )
          ],
        ));
  }
}
