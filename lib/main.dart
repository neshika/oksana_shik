//import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:oksana_shik/screens/splash/splash_screen,dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Инициализация Firebase
  //await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Оксана Шик',
      theme: ThemeData(
        fontFamily: 'Roboto',
        primarySwatch: Colors.deepPurple, // Можно изменить позже
      ),
      home: const SplashScreen(),
      // debugShowCheckedModeBanner: false, // Убирает баннер "DEBUG"
    );
  }
}
