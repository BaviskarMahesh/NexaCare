import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomepageUser extends StatefulWidget {
  const HomepageUser({super.key});

  @override
  State<HomepageUser> createState() => _HomepageUserState();
}

class _HomepageUserState extends State<HomepageUser> {
  User? user;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff0C0C0C),
      appBar: AppBar(
        title: Text(
          "NexaCare",
          style: TextStyle(
            fontFamily: "Font1",
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Text(
          user != null
              ? 'Signed in as: ${user!.email}'
              : 'No user is signed in.',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await FirebaseAuth.instance.signOut();
          setState(() {}); // Update UI after sign out
        },
        backgroundColor: Colors.red,
        child: Icon(Icons.logout),
      ),
    );
  }
}
