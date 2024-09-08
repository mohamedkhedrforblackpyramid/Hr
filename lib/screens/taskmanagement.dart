import 'dart:math';
import 'package:another_flushbar/flushbar.dart';
import 'package:fancy_containers/fancy_containers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_face_pile/flutter_face_pile.dart';
import 'package:hr/projectfield.dart';
import '../modules/chooseusers.dart';
import '../modules/organizationmodel.dart';
import '../modules/phases.dart';
import '../modules/projects.dart';
import '../modules/tasks.dart';
import '../network/remote/dio_helper.dart';
import 'choose_list.dart';
import 'multiscreen_tasks/multiscreenfortasks.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TaskManagement extends StatefulWidget {
  int? organizationId;
  int? userId;
  late OrganizationsList oranizaionsList;
  String? organizationsName;
  String? organizationsArabicName;
  TaskManagement(
      {required this.organizationId,
      required this.userId,
      required this.oranizaionsList,
      required this.organizationsName,
      required this.organizationsArabicName});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<TaskManagement> {
  String? selectedProject;
  String? selectedPhase;
  int? phaseId;
  int? projectId;
  bool projectSelected = false;
  late ProjectsList projectsNew;
  bool projectLoading = false;
  late PhaseList phase_list;
  bool phaseLoading = false;
  bool projectClick = false;
  bool phaseClick = false;
  bool tasksLoading = false;
  late TasksList task_list;
  String searchQuery = '';
  bool noSearch = false;
  var projectName = TextEditingController();
  var phaseName = TextEditingController();
  var projectDescription = TextEditingController();
  TextEditingController controller = TextEditingController();
  List<int?> users = [];
  late ChooseUserList chooseList;
  int? userId;
  bool clickAddProject = false;
  var taskName = TextEditingController();
  var phaseDescription = TextEditingController();
  bool clickAdd = false;
  var taskDescription = TextEditingController();

  getProjects() async {
    projectLoading = true;
    await DioHelper.getData(
        url: "api/projects",
        query: {'organization_id': widget.organizationId}).then((response) {
      projectsNew = ProjectsList.fromJson(response.data);

      print(response.data);

      setState(() {
        projectLoading = false;
      });
    }).catchError((error) {
      print(error);
    });
  }

  List<FaceHolder> getFaceHolders(ProjectsModel project) {
    return project.assignee_avatars.asMap().entries.map((entry) {
      int index = entry.key;
      String avatarUrl = entry.value;
      return FaceHolder(
        id: (project.assignees[index] ?? index).toString(),
        name: 'User $index', // Or use an appropriate name if available
        avatar: NetworkImage(avatarUrl),
      );
    }).toList();
  }

  searchProjects(String query) async {
    projectLoading = true;
    await DioHelper.getData(
            url: "api/projects",
            query: {'organization_id': widget.organizationId, 'name': query})
        .then((response) {
      projectsNew = ProjectsList.fromJson(response.data);
      print(response.data);
      if (projectsNew.projectList!.isEmpty) {
        noSearch = true;
      } else {
        noSearch = false;
      }
      setState(() {
        projectLoading = false;
      });
    }).catchError((error) {
      print(error);
    });
  }

  getPhases() {
    phaseLoading = true;
    DioHelper.getData(url: "api/phases/", query: {
      'organization_id': widget.organizationId,
      'project_id': projectId
    }).then((response) {
      phase_list = PhaseList.fromJson(response.data);

      print(response.data);
      setState(() {
        phaseLoading = false;
      });
    }).catchError((error) {
      print('hhhhhhhhhhhhhhhh');
      print(error.response.data);
    });
  }

  getTasks() async {
    tasksLoading = true;
    await DioHelper.getData(
      url:
          "api/current-tasks?organization_id=${widget.organizationId}&phase_id=${phaseId}",
    ).then((response) {
      task_list = TasksList.fromJson(response.data);
      print(response.data);
      setState(() {
        tasksLoading = false;
      });
    }).catchError((error) {
      print(error.response.data);
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

  returnPage() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ProjectsField(
                  userId: widget.userId,
                  oranizaionsList: widget.oranizaionsList,
                  organizationId: widget.organizationId,
                  organizationsName: widget.organizationsName,
                  organizationsArabicName: widget.organizationsArabicName,
                  personType: '',
                )));
  }

  @override
  void initState() {
    //  getAllTasks();
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
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          elevation: 0,
          title: TextField(
            controller: controller,
            decoration: InputDecoration(
                hintText: '${AppLocalizations.of(context)!.findProject}',
                border: InputBorder.none,
                filled: true,
                fillColor: Colors.grey[200],
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                suffixIcon: IconButton(
                  onPressed: () {
                    controller.text = '';
                    noSearch = false;
                    getProjects();
                  },
                  icon: const Icon(Icons.cancel_outlined),
                )),
            onChanged: (value) {
              setState(() {});
              searchQuery = value;
              if (searchQuery != '' || searchQuery.isNotEmpty) {
                noSearch = true;
                searchProjects(searchQuery);
              } else {
                noSearch = false;
                getProjects();
              }
            },
          ),
          actions: [],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: projectLoading == false
                ? noSearch == false
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                Text(
                                  '${AppLocalizations.of(context)!.myProject}',
                                  style: TextStyle(
                                      fontSize: 24, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                IconButton(
                                    onPressed: () {
                                      projectName.text = '';
                                      projectDescription.text = '';
                                      users.length = 0;
                                      showModalBottomSheet<void>(
                                        isScrollControlled: true,
                                        context: context,
                                        builder: (BuildContext context) {
                                          return StatefulBuilder(builder:
                                              (BuildContext context,
                                                  StateSetter setState) {
                                            return Padding(
                                              padding: EdgeInsets.only(
                                                  top: 20,
                                                  right: 20,
                                                  left: 20,
                                                  bottom: MediaQuery.of(context)
                                                      .viewInsets
                                                      .bottom),
                                              child: Container(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height /
                                                      2,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      1.1,
                                                  child: SingleChildScrollView(
                                                    child: Column(
                                                      children: [
                                                        Padding(
                                                          padding: EdgeInsets.all(
                                                              15.0),
                                                          child: Text(
                                                            "${AppLocalizations.of(context)!.addProject}",
                                                            style: TextStyle(
                                                                fontSize: 30,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  bottom: 20),
                                                          child: Container(
                                                            width: 300,
                                                            child: TextFormField(
                                                              controller:
                                                                  projectName,
                                                              decoration:
                                                                  new InputDecoration(
                                                                labelText:
                                                                    "${AppLocalizations.of(context)!.projectName}",
                                                                fillColor:
                                                                    Colors.white,
                                                                border:
                                                                    new OutlineInputBorder(
                                                                  borderRadius:
                                                                      new BorderRadius
                                                                          .circular(
                                                                          25.0),
                                                                  borderSide:
                                                                      new BorderSide(),
                                                                ),
                                                                //fillColor: Colors.green
                                                              ),
                                                              keyboardType:
                                                                  TextInputType
                                                                      .emailAddress,
                                                              style:
                                                                  new TextStyle(
                                                                fontFamily:
                                                                    "Poppins",
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                        Container(
                                                          width: 300,
                                                          child: TextFormField(
                                                            controller:
                                                                projectDescription,
                                                            decoration:
                                                                new InputDecoration(
                                                              labelText:
                                                                  "${AppLocalizations.of(context)!.projectDescription}",
                                                              fillColor:
                                                                  Colors.white,
                                                              border:
                                                                  new OutlineInputBorder(
                                                                borderRadius:
                                                                    new BorderRadius
                                                                        .circular(
                                                                        25.0),
                                                                borderSide:
                                                                    new BorderSide(),
                                                              ),
                                                              //fillColor: Colors.green
                                                            ),
                                                            keyboardType:
                                                                TextInputType
                                                                    .emailAddress,
                                                            style: new TextStyle(
                                                              fontFamily:
                                                                  "Poppins",
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 20,
                                                        ),
                                                        GestureDetector(
                                                          onTap: () {
                                                            chooseList
                                                                    .chooseuserList!
                                                                    .isNotEmpty
                                                                ? showModalBottomSheet<
                                                                    void>(
                                                                    context:
                                                                        context,
                                                                    // backgroundColor: Colors.,
                                                                    builder:
                                                                        (BuildContext
                                                                            context) {
                                                                      return Padding(
                                                                        padding: const EdgeInsets
                                                                            .all(
                                                                            20.0),
                                                                        child: ListView
                                                                            .builder(
                                                                          shrinkWrap:
                                                                              true,
                                                                          itemBuilder: (BuildContext context, int index) => buildChooseUsers(
                                                                              user:
                                                                                  chooseList.chooseuserList![index],
                                                                              index: index),
                                                                          itemCount: chooseList
                                                                              .chooseuserList!
                                                                              .length,
                                                                        ),
                                                                      );
                                                                    },
                                                                  ).whenComplete(
                                                                    () {
                                                                    setState(
                                                                        () {});
                                                                  })
                                                                : Flushbar(
                                                                    message:
                                                                        'No Employee',
                                                                    icon:
                                                                        const Icon(
                                                                      Icons
                                                                          .info_outline,
                                                                      size: 30.0,
                                                                      color: Colors
                                                                          .black,
                                                                    ),
                                                                    duration:
                                                                        const Duration(
                                                                            seconds:
                                                                                3),
                                                                    leftBarIndicatorColor:
                                                                        Colors.blue[
                                                                            300],
                                                                    backgroundColor:
                                                                        Colors
                                                                            .red,
                                                                  ).show(context);
                                                          },
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    bottom: 40),
                                                            child: Theme(
                                                              data: Theme.of(
                                                                      context)
                                                                  .copyWith(
                                                                      splashColor:
                                                                          Colors
                                                                              .transparent),
                                                              child: TextField(
                                                                enabled: false,
                                                                autofocus: false,
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        22.0,
                                                                    color: Color(
                                                                        0xFFbdc6cf)),
                                                                decoration:
                                                                    InputDecoration(
                                                                  filled: true,
                                                                  fillColor:
                                                                      const Color(
                                                                          0xFCED3FF),
                                                                  label: Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(
                                                                            10),
                                                                    child: users
                                                                            .isEmpty
                                                                        ? Text(
                                                                            "${AppLocalizations.of(context)!.addThisProjectTo}",
                                                                            style: TextStyle(
                                                                                fontWeight: FontWeight.bold,
                                                                                color: Colors.black45),
                                                                          )
                                                                        : Text(
                                                                            '${AppLocalizations.of(context)!.selectedEmployee}${users.length}',
                                                                            style: const TextStyle(
                                                                                fontWeight: FontWeight.bold,
                                                                                color: Colors.green),
                                                                          ),
                                                                  ),
                                                                  contentPadding:
                                                                      const EdgeInsets
                                                                          .only(
                                                                          left:
                                                                              14.0,
                                                                          bottom:
                                                                              8.0,
                                                                          top:
                                                                              8.0,
                                                                          right:
                                                                              14),
                                                                  focusedBorder:
                                                                      OutlineInputBorder(
                                                                    borderSide:
                                                                        const BorderSide(
                                                                            color:
                                                                                Colors.white),
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(
                                                                                25.7),
                                                                  ),
                                                                  enabledBorder:
                                                                      UnderlineInputBorder(
                                                                    borderSide:
                                                                        const BorderSide(
                                                                            color:
                                                                                Colors.white),
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(
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
                                                            child: clickAddProject ==
                                                                    false
                                                                ? FancyContainer(
                                                                    textColor:
                                                                        Colors
                                                                            .white,
                                                                    onTap:
                                                                        () async {
                                                                      setState(
                                                                          () {
                                                                        clickAddProject =
                                                                            true;
                                                                      });
                                                                      await DioHelper
                                                                          .postData(
                                                                        url:
                                                                            "api/projects",
                                                                        data: {
                                                                          "name":
                                                                              "${projectName.text}",
                                                                          "description":
                                                                              "${projectDescription.text}",
                                                                          "organization_id":
                                                                              widget.organizationId,
                                                                          "assignees":
                                                                              users,
                                                                        },
                                                                      ).then(
                                                                          (value) {
                                                                        print(value
                                                                            .data);
                                                                        setState(
                                                                            () {});
                                                                        clickAddProject =
                                                                            false;

                                                                        print(
                                                                            "Shaaaaaaaaatr");
                                                                        getProjects();
                                                                        projectName
                                                                            .text = '';
                                                                        projectDescription
                                                                            .text = '';
                                                                        Navigator.pop(
                                                                            context);
                                                                      }).catchError(
                                                                          (error) {
                                                                        clickAddProject =
                                                                            false;

                                                                        setState(
                                                                            () {});
                                                                        if (projectName
                                                                            .text
                                                                            .isEmpty) {
                                                                          Flushbar(
                                                                            backgroundColor:
                                                                                Colors.red,
                                                                            message:
                                                                                "${AppLocalizations.of(context)!.projectNameisEmpty}",
                                                                            icon:
                                                                                const Icon(
                                                                              Icons.info_outline,
                                                                              size:
                                                                                  30.0,
                                                                              color:
                                                                                  Colors.black,
                                                                            ),
                                                                            duration:
                                                                                const Duration(seconds: 3),
                                                                            leftBarIndicatorColor:
                                                                                Colors.blue[300],
                                                                          )..show(
                                                                              context);
                                                                        } else {
                                                                          Flushbar(
                                                                            message:
                                                                                "${error.response.data['message']}",
                                                                            backgroundColor:
                                                                                Colors.red,
                                                                            icon:
                                                                                Icon(
                                                                              Icons.info_outline,
                                                                              size:
                                                                                  30.0,
                                                                              color:
                                                                                  Colors.blue[300],
                                                                            ),
                                                                            duration:
                                                                                const Duration(seconds: 3),
                                                                            leftBarIndicatorColor:
                                                                                Colors.blue[300],
                                                                          )..show(
                                                                              context);
                                                                        }

                                                                        print(error
                                                                            .response
                                                                            .data);
                                                                      });
                                                                    },
                                                                    title:
                                                                        '${AppLocalizations.of(context)!.save}',
                                                                    color1: Colors
                                                                        .purple,
                                                                    color2: Colors
                                                                        .lightBlue,
                                                                  )
                                                                : const Center(
                                                                    child:
                                                                        CircularProgressIndicator(
                                                                      color: Colors
                                                                          .indigo,
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
                                      Icons.add_circle_sharp,
                                      size: 40,
                                      color: Colors.deepPurple.shade200,
                                    )),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    projectName.text,
                                    style: TextStyle(
                                      fontSize: projectName.text.length<12? 24 : 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red.shade200,
                                    ),
                                    maxLines: 2, // عدد الأسطر الأقصى
                                    overflow: TextOverflow.ellipsis, // لإظهار "..." إذا كان النص يتجاوز الأسطر المحددة
                                    textAlign: TextAlign.start, // محاذاة النص (يمكنك استخدام TextAlign.center أو TextAlign.end حسب الحاجة)
                                  )
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(children: [
                              SizedBox(
                                height: 180,
                                child: ListView.separated(
                                  shrinkWrap: true,
                                  physics: const ScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder:
                                      (BuildContext context, int index) =>
                                          buildProjects(
                                    task: projectsNew.projectList![index],
                                    index: index,
                                  ),
                                  itemCount: projectsNew.projectList!.length,
                                  separatorBuilder:
                                      (BuildContext context, int index) =>
                                          const SizedBox(
                                    height: 5,
                                  ),
                                ),
                              )
                            ]),
                          ),
                          const SizedBox(height: 16),
                          if (projectClick == true) ...[
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  Text(
                                    '${AppLocalizations.of(context)!.phases}',
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    MultiScreenForTasks(
                                                      projectName: projectName.text,
                                                      projectId: projectId!,
                                                      organization_id:
                                                          widget.organizationId!,
                                                      currentIndex: 1,
                                                      organizationsName: widget
                                                          .organizationsName,
                                                      userId: widget.userId,
                                                      oranizaionsList:
                                                          widget.oranizaionsList,
                                                      organizationsArabicName: widget
                                                          .organizationsArabicName,
                                                      phaseName: '',
                                                      phaseId: phaseId,
                                                    )));
                                      },
                                      icon: Icon(
                                        Icons.add_circle_sharp,
                                        size: 40,
                                        color: Colors.deepPurple.shade200,
                                      )),
                                  Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        taskName.text,
                                        style: TextStyle(
                                          fontSize: taskName.text.length<12? 24 : 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red.shade200,
                                        ),
                                        maxLines: 2, // عدد الأسطر الأقصى
                                        overflow: TextOverflow.ellipsis, // لإظهار "..." إذا كان النص يتجاوز الأسطر المحددة
                                        textAlign: TextAlign.start, // محاذاة النص (يمكنك استخدام TextAlign.center أو TextAlign.end حسب الحاجة)
                                      )
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            phaseLoading == false
                                ? SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(children: [
                                      phase_list.phaseList!.isNotEmpty
                                          ? GestureDetector(
                                              child: SizedBox(
                                              height: 100,
                                              child: ListView.separated(
                                                shrinkWrap: true,
                                                physics: const ScrollPhysics(),
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemBuilder:
                                                    (BuildContext context,
                                                            int index) =>
                                                        buildPhase(
                                                  task: phase_list
                                                      .phaseList![index],
                                                  index: index,
                                                ),
                                                itemCount: phase_list
                                                    .phaseList!.length,
                                                separatorBuilder:
                                                    (BuildContext context,
                                                            int index) =>
                                                        const SizedBox(
                                                  height: 5,
                                                ),
                                              ),
                                            ))
                                          : const Center(
                                              child: Text(
                                                "No Phases Found",
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.redAccent,
                                                ),
                                              ),
                                            ),
                                    ]))
                                : const Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 100),
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.indigo,
                                      ),
                                    ),
                                  ),
                            const SizedBox(height: 16),
                            if (phaseClick == true) ...[
                              Row(
                                children: [
                                  Text(
                                    '${AppLocalizations.of(context)!.tasks}',
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    MultiScreenForTasks(
                                                      projectName: projectName.text,
                                                      projectId: projectId!,
                                                      organization_id: widget
                                                          .organizationId!,
                                                      currentIndex: 2,
                                                      organizationsName: widget
                                                          .organizationsName,
                                                      userId: widget.userId,
                                                      oranizaionsList: widget
                                                          .oranizaionsList,
                                                      organizationsArabicName:
                                                          widget
                                                              .organizationsArabicName,
                                                      phaseName: taskName.text,
                                                      phaseId: phaseId,

                                                    )));
                                      },
                                      icon: Icon(
                                        Icons.add_circle_sharp,
                                        size: 40,
                                        color: Colors.deepPurple.shade200,
                                      ))
                                ],
                              ),
                              const SizedBox(height: 8),
                              tasksLoading == false
                                  ? Column(
                                      children: [
                                        task_list.tasksList!.isNotEmpty
                                            ? ListView.separated(
                                                shrinkWrap: true,
                                                physics: const ScrollPhysics(),
                                                scrollDirection: Axis.vertical,
                                                itemBuilder:
                                                    (BuildContext context,
                                                            int index) =>
                                                        buildTasks(
                                                  task: task_list
                                                      .tasksList![index],
                                                  index: index,
                                                ),
                                                itemCount:
                                                    task_list.tasksList!.length,
                                                separatorBuilder:
                                                    (BuildContext context,
                                                            int index) =>
                                                        const SizedBox(
                                                  height: 5,
                                                ),
                                              )
                                            : const Center(
                                                child: Text(
                                                  "No Tasks Found",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.redAccent,
                                                  ),
                                                ),
                                              ),
                                      ],
                                    )
                                  : const Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 300),
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          color: Colors.indigo,
                                        ),
                                      ),
                                    ),
                            ],
                          ],
                        ],
                      )
                    : const Center(child: Text("No Project Found"))
                : const Padding(
                    padding: EdgeInsets.symmetric(vertical: 300),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Colors.indigo,
                      ),
                    ),
                  ),
          ),
        ),
        /*
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home, color: Colors.blue),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search, color: Colors.grey),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today, color: Colors.grey),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person, color: Colors.grey),
              label: '',
            ),
          ],
        ),
      */
      ),
    );
  }

  Widget buildProjects({
    required ProjectsModel task,
    required int index,
  }) {
    return GestureDetector(
      onTap: () async {
        projectName.text = task.name;
        projectId = task.id;
        projectClick = true;
        phaseClick = false;
        taskName.text = '';
        await getPhases();
        setState(() {});
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: projectSelected ? 220 : 200,
        width: projectSelected ? 240 : 200,
        margin: const EdgeInsets.only(right: 16),
        child: Card(
          color: Colors
              .primaries[Random().nextInt(Colors.primaries.length)].shade100,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 50,left: 10,right: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Text(
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        '${task.name}',
                        style: TextStyle(color: Colors.grey[700], fontSize: 20),
                      ),
                      flex: 5,
                    ),
                    Expanded(
                      child: PopupMenuButton(
                        onSelected: (value) {
                          // تنفيذ الإجراءات بناءً على القيمة المحددة
                          if (value == 'edit') {
                            projectName.text = task.name;
                            users = task.assignees as List<int>;
                            if (task.description == null) {
                              projectDescription.text = '';
                            } else {
                              projectDescription.text = task.description!;
                            }
                            showModalBottomSheet<void>(
                              isScrollControlled: true,
                              context: context,
                              builder: (BuildContext context) {
                                return StatefulBuilder(builder:
                                    (BuildContext context,
                                        StateSetter setState) {
                                  return Padding(
                                    padding: EdgeInsets.only(
                                        top: 20,
                                        right: 20,
                                        left: 20,
                                        bottom: MediaQuery.of(context)
                                            .viewInsets
                                            .bottom),
                                    child: Container(
                                        height:
                                            MediaQuery.of(context).size.height /
                                                2,
                                        width:
                                            MediaQuery.of(context).size.width /
                                                1.1,
                                        child: SingleChildScrollView(
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.all(15.0),
                                                child: Text(
                                                  "${AppLocalizations.of(context)!.editProject}",
                                                  style: TextStyle(
                                                      fontSize: 30,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 20),
                                                child: Container(
                                                  width: 300,
                                                  child: TextFormField(
                                                    controller: projectName,
                                                    decoration:
                                                        new InputDecoration(
                                                      labelText:
                                                          "${AppLocalizations.of(context)!.projectName}",
                                                      fillColor: Colors.white,
                                                      border:
                                                          new OutlineInputBorder(
                                                        borderRadius:
                                                            new BorderRadius
                                                                .circular(25.0),
                                                        borderSide:
                                                            new BorderSide(),
                                                      ),
                                                      //fillColor: Colors.green
                                                    ),
                                                    keyboardType: TextInputType
                                                        .emailAddress,
                                                    style: new TextStyle(
                                                      fontFamily: "Poppins",
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Container(
                                                width: 300,
                                                child: TextFormField(
                                                  controller:
                                                      projectDescription,
                                                  decoration:
                                                      new InputDecoration(
                                                    labelText:
                                                        "${AppLocalizations.of(context)!.projectDescription}",
                                                    fillColor: Colors.white,
                                                    border:
                                                        new OutlineInputBorder(
                                                      borderRadius:
                                                          new BorderRadius
                                                              .circular(25.0),
                                                      borderSide:
                                                          new BorderSide(),
                                                    ),
                                                    //fillColor: Colors.green
                                                  ),
                                                  keyboardType: TextInputType
                                                      .emailAddress,
                                                  style: new TextStyle(
                                                    fontFamily: "Poppins",
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  chooseList.chooseuserList!
                                                          .isNotEmpty
                                                      ? showModalBottomSheet<
                                                          void>(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(
                                                                      20.0),
                                                              child: ListView
                                                                  .builder(
                                                                shrinkWrap:
                                                                    true,
                                                                itemBuilder: (BuildContext
                                                                            context,
                                                                        int
                                                                            index) =>
                                                                    buildChooseUsers(
                                                                        user: chooseList.chooseuserList![
                                                                            index],
                                                                        index:
                                                                            index),
                                                                itemCount:
                                                                    chooseList
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
                                                              'No Employee',
                                                          icon: const Icon(
                                                            Icons.info_outline,
                                                            size: 30.0,
                                                            color: Colors.black,
                                                          ),
                                                          duration:
                                                              const Duration(
                                                                  seconds: 3),
                                                          leftBarIndicatorColor:
                                                              Colors.blue[300],
                                                          backgroundColor:
                                                              Colors.red,
                                                        ).show(context);
                                                },
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 40),
                                                  child: Theme(
                                                    data: Theme.of(context)
                                                        .copyWith(
                                                            splashColor: Colors
                                                                .transparent),
                                                    child: TextField(
                                                      enabled: false,
                                                      autofocus: false,
                                                      style: const TextStyle(
                                                          fontSize: 22.0,
                                                          color: Color(
                                                              0xFFbdc6cf)),
                                                      decoration:
                                                          InputDecoration(
                                                        filled: true,
                                                        fillColor: const Color(
                                                            0xFCED3FF),
                                                        label: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(10),
                                                          child: users.isEmpty
                                                              ? Text(
                                                                  "${AppLocalizations.of(context)!.addThisProjectTo}",
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Colors
                                                                          .black45),
                                                                )
                                                              : Text(
                                                                  '${AppLocalizations.of(context)!.selectedEmployee}${users.length}',
                                                                  style: const TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Colors
                                                                          .green),
                                                                ),
                                                        ),
                                                        contentPadding:
                                                            const EdgeInsets
                                                                .only(
                                                                left: 14.0,
                                                                bottom: 8.0,
                                                                top: 8.0,
                                                                right: 14),
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              const BorderSide(
                                                                  color: Colors
                                                                      .white),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      25.7),
                                                        ),
                                                        enabledBorder:
                                                            UnderlineInputBorder(
                                                          borderSide:
                                                              const BorderSide(
                                                                  color: Colors
                                                                      .white),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
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
                                                  child: clickAddProject ==
                                                          false
                                                      ? FancyContainer(
                                                          textColor:
                                                              Colors.white,
                                                          onTap: () async {
                                                            setState(() {
                                                              clickAddProject =
                                                                  true;
                                                            });
                                                            await DioHelper
                                                                .patchData(
                                                              url:
                                                                  "api/projects/${task.id}",
                                                              data: {
                                                                "name":
                                                                    projectName
                                                                        .text,
                                                                "description":
                                                                    projectDescription
                                                                        .text,
                                                                "assignees":
                                                                    users,
                                                              },
                                                            ).then((value) {
                                                              print(projectName
                                                                  .text);
                                                              print(
                                                                  projectDescription
                                                                      .text);
                                                              print(value.data);
                                                              print(
                                                                  "Tmaaaaaaaaaaaaaaaaaaaaaaaaam");
                                                              setState(() {});
                                                              clickAddProject =
                                                                  false;
                                                              getProjects();

                                                              Navigator.pop(
                                                                  context);
                                                              print(
                                                                  "Shaaaaaaaaatr");
                                                            }).catchError(
                                                                (error) {
                                                              clickAddProject =
                                                                  false;

                                                              setState(() {});
                                                              if (projectName
                                                                  .text
                                                                  .isEmpty) {
                                                                Flushbar(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .red,
                                                                  message:
                                                                      "${AppLocalizations.of(context)!.projectNameisEmpty}",
                                                                  icon:
                                                                      const Icon(
                                                                    Icons
                                                                        .info_outline,
                                                                    size: 30.0,
                                                                    color: Colors
                                                                        .black,
                                                                  ),
                                                                  duration:
                                                                      const Duration(
                                                                          seconds:
                                                                              3),
                                                                  leftBarIndicatorColor:
                                                                      Colors.blue[
                                                                          300],
                                                                )..show(
                                                                    context);
                                                              } else if (projectDescription
                                                                  .text
                                                                  .isEmpty) {
                                                                Flushbar(
                                                                  message:
                                                                      "${AppLocalizations.of(context)!.projectDescisEmpty}",
                                                                  backgroundColor:
                                                                      Colors
                                                                          .red,
                                                                  icon:
                                                                      const Icon(
                                                                    Icons
                                                                        .info_outline,
                                                                    size: 30.0,
                                                                    color: Colors
                                                                        .black,
                                                                  ),
                                                                  duration:
                                                                      const Duration(
                                                                          seconds:
                                                                              3),
                                                                  leftBarIndicatorColor:
                                                                      Colors.blue[
                                                                          300],
                                                                )..show(
                                                                    context);
                                                              } else {
                                                                Flushbar(
                                                                  message:
                                                                      "error",
                                                                  icon: Icon(
                                                                    Icons
                                                                        .info_outline,
                                                                    size: 30.0,
                                                                    color: Colors
                                                                            .blue[
                                                                        300],
                                                                  ),
                                                                  duration:
                                                                      const Duration(
                                                                          seconds:
                                                                              3),
                                                                  leftBarIndicatorColor:
                                                                      Colors.blue[
                                                                          300],
                                                                )..show(
                                                                    context);
                                                              }

                                                              print(error
                                                                  .response
                                                                  .data);
                                                            });
                                                          },
                                                          title:
                                                              '${AppLocalizations.of(context)!.save}',
                                                          color1: Colors.purple,
                                                          color2:
                                                              Colors.lightBlue,
                                                        )
                                                      : const Center(
                                                          child:
                                                              CircularProgressIndicator(
                                                            color:
                                                                Colors.indigo,
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
                          } else if (value == 'delete') {
                            showDialog<void>(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  //  title: const Text('Basic dialog title'),
                                  content: Text(
                                    '${AppLocalizations.of(context)!.deleteProject}',
                                    textAlign: TextAlign.center,
                                  ),
                                  actions: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                              url: "api/projects/${task.id}",
                                            ).then((value) {
                                              Navigator.pop(context);

                                              setState(() {
                                                projectsNew.projectList
                                                    ?.removeAt(index);
                                              });
                                              print('mbroook');
                                              Flushbar(
                                                messageColor: Colors.black,
                                                backgroundColor: Colors.green,
                                                message: "Project deleted",
                                                icon: const Icon(
                                                  Icons.verified,
                                                  size: 30.0,
                                                  color: Colors.white,
                                                ),
                                                duration:
                                                    const Duration(seconds: 3),
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
                                                duration:
                                                    const Duration(seconds: 3),
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
                            // قم بإجراء الحذف
                          }
                        },
                        itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                          PopupMenuItem(
                            value: 'edit',
                            child: ListTile(
                              leading: Icon(Icons.edit),
                              title: Text('${AppLocalizations.of(context)!.edit}'),
                            ),
                          ),
                          PopupMenuItem(
                            value: 'delete',
                            child: ListTile(
                              leading: Icon(Icons.delete),
                              title: Text('${AppLocalizations.of(context)!.delete}'),
                            ),
                          ),
                        ],
                        icon: Icon(Icons.more_vert,
                          size: 25,
                        ), // زر النقاط الثلاث
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                LinearProgressIndicator(
                  value: .5,
                  backgroundColor: Colors.grey[300],
                  color: Colors.blue,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Stack(
                    children: [
                      FacePile(
                        faces: getFaceHolders(task).take(5).toList(),
                        faceSize: 30,
                        facePercentOverlap: .2,
                        borderColor: Colors.white,
                      ),
                      if (getFaceHolders(task).length > 5)
                        Positioned(
                          right: 0,
                          child: GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: GridView.builder(
                                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 4,
                                        crossAxisSpacing: 10,
                                        mainAxisSpacing: 10,
                                      ),
                                      itemCount: getFaceHolders(task).length,
                                      itemBuilder: (context, index) {
                                        return CircleAvatar(
                                          backgroundImage: getFaceHolders(task)[index].avatar, // الآن يتم تمرير ImageProvider
                                        );
                                      },
                                    ),
                                  );
                                },
                              );
                            },
                            child: CircleAvatar(
                              radius: 15,
                              backgroundColor: Colors.grey[400],
                              child: Text(
                                "+${getFaceHolders(task).length - 5}",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  )


                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildPhase(
      {required PhasesModel task,
      required int index,
      bool isSelected = false}) {
    return GestureDetector(
      onTap: () {
        phaseClick = true;
        phaseId = task.phase_id;
        getTasks();
        taskName.text = task.phaseName!;
        setState(() {});
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: isSelected ? 100 : 80,
        width: isSelected ? 200 : 180,
        margin: const EdgeInsets.only(right: 16),
        child: Card(
          color: Colors
              .primaries[Random().nextInt(Colors.primaries.length)].shade50,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Center(
                        child: Text(
                          '${task.phaseName}',
                          style: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Center(
                      child: PopupMenuButton<String>(
                        onSelected: (String result) {
                          if (result == 'Edit') {
                            taskName.text = task.phaseName!;
                            if (task.phaseDesc == null) {
                              phaseDescription.text = '';
                            } else {
                              phaseDescription.text = task.phaseDesc!;
                            }
                            showModalBottomSheet<void>(
                              isScrollControlled: true,
                              context: context,
                              builder: (BuildContext context) {
                                return StatefulBuilder(builder:
                                    (BuildContext context,
                                        StateSetter setState) {
                                  return Padding(
                                    padding: EdgeInsets.only(
                                        top: 20,
                                        right: 20,
                                        left: 20,
                                        bottom: MediaQuery.of(context)
                                            .viewInsets
                                            .bottom),
                                    child: Container(
                                        height:
                                            MediaQuery.of(context).size.height /
                                                2,
                                        width:
                                            MediaQuery.of(context).size.width /
                                                1.1,
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.all(15.0),
                                              child: Text(
                                                "${AppLocalizations.of(context)!.editPhase}",
                                                style: TextStyle(
                                                    fontSize: 30,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 20),
                                              child: Container(
                                                width: 300,
                                                child: TextFormField(
                                                  controller: taskName,
                                                  decoration:
                                                      new InputDecoration(
                                                    labelText:
                                                        "${AppLocalizations.of(context)!.phase_name}",
                                                    fillColor: Colors.white,
                                                    border:
                                                        new OutlineInputBorder(
                                                      borderRadius:
                                                          new BorderRadius
                                                              .circular(25.0),
                                                      borderSide:
                                                          new BorderSide(),
                                                    ),
                                                    //fillColor: Colors.green
                                                  ),
                                                  keyboardType: TextInputType
                                                      .emailAddress,
                                                  style: new TextStyle(
                                                    fontFamily: "Poppins",
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Container(
                                              width: 300,
                                              child: TextFormField(
                                                controller: phaseDescription,
                                                decoration: new InputDecoration(
                                                  labelText:
                                                      "${AppLocalizations.of(context)!.phase_desc}",
                                                  fillColor: Colors.white,
                                                  border:
                                                      new OutlineInputBorder(
                                                    borderRadius:
                                                        new BorderRadius
                                                            .circular(25.0),
                                                    borderSide:
                                                        new BorderSide(),
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
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            Center(
                                              child: Container(
                                                height: 50,
                                                width: 200,
                                                child: clickAddProject == false
                                                    ? FancyContainer(
                                                        textColor: Colors.white,
                                                        onTap: () async {
                                                          setState(() {
                                                            clickAddProject =
                                                                true;
                                                          });
                                                          await DioHelper
                                                              .patchData(
                                                            url:
                                                                "api/phases/${task.phase_id}",
                                                            data: {
                                                              "name":
                                                                  "${taskName.text}",
                                                              "description":
                                                                  phaseDescription
                                                                      .text
                                                            },
                                                          ).then((value) {
                                                            print(
                                                                taskName.text);
                                                            print(
                                                                phaseDescription
                                                                    .text);
                                                            print(value.data);
                                                            print(
                                                                "Tmaaaaaaaaaaaaaaaaaaaaaaaaam");
                                                            setState(() {});
                                                            clickAddProject =
                                                                false;
                                                            getPhases();

                                                            Navigator.pop(
                                                                context);
                                                            print(
                                                                "Shaaaaaaaaatr");
                                                          }).catchError(
                                                              (error) {
                                                            clickAddProject =
                                                                false;

                                                            setState(() {});
                                                            if (taskName
                                                                .text.isEmpty) {
                                                              Flushbar(
                                                                backgroundColor:
                                                                    Colors.red,
                                                                message:
                                                                    "${AppLocalizations.of(context)!.projectNameisEmpty}",
                                                                icon:
                                                                    const Icon(
                                                                  Icons
                                                                      .info_outline,
                                                                  size: 30.0,
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                                duration:
                                                                    const Duration(
                                                                        seconds:
                                                                            3),
                                                                leftBarIndicatorColor:
                                                                    Colors.blue[
                                                                        300],
                                                              )..show(context);
                                                            } else if (phaseDescription
                                                                .text.isEmpty) {
                                                              Flushbar(
                                                                message:
                                                                    "${AppLocalizations.of(context)!.projectDescisEmpty}",
                                                                backgroundColor:
                                                                    Colors.red,
                                                                icon:
                                                                    const Icon(
                                                                  Icons
                                                                      .info_outline,
                                                                  size: 30.0,
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                                duration:
                                                                    const Duration(
                                                                        seconds:
                                                                            3),
                                                                leftBarIndicatorColor:
                                                                    Colors.blue[
                                                                        300],
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
                                                                          .blue[
                                                                      300],
                                                                ),
                                                                duration:
                                                                    const Duration(
                                                                        seconds:
                                                                            3),
                                                                leftBarIndicatorColor:
                                                                    Colors.blue[
                                                                        300],
                                                              )..show(context);
                                                            }

                                                            print(error
                                                                .response.data);
                                                          });
                                                        },
                                                        title:
                                                            '${AppLocalizations.of(context)!.save}',
                                                        color1: Colors.purple,
                                                        color2:
                                                            Colors.lightBlue,
                                                      )
                                                    : const Center(
                                                        child:
                                                            CircularProgressIndicator(
                                                          color: Colors.indigo,
                                                        ),
                                                      ),
                                              ),
                                            ),
                                          ],
                                        )),
                                  );
                                });
                              },
                            );
                          } else if (result == 'Delete') {
                            showDialog<void>(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  //  title: const Text('Basic dialog title'),
                                  content: Text(
                                    '${AppLocalizations.of(context)!.deletePhase}',
                                    textAlign: TextAlign.center,
                                  ),
                                  actions: [
                                    Row(
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
                                              url:
                                                  "api/phases/${task.phase_id}",
                                            ).then((value) {
                                              Navigator.pop(context);
                                              setState(() {
                                                phase_list.phaseList
                                                    ?.removeAt(index);
                                              });
                                              print('mbroook');
                                              Flushbar(
                                                messageColor: Colors.black,
                                                backgroundColor: Colors.green,
                                                message: "Phase deleted",
                                                icon: const Icon(
                                                  Icons.verified,
                                                  size: 30.0,
                                                  color: Colors.white,
                                                ),
                                                duration:
                                                    const Duration(seconds: 3),
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
                                                duration:
                                                    const Duration(seconds: 3),
                                                leftBarIndicatorColor:
                                                    Colors.blue[300],
                                              )..show(context);
                                              print(error.response.data);
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
                                      // crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                        itemBuilder: (BuildContext context) =>
                            <PopupMenuEntry<String>>[
                           PopupMenuItem<String>(
                            value: 'Edit',
                            child: ListTile(
                              leading: Icon(Icons.edit),
                              title: Text('${AppLocalizations.of(context)!.edit}'),
                            ),
                          ),
                           PopupMenuItem<String>(
                            value: 'Delete',
                            child: ListTile(
                              leading: Icon(Icons.delete),
                              title: Text('${AppLocalizations.of(context)!.delete}'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTasks({
    required TasksModel task,
    required int index,
  }) {
    return Column(
      children: [
        ListTile(
          leading: Container(
            width: 10,
            height: 40,
            color: Colors.cyan,
          ),
          title: Row(
            children: [
              Expanded(
                  child: GestureDetector(
                    onTap: (){
                      showDialog(
                        context: (context),
                        builder: (context) => AlertDialog(
                          content: Text(
                            task.description!=null? "${task.description}":'No notes to show',
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 20),
                          ),
                        ),
                      );
                    },
                      child: Text('${task.task_name}')),flex: 3,),
              Center(
                child: PopupMenuButton<String>(
                  onSelected: (String result) {
                    if (result == 'Edit') {
                      users = task.assignees as List<int>;
                      taskName.text = task.task_name!;
                      if (task.description == null) {
                        taskDescription.text = '';
                      } else {
                        taskDescription.text = task.description!;
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
                                  bottom: MediaQuery.of(context).viewInsets.bottom),
                              child: Container(
                                  height: MediaQuery.of(context).size.height / 2,
                                  width: MediaQuery.of(context).size.width / 1.1,
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.all(15.0),
                                          child: Text(
                                            "${AppLocalizations.of(context)!.editTask}",
                                            style: TextStyle(
                                                fontSize: 30,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                          const EdgeInsets.only(bottom: 20),
                                          child: SizedBox(
                                            width: 300,
                                            child: TextFormField(
                                              controller: taskName,
                                              decoration: InputDecoration(
                                                labelText:
                                                "${AppLocalizations.of(context)!.taskName}",
                                                fillColor: Colors.white,
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                  BorderRadius.circular(25.0),
                                                  borderSide: const BorderSide(),
                                                ),
                                                //fillColor: Colors.green
                                              ),
                                              keyboardType:
                                              TextInputType.emailAddress,
                                              style: const TextStyle(
                                                fontFamily: "Poppins",
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        SizedBox(
                                          width: 300,
                                          child: TextFormField(
                                            controller: taskDescription,
                                            decoration: InputDecoration(
                                              labelText:
                                              "${AppLocalizations.of(context)!.taskDesc}",
                                              fillColor: Colors.white,
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                BorderRadius.circular(25.0),
                                                borderSide: const BorderSide(),
                                              ),
                                              //fillColor: Colors.green
                                            ),
                                            keyboardType:
                                            TextInputType.emailAddress,
                                            style: const TextStyle(
                                              fontFamily: "Poppins",
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            chooseList.chooseuserList!.isNotEmpty
                                                ? showModalBottomSheet<void>(
                                              context: context,
                                              backgroundColor:
                                              const Color(0xffFAACB4),
                                              builder:
                                                  (BuildContext context) {
                                                return Padding(
                                                  padding:
                                                  const EdgeInsets.all(
                                                      20.0),
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
                                              message: AppLocalizations.of(
                                                  context)!
                                                  .noEmployee,
                                              icon: const Icon(
                                                Icons.info_outline,
                                                size: 30.0,
                                                color: Colors.black,
                                              ),
                                              duration:
                                              const Duration(seconds: 3),
                                              leftBarIndicatorColor:
                                              Colors.blue[300],
                                              backgroundColor: Colors.red,
                                            ).show(context);
                                          },
                                          child: Padding(
                                            padding:
                                            const EdgeInsets.only(bottom: 40),
                                            child: Theme(
                                              data: Theme.of(context).copyWith(
                                                  splashColor: Colors.transparent),
                                              child: TextField(
                                                enabled: false,
                                                autofocus: false,
                                                style: const TextStyle(
                                                    fontSize: 22.0,
                                                    color: Color(0xFFbdc6cf)),
                                                decoration: InputDecoration(
                                                  filled: true,
                                                  fillColor: const Color(0xFCED3FF),
                                                  label: Padding(
                                                    padding:
                                                    const EdgeInsets.all(10),
                                                    child: users.isEmpty
                                                        ? Text(
                                                      "${AppLocalizations.of(context)!.addThisTaskTo}",
                                                      style: TextStyle(
                                                          fontWeight:
                                                          FontWeight.bold,
                                                          color:
                                                          Colors.black45),
                                                    )
                                                        : Text(
                                                      '${AppLocalizations.of(context)!.selectedEmployee}${users.length}',
                                                      style: const TextStyle(
                                                          fontWeight:
                                                          FontWeight.bold,
                                                          color:
                                                          Colors.green),
                                                    ),
                                                  ),
                                                  contentPadding:
                                                  const EdgeInsets.only(
                                                      left: 14.0,
                                                      bottom: 8.0,
                                                      top: 8.0,
                                                      right: 14),
                                                  focusedBorder: OutlineInputBorder(
                                                    borderSide: const BorderSide(
                                                        color: Colors.white),
                                                    borderRadius:
                                                    BorderRadius.circular(25.7),
                                                  ),
                                                  enabledBorder:
                                                  UnderlineInputBorder(
                                                    borderSide: const BorderSide(
                                                        color: Colors.white),
                                                    borderRadius:
                                                    BorderRadius.circular(25.7),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Center(
                                          child: SizedBox(
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
                                                  "api/tasks/${task.task_id}",
                                                  data: {
                                                    "name": taskName.text,
                                                    "description":
                                                    taskDescription.text,
                                                    "assignees": users,
                                                  },
                                                ).then((value) {
                                                  print(taskName.text);
                                                  print(taskDescription.text);
                                                  print(value.data);
                                                  print(
                                                      "Tmaaaaaaaaaaaaaaaaaaaaaaaaam");
                                                  setState(() {});
                                                  clickAdd = false;
                                                  getTasks();

                                                  Navigator.pop(context);
                                                  print("Shaaaaaaaaatr");
                                                }).catchError((error) {
                                                  clickAdd = false;

                                                  setState(() {});
                                                  if (taskName.text.isEmpty) {
                                                    Flushbar(
                                                      backgroundColor:
                                                      Colors.red,
                                                      message: AppLocalizations
                                                          .of(context)!
                                                          .projectNameisEmpty,
                                                      icon: const Icon(
                                                        Icons.info_outline,
                                                        size: 30.0,
                                                        color: Colors.black,
                                                      ),
                                                      duration:
                                                      const Duration(
                                                          seconds: 3),
                                                      leftBarIndicatorColor:
                                                      Colors.blue[300],
                                                    ).show(context);
                                                  } else {
                                                    Flushbar(
                                                      message:
                                                      '${error.response.data['message']}',
                                                      icon: Icon(
                                                        Icons.info_outline,
                                                        size: 30.0,
                                                        color:
                                                        Colors.blue[300],
                                                      ),
                                                      duration:
                                                      const Duration(
                                                          seconds: 3),
                                                      leftBarIndicatorColor:
                                                      Colors.blue[300],
                                                    ).show(context);
                                                  }

                                                  print(error.response.data);
                                                });
                                              },
                                              title:
                                              '${AppLocalizations.of(context)!.save}',
                                              color1: Colors.purple,
                                              color2: Colors.lightBlue,
                                            )
                                                : const Center(
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
                    }
                    else if (result == 'Delete') {
                      showDialog<void>(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            //  title: const Text('Basic dialog title'),
                            content: Text(
                              '${AppLocalizations.of(context)!.deletetask}',
                            ),
                            actions: [
                              Row(
                                children: [
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      textStyle:
                                      Theme.of(context).textTheme.labelLarge,
                                    ),
                                    child: Text(AppLocalizations.of(context)!.yes),
                                    onPressed: () async {
                                      setState(() {});
                                      await DioHelper.deleteData(
                                        url: "api/tasks/${task.task_id}",
                                      ).then((value) {
                                        Navigator.pop(context);
                                        setState(() {
                                          task_list..tasksList?.removeAt(index);
                                        });
                                        print('mbroook');
                                        Flushbar(
                                          messageColor: Colors.black,
                                          backgroundColor: Colors.green,
                                          message: "Task deleted",
                                          icon: const Icon(
                                            Icons.verified,
                                            size: 30.0,
                                            color: Colors.white,
                                          ),
                                          duration: const Duration(seconds: 3),
                                          leftBarIndicatorColor: Colors.blue[300],
                                        )..show(context);
                                      }).catchError((error) {
                                        Navigator.pop(context);
                                        setState(() {});
                                        Flushbar(
                                          message:
                                          "${error.response.data['message']}",
                                          icon: Icon(
                                            Icons.info_outline,
                                            size: 30.0,
                                            color: Colors.blue[300],
                                          ),
                                          duration: const Duration(seconds: 3),
                                          leftBarIndicatorColor: Colors.blue[300],
                                        )..show(context);
                                      });
                                    },
                                  ),
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      textStyle:
                                      Theme.of(context).textTheme.labelLarge,
                                    ),
                                    child: Text(AppLocalizations.of(context)!.no),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                                // crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                              ),
                            ],
                          );
                        },
                      );
                    }

                  },
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<String>>[
                     PopupMenuItem<String>(
                      value: 'Edit',
                      child: ListTile(
                        leading: Icon(Icons.edit),
                        title: Text('${AppLocalizations.of(context)!.edit}'),
                      ),
                    ),
                     PopupMenuItem<String>(
                      value: 'Delete',
                      child:ListTile(
                        leading: Icon(Icons.delete),
                        title: Text('${AppLocalizations.of(context)!.delete}'),
                      ),
                    ),

                  ],
                ),
              )
            ],
          ),
          trailing: Transform.scale(
            scale: 1.2,
            child: CircleAvatar(
              // backgroundColor: completed ? Colors.blue : Colors.grey[200],
              child: Checkbox(
                checkColor: Colors.black,
                fillColor: MaterialStateProperty.all(Colors.white),
                value: task.close,
                onChanged: (value) {
                  if (task.close = value!) {
                    showDialog(
                      barrierDismissible: false,
                      context: (context),
                      builder: (contextop) => AlertDialog(
                        content: Text(
                          '${AppLocalizations.of(context)!.finishTask}',
                          style: TextStyle(fontSize: 20),
                        ),
                        actions: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton(
                                child: Text(
                                    '${AppLocalizations.of(context)!.yes}'),
                                onPressed: () {
                                  DioHelper.patchData(
                                      url: "api/tasks/${task.task_id}",
                                      data: {
                                        "status": "COMPLETED",
                                      }).then((v) {
                                    print("goooooooooooooooooood");
                                    setState(() {
                                      task_list.tasksList!.removeAt(index);
                                    });
                                  }).catchError((e) {
                                    print(e);
                                    setState(() {
                                      task.close = false;
                                    });
                                    showDialog(
                                      context: (context),
                                      builder: (contextotllp) => AlertDialog(
                                        content: Text(
                                          "${e.response.data['en']}",
                                          style: const TextStyle(fontSize: 20),
                                        ),
                                      ),
                                    );

                                    // print('errrrrrrrrr');
                                  });

                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child:
                                    Text('${AppLocalizations.of(context)!.no}'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  task.close = false;
                                  setState(() {});
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                    setState(() {});
                  }
                },
              ),
            ),
          ),
        ),
        Text(
          '_______________________',
          style: TextStyle(
              fontSize: 20,
              color: Colors.primaries[Random().nextInt(Colors.primaries.length)]
                  .shade300,
              fontWeight: FontWeight.bold),
        )
      ],
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
