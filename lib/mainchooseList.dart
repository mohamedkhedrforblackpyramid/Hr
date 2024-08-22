import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hr/projectfield.dart';
import 'package:hr/screens/hr.dart';
import 'package:hr/screens/profile.dart';
import 'package:hr/screens/whoisattend.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'main.dart';
import 'modules/organizationmodel.dart';
import 'network/local/cache_helper.dart';
import 'network/remote/dio_helper.dart';

class MainPage extends StatefulWidget {
  final int? userId;
  final dynamic oranizaionsList;
  int? organizationId;
  String? organizationsName;
  String? organizationsArabicName;
  final String? personType;

  MainPage({
    required this.userId,
    required this.oranizaionsList,
    required this.organizationId,
    required this.organizationsName,
    required this.organizationsArabicName,
    required this.personType,
  });

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool shouldPop = false;
  bool isLoading = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  XFile? _imageFile;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _imageFile = pickedFile;
        });

      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  getOrganizations() {
    DioHelper.getData(
      url: "api/organizations",
    ).then((response) {
      print(response.data);
    }).catchError((error) {
      print("Error fetching organizations: $error");
    });
  }

  @override
  void initState() {
    super.initState();
    print('Initialization started');
    print(CacheHelper.getData(key: 'token'));
    getOrganizations();
  }

  void _startLoading(VoidCallback action) {
    setState(() {
      isLoading = true;
    });

    Future.delayed(Duration(seconds: 2), () {
      action();
      setState(() {
        isLoading = false;
      });
    });
  }

  void _handleDrawerItemSelection(VoidCallback action) {
    if (isLoading) {
      // Optionally stop loading if it's active
      setState(() {
        isLoading = false;
      });
    }
    action();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return shouldPop;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        key: _scaffoldKey,
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
                currentAccountPicture: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 40,
                      child: _imageFile != null
                          ? ClipOval(
                        child: Image.file(
                          File(_imageFile!.path),
                          fit: BoxFit.cover,
                          width: 80,
                          height: 80,
                        ),
                      )
                          : Text(
                        (CacheHelper.getData(key: 'name') ?? 'U')[0],
                        style: TextStyle(
                          color: Colors.teal,
                          fontSize: 40,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      top: 40,
                      left: 40,
                      child: IconButton(
                        icon: Icon(Icons.edit, color: Colors.black, size: 20),
                        onPressed: _pickImage,
                      ),
                    ),
                  ],
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
                  Navigator.pop(context); // Close the drawer
                  showModalBottomSheet<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return ListView.builder(
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) =>
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
                  Navigator.pop(context); // Close the drawer
                  _handleDrawerItemSelection(() {
                    _startLoading(() {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Profile(
                            organizationId: widget.organizationId,
                            userId: widget.userId,
                          ),
                        ),
                      );
                    });
                  });
                },
              ),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text('Log Out'),
                onTap: () {
                  Navigator.pop(context); // Close the drawer
                  _handleDrawerItemSelection(() {
                    _startLoading(() {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MyApp(
                            lang: '${CacheHelper.getData(key: 'language')}',
                          ),
                        ),
                      );
                    });
                  });
                },
              ),
              ListTile(
                leading: Icon(Icons.event_available),
                title: Text('Attending Today'),
                onTap: () {
                  Navigator.pop(context); // Close the drawer
                  _handleDrawerItemSelection(() {
                    _startLoading(() {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WhoIsAttend(
                            organizationId: widget.organizationId,
                            userId: widget.userId,
                          ),
                        ),
                      );
                    });
                  });
                },
              ),
            ],
          ),
        ),
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(Icons.menu, size: 30),
            onPressed: () {
              _scaffoldKey.currentState?.openDrawer();
            },
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
                      title: 'HR',
                      icon: Icons.people,
                      color: Colors.red.shade200,
                      onTap: () {
                        _startLoading(() {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Hr(
                                userId: widget.userId,
                                oranizaionsList: widget.oranizaionsList!,
                                organizationId: widget.organizationId,
                                organizationsName: widget.organizationsName,
                                organizationsArabicName:
                                widget.organizationsArabicName,
                                personType: widget.personType,
                              ),
                            ),
                          );
                        });
                      },
                    ),
                    DashboardCard(
                      title: 'Project Management',
                      icon: Icons.assignment,
                      color: Colors.blue.shade200,
                      onTap: () {
                        _startLoading(() {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProjectsField(
                                userId: widget.userId,
                                oranizaionsList: widget.oranizaionsList!,
                                organizationId: widget.organizationId,
                                organizationsName: widget.organizationsName,
                                organizationsArabicName:
                                widget.organizationsArabicName,
                                personType: widget.personType,
                              ),
                            ),
                          );
                        });
                      },
                    ),
                    DashboardCard(
                      title: 'Marketing',
                      icon: Icons.trending_up,
                      color: Colors.green.shade200,
                      onTap: () {
                        // Handle tap
                      },
                    ),
                    DashboardCard(
                      title: 'Accounting',
                      icon: Icons.account_balance,
                      color: Colors.orange.shade200,
                      onTap: () {
                        // Handle tap
                      },
                    ),
                  ],
                ),
              ),
            ),
            if (isLoading)
              Container(
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: SpinKitCircle(
                    color: Colors.white,
                    size: 80.0,
                  ),
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
              setState(() {
                widget.organizationsName = organizations.name!;
                widget.organizationsArabicName = organizations.arabicName;
                widget.organizationId = organizations.organizations_id;
              });
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
    );
  }
}
