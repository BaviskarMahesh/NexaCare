import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
class LiveLocationPage extends StatefulWidget {
  @override
  State<LiveLocationPage> createState() => _LiveLocationPageState();
}

class _LiveLocationPageState extends State<LiveLocationPage> {
  String googleMapsApiKey = dotenv.env['GOOGLE_MAPS_API_KEY'] ?? '';

  GoogleMapController? _mapController;
  LatLng _currentLocation = LatLng(
    20.5937,
    78.9629,
  ); // Default location (India)
  Set<Marker> _markers = {}; // Store markers

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
    _fetchAttendants(); // Fetch attendants on init
  }

  /// Request location permissions
  Future<void> _requestLocationPermission() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      print("Location permissions are denied.");
    } else {
      _getLiveLocation();
    }
  }

  /// Fetch user's current location
  Future<void> _getLiveLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      _currentLocation = LatLng(position.latitude, position.longitude);
      _markers.add(
        Marker(
          markerId: MarkerId("currentLocation"),
          position: _currentLocation,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          infoWindow: InfoWindow(title: "Your Location"),
        ),
      );
    });

    _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(_currentLocation, 14.0),
    );
  }

  /// Fetch attendants within 5 km and add them to the map
  Future<void> _fetchAttendants() async {
    QuerySnapshot attendantsSnapshot =
        await FirebaseFirestore.instance.collection('Attendant').get();

    Set<Marker> newMarkers = {};

    for (var doc in attendantsSnapshot.docs) {
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
            ), // Blue pin
            infoWindow: InfoWindow(
              title: data["name"] ?? "No Name",
              snippet: data["degree"] ?? "No Degree",
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
      appBar: AppBar(
        title: const Text(
          "Live Location Map",
          style: TextStyle(fontFamily: 'Font1', color: Color(0xffFFFFFF)),
        ),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _currentLocation,
          zoom: 14.0,
        ),
        markers: _markers,
        onMapCreated: (GoogleMapController controller) {
          _mapController = controller;
        },
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 100, left: 10),
        child: FloatingActionButton(
          backgroundColor: Color(0xff0c0c0c),

          onPressed: () {
            _getLiveLocation();
            _fetchAttendants(); // Refresh markers
          },
          child: const Icon(Icons.my_location, color: Color(0xffFFA500)),
        ),
      ),
    );
  }
}
