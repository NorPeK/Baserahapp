import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LogsPage extends StatefulWidget {
  const LogsPage({super.key});

  @override
  _LogsPageState createState() => _LogsPageState();
}

class _LogsPageState extends State<LogsPage> {
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();
  Map<String, dynamic> _logs = {};
  String? _date;

  @override
  void initState() {
    super.initState();
    _fetchLogs();
  }

  void _fetchLogs() async {
    DatabaseEvent event = await _databaseReference.once();
    setState(() {
      _logs = Map<String, dynamic>.from(event.snapshot.value as Map);
      _date = _formatDate(_logs.remove('Date'));
      _logs['waterLevel_sensor'] = _logs.remove('current_WaterLevel_sensor_reading');
    });
  }

  String _formatDate(String? date) {
    if (date == null) return '';
    DateTime dateTime = DateTime.parse(date);
    DateTime localDateTime = dateTime.add(const Duration(hours: 3));
    return DateFormat('yyyy-MM-dd HH:mm').format(localDateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Logs History'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: _logs.isEmpty && _date == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_date != null) ...[
              const Text(
                'Date',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _date!,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white54,
                ),
              ),
              const SizedBox(height: 16),
            ],
            Expanded(
              child: ListView.builder(
                itemCount: _logs.length,
                itemBuilder: (context, index) {
                  String key = _logs.keys.elementAt(index);
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Card(
                      color: Colors.grey[850],
                      child: ListTile(
                        title: Text(
                          _formatTitle(key),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white70,
                          ),
                        ),
                        subtitle: Text(
                          _logs[key].toString(),
                          style: const TextStyle(color: Colors.white60),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTitle(String key) {
    switch (key) {
      case 'waterLevel_sensor':
        return 'Water Level Sensor';
      case 'current_latitude':
        return 'Current Latitude';
      case 'current_longitude':
        return 'Current Longitude';
      case 'current_distance_sensor_reading':
        return 'Distance Sensor';
      default:
        return key;
    }
  }
}
