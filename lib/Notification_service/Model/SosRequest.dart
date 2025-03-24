import 'package:cloud_firestore/cloud_firestore.dart';

class SosRequest {
  final String? sosId;
  final String userId;
  final String userName;
  final double latitude;
  final double longitude;
  final String? attendantId;
  final String? attendantName;
  final String status; // "pending", "accepted", "rejected"
  final Timestamp timestamp;

  SosRequest({
    this.sosId,
    required this.userId,
    required this.userName,
    required this.latitude,
    required this.longitude,
    this.attendantId,
    this.attendantName,
    required this.status,
    required this.timestamp,
  });

  // Convert Firestore DocumentSnapshot to Model
  factory SosRequest.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return SosRequest(
      sosId: doc.id,
      userId: data['userId'],
      userName: data['userName'],
      latitude: data['latitude'],
      longitude: data['longitude'],
      attendantId: data['attendantId'],
      attendantName: data['attendantName'],
      status: data['status'],
      timestamp: data['timestamp'],
    );
  }

  // Convert Model to JSON (For Firestore)
  Map<String, dynamic> toJson() {
    return {
      "userId": userId,
      "userName": userName,
      "latitude": latitude,
      "longitude": longitude,
      "attendantId": attendantId,
      "attendantName": attendantName,
      "status": status,
      "timestamp": timestamp,
    };
  }
}
