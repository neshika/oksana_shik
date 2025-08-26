// lib/screens/profile/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:oksana_shik/utils/theme.dart';
import 'package:oksana_shik/services/firestore_service.dart';
import 'package:oksana_shik/models/user_model.dart' as user_model;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:oksana_shik/services/appointment_service.dart';

// Импортируем только виджет профиля
import 'components/user_profile_widget.dart';
import 'components/settings_widget.dart';
import 'user_appointments_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Переменная для отслеживания режима редактирования
  bool _isEditing = false;
  // Переменная для хранения оригинальных данных пользователя
  user_model.User? _userData;
  // Контроллеры для текстовых полей
  late TextEditingController _fullNameController;
  late TextEditingController _phoneNumberController;

  @override
  void initState() {
    super.initState();
    // Инициализируем контроллеры
    _fullNameController = TextEditingController();
    _phoneNumberController = TextEditingController();
  }

  @override
  void dispose() {
    // Освобождаем ресурсы контроллеров
    _fullNameController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  // --- Функция для обработки нажатия на кнопку редактирования ---
  void _handleEditPressed() {
    if (_isEditing) {
      _saveProfileChanges();
    } else {
      setState(() {
        _isEditing = true;
      });
    }
  }

  // void _navigateToAppointments() {
  //   // Здесь будет логика перехода к экрану истории записей

  //   Navigator.pushNamed(context, '/appointments_history');
  // }

// --- Функция для перехода к экрану записей пользователя ---
  void _navigateToAppointments() {
    // Получаем ID текущего пользователя
    final String? currentUserId = FirebaseAuth.instance.currentUser?.uid;

    // Проверка: если пользователь не авторизован, показываем сообщение
    // (Хотя экран профиля обычно доступен только авторизованным пользователям)
    if (currentUserId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Пользователь не авторизован')),
      );
      return;
    }

    // Переход на экран UserAppointmentsScreen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserAppointmentsScreen(
          // Используем get_it для получения сервиса
          // Убедитесь, что get_it настроен в main.dart
          // appointmentService: GetIt.instance<AppointmentService>(),

          // Альтернатива: Создание нового экземпляра сервиса
          // (менее предпочтительно для реального приложения)
          appointmentService: AppointmentService(),
        ),
      ),
    );
  }

  // --- Функция для сохранения изменений ---
  void _saveProfileChanges() async {
    if (_userData == null) return;
    try {
      await FirestoreService.updateUser(
        uid: _userData!.uid,
        fullName: _fullNameController.text,
        phoneNumber: _phoneNumberController.text,
      );
      setState(() {
        _isEditing = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Профиль успешно обновлен!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка при сохранении: $e')),
      );
    }
  }

  // --- Функция для обработки выхода ---
  void _handleLogoutPressed() {
    FirebaseAuth.instance.signOut();
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/login',
      (route) => false,
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Выход из аккаунта')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Профиль'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: AppTheme.backgroundColor,
        // leading убран, так как AppBar автоматически добавит кнопку "Назад"
        // при навигации через Navigator.push. Если нужна кастомная кнопка, оставьте.
        // leading: IconButton(
        //   onPressed: () => Navigator.pushNamed(context, '/home'),
        //   icon: Icon(Icons.arrow_back),
        // ),
      ),
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (userSnapshot.hasData && userSnapshot.data != null) {
            final firebaseUser = userSnapshot.data!;
            return StreamBuilder<user_model.User?>(
              stream: FirestoreService.getUserStreamById(firebaseUser.uid),
              builder: (context, userDetailSnapshot) {
                if (userDetailSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (userDetailSnapshot.hasData &&
                    userDetailSnapshot.data != null) {
                  _userData = userDetailSnapshot.data!;
                  if (!_isEditing) {
                    _fullNameController.text = _userData!.fullName;
                    _phoneNumberController.text = _userData!.phoneNumber;
                  }

                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // --- Использование нового виджета профиля ---
                        UserProfileWidget(
                          userData: _userData,
                          isEditing: _isEditing,
                          fullNameController: _fullNameController,
                          phoneNumberController: _phoneNumberController,
                          onEditPressed:
                              _handleEditPressed, // <--- Передаем функцию
                        ),
                        const SizedBox(height: 20),

                        // --- Использование нового виджета настроек ---
                        // В profile_screen.dart, в вызове SettingsWidget:
                        SettingsWidget(
                          onLogoutPressed: _handleLogoutPressed,
                          onViewAppointmentsPressed:
                              _navigateToAppointments, // Добавьте эту функцию
                        )
                      ],
                    ),
                  );
                } else {
                  return const Center(
                      child: Text('Данные пользователя не найдены'));
                }
              },
            );
          } else {
            return const Center(child: Text('Пользователь не авторизован'));
          }
        },
      ),
    );
  }
}
