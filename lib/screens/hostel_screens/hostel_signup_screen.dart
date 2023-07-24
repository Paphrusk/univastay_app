import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' show basename;
import 'package:univastay/screens/login_screen.dart';
import 'package:univastay/screens/hostel_screens/hostel_home_screen.dart';

class HostelSignupScreen extends StatefulWidget {
  @override
  _HostelSignupScreenState createState() => _HostelSignupScreenState();
}

class _HostelSignupScreenState extends State<HostelSignupScreen> {
  File? _profilePicture;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _hostelNameController = TextEditingController();
  String _selectedType = 'Hostel'; // Default selected type
  String _selectedStatus = 'Male'; // Default selected status
  final TextEditingController _universityController = TextEditingController();
  final TextEditingController _aboutController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _isLoading = false;

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

  Future<void> _signupHostel() async {
    try {
      // Perform form validation
      if (_passwordController.text != _confirmPasswordController.text) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
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

      // Show a progress indicator while processing
      setState(() {
        _isLoading = true;
      });

      // Create a new user with email and password
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _emailController.text.trim(),
              password: _passwordController.text);

      // Get the user ID of the newly created hostel
      String? hostelId = userCredential.user?.uid;

      // Upload profile picture to Firebase Storage and get the download URL
      String? profilePictureUrl = await _uploadProfilePicture();

      // Save hostel information to Firestore
      Map<String, dynamic> hostelData = {
        'hostelId': hostelId,
        'email': _emailController.text.trim(),
        'hostelName': _hostelNameController.text.trim(),
        'type': _selectedType,
        'status': _selectedStatus,
        'university': _universityController.text.trim(),
        'about': _aboutController.text.trim(),
        'profilePictureUrl': profilePictureUrl,
        'confirmed': false,
      };

      // Save hostel information to Firestore under the 'hostels' collection
      await FirebaseFirestore.instance
          .collection('hostels')
          .doc(hostelId)
          .set(hostelData);

      // Hide the progress indicator after processing
      setState(() {
        _isLoading = false;
      });

      // Show a success dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Success'),
            content: Text(
              'To prevent fraudsters who could use our platform to steal money, we have sent your details to the UnivaStay management for confirmation. Your information is safe and secure. We ask you to be patient with us. It will take 4-48 hours.',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => HostelHomeScreen(),
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
      // Hide the progress indicator after processing
      setState(() {
        _isLoading = false;
      });

      showDialog(
        context: context,
        builder: (BuildContext context) {
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
    _hostelNameController.dispose();
    _universityController.dispose();
    _aboutController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
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
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: 'Enter your email',
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _hostelNameController,
                decoration: InputDecoration(
                  labelText: 'Hostel Name',
                  hintText: 'Enter your hostel name',
                ),
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedType,
                decoration: InputDecoration(
                  labelText: 'Type',
                ),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedType = newValue!;
                  });
                },
                items: ['Hostel', 'Rental'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedStatus,
                decoration: InputDecoration(
                  labelText: 'Status',
                ),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedStatus = newValue!;
                  });
                },
                items: ['Male', 'Female', 'Mixed'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
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
                controller: _aboutController,
                decoration: InputDecoration(
                  labelText: 'About',
                  hintText: 'Enter information about the hostel',
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
                  onPressed: _isLoading ? null : _signupHostel,
                  child:
                      _isLoading ? CircularProgressIndicator() : Text('Signup'),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
