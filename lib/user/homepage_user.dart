import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class HomepageUser extends StatefulWidget {
  const HomepageUser({super.key});

  @override
  State<HomepageUser> createState() => _HomepageUserState();
}

class _HomepageUserState extends State<HomepageUser> {
  final user = FirebaseAuth.instance.currentUser;    
  signout() async {
    await FirebaseAuth.instance.signOut();
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
      ),
      body: Center(child: Text('${user!.email}')),
      floatingActionButton: FloatingActionButton(
        onPressed: (() => signout()),
        child: Icon(Icons.login),
      ),
    );
  }
}
