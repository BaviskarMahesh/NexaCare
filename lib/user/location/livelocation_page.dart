import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LivelocationPage extends StatefulWidget {
  const LivelocationPage({super.key});

  @override
  State<LivelocationPage> createState() => _LivelocationPageState();
}

class _LivelocationPageState extends State<LivelocationPage> {
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  bool _isMapLoaded = false; // ✅ Ensure map loads properly

  static const LatLng _initialLocation = LatLng(
    18.5204,
    73.8567,
  ); // Default location

  @override
  void initState() {
    super.initState();
    _fetchLocationFromFirestore();
  }

  Future<void> _fetchLocationFromFirestore() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('User').get();
      Set<Marker> markers = {};

      for (var doc in snapshot.docs) {
        var data = doc.data() as Map<String, dynamic>;
        if (data.containsKey('latitude') && data.containsKey('longitude')) {
          String name = data['name'] ?? "Unknown";
          double latitude = data['latitude'];
          double longitude = data['longitude'];
          String locationDetail =
              data['locationDetail'] ?? "No details available";

          markers.add(
            Marker(
              markerId: MarkerId(name),
              position: LatLng(latitude, longitude),
              infoWindow: InfoWindow(title: name, snippet: locationDetail),
            ),
          );
        }
      }

      setState(() {
        _markers = markers;
      });
    } catch (e) {
      print("Error fetching location: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: _initialLocation,
              zoom: 13,
            ),
            markers: _markers,
            onMapCreated: (controller) {
              _mapController = controller;
              setState(() {
                _isMapLoaded = true; // ✅ Ensure map loads
              });
            },
          ),
          if (!_isMapLoaded)
            const Center(
              child: CircularProgressIndicator(color: Color(0xffFFA500)),
            ), // Show loading spinner until map is ready
        ],
      ),
    );
  }
}
