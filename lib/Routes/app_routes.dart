import 'package:flutter/material.dart';
import 'package:nexacare/Attendant/professionalDetails.dart';
import 'package:nexacare/screens/landingpage.dart';
import 'package:nexacare/user/healthdetails.dart';

class Approutes {
  static const String landingPage = '/';
  static const String healthDetails = '/healthdetails';
  static const String professionalDetails = '/professionaldetails';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case landingPage:
        return MaterialPageRoute(builder: (_) => const Landingpage());
      case healthDetails:
        return MaterialPageRoute(builder: (_) => Healthdetails());
      case professionalDetails:
        return MaterialPageRoute(builder: (_) => Professionaldetails());

      default:
        return MaterialPageRoute(
          builder:
              (_) =>
                  const Scaffold(body: Center(child: Text('Page not found!'))),
        );
    }
  }
}
