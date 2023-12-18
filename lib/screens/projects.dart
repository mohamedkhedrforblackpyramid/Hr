import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

import '../network/remote/dio_helper.dart';

class Projects extends StatefulWidget {
  int?organizationId;

   Projects({required this.organizationId});

  @override
  State<Projects> createState() => _ProjectsState();
}

class _ProjectsState extends State<Projects> {
  getProjects() async {
    await DioHelper.getData(
      url: "api/projects/${widget.organizationId}",
    ).then((response) {
      print(response.data);
      setState(() {
      });
    }).catchError((error){
      print(error.response.data);
    });

  }

  @override
  void initState() {
    getProjects();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xff1A6293),
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
                SafeArea(
                  child: Column(
                      children: [
                        TextButton(onPressed: () async {
                          await DioHelper.postData(
                            url: "api/projects",
                            formData: {
                              "name":"Project One" ,
                              "description":"HR" ,
                              "organization_id":widget.organizationId ,
                            },
                          ).then((value) => print("Shaaaaaaaaatr"))
                              .catchError((error){
                                print(error.response.data);
                          });
                        },
                            child: Text("click",style: TextStyle(color: Colors.white,fontSize: 30),))
                      ]),
                )
              ],
            ),
          ),
        ));
  }
}
