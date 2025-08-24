//import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:oksana_shik/routes/app_router.dart';
import 'package:oksana_shik/utils/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Инициализация Firebase
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Оксана Шик',
      theme: AppTheme.light,
      // home: const SplashScreen(),
      initialRoute: '/splash',
      onGenerateRoute: AppRouter.generateRoute,
      debugShowCheckedModeBanner: false, // Убирает баннер "DEBUG"
    );
  }
}
