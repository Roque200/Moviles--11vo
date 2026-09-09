import 'package:flutter/material.dart';

class ThemeApp {
  
  static ThemeData warmTheme() {
    final theme = ThemeData.dark().copyWith(
        colorScheme: const ColorScheme(
          primary: Colors.orange,
          secondary: Colors.deepOrangeAccent,
          surface: Colors.orangeAccent,
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