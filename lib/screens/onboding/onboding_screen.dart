import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:hr/main.dart';
import 'package:hr/network/local/cache_helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart'; // استيراد حزمة Spinkit
import 'package:animations/animations.dart'; // استيراد حزمة Animations
import 'package:url_launcher/url_launcher.dart'; // استيراد حزمة url_launcher

import '../../network/locale_provider.dart';
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
  bool isLoading = false; // متغير لتحديد حالة التحميل

  @override
  void initState() {
    super.initState();
    _loadLocale();
  }

  void _loadLocale() async {
    final savedLocale = CacheHelper.getData(key: 'locale');
    if (savedLocale != null) {
      Locale newLocale = Locale(savedLocale);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Provider.of<LocaleProvider>(context, listen: false).setLocale(newLocale);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LocaleProvider>(context);

    return WillPopScope(
      onWillPop: () async {
        _saveLocale();
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
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 800),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  final tween = Tween<Offset>(begin: Offset(1.0, 0.0), end: Offset.zero);
                  final offsetAnimation = animation.drive(tween.chain(CurveTween(curve: Curves.easeInOut)));

                  return SlideTransition(
                    position: offsetAnimation,
                    child: FadeTransition(
                      opacity: animation,
                      child: child,
                    ),
                  );
                },
                child: _buildContent(context, provider),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, LocaleProvider provider) {
    return Column(
      key: ValueKey<String>(AppLocalizations.of(context)!.localeName), // مفتاح فريد لكل حالة محلية
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: AppLocalizations.of(context)!.localeName == 'ar'
              ? Alignment.topLeft
              : Alignment.topRight,
          child: TextButton(
            onPressed: () {
              setState(() {
                isLoading = true; // بدء التحميل
              });

              final currentLocale = AppLocalizations.of(context)!.localeName;
              if (currentLocale == 'ar') {
                provider.setLocale(Locale('en'));
                CacheHelper.saveData(key: 'locale', value: 'en');
              } else {
                provider.setLocale(Locale('ar'));
                CacheHelper.saveData(key: 'locale', value: 'ar');
              }

              Future.delayed(Duration(seconds: 1), () {
                setState(() {
                  isLoading = false; // إيقاف التحميل
                });
              });
            },
            child: isLoading
                ? SpinKitCircle(
              color: accentColor,
              size: 30.0,
            )
                : Text(
              AppLocalizations.of(context)!.localeName == 'ar'
                  ? 'English'
                  : 'عربي',
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
              _buildFeatureText('- ${AppLocalizations.of(context)!.mobile_applications}'),
              _buildFeatureText('- ${AppLocalizations.of(context)!.web_app}'),
              _buildFeatureText('- ${AppLocalizations.of(context)!.desktop_app}'),
              _buildFeatureText('- ${AppLocalizations.of(context)!.network}'),
            ],
          ),
        ),
        Spacer(),

        Center(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: accentColor,
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 5, // إضافة ظل للزر
              shadowColor: Colors.black.withOpacity(0.3), // لون ظل الزر
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
              '${AppLocalizations.of(context)!.getstarted}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Spacer(),
        Center(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.black,
              backgroundColor: Colors.transparent,
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 8, // إضافة ظل للزر
              shadowColor: Colors.black.withOpacity(0.4), // لون ظل الزر
            ),
            onPressed: () async {
              final url = 'https://alex4prog.com';
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                throw 'Could not launch $url';
              }
            },
            child: Text(
              '${AppLocalizations.of(context)!.aboutUs} alex4prog.com',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2, // تباعد بين الحروف
              ),
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              children: [
                Text(
                  "${AppLocalizations.of(context)!.versionDate} : 08/09/2024",
                  style: TextStyle(
                    fontSize: 17,
                    fontFamily: "Poppins",
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "${AppLocalizations.of(context)!.version}: 1.0.6",
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

  void _saveLocale() {
    final currentLocale = AppLocalizations.of(context)!.localeName;
    CacheHelper.saveData(key: 'locale', value: currentLocale);
  }

  void getOutOfApp() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _saveLocale();
      if (Platform.isIOS) {
        try {
          exit(0);
        } catch (e) {
          SystemNavigator.pop();
        }
      } else {
        try {
          SystemNavigator.pop();
        } catch (e) {
          exit(0);
        }
      }
    });
  }
}
