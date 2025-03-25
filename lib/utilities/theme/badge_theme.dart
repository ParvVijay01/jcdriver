import 'package:flutter/material.dart';
import 'package:jcdriver/utilities/constants/colors.dart';

class IKBadgeTheme {
  IKBadgeTheme._();

  // light mode button theme
  static const lightBadgeTheme = BadgeThemeData(
    backgroundColor: IKColors.primary,
    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
  );

  // dark mode button theme
  static const darkBadgeTheme = BadgeThemeData(
    backgroundColor: IKColors.primary,
    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
  );
}
