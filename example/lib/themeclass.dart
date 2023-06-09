import 'package:flutter/material.dart';

class ThemeClass {
  static ThemeData lightTheme = ThemeData(
      scaffoldBackgroundColor: Colors.white,
      colorScheme: const ColorScheme.light(),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.blue,
      ));

  static ThemeData darkTheme = ThemeData(
      scaffoldBackgroundColor: Colors.grey,
      colorScheme: const ColorScheme.dark(),
      textTheme: TextTheme(
        bodyLarge: TextStyle(color: Colors.grey)
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.grey,
      ));
}
