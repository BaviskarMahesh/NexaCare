import 'package:flutter/material.dart';
import 'package:nexacare/Chat_Service/Chat_Screens/chatBox.dart';
import 'package:nexacare/attendant/attendant_details.dart';
import 'package:nexacare/attendant/homepage_attendant.dart';
import 'package:nexacare/attendant/location/permissionlocationAttendant.dart';
import 'package:nexacare/attendant/signin_attendant.dart';
import 'package:nexacare/email/forgotpswd.dart';
import 'package:nexacare/screens/landingpage.dart';
import 'package:nexacare/services/chatBox/listOfattendantforchat.dart';
import 'package:nexacare/user/homepage_user.dart';
import 'package:nexacare/user/location/user_locationpermission.dart';
import 'package:nexacare/user/signin_User.dart';
import 'package:nexacare/user/signup_user.dart';
import 'package:nexacare/user/user_healthdetails.dart';
import 'package:nexacare/utils/wrapper.dart';
import 'package:nexacare/utils/wrapperattendant.dart';

class Approutes {
  static const String landingPage = '/';
  static const String signInuser = '/signInuser';
  static const String signInattendant = '/signInattendant';
  static const String forgotPswd = '/forgotPswd';
  static const String wrapper = '/wrapper';
  static const String homepageUser = '/homepageUser';
  static const String signupUser = '/signupUser';
  static const String userHealthDetails = '/userHealthDetails';
  static const String userlocationpermission = '/userlocationpermission';
  static const String attendantDetail = '/attendantDetail';
  static const String wrapperAttendant = '/wrapperAttendant';
  static const String homepageAttendant = '/homepageAttendant';
  static const String attendantlocationpermission =
      '/attendantlocationpermission';
  static const String ListOfAttendantforChat = '/ListOfAttendantforChat';
  static const String ChatBoxUser = '/ChatBoxUser';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case landingPage:
        return MaterialPageRoute(builder: (_) => const Landingpage());
      case signInuser:
        return MaterialPageRoute(builder: (_) => SigninUser());
      case signInattendant:
        return MaterialPageRoute(builder: (_) => SigninAttendant());
      case forgotPswd:
        return MaterialPageRoute(builder: (_) => Forgotpswd());
      case wrapper:
        return MaterialPageRoute(builder: (_) => Wrapper());
      case homepageUser:
        return MaterialPageRoute(builder: (_) => HomepageUser());
      case signupUser:
        return MaterialPageRoute(builder: (_) => SignupUser());
      case userHealthDetails:
        return MaterialPageRoute(builder: (_) => UserHealthdetails());
      case userlocationpermission:
        return MaterialPageRoute(builder: (_) => UserLocationPermission());
      case attendantDetail:
        return MaterialPageRoute(builder: (_) => AttendantDetails());
      case wrapperAttendant:
        return MaterialPageRoute(builder: (_) => WrapperAttendant());
      case homepageAttendant:
        return MaterialPageRoute(builder: (_) => HomepageAttendant());
      case attendantlocationpermission:
        return MaterialPageRoute(builder: (_) => Permissionlocationattendant());
      case ListOfAttendantforChat:
        return MaterialPageRoute(builder: (_) => Listofattendantforchat());
      case ChatBoxUser:
        if (settings.arguments is Map<String, dynamic>) {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (_) =>  ChatBox(
              senderId: args['senderId'],
              receiverId: args['receiverId'],
              receiverName: args['receiverName'],
              chatId: args['chatId'],
            ),
          );
        }
        return _errorRoute();

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) => const Scaffold(
        body: Center(child: Text('Page not found!')),
      ),
    );
  }
}
