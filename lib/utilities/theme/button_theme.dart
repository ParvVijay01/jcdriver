import 'package:flutter/material.dart';
import 'package:jcdriver/utilities/constants/colors.dart';

class IKButtonTheme {
  IKButtonTheme._();

  // light mode button theme
  static final lightButtonTheme = ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
    elevation: 0,
    foregroundColor: Colors.white,
    backgroundColor: IKColors.secondary,
    disabledBackgroundColor: Colors.grey,
    disabledForegroundColor: Colors.grey,
    // side: const BorderSide(color: IKColors.secondary),
    shadowColor: Colors.transparent,
    // padding: const EdgeInsets.symmetric(vertical: 12,horizontal: 25),
    padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 25),
    textStyle: const TextStyle(
        fontSize: 18,
        fontFamily: "Jost",
        color: Colors.white,
        fontWeight: FontWeight.w500),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
  ));

  // dark mode button theme
  static final darkButtonTheme = ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
    elevation: 0,
    foregroundColor: Colors.white,
    backgroundColor: IKColors.secondary,
    disabledBackgroundColor: Colors.grey,
    disabledForegroundColor: Colors.grey,
    // side: const BorderSide(color: IKColors.secondary),
    shadowColor: Colors.transparent,
    padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 25),
    textStyle: const TextStyle(
        fontSize: 18,
        fontFamily: "Jost",
        color: Colors.white,
        fontWeight: FontWeight.w500),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
  ));
}
