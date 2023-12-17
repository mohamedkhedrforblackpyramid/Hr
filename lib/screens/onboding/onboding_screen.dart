import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hr/main.dart';
import 'package:hr/network/local/cache_helper.dart';
import 'package:rive/rive.dart';

import 'components/custom_sign_in.dart';
import 'components/animated_btn.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
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
    return WillPopScope(
      onWillPop: () async {
        return shouldPop;
      },
      child: Scaffold(
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
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppLocalizations.of(context)!.localeName == 'ar'
                              ? Align(
                                  alignment: Alignment.topLeft,
                                  child: TextButton(
                                    onPressed: () {
                                      print('hello');
                                      // CacheHelper.getData(key: 'language');
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                        return MyApp(lang: 'en');
                                      }));
                                      // AppLocalizations.of(context).localeName = 'en';
                                      getOutOfApp();
                                    },
                                    child: Text(
                                      'English',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                  ),
                                )
                              : Align(
                                  alignment: Alignment.topRight,
                                  child: TextButton(
                                    onPressed: () {
                                      print('hello');
                                      // CacheHelper.getData(key: 'language');
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                        return MyApp(lang: 'ar');
                                      }));
                                      // AppLocalizations.of(context).localeName = 'en';
                                      getOutOfApp();

                                    },
                                    child: Text(
                                      'عربي',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                  ),
                                ),
                          Spacer(),
                          SizedBox(
                            width: 260,
                            child: Column(children: [
                              Text(
                                "${AppLocalizations.of(context)!.alexforProg}",
                                style: TextStyle(
                                    fontSize: 35,
                                    fontFamily: "Poppins",
                                    height: 1.2,
                                    color: Colors.white),
                              ),
                              SizedBox(
                                height: 16,
                              ),
                              Text(
                                "${AppLocalizations.of(context)!.nowYouCan}",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              )
                            ]),
                          ),
                          const Spacer(
                            flex: 2,
                          ),
                          AnimatedBtn(
                            btnAnimationController: _btnAnimationController,
                            press: () {
                              _btnAnimationController.isActive = true;
                              Future.delayed(Duration(milliseconds: 800), () {
                                setState(() {
                                  isSignInDialogShown = true;
                                });
                                customSigninDialog(context, onClosed: (_) {
                                  setState(() {
                                    isSignInDialogShown = false;
                                  });
                                });
                              });
                            },
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 40.0),
                            child: Text(
                              '${AppLocalizations.of(context)!.companyInfo}',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                          )
                        ]),
                  ),
                ),
              )
            ],
          )),
    );
  }
  void getOutOfApp() {

  if (Platform.isIOS) {

  try {
  exit(0);
  } catch (e) {
  SystemNavigator.pop(); // for IOS, not true this, you can make comment this :)
  }

  } else {

  try {
  SystemNavigator.pop(); // sometimes it cant exit app
  } catch (e) {
  exit(0); // so i am giving crash to app ... sad :(
  }

  }
}
}
