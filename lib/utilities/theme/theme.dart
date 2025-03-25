
import 'package:flutter/material.dart';
import 'package:jcdriver/utilities/constants/colors.dart';
import 'package:jcdriver/utilities/theme/badge_theme.dart';
import 'package:jcdriver/utilities/theme/bottom_navigation_theme.dart';
import 'package:jcdriver/utilities/theme/button_theme.dart';
import 'package:jcdriver/utilities/theme/card_theme.dart';
import 'package:jcdriver/utilities/theme/header_theme.dart';
import 'package:jcdriver/utilities/theme/text_theme.dart';

class IKAppTheme {
  IKAppTheme._();

  static ThemeData lightTheme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: IKColors.primary,
      scaffoldBackgroundColor: IKColors.card,
      textTheme: IKTextTheme.lightTheme,
      elevatedButtonTheme: IKButtonTheme.lightButtonTheme,
      appBarTheme: IKHeaderTheme.lightHeaderTheme,
      cardTheme: IKCardTheme.lightCardTheme,
      dividerColor: IKColors.border,
      cardColor: IKColors.card,
      bottomNavigationBarTheme:
          IKBottomNavigationTheme.lightBottomNavigationTheme,
      badgeTheme: IKBadgeTheme.lightBadgeTheme,
      canvasColor: IKColors.light);

  static ThemeData darkTheme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: IKColors.primary,
      scaffoldBackgroundColor: IKColors.darkCard,
      textTheme: IKTextTheme.darkTheme,
      elevatedButtonTheme: IKButtonTheme.lightButtonTheme,
      appBarTheme: IKHeaderTheme.darkHeaderTheme,
      cardTheme: IKCardTheme.darkCardTheme,
      dividerColor: IKColors.darkBorder,
      cardColor: IKColors.darkCard,
      bottomNavigationBarTheme:
          IKBottomNavigationTheme.darkBottomNavigationTheme,
      badgeTheme: IKBadgeTheme.darkBadgeTheme,
      canvasColor: IKColors.dark);
}
