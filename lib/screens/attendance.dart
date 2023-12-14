import 'dart:ui';

import 'package:app_settings/app_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gradient_slide_to_act/gradient_slide_to_act.dart';
import 'package:hr/modules/organizationmodel.dart';
import 'package:hr/screens/choose_list.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:rive/rive.dart';

import '../network/local/cache_helper.dart';
import '../network/remote/dio_helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'onboding/onboding_screen.dart';

class Attendance extends StatefulWidget {
  int? userId;
  int?organizationId;
  String? organizationsName;
  late OrganizationsList oranizaionsList;
  String?organizationsArabicName;



  Attendance({required this.userId,
    required this.organizationId,
    required this.organizationsName,
    required this.oranizaionsList,
    required this.organizationsArabicName


  });
  @override
  State<Attendance> createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> with WidgetsBindingObserver {

  double lat = 0.0;
  double long = 0.0;
  bool shouldPop = false;
  bool isSignInDialogShown = false;
  late RiveAnimationController _btnAnimationController;
  String? _currentAddress;
  Position? _currentPosition;
  bool clickAttend = false;
  bool clickdepar = false;
  var attenKey = GlobalKey();
  var attenKeyAgain = GlobalKey();
  var depKey = GlobalKey();
  var depKeyAgain = GlobalKey();
  bool loadingShowAttend = false;
  bool loadingShowDep = false;
 late  String status = '';

  Future<void> checkAttendace() async {
   await DioHelper.getData(
      url: "api/organizations/${widget.organizationId}/attendance/check",
    ).then((response) {
      status = response.data['status'];
      print(status);
      setState(() {
      });
    }).catchError((error){
      print(error);
    });
   print(status);

  }
  getinfo() async {
    await DioHelper.getData(
      url: "api/vacancies",
    ).then((response) {
      print(response.data);
      setState(() {
      });
    }).catchError((error){
      print(error.response.data);
    });

  }




  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();

    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => _currentPosition = position);
      _getAddressFromLatLng(_currentPosition!);
    }).catchError((e) {
      debugPrint(e);
    });
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(
            _currentPosition!.latitude, _currentPosition!.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
        _currentAddress =
            '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
      });
    }).catchError((e) {
      debugPrint(e);
    });
  }

  Future<Position> _determinePosition() async {
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      AppSettings.openAppSettings(type: AppSettingsType.location);
      if (serviceEnabled == false) {
        print(serviceEnabled);
      } else {
        setState(() {});
      }

      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  Future<Position> _determinePositionNoSetting() async {
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (serviceEnabled == false) {
        setState(() {});
        print(serviceEnabled);
      } else {
        setState(() {});
      }

      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  @override
  void initState() {
    checkAttendace();
    getinfo();
    WidgetsBinding.instance.addObserver(this);
    _determinePositionNoSetting();

    _btnAnimationController = OneShotAnimation("active", autoplay: false);
    super.initState();
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.inactive:
        print('appLifeCycleState inactive');
        break;
      case AppLifecycleState.resumed:
        setState(() {
          _determinePositionNoSetting();
          print(serviceEnabled);
        });
        break;
      case AppLifecycleState.paused:
        print('appLifeCycleState paused');
        setState(() {
          serviceEnabled = true;
        });
        break;

      case AppLifecycleState.detached:
        print('appLifeCycleState paused');
        break;
      case AppLifecycleState.hidden:
        print('appLifeCycleState paused');
        break;
    }
  }

  bool serviceEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Form(
            child: Stack(
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
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          serviceEnabled == false
                              ? Container(
                                  child: TextButton(
                                    onPressed: () {
                                      setState(() {});
                                      print(serviceEnabled);
                                      print('gggggggg');
                                      _determinePosition();
                                      print('Sevice = ${serviceEnabled}');
                                    },
                                    child: Text(
                                      '${AppLocalizations.of(context)!.openlocation}',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                      color: Color(0xff770737),
                                      borderRadius: BorderRadius.circular(30)),
                                  width: MediaQuery.sizeOf(context).width / 1.5,
                                )
                              : clickAttend == false? loadingShowAttend == false?
                          status=='LOGIN'?Directionality(
                            textDirection: TextDirection.ltr,
                            child: GradientSlideToAct(
                              key: attenKey,

                                    width: 300,
                                    textStyle: TextStyle(
                                        color: Colors.white, fontSize: 15),
                                    backgroundColor: Color(0Xff172663),
                                    onSubmit: () async {
                                loadingShowAttend = true;
                                setState(() {
                                });
                                      print("hhhhhhhhhhhhhhhhhhhhhhhh");
                                      await _getCurrentPosition();
                                      await DioHelper.postData(
                                        url: "api/organizations/${widget.organizationId}/attend",
                                        formData: {
                                          "longitude":29.743200 ,//_currentPosition!.longitude,
                                          "latitude":30.997700 //_currentPosition!.latitude,
                                        },
                                      )
                                          .then((value) {
                                            loadingShowAttend = false;
                                            print(value);
                                            if(value.data['status'] == false){

                                              clickAttend =true;
                                              Alert(
                                                context: context,
                                                // title: "RFLUTTER ALERT",
                                                desc:
                                                "This Location Out Of Range",
                                              ).show();
                                              setState(() {
                                              });
                                            }
                                            else{
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(builder: (context) =>  ChooseList(
                                                    userId: widget.userId,
                                                    oranizaionsList: widget.oranizaionsList,
                                                    organizationId: widget.organizationId,
                                                    organizationsName: widget.organizationsName,
                                                    organizationsArabicName: widget.organizationsArabicName,

                                                  )));
                                              setState(() {

                                              });
                                              Alert(
                                                context: context,
                                                // title: "RFLUTTER ALERT",
                                                desc:
                                                "${AppLocalizations.of(context)!.attendAlert}",
                                              ).show();
                                            }
                                          })
                                          .catchError((error) {
                                        loadingShowAttend = false;
                                            print("ggggggggg");

                                        setState(() {
                                          clickAttend =true;

                                            });
                                            print(error.toString());
                                        Alert(
                                          context: context,
                                          // title: "RFLUTTER ALERT",
                                          desc:
                                              "can not attend right now ... please try again later",
                                        ).show();
                                      });
                                      print(_currentPosition?.latitude);
                                      print("hhhhhhhhhhhhhhhhhhhhhhhh");
                                      print(CacheHelper.getData(key: 'token'));
                                    },
                                    text: AppLocalizations.of(context)!.localeName == 'ar'?'اسحب الى اليمين للحضور':
                                    'Slide to Confirm Attend',
                                  ),
                          ):SizedBox()
                              :CircularProgressIndicator(
                                      color: Colors.indigo,
                                        )
                              : loadingShowAttend == false?
                          status=='LOGIN'?Directionality(
                            textDirection: TextDirection.ltr,
                            child: GradientSlideToAct(
                              key: attenKeyAgain,
                              width: 300,
                              textStyle: TextStyle(
                                  color: Colors.white, fontSize: 15),
                              backgroundColor: Color(0Xff172663),
                              onSubmit: () async {
                                setState(() {

                                });
                                loadingShowAttend = true;
                                print("hhhhhhhhhhhhhhhhhhhhhhhh");
                                await _getCurrentPosition();
                                await DioHelper.postData(
                                  url: "api/organizations/${widget.organizationId}/attend",
                                  formData: {
                                    "longitude":29.743200 ,//_currentPosition!.longitude,
                                    "latitude":30.997700 //_currentPosition!.latitude,
                                  },
                                )
                                    .then((value) {
                                      loadingShowAttend = false;
                                  if(value.data['status'] == false){
                                    clickAttend =false;
                                    Alert(
                                      context: context,
                                      // title: "RFLUTTER ALERT",
                                      desc:
                                      "This Location Out Of Range",
                                    ).show();
                                    setState(() {
                                    });
                                  }else{
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) =>  ChooseList(userId: widget.userId,
                                          oranizaionsList: widget.oranizaionsList,

                                          organizationId: widget.organizationId,
                                            organizationsName: widget.organizationsName,
                                          organizationsArabicName: widget.organizationsArabicName,
                                        )));
                                    setState(() {

                                    });
                                    Alert(
                                      context: context,
                                      // title: "RFLUTTER ALERT",
                                      desc:
                                      "${AppLocalizations.of(context)!.attendAlert}",
                                    ).show();
                                  }
                                    })
                                    .catchError((error) {
                                  loadingShowAttend = false;
                                      clickAttend = false;
                                      setState(() {

                                      });
                                  print(error.toString());
                                  Alert(
                                    context: context,
                                    // title: "RFLUTTER ALERT",
                                    desc:
                                    "can not attend right now ... please try again later",
                                  ).show();
                                });

                                print(_currentPosition?.latitude);
                                print("hhhhhhhhhhhhhhhhhhhhhhhh");

                                print(CacheHelper.getData(key: 'token'));
                              },
                              text: AppLocalizations.of(context)!.localeName == 'ar'?'اسحب الى اليمين للحضور':
                              'Slide to Confirm Attend',
                            ),
                          ):SizedBox()
                              :CircularProgressIndicator(
                                 color: Colors.indigo,
                                    ),
                          const SizedBox(
                            height: 40,
                          ),
                          serviceEnabled == false
                              ? const SizedBox()
                              :
                          clickdepar == false? loadingShowDep == false?
                          status =='LOGOUT'?Directionality(
                            textDirection: TextDirection.ltr,
                            child: GradientSlideToAct(
                                    key: depKey,
                                    text: AppLocalizations.of(context)!.localeName == 'ar'?"اسحب الى اليمين للإنصراف":
                                    'Slide to Confirm Departure',
                                    width: 300,
                                    textStyle: const TextStyle(
                                        color: Colors.white, fontSize: 15),
                                    backgroundColor: Color(0Xff133337),
                                    onSubmit: () async {
                                      setState(() {
                                        loadingShowDep = true;
                                      });
                                      await _getCurrentPosition();
                                      await DioHelper.postData(
                                        url: "api/organizations/${widget.organizationId}/leave",
                                        formData: {
                                          "longitude":29.743200 ,//_currentPosition!.longitude,
                                          "latitude":30.997700 //_currentPosition!.latitude,
                                        },
                                      ).then((value) {

                                        loadingShowDep = false;
                                        print(value.data);
                                        if(value.data['status'] == false){
                                          clickdepar = true;
                                          Alert(
                                            context: context,
                                            // title: "RFLUTTER ALERT",
                                            desc:
                                            "This Location Out Of Range",
                                          ).show();
                                          setState(() {

                                          });
                                        }else{
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) =>  ChooseList(userId: widget.userId,
                                                oranizaionsList: widget.oranizaionsList,

                                                organizationId: widget.organizationId,
                                                  organizationsName: widget.organizationsName,
                                                organizationsArabicName: widget.organizationsArabicName,
                                              )));
                                          setState(() {

                                          });
                                          Alert(
                                            context: context,
                                            // title: "RFLUTTER ALERT",
                                            desc:
                                            "${AppLocalizations.of(context)!.leaveAlert}",
                                          ).show();
                                        }
                                      }).catchError((error) {
                                        setState(() {
                                        });
                                        clickdepar = true;
                                        loadingShowDep = false;
                                        Alert(
                                          context: context,
                                          // title: "RFLUTTER ALERT",
                                          desc:
                                              "can not Departure right now ... please try again later",
                                        ).show();
                                      });
                                    },
                                  ),
                          ):SizedBox()
                              :CircularProgressIndicator(
                            color: Colors.indigo,
                          ):
                          loadingShowDep == false?
                          status =='LOGOUT'? Directionality(
                            textDirection: TextDirection.ltr,
                            child: Directionality(
                              textDirection: TextDirection.ltr,
                              child: GradientSlideToAct(
                                key: depKeyAgain,
                                text: AppLocalizations.of(context)!.localeName == 'ar'?"اسحب الى اليمين للإنصراف":
                                'Slide to Confirm Departure',
                                width: 300,
                                textStyle: const TextStyle(
                                    color: Colors.white, fontSize: 15),
                                backgroundColor: Color(0Xff133337),
                                onSubmit: () async {
                                  setState(() {
                                    loadingShowDep = true;
                                  });
                                  await _getCurrentPosition();
                                  await DioHelper.postData(
                                    url: "api/organizations/${widget.organizationId}/leave",
                                    formData: {
                                      "longitude":29.743200 ,//_currentPosition!.longitude,
                                      "latitude":30.997700 //_currentPosition!.latitude,
                                    },
                                  ).then((value) {
                                    loadingShowDep = false;
                                    print(value.data);
                                    if(value.data['status'] == false){
                                      clickdepar = false;
                                      Alert(
                                        context: context,
                                        // title: "RFLUTTER ALERT",
                                        desc:
                                        "This Location Out Of Range",
                                      ).show();
                                      setState(() {

                                      });
                                    }else{
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) =>  ChooseList(userId: widget.userId,
                                            oranizaionsList: widget.oranizaionsList,
                                            organizationId: widget.organizationId,
                                            organizationsName: widget.organizationsName,
                                            organizationsArabicName: widget.organizationsArabicName,

                                          )));
                                      setState(() {

                                      });
                                      Alert(
                                        context: context,
                                        // title: "RFLUTTER ALERT",
                                        desc:
                                        "${AppLocalizations.of(context)!.leaveAlert}",
                                      ).show();
                                    }
                                  }).catchError((error) {
                                    loadingShowDep = false;
                                    setState(() {
                                    });
                                    clickdepar = false;
                                    Alert(
                                      context: context,
                                      // title: "RFLUTTER ALERT",
                                      desc:
                                      "can not Departure right now ... please try again later",
                                    ).show();

                                  });
                                },
                              ),
                            ),
                          ):SizedBox()
                              :CircularProgressIndicator(
                            color: Colors.indigo,
                          )
                        ]),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
