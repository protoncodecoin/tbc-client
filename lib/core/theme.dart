import 'package:client/core/constants.dart';
import 'package:flutter/material.dart';

class ThemeV2 {
  static ColorSelection lightColorSelected = ColorSelection.white;
  static ThemeData lightThemeMode = ThemeData(
    fontFamily: "Montserrat",
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,
    primaryColor: Colors.black,
    colorScheme: ColorScheme.light(
      primary: Colors.black,
      secondary: Colors.black,
      // background: Colors.white,
      surface: Colors.white,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      // onBackground: Colors.black,
      onSurface: Colors.black,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black),
      bodyMedium: TextStyle(color: Colors.black),
      headlineSmall: TextStyle(color: Colors.white),
    ),
  );

  static ColorSelection darkColorSelected = ColorSelection.black;
  static ThemeData darkThemeMode = ThemeData(
    fontFamily: "Montserrat",
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Colors.black,
    primaryColor: Colors.white,
    colorScheme: ColorScheme.dark(
      primary: Colors.white,
      secondary: Colors.white,
      // background: Colors.black,
      surface: Colors.black,
      onPrimary: Colors.black,
      onSecondary: Colors.black,
      // onBackground: Colors.white,
      onSurface: Colors.white,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white),
      headlineSmall: TextStyle(color: Colors.black),
    ),
  );
}
