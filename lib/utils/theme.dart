// lib/utils/theme.dart
import 'package:flutter/material.dart';

class AppTheme {
  // Цвета (можно уточнить у заказчика позже)
  static const Color primaryColor = Color(0xFF8A2BE2); // Фиолетовый (пример)
  static const Color accentColor = Color(0xFFFFD700); // Золотой
  static const Color backgroundColor = Colors.white;
  static const Color textColor = Color(0xFF333333);

  // Темы
  static final ThemeData light = ThemeData(
    brightness: Brightness.light,
    primaryColor: primaryColor,
    fontFamily: 'Roboto',
    appBarTheme: const AppBarTheme(color: primaryColor),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: accentColor,
    ),
  );

  static final ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    primaryColor: primaryColor,
    fontFamily: 'Roboto',
  );

  // Типографика
  static const TextStyle heading1 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle bodyText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
  );
}
