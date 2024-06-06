import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class LocationPage extends StatefulWidget {
  const LocationPage({super.key});

  @override
  _LocationPageState createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  double? _latitude;
  double? _longitude;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchLocation();
  }

  Future<void> _fetchLocation() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
          .collection('locations')
          .doc('user_location') // Assuming 'user_location' is the document ID
          .get();

      if (snapshot.exists) {
        setState(() {
          _latitude = snapshot.data()?['latitude'];
          _longitude = snapshot.data()?['longitude'];
          _loading = false;
        });
      } else {
        setState(() {
          _loading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location not found in Firebase.')),
        );
      }
    } catch (e) {
      setState(() {
        _loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching location: $e')),
      );
    }
  }

  Future<void> _openMap() async {
    if (_latitude != null && _longitude != null) {
      final url = 'https://www.google.com/maps/search/?api=1&query=$_latitude,$_longitude';
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open the map.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Current Location'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_latitude != null && _longitude != null) ...[
              Text('Latitude: $_latitude'),
              Text('Longitude: $_longitude'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _openMap,
                child: const Text('Open in Google Maps'),
              ),
            ] else
              const Text('Location data is not available.'),
          ],
        ),
      ),
    );
  }
}
