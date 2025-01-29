import 'package:flutter/material.dart';

class TextfieldUtil {
  static InputDecoration inputDecoration({
    String? hintText,

    // IconData? prefixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      // prefixIcon: prefixIcon!=null ? Icon(prefixIcon,color: Color(value),)
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25),
       // borderSide: 
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25),
        borderSide: const BorderSide(color: Color(0xffFFFFFF))
      )
    );
  }
  // static TextStyle textStyle(){
  //   return const TextStyle(
  //     fontSize: 20,
  //     fontFamily: 'Font1',

  //   )
  // }
  }
