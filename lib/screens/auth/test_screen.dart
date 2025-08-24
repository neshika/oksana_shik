// lib/screens/auth/test_screen.dart
import 'package:flutter/material.dart';
import 'package:oksana_shik/utils/theme.dart';
import 'package:oksana_shik/services/firestore_service.dart';

class TestScreen extends StatelessWidget {
  const TestScreen({super.key});

  // Функция для создания коллекции users в Firestore
  void createUsersCollection(BuildContext context) async {
    try {
      // Создаем тестового пользователя (для демонстрации)
      await FirestoreService.createUser(
        uid: 'test_user', // Уникальный ID пользователя
        email: 'test@example.com',
        fullName: 'Тестовый Пользователь',
        phoneNumber: '+71234567890',
      );

      // Показываем сообщение об успешном создании
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Коллекция users создана!')),
      );
    } catch (e) {
      // Показываем сообщение об ошибке
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Тест базы данных'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: AppTheme.backgroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Тест создания базы данных',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Здесь можно тестировать создание таблиц базы данных',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 30),

            // Кнопка для создания коллекции users
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () => createUsersCollection(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Синий цвет
                  foregroundColor: Colors.white,
                ),
                child: const Text('Создать коллекцию users'),
              ),
            ),

            const SizedBox(height: 20),

            // Кнопка для перехода обратно
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  // Возвращаемся на экран входа
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey, // Серый цвет
                  foregroundColor: Colors.white,
                ),
                child: const Text('Назад к входу'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
