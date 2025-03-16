import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:redlenshoescleaning/view/splashscreen.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0C8346),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
