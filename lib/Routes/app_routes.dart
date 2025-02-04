import 'package:flutter/material.dart';
import 'package:nexacare/attendant/signin_attendant.dart';
import 'package:nexacare/email/forgotpswd.dart';
import 'package:nexacare/screens/landingpage.dart';
import 'package:nexacare/user/homepage_user.dart';
import 'package:nexacare/user/signin_User.dart';
import 'package:nexacare/utils/wrapper.dart';

class Approutes {
  static const String landingPage = '/';
  static const String signInuser = '/signInuser';
  static const String signInattendant = '/signInattendant';
  static const String forgotPswd = '/forgotPswd';
  static const String wrapper = '/wrapper';
  static const String homepageUser = '/homepageUser';

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

      default:
        return MaterialPageRoute(
          builder:
              (_) =>
                  const Scaffold(body: Center(child: Text('Page not found!'))),
        );
    }
  }
}
