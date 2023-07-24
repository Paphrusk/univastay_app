import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ViewUsersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('View Users')),
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
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('No users found.'),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final userData =
                    snapshot.data!.docs[index].data() as Map<String, dynamic>;
                final userId = snapshot.data!.docs[index].id;

                final profilePictureUrl = userData['profilePictureUrl'];

                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: profilePictureUrl != null
                        ? NetworkImage(profilePictureUrl)
                        : null, // Default image for no profile picture
                    child: profilePictureUrl == null
                        ? Icon(Icons.account_circle) // Default icon
                        : null,
                  ),
                  title: Text(userData['username']),
                  subtitle: Text(userData['email']),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('User Details'),
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
                                    Text('Username: ${userData['username']}'),
                                    SizedBox(height: 8),
                                    Text('Email: ${userData['email']}'),
                                    SizedBox(height: 8),
                                    Text(
                                        'University: ${userData['university']}'),
                                    SizedBox(height: 8),
                                    Text('Gender: ${userData['gender']}'),
                                    SizedBox(height: 8),
                                    Text('Bio: ${userData['bio']}'),
                                    SizedBox(height: 8),
                                    // Add any other user details you want to display here
                                  ],
                                ),
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () async {
                                Navigator.of(context).pop();

                                // Show confirmation dialog before deleting the user
                                bool confirm = await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Delete User'),
                                      content: Text(
                                          'Do you want to delete ${userData['username']} from users?'),
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
                                  // Delete the user from 'users' collection
                                  await FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(userId)
                                      .delete();
                                }
                              },
                              child: Text('Delete User'),
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
