import 'package:flutter/material.dart';
import 'package:univastay/user_navigation_bar.dart';

class UserPostScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Post'),
      ),
      body: Center(
        child: Text('User Post Screen Content'),
      ),
      bottomNavigationBar:
          UserNavigationBar(), // Use the user navigation bar here
    );
  }
}
