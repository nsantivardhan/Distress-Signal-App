import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _currentPosition = position;
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> _sendCoordinates() async {
    if (_currentPosition != null) {
      double latitude = _currentPosition!.latitude;
      double longitude = _currentPosition!.longitude;

      // Add your logic to send the coordinates to your server
      // For example, using Firebase Firestore
      FirebaseFirestore.instance.collection('coordinates').add({
        'latitude': latitude,
        'longitude': longitude,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Current Coordinates:'),
            if (_currentPosition != null)
              Text(
                '${_currentPosition!.latitude}, ${_currentPosition!.longitude}',
                style: TextStyle(fontSize: 18),
              ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _sendCoordinates,
              child: Text('Send Coordinates'),
            ),
          ],
        ),
      ),
    );
  }
}