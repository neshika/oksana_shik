// main.dart
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// Добавьте эти импорты для поддержки локализации
import 'package:flutter_localizations/flutter_localizations.dart';
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

      // Добавьте поддержку локализации
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate, // <-- Для Material виджетов
        GlobalWidgetsLocalizations.delegate, // <-- Для виджетов
        GlobalCupertinoLocalizations.delegate, // <-- Для Cupertino (iOS-стиль)
      ],
      supportedLocales: const [
        Locale('en', ''), // Английский (по умолчанию)
        Locale('ru', ''), // Русский (ваша локаль)
        // ... другие поддерживаемые языки
      ],
      // locale: const Locale('ru', ''), // Можно явно установить локаль по умолчанию, но не обязательно
    );
  }
}
