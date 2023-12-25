import 'dart:ui';

import 'package:another_flushbar/flushbar.dart';
import 'package:fancy_containers/fancy_containers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hr/modules/projects.dart';
import 'package:hr/screens/multiscreen_tasks/multiscreenfortasks.dart';
import 'package:rive/rive.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../network/remote/dio_helper.dart';

class Projects extends StatefulWidget {
  int?organizationId;

   Projects({required this.organizationId});

  @override
  State<Projects> createState() => _ProjectsState();
}

class _ProjectsState extends State<Projects> {
  late ProjectsList projects;
  bool projectLoading = false;
  var projectName = TextEditingController();
  var projectDescription = TextEditingController();
  bool clickAdd = false;





  getProjects() async {
    projectLoading = true;
    await DioHelper.getData(
      url: "api/projects/",
    ).then((response) {
      projects = ProjectsList.fromJson(response.data);
      print(projects);
      setState(() {
        projectLoading = false;
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
      floatingActionButton: FloatingActionButton(
        onPressed: (){
        showModalBottomSheet<void>(
            isScrollControlled: true,
            context: context,
            builder: (BuildContext context) {
              return StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return Padding(
                  padding: EdgeInsets.only(top: 20,  right: 20,  left: 20,
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Container(
                    height: MediaQuery.of(context).size.height/2,
                      width: MediaQuery.of(context).size.width/1.1,
                      child:  Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Text("Add Project",
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                           Padding(
                             padding: const EdgeInsets.only(bottom: 20),
                             child: Container(
                               width: 300,
                               child: TextFormField(
                                 controller: projectName,
                                decoration: new InputDecoration(
                                  labelText: "Project Name",
                                  fillColor: Colors.white,
                                  border: new OutlineInputBorder(
                                    borderRadius: new BorderRadius.circular(25.0),
                                    borderSide: new BorderSide(
                                    ),
                                  ),
                                  //fillColor: Colors.green
                                ),
                                keyboardType: TextInputType.emailAddress,
                                style: new TextStyle(
                                  fontFamily: "Poppins",
                                ),
                               ),
                             ),
                           ),
                          SizedBox(height: 10,),
                          Container(
                            width: 300,
                            child: TextFormField(
                              controller: projectDescription,
                              decoration: new InputDecoration(
                                labelText: "Project Description",
                                fillColor: Colors.white,
                                border: new OutlineInputBorder(
                                  borderRadius: new BorderRadius.circular(25.0),
                                  borderSide: new BorderSide(
                                  ),
                                ),
                                //fillColor: Colors.green
                              ),

                              keyboardType: TextInputType.emailAddress,
                              style: new TextStyle(
                                fontFamily: "Poppins",
                              ),
                            ),
                          ),
                           SizedBox(height: 20,),
                           Center(
                            child:  Container(
                              height: 50,
                              width: 200,
                              child: clickAdd==false?FancyContainer(
                                textColor: Colors.white,
                                onTap: () async {
                                  setState(() {
                                    clickAdd = true;

                                  });
                                  await DioHelper.postData(
                                    url: "api/projects",
                                    formData: {
                                      "name":"${projectName.text}" ,
                                      "description":"${projectDescription.text}" ,
                                      "organization_id":widget.organizationId ,
                                    },
                                  ).then((value) {

                                    setState(() {});
                                    clickAdd = false;

                                    print("Shaaaaaaaaatr");
                                    getProjects();
                                    projectName.text='';
                                    projectDescription.text = '';
                                    Navigator.pop(context);
                                  })
                                      .catchError((error){
                                    clickAdd = false;

                                    setState(() {

                                        });
                                        if(projectName.text.isEmpty) {
                                          Flushbar(
                                            backgroundColor: Colors.red,
                                            message: "project name is empty !",
                                            icon: Icon(
                                              Icons.info_outline,
                                              size: 30.0,
                                              color: Colors.black,
                                            ),
                                            duration: Duration(seconds: 3),
                                            leftBarIndicatorColor: Colors
                                                .blue[300],
                                          )
                                            ..show(context);
                                        }
                                        else if(projectDescription.text.isEmpty){
                                          Flushbar(
                                            message: "project Description is empty !",
                                            backgroundColor: Colors.red,
                                            icon: Icon(
                                              Icons.info_outline,
                                              size: 30.0,
                                              color: Colors.black,

                                            ),
                                            duration: Duration(seconds: 3),
                                            leftBarIndicatorColor: Colors
                                                .blue[300],
                                          )
                                            ..show(context);
                                        }
                                        else{
                                          Flushbar(
                                            message: "Sorry! try again later",
                                            icon: Icon(
                                              Icons.info_outline,
                                              size: 30.0,
                                              color: Colors.blue[300],
                                            ),
                                            duration: Duration(seconds: 3),
                                            leftBarIndicatorColor: Colors
                                                .blue[300],
                                          )
                                            ..show(context);
                                        }

                                    print(error.response.data);
                                  });
                                },
                                title: 'Add',
                                color1: Colors.purple,
                                color2: Colors.lightBlue,
                              ):Center(
                                child: CircularProgressIndicator(
                                  color: Colors.indigo,
                                ),
                              ),
                            ),
                                                   ),
                        ],
                      )
                  ),
                );}
              );

            },
          );
        },
        child: const Icon(Icons.add),
      ),
        backgroundColor: const Color(0xff1A6293),
        body: SafeArea(
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
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    child: Column(

                        children: [
                          Text("${AppLocalizations.of(context)!.myProject}",
                            style: TextStyle(
                                fontSize: 30,
                                color: Colors.white,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          projectLoading==false?Column(
                            children: [
                              projects.projectList!.isNotEmpty ?
                              SizedBox(
                                child: ListView.builder(
                                   shrinkWrap: true,
                                  physics: const ScrollPhysics(),
                                  scrollDirection: Axis.vertical,
                                  itemBuilder:
                                      (BuildContext context, int index) =>
                                          buildProjects(
                                          pr: projects.projectList![index],
                                          index: index, context: context),
                                  itemCount: projects.projectList!.length,
                                ),
                              ): const Padding(
                                padding: EdgeInsets.symmetric(vertical: 300),
                                child: Center(
                                  child: Text(
                                    "No Projects Found",
                                    style: TextStyle(
                                        fontSize: 20, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ],
                          ):const Padding(
                            padding: EdgeInsets.symmetric(vertical: 300),
                            child: Center(
                              child: CircularProgressIndicator(
                                color: Colors.indigo,

                              ),
                            ),
                          ),

                        ]),
                  ),
                ),
              )
            ],
          ),
        ));
  }
  Widget buildProjects({required ProjectsModel pr, required int index, required BuildContext context, }) {
    return GestureDetector(
      onTap: (){
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>  MultiScreenForTasks(
             projectId: pr.project_id!,
              organization_id: widget.organizationId!,

            )));
      },
      child: Container(
        width: MediaQuery.of(context).size.width,

        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF0E3311).withOpacity(0.5),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Center(
              child: Text(
                '${pr.name}',
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            Text(
              '${pr.description}',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),


      ),
    );

  }
}
