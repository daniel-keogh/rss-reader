import 'package:flutter/material.dart';

class Style {
  Style._();

  static ThemeData getThemeData() {
    return ThemeData(
      splashFactory: InkRipple.splashFactory,
    );
  }

  static ThemeData getDarkThemeData() {
    return ThemeData.dark();
  }
}
