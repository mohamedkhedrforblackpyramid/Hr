import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hr/main.dart';
import 'package:hr/network/local/cache_helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'components/custom_sign_in.dart';

// تعريف الألوان بشكل موحد
const Color primaryColor = Color(0xff003366);
const Color accentColor = Color(0xff009688);
const Color backgroundColor = Color(0xffE0F2F1); // لون خلفية ناعم

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  bool shouldPop = false;
  bool isSignInDialogShown = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return shouldPop;
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: SafeArea(
          child: Stack(
            children: [
              Positioned(
                width: MediaQuery.of(context).size.width,
                bottom: 0,
                child: Image.asset(
                  'assets/Backgrounds/Spline.png',
                  fit: BoxFit.cover,
                ),
              ),
              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: const SizedBox(),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: AppLocalizations.of(context)!.localeName == 'ar'
                        ? Alignment.topLeft
                        : Alignment.topRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MyApp(
                              lang: AppLocalizations.of(context)!.localeName == 'ar'
                                  ? 'en'
                                  : 'ar',
                            ),
                          ),
                        );
                        getOutOfApp();
                      },
                      child: Text(
                        AppLocalizations.of(context)!.localeName == 'ar' ? 'English' : 'عربي',
                        style: TextStyle(color: accentColor, fontSize: 18),
                      ),
                    ),
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${AppLocalizations.of(context)!.alexforProg}",
                          style: TextStyle(
                            fontSize: 28,
                            fontFamily: "Poppins",
                            height: 1.3,
                            color: primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          "${AppLocalizations.of(context)!.nowYouCan}",
                          style: TextStyle(
                            fontSize: 20,
                            color: primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 40),
                        _buildFeatureText('- Mobile Applications'),
                        _buildFeatureText('- Web Applications'),
                        _buildFeatureText('- Desktop Applications'),
                        _buildFeatureText('- Networking and Security'),
                      ],
                    ),
                  ),
                  Spacer(),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white, backgroundColor: accentColor,
                        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          isSignInDialogShown = true;
                        });
                        customSigninDialog(context, onClosed: (_) {
                          setState(() {
                            isSignInDialogShown = false;
                          });
                        });
                      },
                      child: Text(
                        'Get Started',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Column(
                        children: [
                          Text(
                            "Version Date : 29/08/2024",
                            style: TextStyle(
                              fontSize: 17,
                              fontFamily: "Poppins",
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Version: 1.0.4",
                            style: TextStyle(
                              fontSize: 17,
                              fontFamily: "Poppins",
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureText(String text) {
    return Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20,
        color: primaryColor,
      ),
    );
  }

  void getOutOfApp() {
    if (Platform.isIOS) {
      try {
        exit(0);
      } catch (e) {
        SystemNavigator.pop(); // for iOS, this might not work consistently
      }
    } else {
      try {
        SystemNavigator.pop(); // sometimes it might not exit the app
      } catch (e) {
        exit(0); // fallback if pop fails
      }
    }
  }
}
