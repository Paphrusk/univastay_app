import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ConfirmHostelsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Confirm Hostels')),
        automaticallyImplyLeading: false, // Remove the back button
        leading: IconButton(
          icon: Icon(Icons.menu), // Add the icon for the side bar
          onPressed: () {
            // Show the side bar
            Scaffold.of(context).openDrawer();
          },
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('hostels')
            .where('confirmed', isEqualTo: false) // Filter unconfirmed hostels
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('No unconfirmed hostels found.'),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final hostelData =
                    snapshot.data!.docs[index].data() as Map<String, dynamic>;
                final hostelId = snapshot.data!.docs[index].id;

                final profilePictureUrl = hostelData['profilePictureUrl'];

                var circleAvatar = CircleAvatar(
                  backgroundImage: profilePictureUrl != null
                      ? NetworkImage(profilePictureUrl)
                      : null, // Default image for no profile picture
                  child: profilePictureUrl == null
                      ? Icon(Icons.account_circle) // Default icon
                      : null,
                );
                return ListTile(
                  leading: circleAvatar,
                  title: Text(hostelData['hostelName']),
                  subtitle: Text(hostelData['email']),
                  onTap: () {
                    // Update the behavior when the admin clicks on a hostel bar
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return HostelDetailsDialog(
                          hostelData: hostelData,
                          onConfirm: () async {
                            // Set the 'confirmed' status to true
                            hostelData['confirmed'] = true;

                            // Move the hostel to the 'hostels' collection
                            await FirebaseFirestore.instance
                                .collection('hostels')
                                .doc(hostelId)
                                .set(hostelData);

                            // Navigate back to the previous screen (ConfirmHostelsScreen)
                            Navigator.of(context).pop();
                          },
                          onReject: () async {
                            // Delete the hostel from 'hostels' collection
                            await FirebaseFirestore.instance
                                .collection('hostels')
                                .doc(hostelId)
                                .delete();

                            // Navigate back to the previous screen (ConfirmHostelsScreen)
                            Navigator.of(context).pop();
                          },
                        );
                      },
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}

class HostelDetailsDialog extends StatelessWidget {
  final Map<String, dynamic> hostelData;
  final VoidCallback onConfirm;
  final VoidCallback onReject;

  HostelDetailsDialog({
    required this.hostelData,
    required this.onConfirm,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    final profilePictureUrl = hostelData['profilePictureUrl'];

    return AlertDialog(
      title: Text('Hostel Details'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (profilePictureUrl != null)
              Center(
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Dialog(
                          child: Image.network(profilePictureUrl),
                        );
                      },
                    );
                  },
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage: NetworkImage(profilePictureUrl),
                  ),
                ),
              )
            else
              Center(
                child: CircleAvatar(
                  radius: 60,
                  child: Icon(Icons.account_circle),
                ),
              ),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Hostel Name: ${hostelData['hostelName']}'),
                  SizedBox(height: 8),
                  Text('Email: ${hostelData['email']}'),
                  SizedBox(height: 8),
                  Text('Type: ${hostelData['type']}'),
                  SizedBox(height: 8),
                  Text('Status: ${hostelData['status']}'),
                  SizedBox(height: 8),
                  Text('University: ${hostelData['university']}'),
                  SizedBox(height: 8),
                  Text('About: ${hostelData['about']}'),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            // Set the 'confirmed' status to true
            hostelData['confirmed'] = true;
            onConfirm();
          },
          child: Text('Confirm'),
        ),
        TextButton(
          onPressed: () {
            onReject();
            Navigator.of(context).pop(); // Close the dialog
          },
          child: Text('Reject'),
        ),
      ],
    );
  }
}
