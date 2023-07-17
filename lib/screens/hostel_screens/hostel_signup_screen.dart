import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class HostelSignupScreen extends StatefulWidget {
  @override
  _HostelSignupScreenState createState() => _HostelSignupScreenState();
}

class _HostelSignupScreenState extends State<HostelSignupScreen> {
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
        title: Text('Hostel Signup'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Sign up for a free account here',
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
                items: ['Hostel', 'Rental']
                    .map((type) => DropdownMenuItem<String>(
                          value: type,
                          child: Text(type),
                        ))
                    .toList(),
                onChanged: (value) {
                  // Handle type selection
                },
                decoration: InputDecoration(
                  labelText: 'Type',
                ),
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                items: ['Male', 'Female', 'Mixed']
                    .map((status) => DropdownMenuItem<String>(
                          value: status,
                          child: Text(status),
                        ))
                    .toList(),
                onChanged: (value) {
                  // Handle status selection
                },
                decoration: InputDecoration(
                  labelText: 'Status',
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
