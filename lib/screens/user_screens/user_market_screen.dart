import 'package:flutter/material.dart';
import 'package:univastay/user_navigation_bar.dart';

class UserMarketScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Market'),
      ),
      body: Center(
        child: Text('User Market Screen Content'),
      ),
      bottomNavigationBar:
          UserNavigationBar(), // Use the user navigation bar here
    );
  }
}
