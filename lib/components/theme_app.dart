import 'package:flutter/material.dart';

class ThemeApp {
  
  static ThemeData warmTheme() {
    final theme = ThemeData.dark().copyWith(
        colorScheme: const ColorScheme(
          primary: Color.fromARGB(255, 238, 32, 32),
          secondary: Colors.deepOrangeAccent,
          surface: Color.fromARGB(255, 240, 166, 139),
          error: Colors.redAccent,
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onSurface: Colors.black, 
          brightness: Brightness.dark, 
          onError: Colors.white,
        ),
      );
      return theme;
  }
}