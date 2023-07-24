import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ViewHostelsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('View Hostels')),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.menu), // Add the icon for the side bar
          onPressed: () {
            // Show the side bar
            Scaffold.of(context).openDrawer();
          },
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('hostels').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('No hostels found.'),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final hostelData =
                    snapshot.data!.docs[index].data() as Map<String, dynamic>;
                final hostelId = snapshot.data!.docs[index].id;

                final profilePictureUrl = hostelData['profilePictureUrl'];

                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: profilePictureUrl != null
                        ? NetworkImage(profilePictureUrl)
                        : null, // Default image for no profile picture
                    child: profilePictureUrl == null
                        ? Icon(Icons.account_circle) // Default icon
                        : null,
                  ),
                  title: Text(hostelData['hostelName']),
                  subtitle: Text(hostelData['email']),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Hostel Details'),
                          content: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (profilePictureUrl != null)
                                Center(
                                  child: GestureDetector(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return Dialog(
                                            child: Image.network(
                                              profilePictureUrl,
                                              fit: BoxFit.contain,
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    child: CircleAvatar(
                                      radius: 60,
                                      backgroundImage:
                                          NetworkImage(profilePictureUrl),
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
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        'Hostel Name: ${hostelData['hostelName']}'),
                                    SizedBox(height: 8),
                                    Text('Email: ${hostelData['email']}'),
                                    SizedBox(height: 8),
                                    Text('Type: ${hostelData['type']}'),
                                    SizedBox(height: 8),
                                    Text('Status: ${hostelData['status']}'),
                                    SizedBox(height: 8),
                                    Text(
                                        'University: ${hostelData['university']}'),
                                    SizedBox(height: 8),
                                    Text('About: ${hostelData['about']}'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () async {
                                Navigator.of(context).pop();

                                // Show confirmation dialog before deleting the hostel
                                bool confirm = await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Delete Hostel'),
                                      content: Text(
                                          'Do you want to delete ${hostelData['hostelName']} from hostels?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop(true);
                                          },
                                          child: Text('Yes'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop(false);
                                          },
                                          child: Text('No'),
                                        ),
                                      ],
                                    );
                                  },
                                );

                                if (confirm) {
                                  // Delete the hostel from 'hostels' collection
                                  await FirebaseFirestore.instance
                                      .collection('hostels')
                                      .doc(hostelId)
                                      .delete();
                                }
                              },
                              child: Text('Delete Hostel'),
                            ),
                          ],
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
