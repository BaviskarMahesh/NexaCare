import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nexacare/attendant/attendant_details.dart';
import 'package:nexacare/user/attendantService/Attedant%20profile/AttendantProfile.dart';

class NearAttendant extends StatefulWidget {
  @override
  _NearAttendantState createState() => _NearAttendantState();
}

class _NearAttendantState extends State<NearAttendant> {
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      if (mounted) {
        // ✅ Check before calling setState
        setState(() {
          _currentPosition = position;
        });
      }
    } catch (e) {
      print("Error getting location: $e");
    }
  }

  double _calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    return Geolocator.distanceBetween(lat1, lon1, lat2, lon2) / 1000;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Nearby Attendants",
          style: TextStyle(fontFamily: 'Font1', fontSize: 20),
        ),
      ),
      body:
          _currentPosition == null
              ? Center(
                child: CircularProgressIndicator(color: Color(0xffFFA500)),
              )
              : StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance
                        .collection("Attendant")
                        .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: Color(0xffFFA500),
                      ),
                    );
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text("No attendants found"));
                  }

                  var users =
                      snapshot.data!.docs.where((doc) {
                        var user = doc.data() as Map<String, dynamic>;
                        if (user.containsKey('latitude') &&
                            user.containsKey('longitude')) {
                          double lat = user['latitude'];
                          double lon = user['longitude'];
                          double distance = _calculateDistance(
                            _currentPosition!.latitude,
                            _currentPosition!.longitude,
                            lat,
                            lon,
                          );
                          return distance <= 5.0;
                        }
                        return false;
                      }).toList();

                  return users.isEmpty
                      ? Center(child: Text("No nearby attendants found"))
                      : ListView.builder(
                        itemCount: users.length,
                        itemBuilder: (context, index) {
                          var user =
                              users[index].data() as Map<String, dynamic>;

                          return ListTile(
                            title: Text(
                              user["name"] ?? "No Name",
                              style: TextStyle(
                                fontFamily: 'Font1',
                                fontSize: 15,
                                color: Colors.white,
                              ),
                            ),
                            subtitle: Text(
                              user["degree"] ?? "No Degree",
                              style: TextStyle(
                                fontFamily: 'Font1',
                                fontSize: 11,
                                color: Colors.white,
                              ),
                            ),
                            trailing: Icon(Icons.arrow_forward_ios),
                            onTap: () {
                              if (mounted) {
                                // ✅ Check before navigation
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => Attendantprofile(
                                          userId: users[index].id,
                                        ),
                                  ),
                                );
                              }
                            },
                          );
                        },
                      );
                },
              ),
    );
  }
}
