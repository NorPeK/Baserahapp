import 'dart:io';
import 'package:baserah_app/location.dart';
import 'package:baserah_app/login.dart';
import 'package:baserah_app/profile.dart';
import 'package:baserah_app/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'ForgetPass.dart';
import 'editProfile.dart';
import 'logs.dart';

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
      home: const AuthWrapper(),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        '/home': (context) => const HomePage(),
        '/signup': (context) => const SignUpPage(),
        '/profile': (context) => const ProfilePage(),
        '/editProfile': (context) => const EditProfilePage(),
        '/logs': (context) => const LogsPage(),
        '/forgetpass': (context) => const ForgetPass(),
      },
    );
  }
}

// Widget to determine if the user is authenticated or not
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
        // Show a loading indicator while checking the auth state
        return const CircularProgressIndicator();
      },
    );
  }
}

// Stateful widget for the home page to manage the selected tab index
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0; // To track the selected tab

  // Method to handle bottom navigation item taps
  void _onItemTapped(int index) {
    if (index == _selectedIndex) {
      // Do nothing if the selected index is the same as the current index
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
        title: const Text('Home'),
        actions: const [
          CircleAvatar(
            backgroundImage: AssetImage('assets/profile.jpg'), // Ensure to add a placeholder image
          ),
        ],
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'BASERAH',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            SizedBox(height: 20),
            SizedBox(height: 20),
            SizedBox(height: 10),
            CategoriesGrid(),
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
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        SimpleCategoryCard(
          title: 'Click Here to See The User Current Location',
          icon: Icons.not_started_rounded,
          onTap: () {

          },
        ),
        SimpleCategoryCard(
          title: 'Click Here to See The Logs History',
          icon: Icons.book,
          onTap: () {
            Navigator.pushNamed(context, '/logs');
          },
        ),
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.white,
                child: Icon(icon, size: 24, color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
