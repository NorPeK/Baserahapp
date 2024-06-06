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
      _logs['waterLevel_sensor'] =
          _logs.remove('current_WaterLevel_sensor_reading');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Logs History'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: _logs.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _logs.length,
              itemBuilder: (context, index) {
                String key = _logs.keys.elementAt(index);
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: Card(
                    child: ListTile(
                      title: Text(
                        _formatTitle(key),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        _logs[key].toString(),
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }

  String _formatTitle(String key) {
    switch (key) {
      case 'waterLevel_sensor':
        return 'Water Level Sensor ';
      case 'current_latitude':
        return 'Current Latitude';
      case 'current_longitude':
        return 'Current Longitude';
      case 'current_distance_sensor_reading':
        return 'Distance Sensor ';
      default:
        return key;
    }
  }
}
