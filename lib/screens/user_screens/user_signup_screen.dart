import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserSignupScreen extends StatefulWidget {
  @override
  _UserSignupScreenState createState() => _UserSignupScreenState();
}

class _UserSignupScreenState extends State<UserSignupScreen> {
  File? _profilePicture;

  Future<void> _selectProfilePicture() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _profilePicture = File(pickedImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Signup'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Sign Up',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              GestureDetector(
                onTap: _selectProfilePicture,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    shape: BoxShape.circle,
                  ),
                  child: _profilePicture != null
                      ? ClipOval(
                          child: Image.file(
                            _profilePicture!,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Icon(
                          Icons.camera_alt,
                          size: 64,
                          color: Colors.grey[600],
                        ),
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: 'Enter your email',
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Username',
                  hintText: 'Enter your username',
                ),
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                items: ['Male', 'Female']
                    .map((gender) => DropdownMenuItem<String>(
                          value: gender,
                          child: Text(gender),
                        ))
                    .toList(),
                onChanged: (value) {
                  // Handle gender selection
                },
                decoration: InputDecoration(
                  labelText: 'Gender',
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'University',
                  hintText: 'Enter your university',
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'Enter your password',
                ),
                obscureText: true,
              ),
              SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Handle signup button pressed
                  },
                  child: Text('Sign Up'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
