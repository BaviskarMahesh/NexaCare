import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nexacare/Routes/app_routes.dart';
import 'package:nexacare/user/homepage_user.dart';
import 'package:nexacare/utils/elevatedbutton.dart';
import 'package:nexacare/utils/textfield.dart';

class SigninUser extends StatefulWidget {
  const SigninUser({super.key});

  @override
  State<SigninUser> createState() => _SigninUserState();
}

class _SigninUserState extends State<SigninUser> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  signIn() async {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email.text,
      password: password.text,
    );
    // ignore: use_build_context_synchronously
    Navigator.pushNamed(context, Approutes.wrapper);
  }

  bool passWordVisible = false; // Define the boolean variable

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xff0C0C0C),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  "NexaCare",
                  style: TextStyle(
                    fontFamily: 'Font1',
                    color: Color(0xffFFFFFF),
                    fontSize: 30,
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.13),
              const Text(
                "Email Address",
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Font1',
                  fontSize: 15,
                ),
              ),
              SizedBox(height: screenHeight * 0.01),
              TextField(
                controller: email,
                keyboardType: TextInputType.emailAddress,
                decoration: TextfieldUtil.inputDecoration(
                  hintText: "Enter your Email address",
                  prefixIcon: Icons.email_outlined,
                  prefixIconColor: const Color(0xff969292),
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              const Text(
                "Password",
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Font1',
                  fontSize: 15,
                ),
              ),
              SizedBox(height: screenHeight * 0.01),
              TextField(
                controller: password,
                keyboardType: TextInputType.text,
                obscureText: passWordVisible,
                decoration: TextfieldUtil.inputDecoration(
                  hintText: "Enter your Password",

                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        passWordVisible = !passWordVisible;
                      });
                    },
                    icon: Icon(
                      passWordVisible
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: Color(0xff969292),
                    ),
                  ),
                  prefixIconColor: const Color(0xff969292),
                ),
              ),

              SizedBox(height: screenHeight * 0.02),
              customElevatedButton(
                buttonSize: Size(310, 55),
                buttonColor: Color(0xffFFA500),
                text: "Sign In",
                textStyle: TextStyle(
                  color: Color(0xff000000),
                  fontFamily: 'Font1',
                  fontSize: 15,
                ),
                onPressed: (() => signIn()),
              ),
              SizedBox(height: screenHeight * 0.05),
              Padding(
                padding: const EdgeInsets.only(left: 40.0),
                child: Row(
                  children: [
                    Text(
                      "Don't have an account?",
                      style: TextStyle(
                        fontFamily: 'Font1',
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 3),
                    InkWell(
                      child: Text(
                        "Sign up",
                        style: TextStyle(
                          fontFamily: 'Font1',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xffFFA500),
                        ),
                      ),
                      onTap: () {
                        Navigator.pushNamed(context, Approutes.signupUser);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
