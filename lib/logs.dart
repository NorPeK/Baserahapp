import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class LogsPage extends StatefulWidget {
  const LogsPage({super.key});

  @override
  _LogsPageState createState() => _LogsPageState();
}

class _LogsPageState extends State<LogsPage> {
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();
  Map<String, dynamic> _logs = {};

  @override
  void initState() {
    super.initState();
    _fetchLogs();
  }

  void _fetchLogs() async {
    DatabaseEvent event = await _databaseReference.once();
    setState(() {
      _logs = Map<String, dynamic>.from(event.snapshot.value as Map);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Logs History'),
      ),
      body: _logs.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _logs.length,
        itemBuilder: (context, index) {
          String key = _logs.keys.elementAt(index);
          return ListTile(
            title: Text(key),
            subtitle: Text(_logs[key].toString()),
          );
        },
      ),
    );
  }
}
