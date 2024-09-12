import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hr/screens/maps.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:hr/screens/onboding/onboding_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'network/local/cache_helper.dart';
import 'network/locale_provider.dart';
import 'network/remote/dio_helper.dart';

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

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    final fcmToken = await FirebaseMessaging.instance.getToken();
    CacheHelper.saveData(key: 'fcm_token', value: fcmToken);
  } catch (e) {
    print("Failed to initialize Firebase: $e");
    CacheHelper.saveData(key: 'fcm_token', value: 'No Firebase Token');
  }

  runApp(

      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => LocaleProvider()),

        ],
          child: MyApp(lang: '${CacheHelper.getData(key: 'language')}',)));
}

class MyApp extends StatefulWidget {
  String lang;
  MyApp({required this.lang});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool shouldPop = false;

  @override
  void initState() {
    CacheHelper.getData(key: 'language');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    CacheHelper.saveData(key: 'language', value: '${widget.lang}');
    print(widget.lang);
    final provider = Provider.of<LocaleProvider>(context);


    return WillPopScope(
      onWillPop: () async {
        return shouldPop;
      },
      child: MaterialApp(

        locale: provider.locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,

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
        home: CompanyLocationPage(),
      ),
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
