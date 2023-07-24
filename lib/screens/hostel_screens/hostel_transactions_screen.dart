import 'package:flutter/material.dart';
import 'package:univastay/hostel_navigation_bar.dart';

class HostelTransactionsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hostel Transactions'),
      ),
      body: Center(
        child: Text('Hostel Transactions Screen Content'),
      ),
      bottomNavigationBar:
          HostelNavigationBar(), // Use the hostel navigation bar here
    );
  }
}
