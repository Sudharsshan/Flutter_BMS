import 'package:flutter/material.dart';

class ThemeClass {
  Color lightPrimaryColor = const Color.fromARGB(255, 139, 52, 224);
  Color darkPrimaryColor = const Color.fromARGB(255, 21, 0, 66);
  Color secondaryColor = const Color.fromARGB(255, 214, 0, 255);
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