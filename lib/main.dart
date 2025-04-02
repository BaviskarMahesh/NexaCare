import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:nexacare/Notification_service/fcm_service.dart';
import 'package:nexacare/Routes/app_routes.dart';
import 'package:nexacare/utils/wrapper.dart';
import 'package:nexacare/firebase_options.dart';

// Background message handler
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("📩 Received background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load .env file from correct path
  try {
    await dotenv.load(fileName: "lib/assets/.env");
    print("✅ .env file loaded successfully!");
  } catch (e) {
    print("❌ Error loading .env file: $e");
  }

  // Fetch environment variables
  String? googleMapsApiKey = dotenv.env['GOOGLE_MAPS_API_KEY'];
  if (googleMapsApiKey == null || googleMapsApiKey.isEmpty) {
    print("⚠️ Warning: GOOGLE_MAPS_API_KEY is missing in .env file.");
  }

  // Initialize Firebase
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    print("✅ Firebase initialized successfully!");
  } catch (e) {
    print("❌ Error initializing Firebase: $e");
  }

  runApp(const NexaCare());
}

class NexaCare extends StatelessWidget {
  const NexaCare({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NexaCare',
      theme: ThemeData.light().copyWith(
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Color(0xff969292),
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff0C0C0C)),
        dialogTheme: const DialogTheme(backgroundColor: Color(0xff0C0C0C)),
      ),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const Wrapper()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/logo 2.jpeg.jpg', height: 120),
            const SizedBox(height: 20),
            const CircularProgressIndicator(color: Colors.white),
          ],
        ),
      ),
    );
  }
}
