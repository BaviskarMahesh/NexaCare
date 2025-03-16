import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LivelocationPage extends StatefulWidget {
  @override
  State<LivelocationPage> createState() => _LivelocationPageState();
}

class _LivelocationPageState extends State<LivelocationPage> {
  final MapController _mapController = MapController();
  LatLng? _currentLocation; // Store the latest location

  /// Fetch user location stream from Firestore
  Stream<LatLng?> _getUserLocationStream() {
    return FirebaseFirestore.instance.collection('User').snapshots().map((
      querySnapshot,
    ) {
      if (querySnapshot.docs.isNotEmpty) {
        var data = querySnapshot.docs.first.data();
        if (data.containsKey('latitude') && data.containsKey('longitude')) {
          double latitude = data['latitude'].toDouble();
          double longitude = data['longitude'].toDouble();

          // Debugging: Print live location updates
          print("Live Location Updated: Lat: $latitude, Lng: $longitude");

          return LatLng(latitude, longitude);
        }
      }
      return null;
    });
  }

  /// Update map position without unnecessary movement
  void _updateMapPosition(LatLng newLocation) {
    if (_currentLocation == null ||
        (_currentLocation!.latitude != newLocation.latitude ||
            _currentLocation!.longitude != newLocation.longitude)) {
      setState(() {
        _currentLocation = newLocation;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Live Location Map")),
      body: StreamBuilder<LatLng?>(
        stream: _getUserLocationStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            _updateMapPosition(snapshot.data!);
          }

          return FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter:
                  _currentLocation ??
                  LatLng(20.5937, 78.9629), // Default: India
              initialZoom: 15.0,
            ),
            children: [
              TileLayer(
                urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
              ),
              if (_currentLocation != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _currentLocation!,
                      width: 50,
                      height: 50,
                      child: const Icon(
                        Icons.location_on,
                        size: 50,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_currentLocation != null) {
            _mapController.move(
              _currentLocation!,
              15.0,
            ); // Move map to current location
          }
        },
        child: const Icon(Icons.my_location),
      ),
    );
  }
}
