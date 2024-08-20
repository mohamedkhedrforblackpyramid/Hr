import 'package:flutter/material.dart';
import 'package:hr/mainchooseList.dart';
import 'package:hr/screens/profile.dart';
import 'package:hr/screens/showpermission.dart';
import 'package:hr/screens/taskmanagement.dart';
import 'package:hr/screens/tasktable.dart';
import 'package:hr/screens/whoisattend.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../main.dart';
import '../modules/organizationmodel.dart';
import '../network/local/cache_helper.dart';
import '../network/remote/dio_helper.dart';


class ProjectsField extends StatefulWidget {
  final int? userId;
  final dynamic oranizaionsList;
  int? organizationId;
  String? organizationsName;
  String? organizationsArabicName;
  final String? personType;

  ProjectsField({
    required this.userId,
    required this.oranizaionsList,
    required this.organizationId,
    required this.organizationsName,
    required this.organizationsArabicName,
    required this.personType,
  });

  @override
  State<ProjectsField> createState() => _ProjectsFieldState();
}

class _ProjectsFieldState extends State<ProjectsField> {
  String status = '';
  bool _isLoading = false;
  returnPage() {
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) =>  MainPage(
          userId: widget.userId,
          oranizaionsList: widget.oranizaionsList,
          organizationId: widget.organizationId,
          organizationsName: widget.organizationsName,
          organizationsArabicName: widget.organizationsArabicName, personType: '',

        )));
  }
  Future<void> checkAttendace() async {
    await DioHelper.getData(
      url: "api/organizations/${widget.organizationId}/attendance/check",
    ).then((response) {
      status = response.data['status'];
      setState(() {});
    }).catchError((error) {
      print(error.response.data);
      if (error.response?.statusCode != 200) {
        status = '';
        print('Error occurred');
      } else {
        print(error);
      }
    });
  }

  getOrganizations() {
    DioHelper.getData(
      url: "api/organizations",
    ).then((response) {
      print(response.data);
    });
  }

  @override
  void initState() {
    super.initState();
    print('Initializing...');
    print(CacheHelper.getData(key: 'token'));
    getOrganizations();
    checkAttendace();
  }

  Future<void> _navigateToPage(Widget page) async {
    setState(() {
      _isLoading = true;
    });
    await Future.delayed(Duration(seconds: 1)); // Simulate a delay
    setState(() {
      _isLoading = false;
    });
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return returnPage();
      },
      child: Scaffold(
        drawer: Drawer(
          child: Column(
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountName: Text(
                  CacheHelper.getData(key: 'name') ?? 'User',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                accountEmail: Text(
                  CacheHelper.getData(key: 'email') ?? 'Email',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Text(
                    (CacheHelper.getData(key: 'name') ?? 'U')[0], // Display the first letter of the name
                    style: TextStyle(
                      color: Colors.teal,
                      fontSize: 40,
                    ),
                  ),
                ),
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
              ),
              ListTile(
                leading: Icon(Icons.home),
                title: Text(
                  widget.organizationsName!,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                      fontSize: 22),
                ),
                onTap: () {
                  showModalBottomSheet<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return ListView.builder(
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context,
                            int index) =>
                            buildOranizationsList(
                                organizations: widget
                                    .oranizaionsList
                                    .organizationsListt![index],
                                index: index),
                        itemCount: widget.oranizaionsList
                            .organizationsListt!.length,
                      );
                    },
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.person),
                title: Text('Profile Setting'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Profile(
                        organizationId: widget.organizationId,
                        userId: widget.userId,
                      ),
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text('Log Out'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyApp(
                        lang: '${CacheHelper.getData(key: 'language')}',
                      ),
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.event_available),
                title: Text('Attending Today'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WhoIsAttend(
                        organizationId: widget.organizationId,
                        userId: widget.userId,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        body: Stack(
          children: [
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                  children: <Widget>[
                    DashboardCard(
                      title: 'Projects',
                      icon: Icons.work,
                      color: Colors.teal.shade200,
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) =>  TaskManagement(
                              userId: widget.userId,
                              organizationId: widget.organizationId,
                              organizationsName: widget.organizationsName,
                              oranizaionsList: widget.oranizaionsList,
                              organizationsArabicName: widget.organizationsArabicName,

                            )));
                      },
                    ),
                    DashboardCard(
                      title: 'Tasks',
                      icon: Icons.task,
                      color: Colors.purple.shade200,
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) =>  TaskTable(
                              organizationId: widget.organizationId,
                              userId: widget.userId,

                            )));
                      },
                    ),
                  ],
                ),
              ),
            ),
            if (_isLoading)
              Center(
                child: AnimatedSwitcher(
                  duration: Duration(milliseconds: 300),
                  child: _isLoading
                      ? CircularProgressIndicator()
                      : Container(),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget buildOranizationsList(
      {required OrganizationsModel organizations, required int index}) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          child: TextButton(
            child: Text(
              organizations.name!,
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () {
              setState(() {});
              widget.organizationsName = organizations.name!;
              widget.organizationsArabicName = organizations.arabicName;
              widget.organizationId = organizations.organizations_id;
              Navigator.pop(context);
            },
          ),
        ),
      ],
    );
  }
}

class DashboardCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const DashboardCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          color: color,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  icon,
                  size: 60,
                  color: Colors.white,
                ),
                SizedBox(height: 10),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
