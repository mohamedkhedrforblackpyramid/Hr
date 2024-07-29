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
                                    fontSize: 25,
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
                                    fontSize: 17,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              /*TextButton(
                                  onPressed: () async {
                                    await Clipboard.setData(ClipboardData(
                                        text: CacheHelper.getData(
                                            key: 'fcm_token')));
                                  },
                                  child: const Text('Clic to copy your fcm token')),*/
                            ]),
                          ),
                          const Spacer(
                            flex: 5,
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
                            padding: EdgeInsets.symmetric(vertical: 20.0),
                            child: Text(
                              '- Mobile Applications',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 10.0),
                            child: Text(
                              '- Web Applications',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 10.0),
                            child: Text(
                              '- Desktop  Applications',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 10.0),
                            child: Text(
                              '- Networking and Security',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                          ),

                          SizedBox(height: 100,),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: Text(
                                "Version Date : 28/07/2024",
                                style: TextStyle(
                                    fontSize: 17,
                                    fontFamily: "Poppins",
                                    height: 1.2,
                                    color: Colors.white70,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: Text(
                                "Version: 1.0.0",
                                style: TextStyle(
                                    fontSize: 17,
                                    fontFamily: "Poppins",
                                    height: 1.2,
                                    color: Colors.white70,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
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
        SystemNavigator
            .pop(); // for IOS, not true this, you can make comment this :)
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
