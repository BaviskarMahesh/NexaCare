import 'package:flutter/material.dart';

ElevatedButton customElevatedButton({
  required String text,
  required VoidCallback onPressed,
  Color? buttonColor,
  TextStyle? textStyle,
}) {
  return ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      backgroundColor: buttonColor ?? Color(0xff312F2F),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
    ),
    child: Text(text, style: textStyle),
  );
}
