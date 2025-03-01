import 'package:flutter/material.dart';

class LivelocationPage extends StatefulWidget {
  const LivelocationPage({super.key});

  @override
  State<LivelocationPage> createState() => _LivelocationPageState();
}

class _LivelocationPageState extends State<LivelocationPage> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Color(0xff0C0C0C),
      body: Container(
        child: Center(child: Text("Live Location")),
      ),
    );
  }
}