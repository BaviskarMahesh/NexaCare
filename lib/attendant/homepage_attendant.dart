import 'package:flutter/material.dart';

class HomepageAttendant extends StatefulWidget {
  const HomepageAttendant({super.key});

  @override
  State<HomepageAttendant> createState() => _HomepageAttendantState();
}

class _HomepageAttendantState extends State<HomepageAttendant> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(child: Text("Home page")),
      ),
    );
  }
}