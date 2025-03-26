import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FcmService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  Future<void> updateFCMToken() async {
    try {
      User? user = _auth.currentUser;
      if (user == null) {
        print("User not logged in!");
        return;
      }

      String? token = await _firebaseMessaging.getToken();
      if (token == null) {
        print("Failed to get FCM token!");
        return;
      }

      print("Updating FCM Token for: ${user.uid}, Token: $token");

      await _firestore.collection('Attendant').doc(user.uid).set({
        'fcmToken': token,
      }, SetOptions(merge: true));

      print("FCM Token Updated Successfully!");

      _firebaseMessaging.onTokenRefresh.listen((newToken) {
        _firestore.collection('Attendant').doc(user.uid).update({
          'fcmToken': newToken,
        });
      });
    } catch (e) {
      print("Error updating FCM token: $e");
    }
  }

  void requestNotificationPermission() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print(' User granted Permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
           print(' User granted provisional Permission');
        }else{
           print(' User denied Permission');
        }
  }

  Future<void> sendSOSNotification({
    required String sosId,
    required double latitude,
    required double longitude,
    required String userId,
  }) async {
    String serverKey = "YOUR_FCM_SERVER_KEY"; // Get from Firebase Console

    QuerySnapshot attendants = await _firestore.collection("Attendant").get();
    List<String> fcmTokens =
        attendants.docs
            .where((doc) => doc.data().toString().contains("fcmToken"))
            .map((doc) => doc["fcmToken"].toString())
            .toList();

    if (fcmTokens.isEmpty) {
      print("No attendants found with valid FCM tokens!");
      return;
    }

    for (String token in fcmTokens) {
      var notification = {
        "to": token,
        "priority": "high",
        "data": {
          "title": "🚨 Emergency Alert!",
          "body": "A patient needs urgent help! Tap to track location.",
          "sosId": sosId,
          "latitude": latitude.toString(),
          "longitude": longitude.toString(),
          "userId": userId,
        },
      };

      var response = await http.post(
        Uri.parse("https://fcm.googleapis.com/fcm/send"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "key=$serverKey",
        },
        body: jsonEncode(notification),
      );

      if (response.statusCode == 200) {
        print("🚀 SOS Notification sent successfully to $token");
      } else {
        print("❌ Failed to send SOS Notification: ${response.body}");
      }
    }
  }
}
