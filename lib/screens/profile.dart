import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';
import '../network/remote/dio_helper.dart';
import '../modules/tasks.dart';

class Profile extends StatefulWidget {
  final int? organizationId;
  final int? userId;

  Profile({
    required this.organizationId,
    required this.userId,
  });

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool showLoading = false;
  late TasksList task_list;
  var password = TextEditingController();
  var confirmPassword = TextEditingController();
  var oldPassword = TextEditingController();
  var changeName = TextEditingController();
  bool clickAdd = false;

  getTasks() async {
    setState(() {
      showLoading = true;
    });
    await DioHelper.getData(
      url: "api/organizations/${widget.organizationId}/current-tasks",
    ).then((response) {
      task_list = TasksList.fromJson(response.data);
      setState(() {
        showLoading = false;
      });
    }).catchError((error) {
      setState(() {
        showLoading = false;
      });
      print(error);
    });
  }
  getInfo() async {
    setState(() {
      showLoading = true;
    });
    await DioHelper.getData(
      url: "api/user/${widget.userId}",
    ).then((response) {
     print(response.data);

    }).catchError((error){
      print(error);
    });
  }

  @override
  void initState() {
    getTasks();
    getInfo();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff1B263B), // Dark Blue Background
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(child: Text("Profile Setting",
          style: TextStyle(
            fontWeight: FontWeight.bold
          ),
        )),
        backgroundColor: Color(0xffFDCB6E), // Yellow AppBar
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              _buildProfileCard(
                title: "Change Password",
                icon: Icons.lock,
                onTap: () => _showChangePasswordModal(context),
              ),
              SizedBox(height: 20),
              _buildProfileCard(
                title: "Change Name",
                icon: Icons.person,
                onTap: () => _showChangeNameModal(context),
              ),
              // إضافة شاشات أو أدوات أخرى حسب الحاجة
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileCard({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Color(0xffF0F0F0), // Light Gray Card
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            Icon(icon, color: Color(0xff1B263B), size: 30), // Dark Blue Icon
            SizedBox(width: 20),
            Text(
              title,
              style: TextStyle(
                color: Color(0xff1B263B),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showChangePasswordModal(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            top: 20,
            right: 20,
            left: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  "Change Password",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff1B263B),
                  ),
                ),
                SizedBox(height: 20),
                _buildTextField(controller: oldPassword, label: "Old password"),
                SizedBox(height: 10),
                _buildTextField(controller: password, label: "New password"),
                SizedBox(height: 10),
                _buildTextField(
                    controller: confirmPassword, label: "Confirm new password"),
                SizedBox(height: 20),
                _buildSaveButton(
                  context: context,
                  onPressed: () async {
                    if (confirmPassword.text != password.text) {
                      Flushbar(
                        backgroundColor: Colors.red,
                        message: "Passwords do not match",
                        icon: Icon(Icons.info_outline, color: Colors.white),
                        duration: Duration(seconds: 3),
                      )..show(context);
                    } else {
                      setState(() {
                        clickAdd = true;
                      });
                      await DioHelper.postData(
                        url: "api/user/${widget.userId}",
                        data: {
                          "password": password.text,
                          'old_password': oldPassword.text
                        },
                      ).then((value) {
                        setState(() {
                          clickAdd = false;
                          password.clear();
                          confirmPassword.clear();
                          oldPassword.clear();
                        });
                        Navigator.pop(context);
                        Flushbar(
                          backgroundColor: Colors.green,
                          message: "Password changed",
                          icon: Icon(Icons.verified, color: Colors.white),
                          duration: Duration(seconds: 3),
                        )..show(context);
                      }).catchError((error) {
                        setState(() {
                          clickAdd = false;
                        });
                        Flushbar(
                          backgroundColor: Colors.red,
                          message: "Failed to change password",
                          icon: Icon(Icons.error_outline, color: Colors.white),
                          duration: Duration(seconds: 3),
                        )..show(context);
                        print(error.response.data);
                      });
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showChangeNameModal(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            top: 20,
            right: 20,
            left: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  "Change Name",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff1B263B),
                  ),
                ),
                SizedBox(height: 20),
                _buildTextField(controller: changeName, label: "New name"),
                SizedBox(height: 20),
                _buildSaveButton(
                  context: context,
                  onPressed: () async {
                    setState(() {
                      clickAdd = true;
                    });
                    await DioHelper.postData(
                      url: "api/user/${widget.userId}",
                      data: {
                        "name": changeName.text,
                      },
                    ).then((value) {
                      setState(() {
                        clickAdd = false;
                        changeName.clear();
                      });
                      Navigator.pop(context);
                      Flushbar(
                        backgroundColor: Colors.green,
                        message: "Name changed",
                        icon: Icon(Icons.verified, color: Colors.white),
                        duration: Duration(seconds: 3),
                      )..show(context);
                    }).catchError((error) {
                      setState(() {
                        clickAdd = false;
                      });
                      Flushbar(
                        backgroundColor: Colors.red,
                        message: "Failed to change name",
                        icon: Icon(Icons.error_outline, color: Colors.white),
                        duration: Duration(seconds: 3),
                      )..show(context);
                      print(error.response.data);
                    });
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Color(0xff1B263B)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Color(0xffFDCB6E)),
        ),
      ),
    );
  }

  Widget _buildSaveButton({
    required BuildContext context,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xffFDCB6E), // Yellow Button
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      child: clickAdd
          ? CircularProgressIndicator(color: Colors.white)
          : Text("Save", style: TextStyle(color: Color(0xff1B263B))),
    );
  }
}
