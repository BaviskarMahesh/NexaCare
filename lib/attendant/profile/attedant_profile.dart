import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AttedantProfile extends StatefulWidget {
  const AttedantProfile({Key? key}) : super(key: key);

  @override
  _AttedantProfileState createState() => _AttedantProfileState();
}

class _AttedantProfileState extends State<AttedantProfile> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    User? user = _auth.currentUser;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Attendant Profile")),
        body: const Center(child: Text("No user logged in.")),
      );
    }

    return Scaffold(
      backgroundColor: Color(0xff0c0c0c),
      appBar: AppBar(
        backgroundColor: Color(0xff0c0c0c),
        title: const Text(
          "Attendant Profile",
          style: TextStyle(fontFamily: 'Font1', fontSize: 20),
        ),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: _firestore.collection("Attendant").doc(user.uid).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text("User profile not found."));
          }

          var userData = snapshot.data!.data() as Map<String, dynamic>;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Container(height: 100, width: 100),
                Card(
                  color: Color(0xff0c0c0c),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 236, 179, 74),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          profileField("Name", userData["name"]),
                          divider(),
                          profileField("Degree", userData["degree"]),
                          divider(),
                          profileField("Gender", userData["gender"]),
                          divider(),
                          profileField(
                            "Date of Birth",
                            userData["dateOfBirth"],
                          ),
                          divider(),
                          profileField(
                            "Mobile Number",
                            userData["mobile number"],
                          ),
                          divider(),
                          profileField(
                            "Home Address",
                            userData["home Address"],
                          ),
                          divider(),
                          profileField(
                            "Work Location",
                            userData["Work Location"],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Helper function to display a profile field
  Widget profileField(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        "$label: ${value ?? 'Not Available'}",
        style: const TextStyle(
          fontFamily: 'Font1',
          fontSize: 16,
          color: Color(0xff0C0C0C),
        ),
      ),
    );
  }

  /// Reusable Divider
  Widget divider() {
    return const Divider(color: Color(0xff0C0C0C), thickness: 1);
  }
}
