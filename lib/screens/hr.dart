import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../main.dart';
import '../mainchooseList.dart';
import '../modules/organizationmodel.dart';
import '../modules/permitmodel.dart';
import '../network/local/cache_helper.dart';
import '../network/remote/dio_helper.dart';
import 'attendance.dart';
import 'excusepermission.dart';
import 'vacancespermissions.dart';
import 'onboding/onboding_screen.dart';
import 'profile.dart';
import 'showpermission.dart';
import 'attendingToday.dart';
import 'package:http_parser/http_parser.dart';


class Hr extends StatefulWidget {
  final int? userId;
  final dynamic oranizaionsList;
  int? organizationId;
  String? organizationsName;
  String? organizationsArabicName;
  final String? personType;
  int? vacancesCount;
  int? permitsPermission;

  Hr({
    required this.userId,
    required this.oranizaionsList,
    required this.organizationId,
    required this.organizationsName,
    required this.organizationsArabicName,
    required this.personType,
    this.permitsPermission,
    this.vacancesCount,
  });

  @override
  State<Hr> createState() => _HrState();
}

class _HrState extends State<Hr> {
  String status = '';
  bool isLoading = false;
  bool permitLoading = false;
  PermitList? permitsVacancesCount;
  PermitList? permitsPermission;
  int? permissionCount;
  int? vacancesCount;
  bool isImageLoading = false; // حالة تحميل الصورة
  String? imagePath;
  bool showLoading = false;


  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  XFile? _imageFile;
  final ImagePicker _picker = ImagePicker();
  void _handleDrawerItemSelection(VoidCallback action) {
    if (isLoading) {
      // Optionally stop loading if it's active
      setState(() {
        isLoading = false;
      });
    }
    action();
  }
  returnPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MainPage(
          userId: widget.userId,
          oranizaionsList: widget.oranizaionsList,
          organizationId: widget.organizationId,
          organizationsName: widget.organizationsName,
          organizationsArabicName: widget.organizationsArabicName,
          personType: '',
        ),
      ),
    );
  }
  Future<void> getProfileInfo() async {
    setState(() {
      showLoading = true;
    });

    try {
      final response = await DioHelper.getData(
        url: "api/auth/me?profile=true",
      );
      setState(() {
        imagePath = response.data['avatar'];
      });
    } catch (error) {
      print("Error fetching profile info: $error");
    } finally {
      setState(() {
        showLoading = false;
      });
    }
  }

  Future<void> _pickImage() async {
    try {
      final XFile? pickedPhoto = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 50,
      );

      if (pickedPhoto != null) {
        setState(() {
          isImageLoading = true; // بدء تحميل الصورة
          imagePath = pickedPhoto.path;
        });

        final fileImage = await MultipartFile.fromFile(
          pickedPhoto.path,
          filename: "fileName.jpg",
          contentType: MediaType('image', 'jpg'),
        );

        try {
          await DioHelper.postFormData(
            url: "api/user/${widget.userId}",
            data: {
              "avatar": fileImage,
            },
          );
          await getProfileInfo();
          print('Image updated successfully');
        } catch (error) {
          print("Error updating image: $error");
        } finally {
          setState(() {
            isImageLoading = false; // إيقاف تحميل الصورة
          });
        }
      }

    } catch (e) {
      print("Error picking image: $e");
    }
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

  void getPermissions() {
    setState(() {
      permitLoading = true;
    });
    DioHelper.getData(
      url: "api/organizations/${widget.organizationId}/vacancies?is_permit=1&status=1",
    ).then((response) {
      permitsPermission = PermitList.fromJson(response.data);
      permissionCount = permitsPermission?.permitList?.length;
      setState(() {
        permitLoading = false;
      });
    }).catchError((error) {
      print(error);
      setState(() {
        permitLoading = false;
      });
    });
  }

  void getVecan() {
    setState(() {
      permitLoading = true;
    });
    DioHelper.getData(
      url: "api/organizations/${widget.organizationId}/vacancies?is_permit=0&status=1",
    ).then((response) {
      permitsVacancesCount = PermitList.fromJson(response.data);
      vacancesCount = permitsVacancesCount?.permitList?.length;
      setState(() {
        permitLoading = false;
      });
    }).catchError((error) {
      print(error.response);
      setState(() {
        permitLoading = false;
      });
    });
  }

  void getOrganizations() {
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
    getVecan();
    getPermissions();
    getProfileInfo();
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return returnPage();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(Icons.menu, size: 30),
            onPressed: () {
              _scaffoldKey.currentState?.openDrawer();
            },
          ),
        ),
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
                  alignment: Alignment.bottomRight,
                  children: [
                    if (isImageLoading)
                      SpinKitFadingCircle(
                        color: Colors.white,
                        size: 50.0, // حجم مؤشر التحميل
                      )
                    else
                      GestureDetector(
                        onTap: () {
                          if (imagePath != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PhotoViewGalleryPageWrapper(
                                  imagePath: imagePath!,
                                ),
                              ),
                            );
                          }
                        },
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 40,
                          child: imagePath != null
                              ? ClipOval(
                            child: Image.network(
                              imagePath!,
                              fit: BoxFit.cover,
                              width: 80,
                              height: 80,
                            ),
                          )
                              : Icon(
                            Icons.person,
                            size: 80,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    Positioned(
                      right: -10,
                      bottom: -10,
                      child: GestureDetector(
                        onTap: _pickImage,
                        child: CircleAvatar(
                          backgroundColor: Colors.blue,
                          radius: 18,
                          child: Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),                  ],
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
                            builder: (context) => OnboardingScreen()
                          /*MyApp(
                            lang: '${CacheHelper.getData(key: 'language')}',
                          ),*/
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
                          builder: (context) => Attending(
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
                      title: 'Vacations',
                      icon: Icons.beach_access,
                      color: Colors.orange.shade200,
                      onTap: () {
                        _startLoading(() {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => VacancesPermissions(
                                userId: widget.userId,
                                organizationId: widget.organizationId,
                              ),
                            ),
                          );
                        });
                      },
                    ),
                    DashboardCard(
                      title: 'Permissions',
                      icon: Icons.access_time,
                      color: Colors.blue.shade200,
                      onTap: () {
                        _startLoading(() {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ExcusePrmission(
                                userId: widget.userId,
                                organizationId: widget.organizationId,
                              ),
                            ),
                          );
                        });
                      },
                    ),
                    DashboardCard(
                      title: 'Attendance',
                      icon: Icons.calendar_today,
                      color: Colors.green.shade200,
                      onTap: ()  {
                         checkAttendace();
                        if (status == 'NOACTION' || status.isEmpty) {




                          Alert(
                            context: context,
                            desc: "Try Again Later!",
                          ).show();
                        } else {
                          setState(() {
                            isLoading = true;
                          });
                           Future.delayed(Duration(seconds: 1));
                          setState(() {
                            isLoading = false;
                          });
                          _startLoading(() {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Attendance(
                                  userId: widget.userId,
                                  organizationId: widget.organizationId,
                                  organizationsName: widget.organizationsName,
                                  oranizaionsList: widget.oranizaionsList,
                                  organizationsArabicName: widget.organizationsArabicName,
                                  personType: widget.personType,
                                ),
                              ),
                            );
                          });
                        }
                      },
                    ),
                    DashboardCard(
                      title: 'Requests',
                      icon: Icons.request_page,
                      color: Colors.red.shade200,
                      onTap: () {
                        getPermissions();
                        getVecan();
                        setState(() {});
                        _startLoading(() {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Showpermit(
                                organizationId: widget.organizationId,
                                userId: widget.userId,
                                personType: widget.personType,
                                vacancesCount: vacancesCount,
                                permitsPermission: permissionCount,
                                oranizaionsList: widget.oranizaionsList,
                                organizationsName: widget.organizationsName,
                                organizationsArabicName: widget.organizationsArabicName,
                              ),
                            ),
                          );
                        });
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

  Widget buildOranizationsList({
    required OrganizationsModel organizations,
    required int index,
  }) {
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
