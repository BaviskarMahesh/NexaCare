import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nexacare/services/chatBox/chatBox.dart';
import 'package:nexacare/user/attendantService/near_Attendant.dart';
import 'package:nexacare/user/location/livelocation_page.dart';
import 'package:nexacare/user/profile/user_profile.dart';
import 'package:nexacare/utils/navbar.dart';

class HomepageUser extends StatefulWidget {
  const HomepageUser({super.key});

  @override
  State<HomepageUser> createState() => _HomepageUserState();
}

class _HomepageUserState extends State<HomepageUser> {
  User? user;
  int _selectedIndex = 0; // Default to home (SOS)
  Color _fabColor = const Color(0xffFFA500); // Default FAB color

  final List<Widget> _screens = [
    NearAttendant(),
    LivelocationPage(),
    Chatbox(),
    UserProfile(),
  ];

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    FirebaseAuth.instance.authStateChanges().listen((User? newUser) {
      if (mounted) {
        setState(() {
          user = newUser;
        });
      }
    });
  }

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onFabPressed() {
    setState(() {
      _fabColor = Colors.red; // Change FAB color on tap
      _selectedIndex = 0; // Navigate to the SOS screen
    });

    // Restore original color after 300ms
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          _fabColor = const Color(0xffFFA500);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0C0C0C),

      appBar: AppBar(
        title: StreamBuilder<DocumentSnapshot>(
          stream:
              FirebaseFirestore.instance
                  .collection('User')
                  .doc(user?.uid)
                  .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData ||
                snapshot.data == null ||
                !snapshot.data!.exists) {
              return const Text(
                'Loading data... Please wait...',
                style: TextStyle(
                  fontFamily: 'Font1',
                  fontSize: 12,
                  color: Colors.white,
                ),
              );
            }

            var userData = snapshot.data!;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Hi, ${userData['name'] ?? 'User'}",
                  style: const TextStyle(
                    fontFamily: 'Font1',
                    fontSize: 15,
                    color: Colors.white,
                  ),
                ),
                Text(
                  userData['locationDetail'] ?? 'No Location Info',
                  style: const TextStyle(
                    fontFamily: 'Font1',
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
              ],
            );
          },
        ),
        backgroundColor: const Color(0xff0C0C0C),
      ),

      body:
          _selectedIndex == 0
              ? Center(
                child: ElevatedButton(
                  onPressed: () {
                    print(
                      "🚨 SOS BUTTON PRESSED! Implement SOS function here.",
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xffFFA500),
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 40,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    "EMERGENCY SOS",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              )
              : IndexedStack(index: _selectedIndex - 1, children: _screens),

      floatingActionButton: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: _fabColor.withOpacity(0.9),
              spreadRadius: 10,
              blurRadius: 20,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: _onFabPressed,
          backgroundColor: _fabColor,
          splashColor: Colors.amber.shade600,
          elevation: 10,
          child: const Icon(Icons.sos, size: 40),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: CustomBottomNav(
        currentIndex: _selectedIndex,
        onTabSelected: _onTabSelected,
      ),
    );
  }
}
