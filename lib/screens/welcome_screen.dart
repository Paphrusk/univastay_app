import 'package:flutter/material.dart';
import 'package:univastay/screens/choose_account.dart';
import 'package:univastay/screens/login_screen.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.purple, Colors.green],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              // Add your app icon widget or placeholder image here
              child: Icon(
                Icons.home,
                size: 64,
                color: Colors.purple,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Welcome to UnivaStay',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Find hostels around your university',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 32),
            SizedBox(
              width: 200,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to Choose Account Screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChooseAccountScreen(),
                    ),
                  );
                },
                child: Text(
                  'Create Account',
                  style: TextStyle(fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.purple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            TextButton(
              onPressed: () {
                // Navigate to Login Screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginScreen(),
                  ),
                );
              },
              child: Text(
                'Login',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
