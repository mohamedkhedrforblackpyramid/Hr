import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rive/rive.dart';

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
  final mobileController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool shouldPop = false;
  String valueClosed = '1';
  bool isOpen = false;
  File?  image;


  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if(image == null) return;
      final imageTemp = File(image.path);
      print(image.path);
      setState(() => this.image = imageTemp);
    } on PlatformException catch(e) {
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
      if (_formKey.currentState!.validate()&&userNameController.text=='mohamed'&&passwordController.text=='123') {
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
                Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "User Name",
                          style: TextStyle(color: Colors.black54),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0, bottom: 16),
                          child: TextFormField(
                            controller: userNameController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'user name is empty';
                              }
                              return null;
                            },
                            onSaved: (email) {},
                            decoration: InputDecoration(
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Icon(Icons.account_box_sharp,
                                    color: Colors.pinkAccent,
                                  ),
                                )),
                          ),
                        ),
                        const Text(
                          "e-mail",
                          style: TextStyle(color: Colors.black54),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0, bottom: 16),
                          child: TextFormField(
                            controller: emailController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'e-mail is empty';
                              }
                              else if(!value.contains('@')){
                              return '@@@@@@@@@@@@@@@@@';

                              }
                              return null;
                            },
                            onSaved: (password) {},
                            obscureText: true,
                            decoration: InputDecoration(
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Icon(Icons.email_outlined,color: Colors.pinkAccent),
                                )),
                          ),
                        ),

                        const Text(
                          "mobile",
                          style: TextStyle(color: Colors.black54),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0, bottom: 16),
                          child: TextFormField(
                            controller: mobileController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "";
                              }
                              return null;
                            },
                            onSaved: (password) {},
                            obscureText: true,
                            decoration: InputDecoration(
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Icon(Icons.phone_android,color: Colors.pinkAccent),
                                )),
                          ),
                        ),
                        const Text(
                          "Create Password",
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
                            obscureText: true,
                            decoration: InputDecoration(
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Icon(Icons.password,color: Colors.pinkAccent),
                                )),
                          ),
                        ),
                        const Text(
                          "confirm password",
                          style: TextStyle(color: Colors.black54),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0, bottom: 16),
                          child: TextFormField(
                            controller: confirmPasswordController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "";
                              }
                              return null;
                            },
                            onSaved: (password) {},
                            obscureText: true,
                            decoration: InputDecoration(
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Icon(Icons.password,color: Colors.pinkAccent),
                                )),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0, bottom: 24),
                          child: ElevatedButton.icon(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  // If the form is valid, display a snackbar. In the real world,
                                  // you'd often call a server or save the information in a database.
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Processing Data')),
                                  );
                                }                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFF77D8E),
                                  minimumSize: const Size(double.infinity, 56),
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
                              label: const Text("Sign Up")),
                        ),
                        Center(
                          child: Container(
                            width: 150,
                            height: 100,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 8.0, bottom: 24),
                              child: ElevatedButton.icon(
                                  onPressed: () {
                                    Navigator.pop(context);

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
                                  icon: const Icon(
                                    CupertinoIcons.arrow_right,
                                    color: Color(0xFFFE0037),
                                  ),
                                  label: const Text("Sign In")),
                            ),
                          ),
                        )
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


