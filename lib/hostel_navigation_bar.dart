import 'package:flutter/material.dart';
import 'package:univastay/screens/hostel_screens/hostel_home_screen.dart';
import 'package:univastay/screens/hostel_screens/hostel_transactions_screen.dart';
import 'package:univastay/screens/hostel_screens/hostel_post_screen.dart';
import 'package:univastay/screens/hostel_screens/hostel_chat_screen.dart';
import 'package:univastay/screens/hostel_screens/hostel_dashboard_screen.dart';

class HostelNavigationBar extends StatefulWidget {
  @override
  _HostelNavigationBarState createState() => _HostelNavigationBarState();
}

class _HostelNavigationBarState extends State<HostelNavigationBar> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    HostelHomeScreen(),
    HostelTransactionsScreen(),
    HostelPostScreen(),
    HostelChatScreen(),
    HostelDashboardScreen(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Transactions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add Post',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
        ],
      ),
    );
  }
}
