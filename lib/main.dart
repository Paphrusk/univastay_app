import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:univastay/screens/welcome_screen.dart';
import 'package:univastay/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(UnivaStayApp());
}

class UnivaStayApp extends StatefulWidget {
  @override
  _UnivaStayAppState createState() => _UnivaStayAppState();
}

class _UnivaStayAppState extends State<UnivaStayApp> {
  @override
  void initState() {
    super.initState();
    // Wait for 2 seconds and then navigate to WelcomeScreen
    Timer(Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => WelcomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // Hide the debug banner
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    return MaterialApp(
      title: 'UnivaStay',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.purple)
            .copyWith(secondary: Colors.green),
      ),
      debugShowCheckedModeBanner: false, // Remove the debug banner
      home: Scaffold(
        // Add your splash screen widget here
        body: Center(
          child: Builder(
            builder: (context) {
              // Access the Navigator widget through the builder's context
              // and navigate to WelcomeScreen after the delay
              Future.delayed(Duration(seconds: 2), () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => WelcomeScreen()),
                );
              });
              // Display your custom splash screen widget here
              return FlutterLogo(
                size: 100,
              );
            },
          ),
        ),
      ),
    );
  }
}
