import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' show basename;
import 'package:univastay/screens/login_screen.dart';

import 'user_home_screen.dart'; // Import the UserHomeScreen

class UserSignupScreen extends StatefulWidget {
  @override
  _UserSignupScreenState createState() => _UserSignupScreenState();
}

class _UserSignupScreenState extends State<UserSignupScreen> {
  File? _profilePicture;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();
  String _selectedGender = 'Male'; // Default selected gender
  TextEditingController _universityController = TextEditingController();
  TextEditingController _bioController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  Future<void> _selectProfilePicture() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _profilePicture = File(pickedImage.path);
      });
    }
  }

  Future<String?> _uploadProfilePicture() async {
    if (_profilePicture != null) {
      String fileName = basename(_profilePicture!.path);
      Reference storageReference =
          FirebaseStorage.instance.ref().child('profilePictures/$fileName');
      UploadTask uploadTask = storageReference.putFile(_profilePicture!);
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      return downloadUrl;
    }
    return null;
  }

  Future<void> _signupUser() async {
    try {
      // Perform form validation
      if (_passwordController.text != _confirmPasswordController.text) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            // Specify the correct context type
            return AlertDialog(
              title: Text('Error'),
              content: Text('Passwords do not match.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
        return;
      }

      // Create user with email and password
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      // Get the newly created user's ID
      String userId = userCredential.user!.uid;

      // Upload profile picture to Firebase Storage and get the download URL
      String? profilePictureUrl = await _uploadProfilePicture();

      // Save user information to Firestore
      await FirebaseFirestore.instance.collection('users').doc(userId).set({
        'email': _emailController.text.trim(),
        'username': _usernameController.text.trim(),
        'gender': _selectedGender,
        'university': _universityController.text.trim(),
        'bio': _bioController.text.trim(),
        'profilePictureUrl': profilePictureUrl,
      });

      // Display success message and navigate to the next screen
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // Specify the correct context type
          return AlertDialog(
            title: Text('Success'),
            content: Text('User signup successful.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => UserHomeScreen(),
                    ),
                  );
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } catch (error) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // Specify the correct context type
          return AlertDialog(
            title: Text('Error'),
            content: Text(error.toString()),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _universityController.dispose();
    _bioController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
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
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: 'Enter your email',
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  hintText: 'Enter your username',
                ),
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedGender,
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value!;
                  });
                },
                items: <String>['Male', 'Female'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: InputDecoration(
                  labelText: 'Gender',
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _universityController,
                decoration: InputDecoration(
                  labelText: 'University',
                  hintText: 'Enter your university',
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _bioController,
                decoration: InputDecoration(
                  labelText: 'Bio',
                  hintText: 'Enter your bio',
                ),
                maxLines: 3,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'Enter your password',
                ),
                obscureText: true,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  hintText: 'Confirm your password',
                ),
                obscureText: true,
              ),
              SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _signupUser,
                  child: Text('Sign Up'),
                ),
              ),
              SizedBox(height: 16),
              Center(
                child: Text('Already have an account?'),
              ),
              SizedBox(height: 8),
              Center(
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => LoginScreen(),
                      ),
                    );
                  },
                  child: Text(
                    'Login',
                    style: TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
