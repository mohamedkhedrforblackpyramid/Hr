import 'dart:io';
import 'dart:ui';
import 'package:http_parser/http_parser.dart';

import 'package:another_flushbar/flushbar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hr/modules/organizationmodel.dart';
import 'package:hr/screens/excusepermission.dart';
import 'package:hr/screens/projects.dart';
import 'package:hr/screens/switchpermitandvacan.dart';
import 'package:hr/screens/tasktable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:rive/rive.dart';

import '../network/local/cache_helper.dart';
import '../network/remote/dio_helper.dart';
import 'attendance.dart';
import 'holiday_permission.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CreateOrganizations extends StatefulWidget {
  int? userId;

  CreateOrganizations({
    required this.userId,
  });

  @override
  State<CreateOrganizations> createState() => _CreateOrganizationsState();
}

class _CreateOrganizationsState extends State<CreateOrganizations> {
  String? image_path_front;
  XFile? photo_front;

  String? image_path_back;
  XFile? photo_back;

  String? image_path_bta2aDrebia;
  XFile? photo_bta2aDrebia;

  String? image_path_card;
  XFile? photo_card;

  bool shouldPop = false;
  String valueClosed = '1';
  bool isOpen = false;
  File? imageForFirstId;
  File? imageForSecond;
  File? imageFordrebia;
  File? imageFoCardTax;
  final _formKey = GlobalKey<FormState>();
  bool loadingSend = false;
  var bussinessCode =
      TextEditingController(text: '7f2d9ff5-c028-11ee-8c58-6a3cd81fa40a');
  var organizationName = TextEditingController(text: 'el kayan');
  var organizationNameArabic = TextEditingController(text: 'الكيان');
  var organozationDesc = TextEditingController(text: '...');
  var organozationDescArabic = TextEditingController(text: '...');
  var commercialRegistryNumber = TextEditingController(text: '665669');
  var taxCardNumber = TextEditingController(text: '86526456');
  var ownerName = TextEditingController(text: 'ahmed');
  var responsibleManager = TextEditingController(text: 'tarek');
  var organizationMail = TextEditingController(text: 'ahmed@gmail.com');
  var organizationphone = TextEditingController(text: '0102569875');
  var organizationwebsite = TextEditingController(text: 'www.hfewf.com');

   frontid_gallery() async {
     final ImagePicker picker =
     ImagePicker();
     this.photo_front =
     await picker.pickImage(
         source:
         ImageSource.gallery,
         imageQuality: 50);
     final photo = this.photo_front;
     if (photo != null) {
       print(photo.path);
       setState(() {
         image_path_front =
             photo.path;
       });
       print("image is here !");
       print(image_path_front);
       print("image is here !");
     }
     image_path_front != null
         ? Container(
       height: 200,
       child: Image.file(
         File(
             image_path_front!),
         fit: BoxFit.contain,
       ),
     )
         : SizedBox.shrink();
  }
   frontId_camera() async {
    final ImagePicker picker =
    ImagePicker();
    this.photo_front =
    await picker.pickImage(
        source:
        ImageSource.camera,
        imageQuality: 50);
    final photo = this.photo_front;
    if (photo != null) {
      print(photo.path);
      setState(() {
        image_path_front =
            photo.path;
      });
      print("image is here !");
      print(image_path_front);
      print("image is here !");
    }
    image_path_front != null
        ? Container(
      height: 200,
      child: Image.file(
        File(
            image_path_front!),
        fit: BoxFit.contain,
      ),
    )
        : SizedBox.shrink();
  }

   backid_gallery() async {
    final ImagePicker picker =
    ImagePicker();
    this.photo_back =
    await picker.pickImage(
        source:
        ImageSource.gallery,
        imageQuality: 50);
    final photo = this.photo_back;
    if (photo != null) {
      print(photo.path);
      setState(() {
        image_path_back =
            photo.path;
      });
      print("image is here !");
      print(image_path_front);
      print("image is here !");
    }
    image_path_front != null
        ? Container(
      height: 200,
      child: Image.file(
        File(
            image_path_front!),
        fit: BoxFit.contain,
      ),
    )
        : SizedBox.shrink();
  }
   backid_camera() async {
    final ImagePicker picker =
    ImagePicker();
    this.photo_back =
    await picker.pickImage(
        source:
        ImageSource.camera,
        imageQuality: 50);
    final photo = this.photo_back;
    if (photo != null) {
      print(photo.path);
      setState(() {
        image_path_back =
            photo.path;
      });
      print("image is here !");
      print(image_path_front);
      print("image is here !");
    }
    image_path_front != null
        ? Container(
      height: 200,
      child: Image.file(
        File(
            image_path_front!),
        fit: BoxFit.contain,
      ),
    )
        : SizedBox.shrink();
  }

   btakaDrebia_gallery() async {
    final ImagePicker picker =
    ImagePicker();
    this.photo_bta2aDrebia =
    await picker.pickImage(
        source:
        ImageSource.gallery,
        imageQuality: 50);
    final photo = this.photo_bta2aDrebia;
    if (photo != null) {
      print(photo.path);
      setState(() {
        image_path_bta2aDrebia =
            photo.path;
      });
      print("image is here !");
      print(image_path_front);
      print("image is here !");
    }
    image_path_front != null
        ? Container(
      height: 200,
      child: Image.file(
        File(
            image_path_front!),
        fit: BoxFit.contain,
      ),
    )
        : SizedBox.shrink();
  }
   btakaDrebia_camera() async {
    final ImagePicker picker =
    ImagePicker();
    this.photo_bta2aDrebia =
    await picker.pickImage(
        source:
        ImageSource.camera,
        imageQuality: 50);
    final photo = this.photo_bta2aDrebia;
    if (photo != null) {
      print(photo.path);
      setState(() {
        image_path_bta2aDrebia =
            photo.path;
      });
      print("image is here !");
      print(image_path_front);
      print("image is here !");
    }
    image_path_front != null
        ? Container(
      height: 200,
      child: Image.file(
        File(
            image_path_front!),
        fit: BoxFit.contain,
      ),
    )
        : SizedBox.shrink();
  }

  card_gallery() async {
    final ImagePicker picker =
    ImagePicker();
    this.photo_card =
    await picker.pickImage(
        source:
        ImageSource.gallery,
        imageQuality: 50);
    final photo = this.photo_card;
    if (photo != null) {
      print(photo.path);
      setState(() {
        image_path_card =
            photo.path;
      });
      print("image is here !");
      print(image_path_card);
      print("image is here !");
    }
    image_path_card != null
        ? Container(
      height: 200,
      child: Image.file(
        File(
            image_path_card!),
        fit: BoxFit.contain,
      ),
    )
        : SizedBox.shrink();
  }
  card_camera() async {
     final ImagePicker picker =
     ImagePicker();
     this.photo_card =
     await picker.pickImage(
         source:
         ImageSource.camera,
         imageQuality: 50);
     final photo = this.photo_card;
     if (photo != null) {
       print(photo.path);
       setState(() {
         image_path_card =
             photo.path;
       });
       print("image is here !");
       print(image_path_card);
       print("image is here !");
     }
     image_path_card != null
         ? Container(
       height: 200,
       child: Image.file(
         File(
             image_path_card!),
         fit: BoxFit.contain,
       ),
     )
         : SizedBox.shrink();
  }

  @override
  void initState() {
    print('hhhhhhhhhhhhhhojhipihiphp');
    print(CacheHelper.getData(key: 'token'));
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
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: SingleChildScrollView(
                    child: loadingSend == false
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              RadioListTile(
                                fillColor:
                                    MaterialStateProperty.all(Colors.white),
                                title: Text(
                                  "Employee",
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                value: '1',
                                groupValue: valueClosed,
                                onChanged: (value) {
                                  isOpen = false;
                                  valueClosed = value.toString();
                                  setState(() {
                                    valueClosed = value.toString();
                                  });
                                },
                              ),
                              valueClosed == '1'
                                  ? const Text(
                                      "Business Code",
                                      style: TextStyle(color: Colors.white70),
                                    )
                                  : SizedBox(),
                              valueClosed == '1'
                                  ? Padding(
                                      padding: const EdgeInsets.only(
                                          top: 8.0, bottom: 16),
                                      child: Column(
                                        children: [
                                          TextFormField(
                                            controller: bussinessCode,
                                            onSaved: (password) {},
                                            decoration: InputDecoration(
                                                fillColor: Colors.transparent,
                                                prefixIcon: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 8.0),
                                                  child: Icon(Icons.code,
                                                      color: Colors.white70),
                                                )),
                                          ),
                                          Container(
                                            color: Colors.transparent,
                                            child: TextButton(
                                              child: Text(
                                                'Send',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 30),
                                              ),
                                              onPressed: () async {
                                                setState(() {});
                                                loadingSend = true;
                                                await DioHelper.postData(
                                                  url: "api/join-organization",
                                                  formData: {
                                                    "code": bussinessCode.text,
                                                  },
                                                ).then((value) {
                                                  setState(() {});
                                                  loadingSend = false;
                                                  print('Done');
                                                  Flushbar(
                                                    messageColor: Colors.black,
                                                    backgroundColor:
                                                        Colors.green,
                                                    message:
                                                        "The application has been sent successfully. Please wait for acceptance from the company via email",
                                                    icon: Icon(
                                                      Icons.verified,
                                                      size: 30.0,
                                                      color: Colors.white,
                                                    ),
                                                    duration:
                                                        Duration(seconds: 3),
                                                    leftBarIndicatorColor:
                                                        Colors.blue[300],
                                                  )..show(context);
                                                }).catchError((error) {
                                                  setState(() {});
                                                  loadingSend = false;
                                                  print(error);
                                                  Flushbar(
                                                    messageColor: Colors.white,
                                                    backgroundColor:
                                                        Colors.green,
                                                    message:
                                                        "something .. try again later",
                                                    icon: Icon(
                                                      Icons.info_outline,
                                                      size: 30.0,
                                                      color: Colors.black,
                                                    ),
                                                    duration:
                                                        Duration(seconds: 3),
                                                    leftBarIndicatorColor:
                                                        Colors.blue[300],
                                                  )..show(context);
                                                });
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : SizedBox(),
                              RadioListTile(
                                fillColor:
                                    MaterialStateProperty.all(Colors.white),
                                title: Text(
                                  "Business Owner",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                value: '0',
                                groupValue: valueClosed,
                                onChanged: (value) {
                                  isOpen = false;
                                  valueClosed = value.toString();
                                  setState(() {
                                    valueClosed = value.toString();
                                  });
                                },
                              ),
                              valueClosed != '1'
                                  ? Column(
                                      children: [
                                        SizedBox(
                                          height: 10,
                                        ),
                                        TextFormField(
                                          controller: organizationName,
                                          onSaved: (password) {},
                                          decoration: InputDecoration(
                                            fillColor: Colors.transparent,
                                            label: Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Text(
                                                'organization name',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        TextFormField(
                                          controller: organizationNameArabic,
                                          onSaved: (password) {},
                                          decoration: InputDecoration(
                                            fillColor: Colors.transparent,
                                            label: Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Text(
                                                'organization name (arabic)',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        TextFormField(
                                          controller: organozationDesc,
                                          onSaved: (password) {},
                                          decoration: InputDecoration(
                                            fillColor: Colors.transparent,
                                            label: Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Text(
                                                'organization description (Optional)',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        TextFormField(
                                          controller: organozationDescArabic,
                                          onSaved: (password) {},
                                          decoration: InputDecoration(
                                            fillColor: Colors.transparent,
                                            label: Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Text(
                                                'organization description in arabic (Optional)',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        TextFormField(
                                          controller: commercialRegistryNumber,
                                          onSaved: (password) {},
                                          decoration: InputDecoration(
                                            fillColor: Colors.transparent,
                                            label: Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Text(
                                                'commercial registry number',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        TextFormField(
                                          controller: taxCardNumber,
                                          onSaved: (password) {},
                                          decoration: InputDecoration(
                                            fillColor: Colors.transparent,
                                            label: Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Text(
                                                'tax card',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        TextFormField(
                                          controller: ownerName,
                                          onSaved: (password) {},
                                          decoration: InputDecoration(
                                            fillColor: Colors.transparent,
                                            label: Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Text(
                                                'owner name',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        TextFormField(
                                          controller: responsibleManager,
                                          onSaved: (password) {},
                                          decoration: InputDecoration(
                                            fillColor: Colors.transparent,
                                            label: Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Text(
                                                'responsible Manager name',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        TextFormField(
                                          controller: organizationMail,
                                          onSaved: (password) {},
                                          decoration: InputDecoration(
                                            fillColor: Colors.transparent,
                                            label: Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Text(
                                                'organization mail',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        TextFormField(
                                          controller: organizationphone,
                                          onSaved: (password) {},
                                          decoration: InputDecoration(
                                            fillColor: Colors.transparent,
                                            label: Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Text(
                                                'organization phone',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        TextFormField(
                                          controller: organizationwebsite,
                                          onSaved: (password) {},
                                          decoration: InputDecoration(
                                            fillColor: Colors.transparent,
                                            label: Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Text(
                                                'organization website',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          " Now We need some papers for you to join our team ",
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          '1 - Scan National Id first face',
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.white),
                                        ),
                                      ],
                                    )
                                  : SizedBox(),
                              valueClosed != '1'
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(15.0),
                                          child: IconButton(
                                              onPressed: () async {
                                                frontid_gallery();
                                              },
                                              icon: Icon(
                                                Icons.file_copy,
                                                size: 40,
                                                color: Colors.white,
                                              )),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(15.0),
                                          child: Center(
                                            child: IconButton(
                                                onPressed: () async {
                                                  frontId_camera();
                                                },
                                                icon: Icon(
                                                  Icons.camera_alt,
                                                  size: 40,
                                                  color: Colors.white,
                                                )),
                                          ),
                                        ),
                                      ],
                                    )
                                  : SizedBox(),
                              valueClosed != '1'
                                  ? Container(
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(30)),
                                      child: /* image!=null?Image.file(
                            File(image!.path),
                            width: 130,
                          )*/
                                          image_path_front != null
                                              ? Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        'Scaned First Face Successfully',
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.green),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Icon(
                                                      Icons.verified_outlined,
                                                      color: Colors.green,
                                                    )
                                                  ],
                                                )
                                              : SizedBox(),
                                    )
                                  : SizedBox(),
                              SizedBox(
                                height: 20,
                              ),
                              valueClosed != '1'
                                  ? Text(
                                      '2 - Scan National Id second face',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  : SizedBox(),
                              valueClosed != '1'
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(15.0),
                                          child: IconButton(
                                              onPressed: () async {
                                              backid_gallery();
                                              },
                                              icon: Icon(
                                                Icons.file_copy,
                                                size: 40,
                                                color: Colors.white,
                                              )),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(15.0),
                                          child: Center(
                                            child: IconButton(
                                                onPressed: () async {
                                                  backid_camera();
                                                  },
                                                icon: Icon(
                                                  Icons.camera_alt,
                                                  size: 40,
                                                  color: Colors.white,
                                                )),
                                          ),
                                        ),
                                      ],
                                    )
                                  : SizedBox(),
                              valueClosed != '1'
                                  ? Container(
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(30)),
                                      child: /* image!=null?Image.file(
                            File(image!.path),
                            width: 130,
                          )*/
                                          image_path_back != null
                                              ? Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        'Scaned Second Face Successfully',
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.green),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Icon(
                                                      Icons.verified_outlined,
                                                      color: Colors.green,
                                                    )
                                                  ],
                                                )
                                              : SizedBox(),
                                    )
                                  : SizedBox(),
                              SizedBox(
                                height: 20,
                              ),
                              valueClosed != '1'
                                  ? Text(
                                      '3 - Scan commercial register',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    )
                                  : SizedBox(),
                              valueClosed != '1'
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(15.0),
                                          child: IconButton(
                                              onPressed: () async {
                                                btakaDrebia_gallery();
                                                },
                                              icon: Icon(
                                                Icons.file_copy,
                                                size: 40,
                                                color: Colors.white,
                                              )),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(15.0),
                                          child: Center(
                                            child: IconButton(
                                                onPressed: () async {
                                                  btakaDrebia_camera();
                                                },
                                                icon: Icon(
                                                  Icons.camera_alt,
                                                  size: 40,
                                                  color: Colors.white,
                                                )),
                                          ),
                                        ),
                                      ],
                                    )
                                  : SizedBox(),
                              valueClosed != '1'
                                  ? Container(
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(30)),
                                      child: /* image!=null?Image.file(
                            File(image!.path),
                            width: 130,
                          )*/
                                          image_path_bta2aDrebia != null
                                              ? Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        'Scaned commercial register Successfully',
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.green),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Icon(
                                                      Icons.verified_outlined,
                                                      color: Colors.green,
                                                    )
                                                  ],
                                                )
                                              : SizedBox(),
                                    )
                                  : SizedBox(),
                              valueClosed != '1'
                                  ? Text(
                                      '4 - Scan Card Tax',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    )
                                  : SizedBox(),
                              valueClosed != '1'
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(15.0),
                                          child: IconButton(
                                              onPressed: () async {
                                                card_gallery();
                                              },
                                              icon: Icon(
                                                Icons.file_copy,
                                                size: 40,
                                                color: Colors.white,
                                              )),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(15.0),
                                          child: Center(
                                            child: IconButton(
                                                onPressed: () async {
                                                  card_camera();
                                                },
                                                icon: Icon(
                                                  Icons.camera_alt,
                                                  size: 40,
                                                  color: Colors.white,
                                                )),
                                          ),
                                        ),
                                      ],
                                    )
                                  : SizedBox(),
                              valueClosed != '1'
                                  ? Container(
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius.circular(30)),
                                child: /* image!=null?Image.file(
                            File(image!.path),
                            width: 130,
                          )*/
                                image_path_card != null
                                    ? Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Scaned Tax Card Successfully',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight:
                                            FontWeight.bold,
                                            color:
                                            Colors.green),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Icon(
                                      Icons.verified_outlined,
                                      color: Colors.green,
                                    )
                                  ],
                                )
                                    : SizedBox(),
                              )
                                  : SizedBox(),
                              valueClosed != '1'
                                  ? Container(
                                      color: Colors.transparent,
                                      child: TextButton(
                                        child: Text(
                                          'Send',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 30),
                                        ),
                                        onPressed: () async {
                                          setState(() {});
                                          loadingSend = true;

                                          var file_image_front;
                                          var file_image_back;
                                          var file_image_bta2adrebia;
                                          var file_image_card;

                                          if (image_path_front != null) {
                                            file_image_front =
                                                await MultipartFile.fromFile(
                                                    image_path_front!,
                                                    filename: "fileName.jpg",
                                                    contentType: MediaType(
                                                        'image', 'jpg'));
                                            print(file_image_front);
                                          }
                                          if (image_path_back != null) {
                                            file_image_back =
                                            await MultipartFile.fromFile(
                                                image_path_back!,
                                                filename: "fileName.jpg",
                                                contentType: MediaType(
                                                    'image', 'jpg'));
                                            print(file_image_front);
                                          }

                                          if (image_path_bta2aDrebia != null) {
                                            file_image_bta2adrebia =
                                            await MultipartFile.fromFile(
                                                image_path_bta2aDrebia!,
                                                filename: "fileName.jpg",
                                                contentType: MediaType(
                                                    'image', 'jpg'));
                                            print(file_image_bta2adrebia);
                                          }
                                          if (image_path_card != null) {
                                            file_image_card =
                                            await MultipartFile.fromFile(
                                                image_path_card!,
                                                filename: "fileName.jpg",
                                                contentType: MediaType(
                                                    'image', 'jpg'));
                                            print(file_image_card);
                                          }
                                          await DioHelper.postFormData(
                                            url: "api/organizations",
                                            formData: {
                                              "name": organizationName.text,
                                              "name_ar":
                                                  organizationNameArabic.text,
                                              "description":
                                                  organozationDesc.text,
                                              "decription_ar":
                                                  organozationDescArabic.text,
                                              "commercial_registry":
                                                  commercialRegistryNumber.text,
                                              "tax_card": taxCardNumber.text,
                                              "owner_name": ownerName.text,
                                              "responsible_manager":
                                                  responsibleManager.text,
                                              "email": organizationMail.text,
                                              "phone": organizationphone.text,
                                              "website":
                                                  organizationwebsite.text,
                                              'id_front': file_image_front,
                                              'id_back': file_image_back,
                                              'commercial_registry_image':
                                                  file_image_bta2adrebia,
                                              'tax_card_image': file_image_card,
                                            },
                                          ).then((value) {
                                            setState(() {});
                                            loadingSend = false;
                                            print('Done');
                                            Flushbar(
                                              messageColor: Colors.black,
                                              backgroundColor: Colors.green,
                                              message:
                                                  "The application has been sent successfully. Please wait for acceptance from the company via email",
                                              icon: Icon(
                                                Icons.verified,
                                                size: 30.0,
                                                color: Colors.white,
                                              ),
                                              duration: Duration(seconds: 3),
                                              leftBarIndicatorColor:
                                                  Colors.blue[300],
                                            )..show(context);
                                            organizationName.text='';
                                            organizationNameArabic.text='';
                                            organozationDesc.text='';
                                            organozationDescArabic.text='';
                                            organizationwebsite.text='';
                                            organizationphone.text='';
                                            organizationMail.text='';
                                            ownerName.text='';
                                            responsibleManager.text='';
                                            commercialRegistryNumber.text='';
                                            taxCardNumber.text='';
                                            image_path_card =null;
                                            image_path_bta2aDrebia=null;
                                            image_path_back=null;
                                            image_path_front=null;

                                          }).catchError((error) {
                                            setState(() {});

                                            loadingSend = false;
                                            print(CacheHelper.getData(
                                                key: 'token'));
                                            print(error.response.data);
                                            print('wqefwewegwrgw4rgwerg');
                                            print(imageForFirstId.toString());
                                            print(error);
                                            Flushbar(
                                              messageColor: Colors.white,
                                              backgroundColor: Colors.red,
                                              message:
                                                  "something .. try again later",
                                              icon: Icon(
                                                Icons.info_outline,
                                                size: 30.0,
                                                color: Colors.black,
                                              ),
                                              duration: Duration(seconds: 3),
                                              leftBarIndicatorColor:
                                                  Colors.blue[300],
                                            )..show(context);
                                          });
                                        },
                                      ),
                                    )
                                  : SizedBox(),

                            ],
                          )
                        : Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 250),
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            ),
                          ),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
