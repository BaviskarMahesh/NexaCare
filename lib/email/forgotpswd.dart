import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nexacare/utils/elevatedbutton.dart';
import 'package:nexacare/utils/textfield.dart';

class Forgotpswd extends StatefulWidget {
  const Forgotpswd({super.key});

  @override
  State<Forgotpswd> createState() => _ForgotpswdState();
}

class _ForgotpswdState extends State<Forgotpswd> {
  TextEditingController email = TextEditingController();

  reset() async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email.text);
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color(0xff0C0C0C),
      appBar: AppBar(
        title: Text(
          "Forgot Password",
          style: TextStyle(
            fontFamily: 'Font1',
            color: Colors.white,
            fontSize: 15,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            TextField(
              keyboardType: TextInputType.phone,
              decoration: TextfieldUtil.inputDecoration(
                hintText: "Enter your Email address",
                prefixIcon: Icons.email_outlined,
                prefixIconColor: const Color(0xff969292),
              ),
            ),

            SizedBox(height: screenHeight * 0.04),
            customElevatedButton(
              buttonSize: Size(310, 55),
              buttonColor: Color(0xffFFA500),
              text: "Send Link",
              textStyle: TextStyle(
                color: Color(0xff000000),
                fontFamily: 'Font1',
                fontSize: 15,
              ),
              onPressed: (() => reset()),
            ),
          ],
        ),
      ),
    );
  }
}
