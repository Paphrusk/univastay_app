import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome back'),
      ),
      body: Container(
        alignment: Alignment.center,
        child: Text('Login Screen'),
      ),
    );
  }
}
