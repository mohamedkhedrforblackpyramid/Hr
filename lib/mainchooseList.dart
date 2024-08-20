import 'package:flutter/material.dart';
import 'package:hr/screens/profile.dart';
import 'package:hr/screens/whoisattend.dart';

import 'main.dart';
import 'network/local/cache_helper.dart';

class MainPage extends StatefulWidget {
  final int? userId;
  final dynamic oranizaionsList;
  final int? organizationId;
  final String? organizationsName;
  final String? organizationsArabicName;
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: SafeArea(
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
                  // Handle tap
                },
              ),
              DashboardCard(
                title: 'Project Management',
                icon: Icons.assignment,
                color: Colors.blue.shade200,
                onTap: () {
                  // Handle tap
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
