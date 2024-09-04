import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hr/projectfield.dart';
import 'package:hr/screens/hr.dart';
import 'package:hr/screens/onboding/onboding_screen.dart';
import 'package:hr/screens/profile.dart';
import 'package:hr/screens/attendingToday.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'main.dart';
import 'modules/organizationmodel.dart';
import 'network/local/cache_helper.dart';
import 'network/remote/dio_helper.dart';
import 'package:http_parser/http_parser.dart';

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
  bool isImageLoading = false; // حالة تحميل الصورة
  String? imagePath;
  bool showLoading = false;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    getProfileInfo();
    getOrganizations();
    _checkFirstLaunch();
  }
  Future<void> _checkFirstLaunch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool hasShownDialog = prefs.getBool('hasShownDialog') ?? false;

    if (!hasShownDialog) {
      _showUpdateDialog();
      await prefs.setBool('hasShownDialog', true);
    }
  }

  void _showUpdateDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(
                Icons.update,
                color: Colors.blueAccent,
                size: 28,
              ),
              SizedBox(width: 10),
              Text(
                'تحديثات جديدة',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: Colors.blueAccent,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'إليك آخر التحديثات...',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black54,
                ),
              ),
              SizedBox(height: 20),

            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Text(
                  'موافق',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ],
        );
      },
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

  Future<void> getOrganizations() async {
    try {
      final response = await DioHelper.getData(
        url: "api/organizations",
      );
      print('fffffffffffffffffffffffffffffffffffffffffff');
      print(response.data);
      print('fffffffffffffffffffffffffffffffffffffffffff');

    } catch (error) {
      print("Error fetching organizations: $error");
    }
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
                  AppLocalizations.of(context)!.localeName == 'ar'?widget.organizationsArabicName!:   widget.organizationsName!,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                      fontSize: 22),
                ),
                onTap: () {
                  setState(() {

                  });
                  Navigator.pop(context); // Close the drawer
                  showModalBottomSheet<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return ListView.builder(
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) =>
                            buildOrganizationsList(
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
                title: Text('${AppLocalizations.of(context)!.profileSetting}'),
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
                title: Text('${AppLocalizations.of(context)!.logOut}'),
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
                title: Text('${AppLocalizations.of(context)!.attendingToday}'),
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
                      title: '${AppLocalizations.of(context)!.hr}',
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
                      title: '${AppLocalizations.of(context)!.project_management}',
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
                      title: '${AppLocalizations.of(context)!.marketing}',
                      icon: Icons.trending_up,
                      color: Colors.green.shade200,
                      onTap: () {
                        // Handle tap
                      },
                    ),
                    DashboardCard(
                      title: '${AppLocalizations.of(context)!.accounting}',
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
                  child: SpinKitFadingCircle(
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

  Widget buildOrganizationsList({
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

class PhotoViewGalleryPageWrapper extends StatelessWidget {
  final String imagePath;

  const PhotoViewGalleryPageWrapper({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PhotoViewGallery.builder(
        itemCount: 1,
        builder: (context, index) {
          return PhotoViewGalleryPageOptions(
            imageProvider: NetworkImage(imagePath),
            minScale: PhotoViewComputedScale.contained,
            maxScale: PhotoViewComputedScale.covered * 2,

          );
        },
        scrollPhysics: BouncingScrollPhysics(),
        backgroundDecoration: BoxDecoration(
          color: Colors.black,

        ),

        pageController: PageController(),
      ),
    );
  }
}
