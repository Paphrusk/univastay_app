import 'package:flutter/material.dart';
import 'package:univastay/hostel_navigation_bar.dart';

class HostelPostScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hostel Post'),
      ),
      body: Center(
        child: Text('Hostel Post Screen Content'),
      ),
      bottomNavigationBar:
          HostelNavigationBar(), // Use the hostel navigation bar here
    );
  }
}
