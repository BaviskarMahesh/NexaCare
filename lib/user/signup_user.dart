import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nexacare/Routes/app_routes.dart';
import 'package:nexacare/utils/elevatedbutton.dart';
import 'package:nexacare/utils/textfield.dart';

class SignupUser extends StatefulWidget {
  const SignupUser({super.key});

  @override
  State<SignupUser> createState() => _SignupUserState();
}

class _SignupUserState extends State<SignupUser> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  signUp() async {
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
      appBar: AppBar(
        backgroundColor: Color(0xff0C0C0C),
        title: Text(
          "NexaCare",
          style: TextStyle(
            fontFamily: 'Font1',
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),

      backgroundColor: const Color(0xff0C0C0C),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Padding(
            padding: const EdgeInsets.only(top: 50.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    "Sign Up",
                    style: TextStyle(
                      fontFamily: 'Font1',
                      color: Color(0xffFFFFFF),
                      fontSize: 25,
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.07),
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
                  text: "Sign Up",
                  textStyle: TextStyle(
                    color: Color(0xff000000),
                    fontFamily: 'Font1',
                    fontSize: 15,
                  ),
                  onPressed: (() => signUp()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
