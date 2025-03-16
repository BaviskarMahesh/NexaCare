import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nexacare/attendant/attendant_details.dart';
import 'package:nexacare/attendant/homepage_attendant.dart';
import 'package:nexacare/attendant/signin_attendant.dart';
import 'package:nexacare/email/verifyEmail.dart';
import 'package:nexacare/user/location/user_locationpermission.dart';

class WrapperAttendant extends StatefulWidget {
  @override
  _WrapperAttendantState createState() => _WrapperAttendantState();
}

class _WrapperAttendantState extends State<WrapperAttendant> {
  @override
  void initState() {
    super.initState();
    _checkUserState();
  }

  Future<void> _checkUserState() async {
    await Future.delayed(
      const Duration(milliseconds: 500),
    ); // Small delay to prevent flickering

    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      _navigateTo(SigninAttendant());
    } else if (!user.emailVerified) {
      _navigateTo(Verifyemail());
    } else {
      bool detailsFilled = await _isUserDetailsFilled();
      if (detailsFilled) {
        _navigateTo(const HomepageAttendant());
      } else {
        _navigateTo(const AttendantDetails());
      }
    }
  }

  /// Function to navigate to a new screen and clear previous stack
  void _navigateTo(Widget screen) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => screen),
        (route) => false, // Clears all previous routes
      );
    });
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> _isUserDetailsFilled() async {
    User? user = _auth.currentUser;
    if (user == null) return false;

    try {
      DocumentSnapshot snapshot =
          await _firestore.collection('Attendant').doc(user.uid).get();

      if (!snapshot.exists) return false;

      var data = snapshot.data() as Map<String, dynamic>;

      bool hasPersonalDetails =
          data.containsKey("name") &&
          data.containsKey("dateOfBirth") &&
          data.containsKey("mobileNumber") &&
          data.containsKey("gender") &&
          data.containsKey("homeAddress") &&
          data.containsKey("workLocation") &&
          data.containsKey("degree") &&
          data["name"] != "" &&
          data["dateOfBirth"] != "" &&
          data["mobileNumber"] != "" &&
          data["gender"] != "" &&
          data["homeAddress"] != "" &&
          data["workLocation"] != "" &&
          data["degree"] != "";

      return hasPersonalDetails;
    } catch (e) {
      print("❌ Error fetching user details: $e");
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator(color: Color(0xffFFA500))),
    );
  }
}
