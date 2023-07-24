import 'package:flutter/material.dart';
import 'package:univastay/screens/admin_screens/confirm_hostels.dart';
import 'package:univastay/screens/admin_screens/view_hostels.dart';
import 'package:univastay/screens/admin_screens/view_users.dart';
import 'package:univastay/screens/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminScreen extends StatefulWidget {
  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  int _selectedIndex = 0;
  String adminName = 'Univastay';
  String adminEmail = 'univastay@gmail.com';

  final List<Widget> _screens = [
    ConfirmHostelsScreen(),
    ViewHostelsScreen(),
    ViewUsersScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout'),
          content: Text('Do you want to logout?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Navigate to the login screen
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => LoginScreen(),
                  ),
                  (route) => false,
                );
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    // Fetch and set admin data from Firestore
    fetchAdminData();
  }

  Future<void> fetchAdminData() async {
    try {
      final adminSnapshot = await FirebaseFirestore.instance
          .collection('admins')
          .doc('adminId')
          .get();
      final adminData = adminSnapshot.data() as Map<String, dynamic>;
      setState(() {
        adminName = adminData['name'];
        adminEmail = adminData['email'];
      });
    } catch (error) {
      print('Error fetching admin data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Remove the app bar
      body: _screens[_selectedIndex],
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(adminName),
              accountEmail: Text(adminEmail),
            ),
            ListTile(
              leading: Icon(Icons.check),
              title: Text('Confirm Hostels'),
              onTap: () {
                _onItemTapped(0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.hotel),
              title: Text('View Hostels'),
              onTap: () {
                _onItemTapped(1);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('View Users'),
              onTap: () {
                _onItemTapped(2);
                Navigator.pop(context);
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: _logout,
            ),
          ],
        ),
      ),
    );
  }
}
