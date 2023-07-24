import 'package:flutter/material.dart';
import 'package:univastay/hostel_navigation_bar.dart';

class HostelHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hostel Home'),
      ),
      body: Center(
        child: Text('Hostel Home Screen Content'),
      ),
      bottomNavigationBar:
          HostelNavigationBar(), // Use the hostel navigation bar here
    );
  }
}
