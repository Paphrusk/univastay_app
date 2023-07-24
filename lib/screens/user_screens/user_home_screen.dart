import 'package:flutter/material.dart';
import 'package:univastay/user_navigation_bar.dart';

class UserHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Home'),
      ),
      body: Center(
        child: Text('User Home Screen Content'),
      ),
      bottomNavigationBar:
          UserNavigationBar(), // Use the user navigation bar here
    );
  }
}
