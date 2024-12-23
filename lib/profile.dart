import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Future<Map<String, dynamic>> _fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      return userDoc.data() as Map<String, dynamic>;
    }
    return {};
  }

  Future<void> _uploadProfilePicture() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File file = File(pickedFile.path);
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        try {
          Reference storageReference = FirebaseStorage.instance
              .ref()
              .child('profilePictures/${user.uid}.jpg');
          UploadTask uploadTask = storageReference.putFile(file);
          await uploadTask;
          String downloadUrl = await storageReference.getDownloadURL();

          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .update({'profilePhotoUrl': downloadUrl});

          setState(() {});
        } catch (e) {
          print('Error uploading profile picture: $e');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _fetchUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No user data found'));
          } else {
            Map<String, dynamic> userData = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: _uploadProfilePicture,
                    child: CircleAvatar(
                      radius: 40,
                      backgroundImage: userData['profilePhotoUrl'] != null
                          ? NetworkImage(userData['profilePhotoUrl'])
                          : const AssetImage('assets/profile.jpg')
                              as ImageProvider,
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    userData['name'] ?? 'Unknown User',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView(
                      children: [
                        ProfileOption(
                          icon: Icons.edit,
                          title: 'Edit Profile',
                          color: Colors.deepPurple,
                          onTap: () {
                            Navigator.pushReplacementNamed(
                                context, '/editProfile');
                          },
                        ),
                        ProfileOption(
                          icon: Icons.help,
                          title: 'Help Center',
                          color: Colors.deepPurple,
                          onTap: () {
                            Navigator.pushReplacementNamed(
                                context, '/helpcenter');
                          },
                        ),
                        ProfileOption(
                          icon: Icons.logout,
                          title: 'Sign Out',
                          color: Colors.deepPurple,
                          onTap: () {
                            FirebaseAuth.instance.signOut().then((value) {
                              Navigator.pushReplacementNamed(context, '/login');
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: 1, // Set the current index to the profile tab
        onTap: (index) {
          if (index == 0) {
            Navigator.pushNamed(context, '/home');
          } else if (index == 1) {
            Navigator.pushNamed(context, '/profile');
          }
        },
      ),
    );
  }
}

class ProfileOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback? onTap;

  const ProfileOption({
    super.key,
    required this.icon,
    required this.title,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color,
        child: Icon(icon, color: Colors.white),
      ),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: onTap ?? () {},
    );
  }
}
