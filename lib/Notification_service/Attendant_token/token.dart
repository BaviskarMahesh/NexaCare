import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> saveFCMToken() async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // Get FCM token
    String? token = await messaging.getToken();
    if (token != null) {
      // Save token in Firestore under the attendant's document
      await FirebaseFirestore.instance.collection('Attendant').doc(user.uid).update({
        'fcmtoken': token,
      });

      print("FCM Token saved successfully: $token");
    }
  }
}

void setupFCMTokenListener() {
  FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('Attendant').doc(user.uid).update({
        'fcmtoken': newToken,
      });
      print("FCM Token updated: $newToken");
    }
  });
}

