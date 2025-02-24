import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String name;
  String dateOfBirth;
  String bloodGroup;
  String gender;
  double height;
  double weight;

  UserModel({
    required this.name,
    required this.dateOfBirth,
    required this.bloodGroup,
    required this.gender,
    required this.height,
    required this.weight,
  });

  //json format
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'dateOfBirth': dateOfBirth,
      'bloodGroup': bloodGroup,
      'gender': gender,
      'height': height,
      'weight': weight,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ?? ' ',
      dateOfBirth: map['dateOfBirth'] ?? ' ',
      bloodGroup: map['bloodGroup'] ?? ' ',
      gender: map['gender'] ?? ' ' ,
      height:(map['height']??0.0).toDouble(),
      weight:(map['weight']??0.0).toDouble(),

    );
  }
}
