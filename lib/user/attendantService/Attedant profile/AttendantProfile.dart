import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Attendantprofile extends StatefulWidget {
  final String userId;
  const Attendantprofile({Key? key, required this.userId}) : super(key: key);

  @override
  _ViewAttendantState createState() => _ViewAttendantState();
}

class _ViewAttendantState extends State<Attendantprofile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Attendant Profile",
          style: TextStyle(fontFamily: 'Font1', fontSize: 20),
        ),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future:
            FirebaseFirestore.instance
                .collection("Attendant")
                .doc(widget.userId)
                .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text("User not found"));
          }

          var user = snapshot.data!.data() as Map<String, dynamic>;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 236, 179, 74),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.3)),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Name: ${user["name"]}",
                        style: const TextStyle(
                          fontFamily: 'Font1',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff0C0C0C),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Divider(),
                      Text(
                        "Degree: ${user["degree"]}",
                        style: TextStyle(
                          fontFamily: 'Font1',
                          fontSize: 16,
                          color: Color(0xff0C0C0C),
                        ),
                      ),
                      Divider(),
                      Text(
                        "Gender: ${user["gender"]}",
                        style: TextStyle(
                          fontFamily: 'Font1',
                          fontSize: 16,
                          color: Color(0xff0C0C0C),
                        ),
                      ),
                      Divider(),
                      Text(
                        "Date of Birth: ${user["dateOfBirth"]}",
                        style: TextStyle(
                          fontFamily: 'Font1',
                          fontSize: 16,
                          color: Color(0xff0C0C0C),
                        ),
                      ),
                      Divider(),
                      Text(
                        "Mobile Number: ${user["mobile number"]}",
                        style: TextStyle(
                          fontFamily: 'Font1',
                          fontSize: 16,
                          color: Color(0xff0C0C0C),
                        ),
                      ),
                      Divider(),
                      Text(
                        "Home Address: ${user["home Address"]}",
                        style: TextStyle(
                          fontFamily: 'Font1',
                          fontSize: 16,
                          color: Color(0xff0C0C0C),
                        ),
                      ),
                      Divider(),
                      Text(
                        "Work Location: ${user["Work Location"]}",
                        style: TextStyle(
                          fontFamily: 'Font1',
                          fontSize: 16,
                          color: Color(0xff0C0C0C),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

Widget divider() {
  return Divider(color: Color(0xff0C0C0C), thickness: 1);
}
