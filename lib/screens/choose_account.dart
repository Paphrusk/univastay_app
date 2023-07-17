import 'package:flutter/material.dart';
import 'package:univastay/screens/user_screens/user_signup_screen.dart';
import 'package:univastay/screens/hostel_screens/hostel_signup_screen.dart';

class ChooseAccountScreen extends StatefulWidget {
  @override
  _ChooseAccountScreenState createState() => _ChooseAccountScreenState();
}

class _ChooseAccountScreenState extends State<ChooseAccountScreen> {
  bool _isStudentAccountSelected = false;
  bool _isHostelAccountSelected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Navigate back to the previous screen
            Navigator.pop(context);
          },
        ),
        title: Text('Choose Account'),
      ),
      body: Column(
        children: [
          ListTile(
            leading: Checkbox(
              value: _isStudentAccountSelected,
              onChanged: (value) {
                setState(() {
                  _isStudentAccountSelected = value!;
                  _isHostelAccountSelected = false;
                });
              },
            ),
            title: Text('Student Account'),
            onTap: () {
              setState(() {
                _isStudentAccountSelected = !_isStudentAccountSelected;
                _isHostelAccountSelected = false;
              });
            },
            tileColor: _isStudentAccountSelected ? Colors.grey[300] : null,
          ),
          ListTile(
            leading: Checkbox(
              value: _isHostelAccountSelected,
              onChanged: (value) {
                setState(() {
                  _isHostelAccountSelected = value!;
                  _isStudentAccountSelected = false;
                });
              },
            ),
            title: Text('Hostel Account'),
            onTap: () {
              setState(() {
                _isHostelAccountSelected = !_isHostelAccountSelected;
                _isStudentAccountSelected = false;
              });
            },
            tileColor: _isHostelAccountSelected ? Colors.grey[300] : null,
          ),
          ElevatedButton(
            onPressed: () {
              if (_isStudentAccountSelected) {
                // Navigate to student signup screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UserSignupScreen()),
                );
              } else if (_isHostelAccountSelected) {
                // Navigate to hostel signup screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HostelSignupScreen()),
                );
              }
            },
            child: Text('Continue'),
          ),
        ],
      ),
    );
  }
}
