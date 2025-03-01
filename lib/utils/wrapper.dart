import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nexacare/email/verifyEmail.dart';
import 'package:nexacare/user/homepage_user.dart';
import 'package:nexacare/user/signin_User.dart';
import 'package:nexacare/user/user_healthdetails.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  Future<bool> isUserDetailsFilled(String uid) async {
    try {
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection("User").doc(uid).get();

      if (userDoc.exists) {
        Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;

        bool hasLocation =
            data.containsKey("latitude") &&
            data.containsKey("longitude") &&
            data["latitude"] != null &&
            data["longitude"] != null;

        bool hasHealthDetails =
            data.containsKey("bloodGroup") &&
            data.containsKey("height") &&
            data.containsKey("weight") &&
            data.containsKey("gender") &&
            data["bloodGroup"] != "" &&
            data["height"] != 0.0 &&
            data["weight"] != 0.0 &&
            data["gender"] != "";

        return hasLocation && hasHealthDetails;
      }
      return false;
    } catch (e) {
      print("❌ Error checking user details: $e");
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // Loading state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          // Error state
          if (snapshot.hasError) {
            return Center(child: Text("Something went wrong"));
          }

          // Check user authentication state
          if (snapshot.hasData) {
            User user = snapshot.data!;
            if (!user.emailVerified) {
              return Verifyemail();
            }

            // Check if the user has filled location & health details
            return FutureBuilder<bool>(
              future: isUserDetailsFilled(user.uid),
              builder: (context, AsyncSnapshot<bool> userDetailsSnapshot) {
                if (userDetailsSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (userDetailsSnapshot.hasError ||
                    !userDetailsSnapshot.hasData ||
                    !userDetailsSnapshot.data!) {
                  return UserHealthdetails();
                }

                return HomepageUser();
              },
            );
          } else {
            return SigninUser();
          }
        },
      ),
    );
  }
}
