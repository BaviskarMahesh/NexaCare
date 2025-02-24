import 'package:flutter/material.dart';

class UserLocationpermission extends StatefulWidget {
  const UserLocationpermission({super.key});

  @override
  State<UserLocationpermission> createState() => _UserLocationpermissionState();
}

class _UserLocationpermissionState extends State<UserLocationpermission> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff0C0C0C),
      body: Center(
        child: Text("Location", style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
