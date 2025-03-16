import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nexacare/attendant/attendant_details.dart';
import 'package:nexacare/user/attendantService/Attedant%20profile/AttendantProfile.dart';

class NearAttendant extends StatefulWidget {
  @override
  _NearAttendantState createState() => _NearAttendantState();
}

class _NearAttendantState extends State<NearAttendant> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Nearby Attendants",
          style: TextStyle(fontFamily: 'Font1', fontSize: 20),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("Attendant").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No attendants found"));
          }

          var users = snapshot.data!.docs;

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              var user = users[index].data() as Map<String, dynamic>;

              return ListTile(
                title: Text(
                  user["name"] ?? "No Name",
                  style: TextStyle(
                    fontFamily: 'Font1',
                    fontSize: 15,
                    color: Color(0xffffffff),
                  ),
                ),
                subtitle: Text(
                  user["degree"] ?? "No Degree",
                  style: TextStyle(
                    fontFamily: 'Font1',
                    fontSize: 11,
                    color: Color(0xffffffff),
                  ),
                ),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) =>
                              Attendantprofile(userId: users[index].id),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
