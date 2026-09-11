import 'package:flutter/material.dart';
import 'package:moviles/components/global_values.dart';
import 'package:moviles/components/theme_app.dart';
import 'package:moviles/screens/dashboard_screens.dart';
import 'package:moviles/screens/login_screens.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: GlobalValues.banTheme,
      builder: (context, value, _ ) {

         ThemeData tema = ThemeData.light();
        switch(value){
          case 0:
            tema = ThemeData.dark();
            break;
          case 1:
            tema = ThemeData.light();
            break;
          case 2:
            tema = ThemeApp.warmTheme();
            break;
        }

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          routes: {
            '/dash': (context) => DashboardScreens(),
          },
          theme: tema,
          home: LoginScreen(),
        );
      }
    );
  }
}