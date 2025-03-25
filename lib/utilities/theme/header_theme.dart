
import 'package:flutter/material.dart';
import 'package:jcdriver/utilities/constants/colors.dart';
import 'package:jcdriver/utilities/constants/sizes.dart';

class IKHeaderTheme {
  IKHeaderTheme._();

  // light mode Header theme
  static const lightHeaderTheme = AppBarTheme(
    elevation: 0,
    centerTitle: false,
    scrolledUnderElevation: 0,
    toolbarHeight: IKSizes.headerHeight,
    backgroundColor: IKColors.background,
    surfaceTintColor: Colors.transparent,
    iconTheme: IconThemeData(color: IKColors.title, size: 24),
    actionsIconTheme: IconThemeData(color: IKColors.title, size: 24),
    titleTextStyle: TextStyle(
        fontSize: 20.0,
        fontFamily: 'Jost',
        fontWeight: FontWeight.w500,
        color: IKColors.title),
  );

  // dark mode Header theme
  static const darkHeaderTheme = AppBarTheme(
    elevation: 0,
    centerTitle: false,
    scrolledUnderElevation: 0,
    toolbarHeight: IKSizes.headerHeight,
    backgroundColor: IKColors.darkBackground,
    surfaceTintColor: Colors.transparent,
    iconTheme: IconThemeData(color: Colors.white, size: 24),
    actionsIconTheme: IconThemeData(color: Colors.white, size: 24),
    titleTextStyle: TextStyle(
        fontSize: 20.0,
        fontFamily: 'Jost',
        fontWeight: FontWeight.w500,
        color: Colors.white),
  );
}
