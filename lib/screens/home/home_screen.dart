// lib/screens/home/home_screen.dart
import 'package:flutter/material.dart';
import 'package:oksana_shik/utils/theme.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:oksana_shik/services/firestore_service.dart'; // Добавляем импорт сервиса Firestore
import 'package:oksana_shik/models/user_model.dart'
    as user_model; // Добавляем импорт модели пользователя
import 'package:oksana_shik/screens/profile/user_appointments_screen.dart'; // Импорт экрана записей
import 'package:oksana_shik/services/appointment_service.dart'; // Импорт сервиса записей

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Переменная для хранения имени пользователя
  String _userName = 'Гость';
  bool _isLoading = true; // Для отображения загрузки

  // Функция для получения данных пользователя из Firestore
  Future<void> _loadUserData() async {
    try {
      // Получаем текущего пользователя из Firebase Auth
      firebase_auth.User? currentUser =
          firebase_auth.FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        // Получаем UID пользователя
        String uid = currentUser.uid;

        // Получаем данные пользователя из Firestore
        user_model.User? user = await FirestoreService.getUserById(uid);

        if (user != null) {
          // Устанавливаем имя пользователя из базы данных
          setState(() {
            _userName = user.fullName;
            _isLoading = false;
          });
        } else {
          // Если пользователя нет в базе данных, используем email
          setState(() {
            _userName = currentUser.email ?? 'Пользователь';
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      // В случае ошибки показываем стандартное имя
      setState(() {
        _userName = 'Пользователь';
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // Загружаем данные пользователя при инициализации экрана
    _loadUserData();
  }

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
            // Отображаем загрузку пока данные не загрузились
            if (_isLoading)
              Center(
                child:
                    CircularProgressIndicator(), // Показываем индикатор загрузки
              )
            else
              Text(
                'Добро пожаловать, $_userName!', // Используем имя из базы данных
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
              title: Text('Мои активные записи'),
              onTap: () {
                // Навигация на историю записей
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserAppointmentsScreen(
                      appointmentService:
                          AppointmentService(), // Передаем сервис
                      statusFilter:
                          'confirmed', // Фильтр на подтвержденные записи
                      title: 'Активные записи', // Кастомный заголовок
                    ),
                  ),
                );
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
