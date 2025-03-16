import 'package:flutter/material.dart';

class Chatboxattendant extends StatefulWidget {
  const Chatboxattendant({super.key});

  @override
  State<Chatboxattendant> createState() => _ChatboxattendantState();
}

class _ChatboxattendantState extends State<Chatboxattendant> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff0c0c0c),
      body: Container(
        child: Center(
          child: Text("Chat Box Attendant"),
        ),
      ),
    );
  }
}