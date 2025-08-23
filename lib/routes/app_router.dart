// lib/routes/app_router.dart
import 'package:flutter/material.dart';
import 'package:oksana_shik/screens/auth/login_screen.dart';
import 'package:oksana_shik/screens/auth/register_screen.dart';
import 'package:oksana_shik/screens/booking/booking_screen.dart';
import 'package:oksana_shik/screens/home/home_screen.dart';
import 'package:oksana_shik/screens/profile/profile_screen.dart';
import 'package:oksana_shik/screens/splash/splash_screen.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/splash':
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case '/login':
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case '/register':
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case '/home':
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case '/booking':
        return MaterialPageRoute(builder: (_) => const BookingScreen());
      case '/profile':
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('Страница не найдена'))),
        );
    }
  }
}
