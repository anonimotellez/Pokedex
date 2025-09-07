import 'package:flutter/material.dart';

class AppTheme {
  // theme light
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorSchemeSeed: Color.fromARGB(255, 194, 74, 65),
    brightness: Brightness.light,
    appBarTheme: const AppBarTheme(
      backgroundColor: Color.fromARGB(255, 194, 74, 65),
      foregroundColor: Colors.white,
    ),
  );

  // Ttheme dark
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorSchemeSeed: Colors.blue,
    brightness: Brightness.dark,
    appBarTheme: const AppBarTheme(
      backgroundColor: Color.fromARGB(255, 64, 82, 185),
      foregroundColor: Colors.white,
    ),
  );
}
