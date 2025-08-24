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

  // Функция для создания коллекции categories
  void createCategoriesCollection(BuildContext context) async {
    try {
      // Создаем тестовую категорию
      await FirestoreService.createCategory(
        categoryId: 'female_001',
        name: {'ru': 'Женская', 'en': 'Female'},
        order: 1,
        isActive: true,
      );
      // Показываем сообщение об успешном создании
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Коллекция categories создана!')),
      );
    } catch (e) {
      // Показываем сообщение об ошибке
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка: $e')),
      );
    }
  }

  // Функция для создания коллекции services
  void createServicesCollection(BuildContext context) async {
    try {
      // Создаем тестовый сервис
      await FirestoreService.createService(
        serviceId: 'svc_test_001',
        title: {'ru': 'Стрижка', 'en': 'haircut'},
        description: {
          'ru': 'Стрижка женская короткий волос',
          'en': 'Women\'s haircut short hair'
        },
        price: 1000,
        duration: 60,
        category: 'female_001', // Ссылка на созданную категорию
        isActive: true,
      );
      // Показываем сообщение об успешном создании
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Коллекция services создана!')),
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
            // Кнопка для создания коллекции categories
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () => createCategoriesCollection(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green, // Зеленый цвет
                  foregroundColor: Colors.white,
                ),
                child: const Text('Создать коллекцию categories'),
              ),
            ),
            const SizedBox(height: 20),
            // Кнопка для создания коллекции services
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () => createServicesCollection(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange, // Оранжевый цвет
                  foregroundColor: Colors.white,
                ),
                child: const Text('Создать коллекцию services'),
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
