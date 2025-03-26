import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nexacare/attendant/Emergency_request/emergencyrequest.dart';
import 'package:nexacare/attendant/chatBox_Attendant/chatListAtt.dart';
import 'package:nexacare/attendant/location/liveLocationAttendant.dart';
import 'package:nexacare/attendant/profile/attedant_profile.dart';
import 'package:nexacare/attendant/attendant_util/navbarAtt.dart';

class HomepageAttendant extends StatefulWidget {
  const HomepageAttendant({super.key});

  @override
  State<HomepageAttendant> createState() => _HomepageAttendantState();
}

class _HomepageAttendantState extends State<HomepageAttendant> {
  User? attendant;
  int _selectedIndex = 0;
  String _attendantName = "Attendant";
  String _attendantLocation = "No Location Info";
  List<Widget> _screens = [];  

  

  @override
  void initState() {
    super.initState();
    attendant = FirebaseAuth.instance.currentUser;

    if (attendant != null) {
      _fetchUserData();
      _initializeScreens(); // Initialize screens after fetching attendant data
    }

    FirebaseAuth.instance.authStateChanges().listen((User? newAttendant) {
      if (mounted) {
        setState(() {
          attendant = newAttendant;
        });
        if (newAttendant != null) {
          _fetchUserData();
          _initializeScreens(); // Reinitialize screens when user state changes
        }
      }
    });
  }
   
  /// Initializes the screens with a valid `attendantId`
  void _initializeScreens() {
    setState(() {
      _screens = [
        Emergencyrequest(),
        Livelocationattendant(),
        Chatlistatt(
          attendantId: attendant?.uid ?? "",
        ), // Ensure `attendantId` is valid
        AttedantProfile(),
      ];
    });
  }

  /// Fetches the logged-in attendant's details from Firestore
  void _fetchUserData() {
    if (attendant != null) {
      FirebaseFirestore.instance
          .collection('Attendant')
          .doc(attendant!.uid)
          .snapshots()
          .listen((DocumentSnapshot snapshot) {
            if (snapshot.exists) {
              if (mounted) {
                setState(() {
                  _attendantName = snapshot['name'] ?? 'Attendant';
                  _attendantLocation =
                      snapshot['locationDetail'] ?? 'No Location Info';
                });
              }
            }
          });
    }
  }

  /// Handles bottom navigation bar selection
  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0c0c0c),
      appBar:
          _selectedIndex == 0
              ? AppBar(
                backgroundColor: const Color(0xff0c0c0c),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Hi, $_attendantName",
                      style: const TextStyle(
                        fontFamily: 'Font1',
                        fontSize: 15,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      _attendantLocation,
                      style: const TextStyle(
                        fontFamily: 'Font1',
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              )
              : null,
      body:
          _screens.isNotEmpty
              ? _screens[_selectedIndex]
              : Center(
                child: CircularProgressIndicator(
                  color: Color(0xffFFA500),
                ),
              ), // Show loader if screens are not initialized
      bottomNavigationBar: NavbarAtt(
        selectedIndex: _selectedIndex,
        onItemSelected: _onTabSelected,
      ),
    );
  }
}
