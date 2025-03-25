import 'package:flutter/material.dart';
import 'package:jcdriver/utilities/constants/colors.dart';

class IKTextTheme {
  IKTextTheme._();

  // light mode text theme
  static TextTheme lightTheme = TextTheme(
    //headings
    headlineLarge: const TextStyle().copyWith(
        fontSize: 20.0,
        fontFamily: "PlusJakartaSans",
        fontWeight: FontWeight.w600,
        color: IKColors.title),
    headlineMedium: const TextStyle().copyWith(
        fontSize: 18.0,
        fontFamily: "PlusJakartaSans",
        fontWeight: FontWeight.w600,
        color: IKColors.title),
    headlineSmall: const TextStyle().copyWith(
        fontSize: 16.0,
        fontFamily: "PlusJakartaSans",
        fontWeight: FontWeight.w600,
        color: IKColors.title),

    titleLarge: const TextStyle().copyWith(
        fontSize: 16.0,
        fontFamily: "PlusJakartaSans",
        fontWeight: FontWeight.w600,
        color: IKColors.title),
    titleMedium: const TextStyle().copyWith(
        fontSize: 14.0,
        fontFamily: "PlusJakartaSans",
        fontWeight: FontWeight.w600,
        color: IKColors.title),
    titleSmall: const TextStyle().copyWith(
        fontSize: 12.0,
        fontFamily: "PlusJakartaSans",
        fontWeight: FontWeight.w600,
        color: IKColors.title),

    //body text
    bodyLarge: const TextStyle().copyWith(
        fontSize: 16.0,
        fontFamily: "PlusJakartaSans",
        fontWeight: FontWeight.w400,
        color: const Color.fromARGB(255, 0, 0, 0)),
    bodyMedium: const TextStyle().copyWith(
        fontSize: 14.0,
        fontFamily: "PlusJakartaSans",
        fontWeight: FontWeight.w400,
        color: IKColors.text),
    bodySmall: const TextStyle().copyWith(
        fontSize: 12.0,
        fontFamily: "PlusJakartaSans",
        fontWeight: FontWeight.w400,
        color: IKColors.text),

    //label
    labelMedium: const TextStyle().copyWith(
        fontSize: 14.0,
        fontFamily: "PlusJakartaSans",
        fontWeight: FontWeight.w600,
        color: IKColors.text),
    labelSmall: const TextStyle().copyWith(
        fontSize: 12.0,
        fontFamily: "PlusJakartaSans",
        fontWeight: FontWeight.w600,
        color: IKColors.text),
  );

  // dark mode text theme
  static TextTheme darkTheme = TextTheme(
    //headings
    headlineLarge: const TextStyle().copyWith(
        fontSize: 20.0,
        fontFamily: "PlusJakartaSans",
        fontWeight: FontWeight.w600,
        color: Colors.white),
    headlineMedium: const TextStyle().copyWith(
        fontSize: 18.0,
        fontFamily: "PlusJakartaSans",
        fontWeight: FontWeight.w600,
        color: Colors.white),
    headlineSmall: const TextStyle().copyWith(
        fontSize: 16.0,
        fontFamily: "PlusJakartaSans",
        fontWeight: FontWeight.w600,
        color: Colors.white),

    titleLarge: const TextStyle().copyWith(
        fontSize: 16.0,
        fontFamily: "PlusJakartaSans",
        fontWeight: FontWeight.w600,
        color: Colors.white),
    titleMedium: const TextStyle().copyWith(
        fontSize: 14.0,
        fontFamily: "PlusJakartaSans",
        fontWeight: FontWeight.w600,
        color: Colors.white),
    titleSmall: const TextStyle().copyWith(
        fontSize: 12.0,
        fontFamily: "PlusJakartaSans",
        fontWeight: FontWeight.w600,
        color: Colors.white),

    //body text
    bodyLarge: const TextStyle().copyWith(
        fontSize: 16.0,
        fontFamily: "PlusJakartaSans",
        fontWeight: FontWeight.w400,
        color: Colors.white),
    bodyMedium: const TextStyle().copyWith(
        fontSize: 14.0,
        fontFamily: "PlusJakartaSans",
        fontWeight: FontWeight.w400,
        color: Colors.white),
    bodySmall: const TextStyle().copyWith(
        fontSize: 12.0,
        fontFamily: "PlusJakartaSans",
        fontWeight: FontWeight.w400,
        color: Colors.white),

    //label
    labelMedium: const TextStyle().copyWith(
        fontSize: 14.0,
        fontFamily: "PlusJakartaSans",
        fontWeight: FontWeight.w600,
        color: Colors.white),
    labelSmall: const TextStyle().copyWith(
        fontSize: 12.0,
        fontFamily: "PlusJakartaSans",
        fontWeight: FontWeight.w600,
        color: Colors.white),
  );
}
