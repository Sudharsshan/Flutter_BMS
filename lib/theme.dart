import 'package:flutter/material.dart';

class ThemeClass {
  Color lightPrimaryColor = const Color.fromARGB(255, 221, 0, 84);
  Color darkPrimaryColor = const Color.fromARGB(255, 71, 0, 51);
  Color secondaryColor = const Color.fromARGB(255, 253, 138, 106);
  Color accentColor = const Color.fromARGB(255, 253, 208, 187);

  static ThemeData lightTheme = ThemeData(
    primaryColor: ThemeData.light().scaffoldBackgroundColor,
    colorScheme: const ColorScheme.light().copyWith(
        primary: _themeClass.lightPrimaryColor,
        secondary: _themeClass.secondaryColor),
  );

  static ThemeData darkTheme = ThemeData(
    primaryColor: ThemeData.dark().scaffoldBackgroundColor,
    colorScheme: const ColorScheme.dark().copyWith(
      primary: _themeClass.darkPrimaryColor,
    ),
  );
}

ThemeClass _themeClass = ThemeClass();