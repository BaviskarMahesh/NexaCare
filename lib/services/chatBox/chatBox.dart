import 'dart:async';
import 'package:flutter/material.dart';

class ChatBox extends StatelessWidget {
  const ChatBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("SOS Emergency"),
        backgroundColor: Colors.red,
      ),
      body: Center(child: SOSButton(onSOSActivated: sendSOSAlert)),
    );
  }

  void sendSOSAlert() {
    print("🚨 SOS Triggered! Sending emergency alert...");
    // Implement SOS function (e.g., send notification, call API)
  }
}

class SOSButton extends StatefulWidget {
  final VoidCallback onSOSActivated;

  const SOSButton({super.key, required this.onSOSActivated});

  @override
  _SOSButtonState createState() => _SOSButtonState();
}

class _SOSButtonState extends State<SOSButton> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _borderAnimation;
  int countdown = 5;
  bool isPressed = false;
  Timer? countdownTimer;
  Color buttonColor = Color(0xffFFA500);

  @override
  void initState() {
    super.initState();

    // Initialize animation controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    // Border animation using Tween
    _borderAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
  }

  void startCountdown() {
    setState(() {
      isPressed = true;
    });

    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdown > 1) {
        setState(() {
          countdown--;
          buttonColor = countdown % 2 == 0 ? Color(0xffFFA500) : Colors.red;
        });
      } else {
        timer.cancel();
        widget.onSOSActivated();
        resetButton();
      }
    });
  }

  void resetButton() {
    setState(() {
      countdown = 5;
      isPressed = false;
      buttonColor = Colors.red;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: startCountdown,
      onLongPressEnd: (details) {
        countdownTimer?.cancel();
        resetButton();
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Animated Circular Border
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Container(
                width: 170 + (_borderAnimation.value * 20),
                height: 170 + (_borderAnimation.value * 20),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.red.withOpacity(0.5),
                    width: 5 + (_borderAnimation.value * 5),
                  ),
                ),
              );
            },
          ),
          // Ripple Effect
          for (double i = 0; i < 2; i++)
            AnimatedContainer(
              duration: const Duration(seconds: 1),
              width: isPressed ? 170 + (i * 20) : 150,
              height: isPressed ? 170 + (i * 20) : 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.red.withOpacity(0.1),
              ),
            ),
          // Main SOS Button
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: isPressed ? 120 : 150,
            height: isPressed ? 120 : 150,
            decoration: BoxDecoration(
              color: buttonColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Color(0xffFFA500),
                  blurRadius: 20,
                  spreadRadius: 10,
                ),
              ],
            ),
            child: Center(
              child: Text(
                isPressed ? "$countdown" : "SOS",
                style: const TextStyle(
                  fontFamily: 'Font1',
                  fontSize: 30,
                  // fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
