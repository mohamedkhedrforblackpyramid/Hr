import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hr/modules/organizationmodel.dart';
import 'package:hr/screens/attendance.dart';
import 'package:hr/screens/choose_list.dart';
import 'package:hr/screens/holiday_permission.dart';
import 'package:hr/screens/onboding/onboding_screen.dart';
import 'package:hr/screens/excusepermission.dart';
import 'package:hr/screens/showpermission.dart';
import 'package:hr/screens/switchpermitandvacan.dart';
import 'package:hr/screens/multiscreen_tasks/multiscreenfortasks.dart';
import 'package:hr/screens/timepicker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'network/local/cache_helper.dart';
import 'network/remote/dio_helper.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';


class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DioHelper.init();
  await CacheHelper.init();
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  runApp( MyApp(lang: '${CacheHelper.getData(key: 'language')}',));
}

class MyApp extends StatefulWidget {
  String lang ;
   MyApp({required this.lang});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  void initState() {
    CacheHelper.getData(key: 'language');


    super.initState();
  }
  @override
  Widget build(BuildContext context) {
     CacheHelper.saveData(key: 'language', value: '${widget.lang}');
     print(widget.lang);
    return MaterialApp(
      //locale:  Locale(CacheHelper.getData(key: 'language')),
      locale: Locale(widget.lang),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('ar'),
      ],
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xFFEEF1F8),
        primarySwatch: Colors.blue,
        fontFamily: "Intel",
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          errorStyle: TextStyle(height: 0),
          border: defaultInputBorder,
          enabledBorder: defaultInputBorder,
          focusedBorder: defaultInputBorder,
          errorBorder: defaultInputBorder,
        ),
      ),
      home:OnboardingScreen(),
    );
  }
}

const defaultInputBorder = OutlineInputBorder(
  borderRadius: BorderRadius.all(Radius.circular(16)),
  borderSide: BorderSide(
    color: Color(0xFFDEE3F2),
    width: 1,
  ),
);
