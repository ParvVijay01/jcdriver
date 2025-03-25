import 'package:flutter/material.dart';
import 'package:jcdriver/utilities/constants/colors.dart';

class IKBottomNavigationTheme {
  IKBottomNavigationTheme._();

  // light mode button theme
  static const lightBottomNavigationTheme = BottomNavigationBarThemeData(
    backgroundColor: IKColors.card,
    showUnselectedLabels: true,
    elevation: 20,
    unselectedLabelStyle: TextStyle(
      fontFamily: 'Jost',
      fontSize: 13,
    ),
    unselectedItemColor: IKColors.title,
    selectedItemColor: IKColors.primary,
    unselectedIconTheme: IconThemeData(
      color: IKColors.title,
    ),
    selectedIconTheme: IconThemeData(
      color: IKColors.primary,
    ),
  );

  // dark mode button theme
  static const darkBottomNavigationTheme = BottomNavigationBarThemeData(
    backgroundColor: IKColors.card,
    showUnselectedLabels: true,
    elevation: 20,
    unselectedLabelStyle: TextStyle(
      fontFamily: 'Jost',
      fontSize: 13,
    ),
    unselectedItemColor: Colors.white,
    selectedItemColor: IKColors.primary,
    unselectedIconTheme: IconThemeData(
      color: Colors.white,
    ),
    selectedIconTheme: IconThemeData(
      color: IKColors.primary,
    ),
  );
}
