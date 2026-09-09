import 'package:flutter/material.dart';
import 'package:moviles/components/global_values.dart';
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
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          routes: {
            '/dash': (context) => DashboardScreens(),
          },
          theme:value ? ThemeData.dark() : ThemeData.light(),
          home: LoginScreen(),
        );
      }
    );
  }
}