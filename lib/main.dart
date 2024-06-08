import 'dart:io';
import 'package:baserah_app/HelpCenterPage.dart';
import 'package:baserah_app/location.dart';
import 'package:baserah_app/login.dart';
import 'package:baserah_app/profile.dart';
import 'package:baserah_app/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'ForgetPass.dart';
import 'editProfile.dart';
import 'logs.dart';
import 'splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase for Android with specific options
  Platform.isAndroid
      ? await Firebase.initializeApp(
          options: const FirebaseOptions(
              apiKey: 'REMOVED_PROJECT_Key',
              appId: 'REMOVED_PROJECT_ID',
              messagingSenderId: 'REMOVED_PROJECT_SENT_ID',
              projectId: 'REMOVED_PROJECT_MESSAGE'))
      // Initialize Firebase for other platforms
      : await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Baserah',
      theme: ThemeData.dark(),
      home: const SplashScreen(),
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/authWrapper': (context) => const AuthWrapper(),
        '/login': (context) => const LoginPage(),
        '/home': (context) => const HomePage(),
        '/signup': (context) => const SignUpPage(),
        '/profile': (context) => const ProfilePage(),
        '/editProfile': (context) => const EditProfilePage(),
        '/logs': (context) => const LogsPage(),
        '/forgetpass': (context) => const ForgetPass(),
        '/location': (context) => const LocationPage(),
        '/helpcenter': (context) => const HelpCenterPage(),
      },
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final user = snapshot.data;
          return user == null ? const LoginPage() : const HomePage();
        }
        return const CircularProgressIndicator();
      },
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  String _userName = "Loading..."; // Initial placeholder

  @override
  void initState() {
    super.initState();
    _fetchUserName();
  }

  void _fetchUserName() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      setState(() {
        _userName = userDoc['name'] ?? 'No Name';
      });
    }
  }

  void _onItemTapped(int index) {
    if (index == _selectedIndex) {
      return;
    }
    setState(() {
      _selectedIndex = index;
    });
    if (index == 0) {
      Navigator.pushReplacementNamed(context, '/home');
    } else if (index == 1) {
      Navigator.pushReplacementNamed(context, '/profile');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Padding(
          padding: EdgeInsets.only(top: 30),
          child: Text(
            'Baserah',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
          ),
        ),
        actions: const [
          CircleAvatar(
            backgroundImage: AssetImage('assets/profile.jpg'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Text(
              'Hello, $_userName',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 5),
            const Text(
              'Good morning',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 20),
            const CategoriesGrid(),
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
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

// Stateless widget for the categories grid
class CategoriesGrid extends StatelessWidget {
  const CategoriesGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 15, // Keep horizontal spacing as desired
      mainAxisSpacing: 20, // Increase vertical spacing
      childAspectRatio:
          0.4, // Adjust this to make cards taller (width to height ratio)
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        SimpleCategoryCard(
          title: 'Location',
          icon: Icons.location_on,
          onTap: () {
            Navigator.pushNamed(context, '/location');
          },
        ),
        SimpleCategoryCard(
          title: 'Logs History',
          icon: Icons.history,
          onTap: () {
            Navigator.pushNamed(context, '/logs');
          },
        ),
        // Add more cards as needed
      ],
    );
  }
}

// Stateless widget for individual category cards
class SimpleCategoryCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const SimpleCategoryCard({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: 180, // Set the desired minimum height here
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24, // Increase font size
                    fontWeight: FontWeight.bold, // Make text bold
                  ),
                ),
                const SizedBox(height: 20),
                CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.white,
                  child: Icon(icon, size: 70, color: Colors.black),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
