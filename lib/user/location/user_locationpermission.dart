import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:logger/logger.dart';
import 'package:nexacare/Routes/app_routes.dart';
import 'package:nexacare/utils/elevatedbutton.dart';

final log = Logger();

class UserLocationPermission extends StatefulWidget {
  const UserLocationPermission({super.key});

  @override
  State<UserLocationPermission> createState() => _UserLocationPermissionState();
}

class _UserLocationPermissionState extends State<UserLocationPermission> {
  String cityName = "Unknown";
  String colonyName = "Unknown";
  double latitude = 0.0;
  double longitude = 0.0;
  bool isUpdating = false;

  Future<void> updateUserLocation() async {
    setState(() {
      isUpdating = true;
    });

    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      log.e("❌ No user logged in");
      return;
    }

    String uid = user.uid;

    try {
      bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();
      if (!isLocationEnabled) {
        log.w("⚠️ Location services are disabled.");
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          log.w("⚠️ Location permission denied.");
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        log.w("⛔ Location permission is permanently denied.");
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );

      double lat = position.latitude;
      double lng = position.longitude;

      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      Placemark place = placemarks.isNotEmpty ? placemarks.first : Placemark();

      String colony = place.subLocality ?? "Unknown Colony";
      String city = place.locality ?? "Unknown City";
      String country = place.country ?? "Unknown Country";

      log.i("📍 Location: $colony, $city, $country");

      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection("User").doc(uid).get();
      Map<String, dynamic> existingData =
          userDoc.exists ? userDoc.data() as Map<String, dynamic> : {};
      String locationDetail;
      if (colony.isNotEmpty && city.isNotEmpty) {
        locationDetail = "$colony, $city";
      } else if (city.isNotEmpty) {
        locationDetail = city;
      } else {
        locationDetail = "Unknown Location";
      }

      Map<String, dynamic> updatedData = {
        "locationDetail": locationDetail,
        "country": country,
        "latitude": lat,
        "longitude": lng,
        "locationUpdatedAt": Timestamp.now(),
        "name": existingData["name"] ?? "",
        "dateOfBirth": existingData["dateOfBirth"] ?? "",
        "bloodGroup": existingData["bloodGroup"] ?? "",
        "gender": existingData["gender"] ?? "",
        "height": existingData["height"] ?? 0.0,
        "weight": existingData["weight"] ?? 0.0,
      };

      await FirebaseFirestore.instance
          .collection('User')
          .doc(uid)
          .set(updatedData, SetOptions(merge: true));

      setState(() {
        cityName = locationDetail;
        latitude = lat;
        longitude = lng;
        isUpdating = false;
      });

      log.i("✅ Location updated successfully!");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Color(0xff0C0C0C),
          content: Text(
            "Location updated successfully!",
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Font1',
              fontSize: 15,
            ),
          ),
        ),
      );

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Center(child: CircularProgressIndicator(color: Colors.white));
        },
      );

      Future.delayed(Duration(seconds: 1), () {
        Navigator.pop(context);
        Navigator.pushNamed(context, Approutes.homepageUser);
      });
    } catch (e) {
      log.e("❌ Failed to update location: $e");
      setState(() {
        isUpdating = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Failed to update location: $e",
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Font1',
              fontSize: 15,
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color(0xff0C0C0C),
      appBar: AppBar(
        title: Text(
          "Location Permission",
          style: TextStyle(fontFamily: 'Font1', fontSize: 20),
        ),
        backgroundColor: Color(0xff0C0C0C),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: screenHeight * 0.02),
              Center(
                child: Icon(Icons.location_pin, size: 60, color: Colors.white),
              ),
              Center(
                child: Text(
                  "Location Access",
                  style: TextStyle(
                    fontFamily: 'Font1',
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
              
              SizedBox(height: screenHeight * 0.6),
              customElevatedButton(
                text: isUpdating ? "Updating..." : "Enable Location",
                textStyle: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Font1',
                  fontSize: 15,
                ),
                onPressed: isUpdating ? () {} : updateUserLocation,
                buttonColor: Color(0xffFFA500),
                buttonSize: Size(310, 55),
                splashColor: Colors.white.withOpacity(0.3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
