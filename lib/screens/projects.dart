import 'dart:ui';

import 'package:another_flushbar/flushbar.dart';
import 'package:fancy_containers/fancy_containers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hr/modules/projects.dart';
import 'package:hr/screens/choose_list.dart';
import 'package:hr/screens/multiscreen_tasks/multiscreenfortasks.dart';
import 'package:rive/rive.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../modules/chooseusers.dart';
import '../modules/organizationmodel.dart';
import '../network/remote/dio_helper.dart';

class Projects extends StatefulWidget {
  int? organizationId;
  int? userId;
  late OrganizationsList oranizaionsList;
  String? organizationsName;
  String? organizationsArabicName;

  Projects({
    required this.organizationId,
    required this.userId,
    required this.organizationsArabicName,
    required this.organizationsName,
    required this.oranizaionsList,
  });

  @override
  State<Projects> createState() => _ProjectsState();
}

class _ProjectsState extends State<Projects> {
  late ProjectsList projects;
  bool projectLoading = false;
  var projectName = TextEditingController();
  var projectDescription = TextEditingController();
  bool clickAdd = false;
  List<int?> users = [];
  late ChooseUserList chooseList;
  int? userId;

  returnPage() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ChooseList(
              userId: widget.userId,
              organizationId: widget.organizationId,
              organizationsName: widget.organizationsName,
              oranizaionsList: widget.oranizaionsList,
              organizationsArabicName: widget.organizationsArabicName,
            )));
  }
  getProjects() async {
    projectLoading = true;
    await DioHelper.getData(
        url: "api/projects",
        query: {'organization_id': widget.organizationId}).then((response) {
      // print(response.data);
      projects = ProjectsList.fromJson(response.data);
      //  print(projects);
      setState(() {
        projectLoading = false;
      });
    }).catchError((error) {
      print(error);
    });
  }
  getUsers() {
    DioHelper.getData(
      url: "api/organizations/${widget.organizationId}/employees",
    ).then((response) {
      chooseList = ChooseUserList.fromJson(response.data['data']);
      print(response.data);
      setState(() {});
    }).catchError((error) {
      print('hhhhhhhhhhhhhhhh');
      print(error);
    });
  }

  @override
  void initState() {
    getProjects();
    getUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return returnPage();
      },
      child: Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              projectName.text = '';
              projectDescription.text = '';
              users.length = 0;
              showModalBottomSheet<void>(
                isScrollControlled: true,
                context: context,
                builder: (BuildContext context) {
                  return StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                        return Padding(
                          padding: EdgeInsets.only(
                              top: 20,
                              right: 20,
                              left: 20,
                              bottom: MediaQuery.of(context).viewInsets.bottom),
                          child: Container(
                              height: MediaQuery.of(context).size.height / 2,
                              width: MediaQuery.of(context).size.width / 1.1,
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Text(
                                        "${AppLocalizations.of(context)!.addProject}",
                                        style: TextStyle(
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 20),
                                      child: Container(
                                        width: 300,
                                        child: TextFormField(
                                          controller: projectName,
                                          decoration: new InputDecoration(
                                            labelText:
                                            "${AppLocalizations.of(context)!.projectName}",
                                            fillColor: Colors.white,
                                            border: new OutlineInputBorder(
                                              borderRadius:
                                              new BorderRadius.circular(25.0),
                                              borderSide: new BorderSide(),
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
                                    SizedBox(
                                      height: 10,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      width: 300,
                                      child: TextFormField(
                                        controller: projectDescription,
                                        decoration: new InputDecoration(
                                          labelText:
                                          "${AppLocalizations.of(context)!.projectDescription}",
                                          fillColor: Colors.white,
                                          border: new OutlineInputBorder(
                                            borderRadius:
                                            new BorderRadius.circular(25.0),
                                            borderSide: new BorderSide(),
                                          ),
                                          //fillColor: Colors.green
                                        ),
                                        keyboardType: TextInputType.emailAddress,
                                        style: new TextStyle(
                                          fontFamily: "Poppins",
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        chooseList.chooseuserList!.isNotEmpty
                                            ? showModalBottomSheet<void>(
                                          context: context,
                                          backgroundColor: Color(0xffFAACB4),
                                          builder: (BuildContext context) {
                                            return Padding(
                                              padding:
                                              const EdgeInsets.all(20.0),
                                              child: ListView.builder(
                                                shrinkWrap: true,
                                                itemBuilder: (BuildContext
                                                context,
                                                    int index) =>
                                                    buildChooseUsers(
                                                        user: chooseList
                                                            .chooseuserList![
                                                        index],
                                                        index: index),
                                                itemCount: chooseList
                                                    .chooseuserList!.length,
                                              ),
                                            );
                                          },
                                        ).whenComplete(() {
                                          setState(() {});
                                        })
                                            : Flushbar(
                                          message:
                                          AppLocalizations.of(context)!
                                              .noEmployee,
                                          icon: Icon(
                                            Icons.info_outline,
                                            size: 30.0,
                                            color: Colors.black,
                                          ),
                                          duration: Duration(seconds: 3),
                                          leftBarIndicatorColor:
                                          Colors.blue[300],
                                          backgroundColor: Colors.red,
                                        ).show(context);
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(bottom: 40),
                                        child: Theme(
                                          data: Theme.of(context).copyWith(
                                              splashColor: Colors.transparent),
                                          child: TextField(
                                            enabled: false,
                                            autofocus: false,
                                            style: TextStyle(
                                                fontSize: 22.0,
                                                color: Color(0xFFbdc6cf)),
                                            decoration: InputDecoration(
                                              filled: true,
                                              fillColor: Color(0xFCED3FF),
                                              label: Padding(
                                                padding: const EdgeInsets.all(10),
                                                child: users.isEmpty
                                                    ? Text(
                                                  "Add this project to",
                                                  style: TextStyle(
                                                      fontWeight:
                                                      FontWeight.bold,
                                                      color: Colors.black45),
                                                )
                                                    : Text(
                                                  'You Selected ${users.length} Employee',
                                                  style: TextStyle(
                                                      fontWeight:
                                                      FontWeight.bold,
                                                      color: Colors.green),
                                                ),
                                              ),
                                              contentPadding: const EdgeInsets.only(
                                                  left: 14.0,
                                                  bottom: 8.0,
                                                  top: 8.0,
                                                  right: 14),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide:
                                                BorderSide(color: Colors.white),
                                                borderRadius:
                                                BorderRadius.circular(25.7),
                                              ),
                                              enabledBorder: UnderlineInputBorder(
                                                borderSide:
                                                BorderSide(color: Colors.white),
                                                borderRadius:
                                                BorderRadius.circular(25.7),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Center(
                                      child: Container(
                                        height: 50,
                                        width: 200,
                                        child: clickAdd == false
                                            ? FancyContainer(
                                          textColor: Colors.white,
                                          onTap: () async {
                                            setState(() {
                                              clickAdd = true;
                                            });
                                            await DioHelper.postData(
                                              url: "api/projects",
                                              data: {
                                                "name": "${projectName.text}",
                                                "description":
                                                "${projectDescription.text}",
                                                "organization_id":
                                                widget.organizationId,
                                                "assignees": users,
                                              },
                                            ).then((value) {
                                              print(value.data);
                                              setState(() {});
                                              clickAdd = false;

                                              print("Shaaaaaaaaatr");
                                              getProjects();
                                              projectName.text = '';
                                              projectDescription.text = '';
                                              Navigator.pop(context);
                                            }).catchError((error) {
                                              clickAdd = false;

                                              setState(() {});
                                              if (projectName.text.isEmpty) {
                                                Flushbar(
                                                  backgroundColor: Colors.red,
                                                  message:
                                                  "${AppLocalizations.of(context)!.projectNameisEmpty}",
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
                                              } else {
                                                Flushbar(
                                                  message:
                                                  "${error.response.data['message']}",
                                                  backgroundColor: Colors.red,
                                                  icon: Icon(
                                                    Icons.info_outline,
                                                    size: 30.0,
                                                    color: Colors.blue[300],
                                                  ),
                                                  duration:
                                                  Duration(seconds: 3),
                                                  leftBarIndicatorColor:
                                                  Colors.blue[300],
                                                )..show(context);
                                              }

                                              print(error.response.data);
                                            });
                                          },
                                          title:
                                          '${AppLocalizations.of(context)!.add}',
                                          color1: Colors.purple,
                                          color2: Colors.lightBlue,
                                        )
                                            : Center(
                                          child: CircularProgressIndicator(
                                            color: Colors.indigo,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                        );
                      });
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
                      child: Column(children: [
                        Text(
                          "${AppLocalizations.of(context)!.myProject}",
                          style: TextStyle(
                              fontSize: 30,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        projectLoading == false
                            ? Column(
                          children: [
                            projects.projectList!.isNotEmpty
                                ? SizedBox(
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: const ScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                itemBuilder: (BuildContext context,
                                    int index) =>
                                    buildProjects(
                                        project: projects
                                            .projectList![index],
                                        index: index,
                                        context: context),
                                itemCount:
                                projects.projectList!.length,
                              ),
                            )
                                : const Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 300),
                              child: Center(
                                child: Text(
                                  "No Projects Found",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        )
                            : const Padding(
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
          )),
    );
  }

  Widget buildProjects({
    required ProjectsModel project,
    required int index,
    required BuildContext context,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MultiScreenForTasks(
                  projectId: project.id,
                  organization_id: widget.organizationId!,
                  currentIndex: 0,
                  organizationsArabicName: widget.organizationsArabicName,
                  oranizaionsList: widget.oranizaionsList,
                  userId: widget.userId,
                  organizationsName: widget.organizationsName,
                  phaseName: '',
                  phaseId: null,
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
                project.name,
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            project.description != null
                ? Text(
              '${project.description}',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            )
                : SizedBox(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                    onPressed: () {
                      projectName.text = project.name;
                      users = project.assignees as List<int>;
                      if (project.description == null) {
                        projectDescription.text = '';
                      } else {
                        projectDescription.text = project.description!;
                      }
                      showModalBottomSheet<void>(
                        isScrollControlled: true,
                        context: context,
                        builder: (BuildContext context) {
                          return StatefulBuilder(builder:
                              (BuildContext context, StateSetter setState) {
                            return Padding(
                              padding: EdgeInsets.only(
                                  top: 20,
                                  right: 20,
                                  left: 20,
                                  bottom:
                                  MediaQuery.of(context).viewInsets.bottom),
                              child: Container(
                                  height:
                                  MediaQuery.of(context).size.height / 2,
                                  width:
                                  MediaQuery.of(context).size.width / 1.1,
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(15.0),
                                          child: Text(
                                            "Edit Project Name",
                                            style: TextStyle(
                                                fontSize: 30,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                          const EdgeInsets.only(bottom: 20),
                                          child: Container(
                                            width: 300,
                                            child: TextFormField(
                                              controller: projectName,
                                              decoration: new InputDecoration(
                                                labelText: "Project Name",
                                                fillColor: Colors.white,
                                                border: new OutlineInputBorder(
                                                  borderRadius:
                                                  new BorderRadius.circular(
                                                      25.0),
                                                  borderSide: new BorderSide(),
                                                ),
                                                //fillColor: Colors.green
                                              ),
                                              keyboardType:
                                              TextInputType.emailAddress,
                                              style: new TextStyle(
                                                fontFamily: "Poppins",
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
                                        Container(
                                          width: 300,
                                          child: TextFormField(
                                            controller: projectDescription,
                                            decoration: new InputDecoration(
                                              labelText: "Project Description",
                                              fillColor: Colors.white,
                                              border: new OutlineInputBorder(
                                                borderRadius:
                                                new BorderRadius.circular(
                                                    25.0),
                                                borderSide: new BorderSide(),
                                              ),
                                              //fillColor: Colors.green
                                            ),
                                            keyboardType:
                                            TextInputType.emailAddress,
                                            style: new TextStyle(
                                              fontFamily: "Poppins",
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            chooseList
                                                .chooseuserList!.isNotEmpty
                                                ? showModalBottomSheet<void>(
                                              context: context,
                                              backgroundColor:
                                              Color(0xffFAACB4),
                                              builder:
                                                  (BuildContext context) {
                                                return Padding(
                                                  padding:
                                                  const EdgeInsets
                                                      .all(20.0),
                                                  child: ListView.builder(
                                                    shrinkWrap: true,
                                                    itemBuilder: (BuildContext
                                                    context,
                                                        int index) =>
                                                        buildChooseUsers(
                                                            user: chooseList
                                                                .chooseuserList![
                                                            index],
                                                            index: index),
                                                    itemCount: chooseList
                                                        .chooseuserList!
                                                        .length,
                                                  ),
                                                );
                                              },
                                            ).whenComplete(() {
                                              setState(() {});
                                            })
                                                : Flushbar(
                                              message:
                                              AppLocalizations.of(
                                                  context)!
                                                  .noEmployee,
                                              icon: Icon(
                                                Icons.info_outline,
                                                size: 30.0,
                                                color: Colors.black,
                                              ),
                                              duration:
                                              Duration(seconds: 3),
                                              leftBarIndicatorColor:
                                              Colors.blue[300],
                                              backgroundColor: Colors.red,
                                            ).show(context);
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 40),
                                            child: Theme(
                                              data: Theme.of(context).copyWith(
                                                  splashColor:
                                                  Colors.transparent),
                                              child: TextField(
                                                enabled: false,
                                                autofocus: false,
                                                style: TextStyle(
                                                    fontSize: 22.0,
                                                    color: Color(0xFFbdc6cf)),
                                                decoration: InputDecoration(
                                                  filled: true,
                                                  fillColor: Color(0xFCED3FF),
                                                  label: Padding(
                                                    padding:
                                                    const EdgeInsets.all(
                                                        10),
                                                    child: users.isEmpty
                                                        ? Text(
                                                      "Add this project to",
                                                      style: TextStyle(
                                                          fontWeight:
                                                          FontWeight
                                                              .bold,
                                                          color: Colors
                                                              .black45),
                                                    )
                                                        : Text(
                                                      'You Selected ${users.length} Employee',
                                                      style: const TextStyle(
                                                          fontWeight:
                                                          FontWeight
                                                              .bold,
                                                          color: Colors
                                                              .green),
                                                    ),
                                                  ),
                                                  contentPadding:
                                                  const EdgeInsets.only(
                                                      left: 14.0,
                                                      bottom: 8.0,
                                                      top: 8.0,
                                                      right: 14),
                                                  focusedBorder:
                                                  OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.white),
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        25.7),
                                                  ),
                                                  enabledBorder:
                                                  UnderlineInputBorder(
                                                    borderSide:
                                                    const BorderSide(
                                                        color:
                                                        Colors.white),
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        25.7),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Center(
                                          child: Container(
                                            height: 50,
                                            width: 200,
                                            child: clickAdd == false
                                                ? FancyContainer(
                                              textColor: Colors.white,
                                              onTap: () async {
                                                setState(() {
                                                  clickAdd = true;
                                                });
                                                await DioHelper.patchData(
                                                  url:
                                                  "api/projects/${project.id}",
                                                  data: {
                                                    "name":
                                                    projectName.text,
                                                    "description":
                                                    projectDescription
                                                        .text,
                                                    "assignees": users,
                                                  },
                                                ).then((value) {
                                                  print(projectName.text);
                                                  print(projectDescription
                                                      .text);
                                                  print(value.data);
                                                  print(
                                                      "Tmaaaaaaaaaaaaaaaaaaaaaaaaam");
                                                  setState(() {});
                                                  clickAdd = false;
                                                  getProjects();

                                                  Navigator.pop(context);
                                                  print("Shaaaaaaaaatr");
                                                }).catchError((error) {
                                                  clickAdd = false;

                                                  setState(() {});
                                                  if (projectName
                                                      .text.isEmpty) {
                                                    Flushbar(
                                                      backgroundColor:
                                                      Colors.red,
                                                      message:
                                                      "${AppLocalizations.of(context)!.projectNameisEmpty}",
                                                      icon: Icon(
                                                        Icons
                                                            .info_outline,
                                                        size: 30.0,
                                                        color:
                                                        Colors.black,
                                                      ),
                                                      duration: Duration(
                                                          seconds: 3),
                                                      leftBarIndicatorColor:
                                                      Colors
                                                          .blue[300],
                                                    )..show(context);
                                                  } else if (projectDescription
                                                      .text.isEmpty) {
                                                    Flushbar(
                                                      message:
                                                      "${AppLocalizations.of(context)!.projectDescisEmpty}",
                                                      backgroundColor:
                                                      Colors.red,
                                                      icon: Icon(
                                                        Icons
                                                            .info_outline,
                                                        size: 30.0,
                                                        color:
                                                        Colors.black,
                                                      ),
                                                      duration: Duration(
                                                          seconds: 3),
                                                      leftBarIndicatorColor:
                                                      Colors
                                                          .blue[300],
                                                    )..show(context);
                                                  } else {
                                                    Flushbar(
                                                      message:
                                                      "${AppLocalizations.of(context)!.project_error}",
                                                      icon: Icon(
                                                        Icons
                                                            .info_outline,
                                                        size: 30.0,
                                                        color: Colors
                                                            .blue[300],
                                                      ),
                                                      duration: Duration(
                                                          seconds: 3),
                                                      leftBarIndicatorColor:
                                                      Colors
                                                          .blue[300],
                                                    )..show(context);
                                                  }

                                                  print(error
                                                      .response.data);
                                                });
                                              },
                                              title: 'Save',
                                              color1: Colors.purple,
                                              color2: Colors.lightBlue,
                                            )
                                                : Center(
                                              child:
                                              CircularProgressIndicator(
                                                color: Colors.indigo,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                            );
                          });
                        },
                      );
                    },
                    icon: Icon(
                      Icons.edit,
                      color: Colors.white,
                    )),
                IconButton(
                    onPressed: () async {
                      showDialog<void>(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            //  title: const Text('Basic dialog title'),
                            content: Text(
                              'Delete this project ?',
                            ),
                            actions: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .labelLarge,
                                    ),
                                    child: Text(
                                        '${AppLocalizations.of(context)!.yes}'),
                                    onPressed: () async {
                                      setState(() {});
                                      await DioHelper.deleteData(
                                        url: "api/projects/${project.id}",
                                      ).then((value) {
                                        Navigator.pop(context);

                                        setState(() {
                                          projects.projectList?.removeAt(index);
                                        });
                                        print('mbroook');
                                        Flushbar(
                                          messageColor: Colors.black,
                                          backgroundColor: Colors.green,
                                          message: "Project deleted",
                                          icon: Icon(
                                            Icons.verified,
                                            size: 30.0,
                                            color: Colors.white,
                                          ),
                                          duration: Duration(seconds: 3),
                                          leftBarIndicatorColor:
                                          Colors.blue[300],
                                        )..show(context);
                                      }).catchError((error) {
                                        Navigator.pop(context);
                                        setState(() {});
                                        Flushbar(
                                          message:
                                          "${error.response.data['message']}",
                                          backgroundColor: Colors.red,
                                          icon: Icon(
                                            Icons.info_outline,
                                            size: 30.0,
                                            color: Colors.blue[300],
                                          ),
                                          duration: Duration(seconds: 3),
                                          leftBarIndicatorColor:
                                          Colors.blue[300],
                                        )..show(context);
                                      });
                                    },
                                  ),
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .labelLarge,
                                    ),
                                    child: Text(
                                        '${AppLocalizations.of(context)!.no}'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      );
                    },
                    icon: Icon(
                      Icons.delete,
                      color: Colors.white,
                    )),

              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildChooseUsers({required ChooseUserModel user, required int index}) {
    userId = user.userId;
    return StatefulBuilder(builder:
        (BuildContext context, void Function(void Function()) setState) {
      return Row(
        children: [
          Expanded(
            child: Text(
              "${user.name}",
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Checkbox(
              checkColor: Colors.white,
              value: users.contains(user.userId),
              onChanged: (bool? value) {
                if (!users.contains(user.userId)) {
                  setState(
                        () {
                      users.add(user.userId);
                    },
                  );
                } else {
                  setState(
                        () {
                      users.remove(user.userId);
                    },
                  );
                }
                print(users);
              },
            ),
          ),
        ],
      );
    });
  }
}