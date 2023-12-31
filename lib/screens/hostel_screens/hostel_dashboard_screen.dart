import 'package:flutter/material.dart';
import 'package:univastay/hostel_navigation_bar.dart';

class HostelDashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hostel Dashboard'),
      ),
      body: Center(
        child: Text('Hostel Dashboard Screen Content'),
      ),
      bottomNavigationBar:
          HostelNavigationBar(), // Use the hostel navigation bar here
    );
  }
}
