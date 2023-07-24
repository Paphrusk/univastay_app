import 'package:flutter/material.dart';
import 'package:univastay/screens/user_screens/user_home_screen.dart';
import 'package:univastay/screens/user_screens/user_market_screen.dart';
import 'package:univastay/screens/user_screens/user_post_screen.dart';
import 'package:univastay/screens/user_screens/user_chat_screen.dart';
import 'package:univastay/screens/user_screens/user_profile_screen.dart';

class UserNavigationBar extends StatefulWidget {
  @override
  _UserNavigationBarState createState() => _UserNavigationBarState();
}

class _UserNavigationBarState extends State<UserNavigationBar> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    UserHomeScreen(),
    UserMarketScreen(),
    UserPostScreen(),
    UserChatScreen(),
    UserProfileScreen(),
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
            icon: Icon(Icons.shopping_bag),
            label: 'Market',
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
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
