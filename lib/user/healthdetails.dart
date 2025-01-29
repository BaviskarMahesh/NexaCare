import 'package:flutter/material.dart';

class Healthdetails extends StatefulWidget {
  const Healthdetails({super.key});

  @override
  State<Healthdetails> createState() => _HealthdetailsState();
}

class _HealthdetailsState extends State<Healthdetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff0C0C0C),
      body: Center(
        child: Text("User",
        style: TextStyle(
          color: Color(0xffFFFFFF)
        ),),
      ),
    );
  }
}