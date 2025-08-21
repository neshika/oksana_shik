// lib/routes/app_router.dart
import 'package:flutter/material.dart';
import 'package:oksana_shik/screens/auth/login_screen.dart';
import 'package:oksana_shik/screens/splash/splash_screen,dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/splash':
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case '/login':
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('Страница не найдена'))),
        );
    }
  }
}
