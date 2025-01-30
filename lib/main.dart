import 'package:flutter/material.dart';
import 'package:nexacare/Routes/app_routes.dart';
import 'package:nexacare/screens/landingpage.dart';

class NexaCare extends StatefulWidget {
  const NexaCare({super.key});

  @override
  State<NexaCare> createState() => _NexaCareState();
}

void main() {
  runApp(const NexaCare());
}

class _NexaCareState extends State<NexaCare> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NexaCare',
      theme: ThemeData(
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Color(0xff969292),
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xff0C0C0C)),
      ),
      darkTheme: ThemeData(brightness: Brightness.dark),
      debugShowCheckedModeBanner: false,
      initialRoute: Approutes.landingPage, // Set the initial route
      onGenerateRoute: Approutes.generateRoute,
    );
  }
}
