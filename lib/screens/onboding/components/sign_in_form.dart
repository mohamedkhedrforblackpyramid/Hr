import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_jailbreak_detection/flutter_jailbreak_detection.dart';
import 'package:hr/mainchooseList.dart';
import 'package:hr/modules/organizationmodel.dart';
import 'package:hr/screens/create_organizations.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:rive/rive.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unique_identifier/unique_identifier.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:unique_identifier/unique_identifier.dart';
import 'package:app_settings/app_settings.dart';
import '../../../network/local/cache_helper.dart';
import '../../../network/remote/dio_helper.dart';
import '../../choose_list.dart';
var url;

enum FormData {
  userName,
  password,
}
class SignInForm extends StatefulWidget {
  const SignInForm({
    super.key,
  });

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  String _identifier = 'Unknown';

  bool? _jailbroken;
  bool? _developerMode;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();
  bool ispasswordev = true;
  FormData? selected;
  Color enabledtxt = Colors.white;
  Color deaible = Colors.grey;
  bool isShowLoading = false;
  bool isShowConfetti = false;
  late bool jailbroken;
  late bool developerMode;
  late SMITrigger check;
  late SMITrigger error;
  late SMITrigger reset;
  late SMITrigger confetti;
  int? userID;
  String? name;
  OrganizationsList? orgList;
  late int organizationsId;
  String organizationsName = '';
  String personType = '';
  String organizationsArabicName = '';
  bool _isChecked = false;
  bool settingsLoad = false;
  String versionNow = '1.0.4';
  List <String>? versions;
  StateMachineController getRiveController(Artboard artboard) {
    StateMachineController? controller =
        StateMachineController.fromArtboard(artboard, "State Machine 1");
    artboard.addController(controller!);
    return controller;
  }
  Future<void> initUniqueIdentifierState() async {
    String? identifier;
    try {
      identifier = await UniqueIdentifier.serial;
    } on PlatformException {
      identifier = 'Failed to get Unique Identifier';
    }
    if (!mounted) return;
    setState(() {
      _identifier = identifier!;
    });
  }


  void getSettings() {
    DioHelper.getData(
      url: "api/settings",
    ).then((response) {
      print(response.data);

      if(response.data['app.version'].contains(versionNow)){

      }else{
        url = response.data['app.download'];
        print(url);
        showDialog(
          context: context,
          builder: (BuildContext context) => UpdateAlert(),
        );
      }
      setState(() {
      });
    }).catchError((error) {
      print(error.response.data);
    });
  }


  Future? userLogin({
    required String name,
    required String password,
  }) async {
    setState(() {
      isShowLoading = true;
      isShowConfetti = true;
    });
    print("sending");
    /*  print(name);
    print(password);*/

    await DioHelper.postData(
      url: "api/auth/login",
      data: {
        "name": name,
        "password": password,
        'fcm_token':CacheHelper.getData(
            key: 'fcm_token')
      },
    ).then((Response response) {
      print(_identifier);
      name = response.data['data']['user']['name'];
      CacheHelper.saveData(
          key: "name", value: response.data['data']['user']['name']);
      // print(response.data['data']['token']);
      userID = response.data['data']['user']['id'];
      CacheHelper.saveData(key: "token", value: response.data['token']);
      print(response.data['data']['organizations']);

      orgList =
          OrganizationsList.fromJson(response.data['data']['organizations']);
      if(orgList!.organizationsListt!.length==0){
        CacheHelper.getData(key: 'token');
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CreateOrganizations(
                    userId: userID,
                    )));
      }
      else{
        print(CacheHelper.getData(
            key: 'fcm_token'));
        CacheHelper.getData(key: 'token');
      organizationsName = response.data['data']['organizations'][0]['name'];
      organizationsArabicName =
          response.data['data']['organizations'][0]['name_ar'];
      organizationsId = response.data['data']['organizations'][0]['id'];
      personType = response.data['data']['organizations'][0]['type'];
      print(personType);

      // print(userID);
      //  print(response.data);

      Future.delayed(Duration(seconds: 1), () {
        if (_formKey.currentState!.validate()) {
          // show success
          check.fire();
          Future.delayed(Duration(seconds: 1), () {
            setState(() {
              isShowLoading = false;
            });
            confetti.fire();
            DioHelper.getData(
              url: "api/settings",
            ).then((response) {
              print(response.data);

              if(response.data['app.version'].contains(versionNow)){
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MainPage(
                          userId: userID,
                          oranizaionsList: orgList!,
                          organizationId: organizationsId,
                          organizationsName: organizationsName,
                          organizationsArabicName: organizationsArabicName, personType: personType,)));

              }else{
                url = response.data['app.download'];
                print(url);
                showDialog(
                  context: context,
                  builder: (BuildContext context) => UpdateAlert(),
                );
              }
              setState(() {
              });
            }).catchError((error) {
              print(error.response.data);
            });
          });
        }
      });

      CacheHelper.saveData(key: "token", value: response.data['data']['token']);
    }}).catchError((error) async {
      print(error);
      print(error.response.data);
      await Alert(
        context: context,
        // title: "RFLUTTER ALERT",
        desc: "user name or password is not correct .. Try Again",
      ).show();
      isShowLoading = false;
      setState(() {
        isShowLoading = false;
      });
    });
  }


  void handleRemeberme(value) {
    print("Handle Rember Me");
    _isChecked = value;
    SharedPreferences.getInstance().then(
          (prefs) {
        prefs.setBool("remember_me", value);
        prefs.setString('name', userNameController.text);
        prefs.setString('password', passwordController.text);
      },
    );
    setState(() {
      _isChecked = value;

    });
  }
  void loadUserEmailPassword() async {
    print("Load Email");
    try {
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      var name = _prefs.getString("name") ?? "";
      var password = _prefs.getString("password") ?? "";
      var _remeberMe = _prefs.getBool("remember_me") ?? false;
      print(password);
      print("1111111");
      print(_remeberMe);
      if (_remeberMe) {
        setState(() {
          _isChecked = true;
        });
        userNameController.text = name ?? "";
        passwordController.text = password ?? "";
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
   // initPlatformState();
    loadUserEmailPassword();
    initUniqueIdentifierState();
  //  getSettings();
    super.initState();
  }

  /*Future<void> initPlatformState() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      jailbroken = await FlutterJailbreakDetection.jailbroken;
      developerMode = await FlutterJailbreakDetection.developerMode;
    } on PlatformException {
      jailbroken = true;
      developerMode = false;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _jailbroken = jailbroken;
      _developerMode = developerMode;
    });
  }*/


  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${AppLocalizations.of(context)!.userName}",
                  style: TextStyle(color: Colors.black54),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 16),
                  child: TextFormField(
                    controller: userNameController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "";
                      }
                      return null;
                    },
                    onSaved: (email) {},
                    decoration: const InputDecoration(
                        prefixIcon: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Icon(
                        Icons.account_box_sharp,
                        color: Colors.pinkAccent,
                      ),
                    )),
                  ),
                ),
                Text(
                  "${AppLocalizations.of(context)!.password}",
                  style: TextStyle(color: Colors.black54),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 16),
                  child: TextFormField(
                    controller: passwordController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "";
                      }
                      return null;
                    },
                    onSaved: (password) {},
                    obscureText: ispasswordev,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        icon: ispasswordev==false
                            ? Icon(
                          Icons.visibility_off,
                          color: selected == FormData.password
                              ? enabledtxt
                              : deaible,
                          size: 20,
                        )
                            : Icon(
                          Icons.visibility,
                          color: selected == FormData.password
                              ? enabledtxt
                              : deaible,
                          size: 20,
                        ),
                        onPressed: () => setState(
                                () => ispasswordev = !ispasswordev),
                      ),
                      prefixIcon: Icon(Icons.lock,
                        color: Colors.pinkAccent,

                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.only(left: 25),
                  child: Row(mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                            height: 24.0,
                            width: 24.0,
                            child: Theme(
                              data: ThemeData(
                                  unselectedWidgetColor: Color(0xff00C8E8) // Your color
                              ),
                              child: Checkbox(
                                  activeColor: Colors.redAccent,
                                  value: _isChecked,
                                  onChanged: handleRemeberme),
                            )),
                        SizedBox(width: 10.0),
                        Text("Remember Me",
                            textScaleFactor: 1.0,
                            style: TextStyle(
                                color: Color(0xff646464),
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Rubic'))
                      ]),
                ),
                SizedBox(height: 20,),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 24),
                  child: ElevatedButton.icon(
                      onPressed: () async {
                        _isChecked==true? handleRemeberme(true):null;
                        userLogin(
                            name: userNameController.text,
                            password: passwordController.text);

                        //     signIn(context);
                        /*if(developerMode == false) {
                          userLogin(name: userNameController.text,
                              password: passwordController.text);
                        }else{
                        await Alert(
                          context: context,
                          // title: "RFLUTTER ALERT",
                          desc: "Close Developer Mode",
                        ).show();
                        }*/
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF77D8E),
                          minimumSize: const Size(double.infinity, 56),
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(25),
                                  bottomRight: Radius.circular(25),
                                  bottomLeft: Radius.circular(25)))),
                      icon: Icon(
                          AppLocalizations.of(context)!.localeName == 'ar'
                              ? CupertinoIcons.arrow_left
                              : CupertinoIcons.arrow_right),
                      label: Text("${AppLocalizations.of(context)!.signIn}")),
                ),
              ],
            )),
        isShowLoading
            ? CustomPositioned(
                child: RiveAnimation.asset(
                "assets/RiveAssets/check.riv",
                onInit: (artboard) {
                  StateMachineController controller =
                      getRiveController(artboard);
                  check = controller.findSMI("Check") as SMITrigger;
                  error = controller.findSMI("Error") as SMITrigger;
                  reset = controller.findSMI("Reset") as SMITrigger;
                },
              ))
            : const SizedBox(),
        isShowConfetti
            ? CustomPositioned(
                child: Transform.scale(
                scale: 6,
                child: RiveAnimation.asset(
                  "assets/RiveAssets/confetti.riv",
                  onInit: (artboard) {
                    StateMachineController controller =
                        getRiveController(artboard);
                    confetti =
                        controller.findSMI("Trigger explosion") as SMITrigger;
                  },
                ),
              ))
            : const SizedBox()
      ],
    );
  }
}

class CustomPositioned extends StatelessWidget {
  const CustomPositioned({super.key, required this.child, this.size = 100});
  final Widget child;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Column(
        children: [
          Spacer(),
          SizedBox(
            height: size,
            width: size,
            child: child,
          ),
          Spacer(flex: 2),
        ],
      ),
    );
  }

}

class UpdateAlert extends StatefulWidget {
  @override
  State<UpdateAlert> createState() => _UpdateAlertState();
}

class _UpdateAlertState extends State<UpdateAlert> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      backgroundColor: Colors.white,
      title: Column(
        children: [
          Icon(
            Icons.update,
            color: Colors.blue,
            size: 40.0,
          ),
          SizedBox(height: 16.0),
          Text(
            'Update required',
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      content: Text(
        'There is a new version of the app. Please update the app to benefit from new features and improvements',
        textAlign: TextAlign.center,
      ),
      actions: <Widget>[
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
          child: Text('Update Now'),
          onPressed: () async {
            print(url);

            await launch(url,
            enableJavaScript: true, universalLinksOnly: false);

          },
        ),
        TextButton(
          child: Text('Later'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
