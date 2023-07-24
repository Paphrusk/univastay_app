import 'package:flutter/material.dart';
import 'package:univastay/user_navigation_bar.dart';

class UserChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Chat'),
      ),
      body: Center(
        child: Text('User Chat Screen Content'),
      ),
      bottomNavigationBar:
          UserNavigationBar(), // Use the user navigation bar here
    );
  }
}
