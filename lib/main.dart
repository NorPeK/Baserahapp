import 'dart:io';
import 'package:baserah_app/editProfile.dart';
import 'package:baserah_app/login.dart';
import 'package:baserah_app/profile.dart';
import 'package:baserah_app/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  Platform.isAndroid ? await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: 'REMOVED_PROJECT_Key',
          appId: 'REMOVED_PROJECT_ID',
          messagingSenderId: 'REMOVED_PROJECT_SENT_ID',
          projectId: 'REMOVED_PROJECT_MESSAGE')
  ) : await Firebase.initializeApp();
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
        '/editProfile': (context) => const editProfilePage(),
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
        return const CircularProgressIndicator(); // or some loading indicator
      },
    );
  }
}


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Home'),
        actions: const [
          /*
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
          */
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
              'Baserah',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            /*
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  child: const Text('Live User Location'),
                ),
                const SizedBox(width: 10),
                TextButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  child: const Text('User Location logs'),
                ),
              ],
            ),
            */
            SizedBox(height: 20),
            //const ProgressCard(),
            SizedBox(height: 20),
            /*
            const Text(
              'Categories',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
             */
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
          /*
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle),
            label: '',
          ),
           */
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
        ],
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
// WE CAN REMOVE THIS CLASS
/*
class ProgressCard extends StatelessWidget {
  const ProgressCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Daily progress',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 12,
                      backgroundImage: AssetImage('assets/avatar1.jpg'),
                    ),
                    SizedBox(width: 5),
                    CircleAvatar(
                      radius: 12,
                      backgroundImage: AssetImage('assets/avatar2.jpg'),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 10),
            Text('Here you can see your daily task'),
            SizedBox(height: 10),
            LinearProgressIndicator(
              value: 0.76,
              color: Colors.blue,
              backgroundColor: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
*/


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
      children: const [
        SimpleCategoryCard(
          title: 'Click Here to See The User Current Location',
          icon: Icons.not_started_rounded,
        ),
        SimpleCategoryCard(
          title: 'Click Here to See The logs history',
          icon: Icons.book,
        ),

      ],
    );
  }
}

/*
// WE CAN REMOVE THIS CLASS
class CategoryCard extends StatelessWidget {
  final String title;
  final int newItems;
  final int progress;
  final int total;
  final Color color;

  const CategoryCard({
    super.key,
    required this.title,
    required this.newItems,
    required this.progress,
    required this.total,
    required this.color,
  });



  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$newItems New',
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const CircleAvatar(
                  radius: 15,
                  backgroundImage: AssetImage('assets/category_icon.jpg'), // Ensure to add a placeholder image
                ),
              ],
            ),
            const Spacer(),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            LinearProgressIndicator(
              value: progress / total,
              color: color,
              backgroundColor: Colors.grey,
            ),
            const SizedBox(height: 5),
            Text('$progress/$total'),
          ],
        ),
      ),
    );
  }
}
*/

class SimpleCategoryCard extends StatelessWidget {
  final String title;
  final IconData icon;

  const SimpleCategoryCard({
    super.key,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
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
    );
  }
}


