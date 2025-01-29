import 'package:flutter/material.dart';

class Professionaldetails extends StatefulWidget {
  const Professionaldetails({super.key});

  @override
  State<Professionaldetails> createState() => _ProfessionaldetailsState();
}

class _ProfessionaldetailsState extends State<Professionaldetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff0C0C0C),
      body: Center(
        child: Text("Attendant",
        style: TextStyle(color: Color(0xffFFFFFF)),),
      ),
    );
  }
}