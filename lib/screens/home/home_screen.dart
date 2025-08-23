// lib/screens/home/home_screen.dart
import 'package:flutter/material.dart';
import 'package:oksana_shik/utils/theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Главная /home'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: AppTheme.backgroundColor,
        //кнопка назад
        leading: IconButton(
          onPressed: () => Navigator.pushNamed(context, '/login'),
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Добро пожаловать!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Выберите действие:',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 30),
            ListTile(
              leading: Icon(Icons.calendar_today, color: Colors.purple),
              title: Text('Записаться'),
              onTap: () {
                // Навигация на экран записи
                Navigator.pushNamed(context, '/booking');
              },
            ),
            ListTile(
              leading: Icon(Icons.history, color: Colors.purple),
              title: Text('Мои записи'),
              onTap: () {
                // Навигация на историю записей
              },
            ),
            ListTile(
              leading: Icon(Icons.person, color: Colors.purple),
              title: Text('Профиль'),
              onTap: () {
                // Навигация на профиль
                Navigator.pushNamed(context, '/profile');
              },
            ),
          ],
        ),
      ),
    );
  }
}
