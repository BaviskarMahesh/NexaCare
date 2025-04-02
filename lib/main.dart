import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:nexacare/Notification_service/fcm_service.dart';
import 'package:nexacare/Routes/app_routes.dart';
import 'package:nexacare/splashScreen/splashscreen.dart';
import 'package:nexacare/utils/wrapper.dart';
import 'package:nexacare/firebase_options.dart';
   

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Received background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  String? firebaseCredPath = dotenv.env['FIREBASE_CRED_PATH'];
  String? googleMapsApiKey = dotenv.env['GOOGLE_MAPS_API_KEY'];

  if (firebaseCredPath == null || firebaseCredPath.isEmpty) {
    throw Exception(" FIREBASE_CRED_PATH is missing in .env file.");
  }

  if (googleMapsApiKey == null || googleMapsApiKey.isEmpty) {
    throw Exception(" GOOGLE_MAPS_API_KEY is missing in .env file.");
  }

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  FlutterError.onError = (FlutterErrorDetails details) {
    print("Flutter Error: ${details.exceptionAsString()}");
  };

  runApp(const NexaCare());
}

class NexaCare extends StatefulWidget {
  const NexaCare({super.key});

  @override
  State<NexaCare> createState() => _NexaCareState();
}

class _NexaCareState extends State<NexaCare> {
  bool _initialized = false;
  bool _error = false;

  @override
  void initState() {
    super.initState();
    initializeFirebase();
  }

  Future<void> initializeFirebase() async {
    try {
      await Firebase.initializeApp();
      setState(() => _initialized = true);
    } catch (e) {
      setState(() => _error = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_error) {
      return MaterialApp(
        home: Scaffold(body: Center(child: Text("Failed to initialize Firebase"))),
      );
    }

    if (!_initialized) {
      return MaterialApp(
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }

    return MaterialApp(
      title: 'NexaCare',
      theme: ThemeData(
        brightness: Brightness.light,
        textSelectionTheme: TextSelectionThemeData(cursorColor: Color(0xff969292)),
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xff0C0C0C)),
        dialogTheme: DialogTheme(backgroundColor: Color(0xff0C0C0C)),
      ),
      darkTheme: ThemeData(brightness: Brightness.dark),
      themeMode: ThemeMode.system,
      home: Splashscreen(),  
      debugShowCheckedModeBanner: false,
      initialRoute: Approutes.landingPage,
      onGenerateRoute: Approutes.generateRoute,
    );
  }
}
