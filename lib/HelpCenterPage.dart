import 'package:flutter/material.dart';

class HelpCenterPage extends StatelessWidget {
  const HelpCenterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help Center'),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/profile');
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: 6, // We need 6 boxes
          itemBuilder: (context, index) {
            if (index == 0) {
              return const HelpCenterBox(
                name: 'Hassan alzayer',
                email: 'eng.halzayer@gmail.com',
                phoneNumber: '0555886884',
              );
            } else if (index == 1) {
              return const HelpCenterBox(
                name: 'Basil Alsadah',
                email: '2200004030@iau.edu.sa',
                phoneNumber: '0569252825',
              );
            } else if (index == 2) {
              return const HelpCenterBox(
                name: 'Nour-Allah Bek',
                email: 'norpekbusiness@hotmail.com',
                phoneNumber: '0534479162',
              );
            } else if (index == 3) {
              return const HelpCenterBox(
                name: 'Ahmed AlHashem',
                email: '2200004511@iau.edu.sa',
                phoneNumber: '0543823610',
              );
            } else if (index == 4) {
              return const HelpCenterBox(
                name: 'Hussain AlAbbas',
                email: '2200000395@iau.edu.sa',
                phoneNumber: '0507783480',
              );
            } else if (index == 5) {
              return const HelpCenterBox(
                name: 'Mshary AlHarbi',
                email: '2200006039@iau.edu.sa',
                phoneNumber: '0551798900',
              );
            } else {
              return HelpCenterBox(
                name: 'User $index',
                email: 'user$index@example.com',
                phoneNumber: '0555${index}88${index}84',
              );
            }
          },
        ),
      ),
    );
  }
}

class HelpCenterBox extends StatelessWidget {
  final String name;
  final String email;
  final String phoneNumber;

  const HelpCenterBox({
    super.key,
    required this.name,
    required this.email,
    required this.phoneNumber,
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              name,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Email: $email',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 8),
            Text(
              'Phone: $phoneNumber',
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
