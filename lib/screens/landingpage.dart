import 'package:flutter/material.dart';
import 'package:nexacare/attendant/signin_attendant.dart';
import 'package:nexacare/Routes/app_routes.dart';
import 'package:nexacare/main.dart';
import 'package:nexacare/user/signin_User.dart';
import 'package:nexacare/utils/elevatedbutton.dart';

class Landingpage extends StatefulWidget {
  const Landingpage({super.key});

  @override
  State<Landingpage> createState() => _LandingpageState();
}

class _LandingpageState extends State<Landingpage> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color(0xff0C0C0C),
      body: Padding(
        padding: const EdgeInsets.only(left: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: screenHeight * 0.6),
            Text(
              "NexaCare",
              style: TextStyle(
                fontFamily: 'Font1',
                color: Color(0xffFFFFFF),
                //fontWeight: FontWeight.bold,
                fontSize: 40,
              ),
            ),
            //  SizedBox(height: 1),
            Text(
              "Stay Safe, Stay Connected!",
              style: TextStyle(
                fontFamily: 'Font1',
                color: Color(0xffFFFFFF),
                fontSize: 15,
              ),
            ),
            SizedBox(height: 20),
            customElevatedButton(
              text: "User",
              textStyle: TextStyle(
                color: Color(0xffFFFFFF),
                fontSize: 20,
                fontFamily: 'Font1',
              ),
              onPressed: () {
                Navigator.pushNamed(context, Approutes.signInuser,
                arguments:'user',
                );
              },
              buttonSize: const Size(300, 55),
            ),
            SizedBox(height: 20),

            customElevatedButton(
              text: "Attendant",
              textStyle: TextStyle(
                color: Color(0xffFFFFFF),
                fontSize: 20,
                fontFamily: 'Font1',
              ),
              onPressed: () {
                Navigator.pushNamed(context, Approutes.signInattendant);
              },
              buttonSize: const Size(300, 55),
            ),
          ],
        ),
      ),
    );
  }
}
