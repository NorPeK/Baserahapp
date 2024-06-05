import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LogsPage extends StatelessWidget {
  const LogsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Location Logs'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('logs').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No logs found'));
          }
          return ListView(
            children: snapshot.data!.docs.map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              final latitude = data['latitude'] ?? 'Unknown';
              final longitude = data['longitude'] ?? 'Unknown';
              final timestamp = data['timestamp'] != null
                  ? (data['timestamp'] as Timestamp).toDate().toString()
                  : 'Unknown';

              return ListTile(
                title: Text('Lat: $latitude, Lon: $longitude'),
                subtitle: Text('Timestamp: $timestamp'),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
