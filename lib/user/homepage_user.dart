import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
        title: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('User').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Text(
                'Loading data..Please Wait..',
                style: TextStyle(
                  fontFamily: 'Font1',
                  fontSize: 10,
                  color: Color(0xffffffff),
                ),
              );
            }
            return Column(
              children: <Widget>[
                Text(
                  "Hi " + snapshot.data?.docs[0]['name'],
                  style: TextStyle(
                    fontFamily: 'Font1',
                    fontSize: 15,
                    color: Color(0xffffffff),
                  ),
                ),
                Text(
                  snapshot.data?.docs[0]['locationDetail'],
                  style: TextStyle(
                    fontFamily: 'Font1',
                    fontSize: 12,
                    color: Color(0xffffffff),
                  ),
                ),
              ],
            );
          },
        ),
        backgroundColor: Color(0xff0C0C0C),
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
