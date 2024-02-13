import 'dart:io';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rive/rive.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../network/remote/dio_helper.dart';
import 'attendance.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({
    super.key,
  });

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final userNameController = TextEditingController();
  final emailController = TextEditingController();
  final nationalIdController = TextEditingController();
  final addressController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool shouldPop = false;
  String valueClosed = '1';
  bool isOpen = false;
  File? image;
  String userType = 'CLIENT';
  bool loadingSend = false;

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemp = File(image.path);
      print(image.path);
      setState(() => this.image = imageTemp);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }
/*
  Future takeAcamera() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if(image == null) return;
      final imageTemp = File(image.path);
      print(image.path);
      setState(() => this.image = imageTemp);
    } on PlatformException catch(e) {
      print('Failed to pick image: $e');
    }
  }
*/

  bool isShowLoading = false;
  bool isShowConfetti = false;

  late SMITrigger check;
  late SMITrigger error;
  late SMITrigger reset;

  late SMITrigger confetti;

  StateMachineController getRiveController(Artboard artboard) {
    StateMachineController? controller =
        StateMachineController.fromArtboard(artboard, "State Machine 1");
    artboard.addController(controller!);
    return controller;
  }

  void signIn(BuildContext context) {
    setState(() {
      isShowLoading = true;
      isShowConfetti = true;
    });
    Future.delayed(Duration(seconds: 1), () {
      if (_formKey.currentState!.validate() &&
          userNameController.text == 'mohamed' &&
          passwordController.text == '123') {
        // show success
        check.fire();
        Future.delayed(Duration(seconds: 2), () {
          setState(() {
            isShowLoading = false;
          });
          confetti.fire();
/*          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>  Attendance(userId: null,)));*/
        });
      } else {
        error.fire();
        Future.delayed(Duration(seconds: 2), () {
          setState(() {
            isShowLoading = false;
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return shouldPop;
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(50.0),
            child: Stack(
              children: [
                loadingSend == false
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${AppLocalizations.of(context)!.userName}",
                            style: TextStyle(color: Colors.black54),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 8.0, bottom: 16),
                            child: TextFormField(
                              controller: userNameController,
                              onSaved: (email) {},
                              decoration: InputDecoration(
                                  prefixIcon: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Icon(
                                  Icons.account_box_sharp,
                                  color: Colors.pinkAccent,
                                ),
                              )),
                            ),
                          ),
                          Text(
                            "${AppLocalizations.of(context)!.mail}",
                            style: TextStyle(color: Colors.black54),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 8.0, bottom: 16),
                            child: TextFormField(
                              controller: emailController,
                              onSaved: (password) {},
                              decoration: InputDecoration(
                                  prefixIcon: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Icon(Icons.email_outlined,
                                    color: Colors.pinkAccent),
                              )),
                            ),
                          ),
                          Text(
                            "${AppLocalizations.of(context)!.nationalId}",
                            style: TextStyle(color: Colors.black54),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 8.0, bottom: 16),
                            child: TextFormField(
                              controller: nationalIdController,
                              onSaved: (password) {},
                              decoration: InputDecoration(
                                  prefixIcon: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Icon(Icons.perm_identity,
                                    color: Colors.pinkAccent),
                              )),
                            ),
                          ),
                          Text(
                            "${AppLocalizations.of(context)!.password}",
                            style: TextStyle(color: Colors.black54),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 8.0, bottom: 16),
                            child: TextFormField(
                              controller: passwordController,
                              onSaved: (password) {},
                              obscureText: true,
                              decoration: InputDecoration(
                                  prefixIcon: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Icon(Icons.password,
                                    color: Colors.pinkAccent),
                              )),
                            ),
                          ),
                          Text(
                            "${AppLocalizations.of(context)!.confirmPassword}",
                            style: TextStyle(color: Colors.black54),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 8.0, bottom: 16),
                            child: TextFormField(
                              controller: confirmPasswordController,
                              onSaved: (password) {},
                              obscureText: true,
                              decoration: InputDecoration(
                                  prefixIcon: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Icon(Icons.password,
                                    color: Colors.pinkAccent),
                              )),
                            ),
                          ),
                          RadioListTile(
                            title: Text(
                              "${AppLocalizations.of(context)!.client}",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            value: '1',
                            groupValue: valueClosed,
                            onChanged: (value) {
                              setState(() {});
                              userType = 'CLIENT';
                              print(userType);

                              isOpen = false;
                              valueClosed = value.toString();
                              setState(() {
                                valueClosed = value.toString();
                              });
                            },
                            fillColor: MaterialStateProperty.all(Colors.black),
                          ),
                          RadioListTile(
                            title: Text(
                              "${AppLocalizations.of(context)!.admin}",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                            value: '0',
                            groupValue: valueClosed,
                            onChanged: (value) {
                              userType = 'ADMIN';
                              print(userType);
                              setState(() {});
                              isOpen = false;
                              valueClosed = value.toString();
                              setState(() {
                                valueClosed = value.toString();
                              });
                            },
                            fillColor: MaterialStateProperty.all(Colors.black),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 8.0, bottom: 24),
                            child: ElevatedButton.icon(
                                onPressed: () async {
                                  setState(() {});
                                  loadingSend = true;
                                  if (confirmPasswordController.text !=
                                      passwordController.text) {
                                    setState(() {});
                                    loadingSend = false;
                                    Flushbar(
                                      backgroundColor: Colors.red,
                                      message: "${AppLocalizations.of(context)!.passwordnotMatch}",
                                      icon: Icon(
                                        Icons.info_outline,
                                        size: 30.0,
                                        color: Colors.black,
                                      ),
                                      duration: Duration(seconds: 3),
                                      leftBarIndicatorColor: Colors.blue[300],
                                    )..show(context);
                                  } else {
                                    await DioHelper.postData(
                                      url: "api/auth/register",
                                      formData: {
                                        "name": userNameController.text,
                                        "email": emailController.text,
                                        "national_id":
                                            nationalIdController.text,
                                        "password": passwordController.text,
                                        "user_type": userType
                                      },
                                    ).then((value) {
                                      userNameController.text = '';
                                      emailController.text = '';
                                      nationalIdController.text = '';
                                      passwordController.text = '';
                                      confirmPasswordController.text = '';
                                      setState(() {});
                                      loadingSend = false;
                                      Flushbar(
                                        backgroundColor: Colors.green,
                                        message: "${AppLocalizations.of(context)!.signUpSuccess}",
                                        icon: Icon(
                                          Icons.verified,
                                          size: 30.0,
                                          color: Colors.black,
                                        ),
                                        duration: Duration(seconds: 3),
                                        leftBarIndicatorColor: Colors.blue[300],
                                      )..show(context);
                                    }).catchError((error) {
                                      print(error.response.data['message']);
                                      setState(() {});
                                      loadingSend = false;
                                      if(userNameController.text.isEmpty){
                                      Flushbar(
                                        backgroundColor: Colors.red,
                                        message:
                                            "${'${AppLocalizations.of(context)!.userNameIsEmpty}'}",
                                        icon: Icon(
                                          Icons.info_outline,
                                          size: 30.0,
                                          color: Colors.black,
                                        ),
                                        duration: Duration(seconds: 3),
                                        leftBarIndicatorColor: Colors.blue[300],
                                      )..show(context);}
                                      else if(error.response.data['message'].toString().contains('The name has already been taken')){
                                        Flushbar(
                                          backgroundColor: Colors.red,
                                          message:
                                          "${AppLocalizations.of(context)!.nameAlreadyTaken}",
                                          icon: Icon(
                                            Icons.info_outline,
                                            size: 30.0,
                                            color: Colors.black,
                                          ),
                                          duration: Duration(seconds: 3),
                                          leftBarIndicatorColor: Colors.blue[300],
                                        )..show(context);}
                                      else if(emailController.text.isEmpty){
                                        Flushbar(
                                          backgroundColor: Colors.red,
                                          message:
                                          "${'${AppLocalizations.of(context)!.emailIsEmpty}'}",
                                          icon: Icon(
                                            Icons.info_outline,
                                            size: 30.0,
                                            color: Colors.black,
                                          ),
                                          duration: Duration(seconds: 3),
                                          leftBarIndicatorColor: Colors.blue[300],
                                        )..show(context);}
                                      else if(error.response.data['message'].toString().contains('The email field must be a valid email address')){
                                        Flushbar(
                                          backgroundColor: Colors.red,
                                          message:
                                          "${AppLocalizations.of(context)!.mailnotValid}",
                                          icon: Icon(
                                            Icons.info_outline,
                                            size: 30.0,
                                            color: Colors.black,
                                          ),
                                          duration: Duration(seconds: 3),
                                          leftBarIndicatorColor: Colors.blue[300],
                                        )..show(context);}
                                      else if(error.response.data['message'].toString().contains('The email has already been taken')){
                                        Flushbar(
                                          backgroundColor: Colors.red,
                                          message:
                                          "${AppLocalizations.of(context)!.mailAlreadyTaken}",
                                          icon: Icon(
                                            Icons.info_outline,
                                            size: 30.0,
                                            color: Colors.black,
                                          ),
                                          duration: Duration(seconds: 3),
                                          leftBarIndicatorColor: Colors.blue[300],
                                        )..show(context);}
                                      else if(nationalIdController.text.isEmpty){
                                        Flushbar(
                                          backgroundColor: Colors.red,
                                          message:
                                          "${'${AppLocalizations.of(context)!.nationalIdIsEmpty}'}",
                                          icon: Icon(
                                            Icons.info_outline,
                                            size: 30.0,
                                            color: Colors.black,
                                          ),
                                          duration: Duration(seconds: 3),
                                          leftBarIndicatorColor: Colors.blue[300],
                                        )..show(context);}
                                      else if(error.response.data['message'].toString().contains('The national id field must be an integer')){
                                        Flushbar(
                                          backgroundColor: Colors.red,
                                          message:
                                          "The national id field must be 14 numbers",
                                          icon: Icon(
                                            Icons.info_outline,
                                            size: 30.0,
                                            color: Colors.black,
                                          ),
                                          duration: Duration(seconds: 3),
                                          leftBarIndicatorColor: Colors.blue[300],
                                        )..show(context);}
                                      else if(passwordController.text.isEmpty){
                                        Flushbar(
                                          backgroundColor: Colors.red,
                                          message:
                                          "${'${AppLocalizations.of(context)!.passwordIsEmpty}'}",
                                          icon: Icon(
                                            Icons.info_outline,
                                            size: 30.0,
                                            color: Colors.black,
                                          ),
                                          duration: Duration(seconds: 3),
                                          leftBarIndicatorColor: Colors.blue[300],
                                        )..show(context);}
                                      else if(error.response.data['message'].toString().contains('The password field must be at least 6 characters') ){
                                        Flushbar(
                                          backgroundColor: Colors.red,
                                          message:
                                          "The password field must be at least 6 characters",
                                          icon: Icon(
                                            Icons.info_outline,
                                            size: 30.0,
                                            color: Colors.black,
                                          ),
                                          duration: Duration(seconds: 3),
                                          leftBarIndicatorColor: Colors.blue[300],
                                        )..show(context);}
                                      else if(confirmPasswordController.text.isEmpty){
                                        Flushbar(
                                          backgroundColor: Colors.red,
                                          message:
                                          "${'${AppLocalizations.of(context)!.confirmPasswordIsEmpty}'}",
                                          icon: Icon(
                                            Icons.info_outline,
                                            size: 30.0,
                                            color: Colors.black,
                                          ),
                                          duration: Duration(seconds: 3),
                                          leftBarIndicatorColor: Colors.blue[300],
                                        )..show(context);}
                                      else{
                                        Flushbar(
                                          backgroundColor: Colors.red,
                                          message:
                                          "${'${error.response.data['message']}'}",
                                          icon: Icon(
                                            Icons.info_outline,
                                            size: 30.0,
                                            color: Colors.black,
                                          ),
                                          duration: Duration(seconds: 3),
                                          leftBarIndicatorColor: Colors.blue[300],
                                        )..show(context);}



                                      print('kkkkkkkkkkkkkkkkkkkkkkkkk');
                                    });
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFF77D8E),
                                    minimumSize:
                                        const Size(double.infinity, 56),
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            topRight: Radius.circular(25),
                                            bottomRight: Radius.circular(25),
                                            bottomLeft: Radius.circular(25)))),
                                icon: const Icon(
                                  CupertinoIcons.arrow_right,
                                  color: Color(0xFFFE0037),
                                ),
                                label: Text(
                                    "${AppLocalizations.of(context)!.signUp}")),
                          ),
                          Center(
                            child: Container(
                              width: 150,
                              height: 100,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 8.0, bottom: 24),
                                child: ElevatedButton.icon(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xFFF77D8E),
                                        minimumSize:
                                            const Size(double.infinity, 56),
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(10),
                                                topRight: Radius.circular(25),
                                                bottomRight:
                                                    Radius.circular(25),
                                                bottomLeft:
                                                    Radius.circular(25)))),
                                    icon: const Icon(
                                      CupertinoIcons.arrow_right,
                                      color: Color(0xFFFE0037),
                                    ),
                                    label: Text(
                                        "${AppLocalizations.of(context)!.signIn}")),
                              ),
                            ),
                          )
                        ],
                      )
                    : Padding(
                        padding: const EdgeInsets.only(top: 300),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: Colors.indigo,
                          ),
                        ),
                      ),
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
                            confetti = controller.findSMI("Trigger explosion")
                                as SMITrigger;
                          },
                        ),
                      ))
                    : const SizedBox()
              ],
            ),
          ),
        ),
      ),
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
