import 'package:flutter/material.dart';

class Emergencyrequest extends StatefulWidget {
  const Emergencyrequest({super.key});

  @override
  State<Emergencyrequest> createState() => _EmergencyrequestState();
}

class _EmergencyrequestState extends State<Emergencyrequest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff0c0c0c),
      body: Container(
        child: Center(
          child: Text("Emergency Request"),
        ),
      ),
    );
  }
}