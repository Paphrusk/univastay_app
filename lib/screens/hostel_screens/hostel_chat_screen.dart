import 'package:flutter/material.dart';
import 'package:univastay/hostel_navigation_bar.dart';

class HostelChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hostel Chat'),
      ),
      body: Center(
        child: Text('Hostel Chat Screen Content'),
      ),
      bottomNavigationBar:
          HostelNavigationBar(), // Use the hostel navigation bar here
    );
  }
}
