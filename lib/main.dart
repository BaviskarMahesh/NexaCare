import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:nexacare/Notification_service/fcm_service.dart';
import 'package:nexacare/Routes/app_routes.dart';
import 'package:nexacare/screens/landingpage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:nexacare/utils/wrapper.dart';
import 'package:nexacare/firebase_options.dart';

class NexaCare extends StatefulWidget {
  const NexaCare({super.key});

  @override
  State<NexaCare> createState() => _NexaCareState();

  
}
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Received background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await dotenv.load(fileName: ".env");
  //await FcmService().sendSOSNotification();
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
        dialogTheme: DialogThemeData(backgroundColor: Color(0xff0C0C0C)),
      ),
      home: Wrapper(),
      darkTheme: ThemeData(brightness: Brightness.dark),
      debugShowCheckedModeBanner: false,
      initialRoute: Approutes.landingPage, // Set the initial route
      onGenerateRoute: Approutes.generateRoute,
    );
  }
}
