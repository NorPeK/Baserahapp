import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        automaticallyImplyLeading: false,
        // Removed the leading property to remove the back arrow
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 40,
              backgroundImage: AssetImage('assets/profile.jpg'), // Placeholder image
            ),
            const SizedBox(height: 10),
            const Text(
              'Micheal Smith',
              style: TextStyle(
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
                    color: Colors.purple,
                    onTap: () {
                      Navigator.pushReplacementNamed(context, '/editProfile');
                    },
                  ),
                  /*
                  const ProfileOption(
                    icon: Icons.lock,
                    title: 'Privacy',
                    color: Colors.yellow,
                  ),
                   */
                  const ProfileOption(
                    icon: Icons.help,
                    title: 'Help Center',
                    color: Colors.green,
                  ),
                  ProfileOption(
                    icon: Icons.logout,
                    title: 'Sign Out',
                    color: Colors.red,
                    onTap: () {
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
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
          } else if (index == 3) {
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
  final VoidCallback? onTap; // Added onTap parameter

  const ProfileOption({
    super.key,
    required this.icon,
    required this.title,
    required this.color,
    this.onTap, // Initialize onTap parameter

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
      onTap: onTap ?? () {}, // Use onTap if provided, otherwise do nothing
    );
  }
}
