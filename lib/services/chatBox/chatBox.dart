import 'package:flutter/material.dart';

class Chatbox extends StatefulWidget {
  const Chatbox({super.key});

  @override
  State<Chatbox> createState() => _ChatboxState();
}

class _ChatboxState extends State<Chatbox> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff0C0C0C),
      body: Center(child: Text("ChatBox")),
    );
  }
}
