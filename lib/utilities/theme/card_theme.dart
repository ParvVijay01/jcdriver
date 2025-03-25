import 'package:flutter/material.dart';
import 'package:jcdriver/utilities/constants/colors.dart';

class IKCardTheme {
  IKCardTheme._();

  // light mode button theme
  static const lightCardTheme = CardTheme(
    color: IKColors.card,
  );

  // dark mode button theme
  static const darkCardTheme = CardTheme(
    color: IKColors.darkCard,
  );
}
