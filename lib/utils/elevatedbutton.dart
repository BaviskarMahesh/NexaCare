import 'package:flutter/material.dart';

ElevatedButton customElevatedButton({
  required String text,
  required VoidCallback onPressed,
  Color? buttonColor,
  TextStyle? textStyle,
  Size? buttonSize,
  Color? splashColor, 
}) {
  return ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      backgroundColor: buttonColor ?? const Color(0xff312F2F),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      minimumSize: buttonSize,
      elevation: 4, // Adds shadow effect
      shadowColor: const Color.fromARGB(255, 148, 141, 141).withOpacity(0.3),
      splashFactory: InkRipple.splashFactory, // Ensures a smooth ripple effect
    ),
    child: Text(
      text,
      style: textStyle ?? const TextStyle(fontSize: 16, color: Colors.white),
    ),
  );
}
