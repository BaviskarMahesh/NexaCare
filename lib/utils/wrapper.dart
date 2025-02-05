import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nexacare/email/verifyEmail.dart';
import 'package:nexacare/user/homepage_user.dart';
import 'package:nexacare/user/signin_User.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
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
            return snapshot.data!.emailVerified
                ? HomepageUser()
                : Verifyemail();
          } else {
            return SigninUser();
          }
        },
      ),
    );
  }
}
