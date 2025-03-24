import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nexacare/Chat_Service/Chat_Screens/chatBox.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Listofattendantforchat extends StatefulWidget {
  @override
  _ListofattendantforchatState createState() => _ListofattendantforchatState();
}

class _ListofattendantforchatState extends State<Listofattendantforchat> {
  Position? _currentPosition;
  String? _userId;

  @override
  void initState() {
    super.initState();
    _getUserLocation();
    _userId = FirebaseAuth.instance.currentUser?.uid;
  }

  Future<void> _getUserLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    setState(() {
      _currentPosition = position;
    });
  }

  double _calculateDistance(
      double lat1, double lon1, double lat2, double lon2) {
    const double R = 6371; // Earth radius in km
    double dLat = _degToRad(lat2 - lat1);
    double dLon = _degToRad(lon2 - lon1);

    double a =
        (sin(dLat / 2) * sin(dLat / 2)) +
            cos(_degToRad(lat1)) *
                cos(_degToRad(lat2)) *
                (sin(dLon / 2) * sin(dLon / 2));

    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return R * c; // Distance in km
  }

  double _degToRad(double degree) {
    return degree * (pi / 180);
  }

  @override
  Widget build(BuildContext context) {
    if (_currentPosition == null || _userId == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            "Chat with Attendants",
            style: TextStyle(fontFamily: 'Font1', color: Colors.white),
          ),
        ),
        body: Center(
          child: CircularProgressIndicator(color: Colors.orange),
        ),
      );
    }

    double userLat = _currentPosition!.latitude;
    double userLon = _currentPosition!.longitude;
    double latRange = 5 / 111; // Rough latitude range (~5 km)
    double lonRange = 5 / (111 * cos(userLat * pi / 180));

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Chat with Attendants",
          style: TextStyle(fontFamily: 'Font1', fontSize: 20),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Attendant")
            .where("latitude", isGreaterThanOrEqualTo: userLat - latRange)
            .where("latitude", isLessThanOrEqualTo: userLat + latRange)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: Colors.orange),
            );
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No attendants found"));
          }

          var attendants = snapshot.data!.docs.where((doc) {
            var user = doc.data() as Map<String, dynamic>;
            if (user.containsKey('latitude') && user.containsKey('longitude')) {
              double lat = user['latitude'];
              double lon = user['longitude'];
              return _calculateDistance(userLat, userLon, lat, lon) <= 5.0;
            }
            return false;
          }).toList();

          return attendants.isEmpty
              ? Center(child: Text("No nearby attendants found"))
              : ListView.builder(
                  itemCount: attendants.length,
                  itemBuilder: (context, index) {
                    var attendant =
                        attendants[index].data() as Map<String, dynamic>;

                    String attendantId = attendants[index].id;
                    String attendantName = attendant["name"] ?? "No Name";
                    String chatId = _generateChatId(_userId!, attendantId);

                    return ListTile(
                      title: Text(
                        attendantName,
                        style: TextStyle(
                          fontFamily: "Font1",
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                      subtitle: Text(
                        attendant["degree"] ?? "No Degree",
                        style: TextStyle(
                          fontFamily: 'Font1',
                          fontSize: 11,
                          color: Colors.white,
                        ),
                      ),
                      trailing: Icon(Icons.chat),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>  ChatBox(
                              senderId: _userId!,
                              receiverId: attendantId,
                              receiverName: attendantName,
                              chatId: chatId,
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
        },
      ),
    );
  }

  /// Generate a unique and consistent Chat ID
  String _generateChatId(String userId, String attendantId) {
    List<String> ids = [userId, attendantId];
    ids.sort();
    return ids.join("_");
  }
}
