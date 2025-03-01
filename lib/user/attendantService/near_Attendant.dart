import 'package:flutter/material.dart';

class NearAttendant extends StatefulWidget {
  const NearAttendant({super.key});

  @override
  State<NearAttendant> createState() => _NearAttendantState();
}

class _NearAttendantState extends State<NearAttendant> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff0C0C0C),
      body: Container(
        child: Text("Near Attendant"),
      ),
    );
  }
}