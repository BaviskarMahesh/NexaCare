import 'package:flutter/material.dart';

class SigninAttendant extends StatefulWidget {
  const SigninAttendant({super.key});

  @override
  State<SigninAttendant> createState() => _SigninAttendantState();
}

class _SigninAttendantState extends State<SigninAttendant> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Attendant"),
      ),
    );
  }
}