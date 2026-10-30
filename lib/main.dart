import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:moviles/components/global_values.dart';
import 'package:moviles/components/theme_app.dart';
import 'package:moviles/firebase_options.dart';
import 'package:moviles/screens/add_note_screens.dart';
import 'package:moviles/screens/api_popular_screen.dart';
import 'package:moviles/screens/dashboard_screens.dart';
import 'package:moviles/screens/login_screens.dart';
import 'package:moviles/screens/map_google_screen.dart';
import 'package:moviles/screens/notesNube_screen.dart';
import 'package:moviles/screens/notes_screen.dart';
import 'package:moviles/screens/register_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await dotenv.load(fileName: '.env');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: GlobalValues.banTheme,
      builder: (context, value, _) {
        ThemeData tema = ThemeData.light();
        switch (value) {
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
            '/dash': (context) => const DashboardScreens(),
            '/note': (context) => const NotesScreen(),
            '/add': (context) => const AddNoteScreens(),
            '/register': (context) => const RegisterScreen(),
            '/NotesNube': (context) => const NotesNubeScreen(),
            '/movies': (context) => const ApiPopularScreen(),
            '/map': (context) => const MapGoogleScreen(),
          },
          theme: tema,
          home: const LoginScreen(),
        );
      },
    );
  }
}
