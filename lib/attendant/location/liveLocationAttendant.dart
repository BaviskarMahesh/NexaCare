import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Livelocationattendant extends StatefulWidget {
  @override
  State<Livelocationattendant> createState() => _LivelocationattendantState();
}

class _LivelocationattendantState extends State<Livelocationattendant> {
  GoogleMapController? _mapController;
  String googleMapsApiKey = dotenv.env['GOOGLE_MAPS_API_KEY'] ?? '';

  
  LatLng _attendantLocation = const LatLng(20.5937, 78.9629); // Default (India)
  Set<Marker> _markers = {}; // Stores markers for users

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
  }

  /// Request location permission
  Future<void> _requestLocationPermission() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      print("Location permissions are denied.");
    } else {
      _getLiveLocation();
    }
  }

  /// Fetch the attendant's live location
  Future<void> _getLiveLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      _attendantLocation = LatLng(position.latitude, position.longitude);
      _markers.add(
        Marker(
          markerId: MarkerId("attendantLocation"),
          position: _attendantLocation,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          infoWindow: const InfoWindow(title: "Attendant Location"),
        ),
      );
    });

    _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(_attendantLocation, 14.0),
    );

    _updateLocationInFirestore(position.latitude, position.longitude);
    _fetchUsers();
  }

  /// Update attendant's location in Firestore
  Future<void> _updateLocationInFirestore(double lat, double lon) async {
    await FirebaseFirestore.instance
        .collection('Attendant')
        .doc('attendant1')
        .set({'latitude': lat, 'longitude': lon}, SetOptions(merge: true));
  }

  /// Fetch users and add them as blue markers
  Future<void> _fetchUsers() async {
    QuerySnapshot userSnapshot =
        await FirebaseFirestore.instance.collection('Users').get();

    Set<Marker> newMarkers = {};

    for (var doc in userSnapshot.docs) {
      var data = doc.data() as Map<String, dynamic>;

      if (data.containsKey('latitude') && data.containsKey('longitude')) {
        double lat = data['latitude'];
        double lon = data['longitude'];

        newMarkers.add(
          Marker(
            markerId: MarkerId(doc.id),
            position: LatLng(lat, lon),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueBlue,
            ),
            infoWindow: InfoWindow(
              title: data["name"] ?? "No Name",
              snippet: data["details"] ?? "User",
            ),
          ),
        );
      }
    }

    setState(() {
      _markers.addAll(newMarkers);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Attendant Live Location")),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _attendantLocation,
          zoom: 14.0,
        ),
        markers: _markers,
        onMapCreated: (GoogleMapController controller) {
          _mapController = controller;
        },
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 100.0,left: 10),
        child: FloatingActionButton(
          backgroundColor: Colors.black,
          onPressed: () {
            _getLiveLocation(); // Update location & refresh users
          },
          child: const Icon(Icons.my_location, color: Colors.orange),
        ),
      ),
    );
  }
}
