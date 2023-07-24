import 'package:flutter/material.dart';
import 'package:univastay/user_navigation_bar.dart';

class UserProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
      ),
      body: Center(
        child: Text('User Profile Screen Content'),
      ),
      bottomNavigationBar:
          UserNavigationBar(), // Use the user navigation bar here
    );
  }
}
