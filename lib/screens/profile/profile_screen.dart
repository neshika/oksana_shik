// lib/screens/profile/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:oksana_shik/utils/theme.dart';
import 'package:oksana_shik/services/firestore_service.dart';
import 'package:oksana_shik/models/user_model.dart' as UserModel;
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Переменная для отслеживания режима редактирования
  bool _isEditing = false;

  // Переменные для хранения отредактированных значений
  late String _editedFullName;
  late String _editedPhoneNumber;

  // Переменная для хранения оригинальных данных пользователя
  UserModel.User? _userData;

  // Контроллеры для текстовых полей (решают проблему с клавиатурой)
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Профиль'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: AppTheme.backgroundColor,
        leading: IconButton(
          onPressed: () => Navigator.pushNamed(context, '/home'),
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (userSnapshot.hasData && userSnapshot.data != null) {
            final firebaseUser = userSnapshot.data!;

            // Используем StreamBuilder для получения данных пользователя
            return StreamBuilder<UserModel.User?>(
              stream: FirestoreService.getUserStreamById(firebaseUser.uid),
              builder: (context, userDetailSnapshot) {
                if (userDetailSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (userDetailSnapshot.hasData &&
                    userDetailSnapshot.data != null) {
                  // Сохраняем данные пользователя для использования
                  _userData = userDetailSnapshot.data!;

                  // Инициализируем переменные редактирования при первом получении данных
                  if (!_isEditing) {
                    _editedFullName = _userData!.fullName;
                    _editedPhoneNumber = _userData!.phoneNumber;
                    // Обновляем контроллеры при получении новых данных
                    _fullNameController.text = _editedFullName;
                    _phoneNumberController.text = _editedPhoneNumber;
                  }

                  // Пример истории записей (в реальном приложении будут из Firebase)
                  final List<Map<String, dynamic>> appointments = [
                    {
                      'id': '1',
                      'serviceName': 'Стрижка',
                      'date': '15.08.2025',
                      'time': '10:00',
                      'status': 'confirmed',
                    },
                    {
                      'id': '2',
                      'serviceName': 'Окрашивание',
                      'date': '20.08.2025',
                      'time': '14:30',
                      'status': 'confirmed',
                    },
                    {
                      'id': '3',
                      'serviceName': 'Укладка',
                      'date': '25.08.2025',
                      'time': '11:00',
                      'status': 'completed',
                    },
                  ];

                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Профиль пользователя с кнопкой редактирования
                        Card(
                          elevation: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Stack(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const CircleAvatar(
                                      radius: 50,
                                      backgroundColor: AppTheme.primaryColor,
                                      child: Icon(
                                        Icons.person,
                                        size: 60,
                                        color: AppTheme.backgroundColor,
                                      ),
                                    ),
                                    const SizedBox(height: 15),
                                    // Поле ФИО - может быть текстом или текстовым полем в зависимости от режима редактирования
                                    _isEditing
                                        ? TextField(
                                            controller: _fullNameController,
                                            onChanged: (value) {
                                              setState(() {
                                                _editedFullName = value;
                                              });
                                            },
                                            decoration: const InputDecoration(
                                              border: OutlineInputBorder(),
                                              labelText: 'ФИО',
                                            ),
                                          )
                                        : Text(
                                            _userData!.fullName,
                                            style: const TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                    const SizedBox(height: 5),
                                    // Поле email - всегда отображается как текст
                                    Text(
                                      _userData!.email,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    // Поле телефона - может быть текстом или текстовым полем в зависимости от режима редактирования
                                    _isEditing
                                        ? TextField(
                                            controller: _phoneNumberController,
                                            keyboardType: TextInputType.phone,
                                            onChanged: (value) {
                                              setState(() {
                                                _editedPhoneNumber = value;
                                              });
                                            },
                                            decoration: const InputDecoration(
                                              border: OutlineInputBorder(),
                                              labelText: 'Телефон',
                                            ),
                                          )
                                        : Text(
                                            _userData!.phoneNumber,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.grey,
                                            ),
                                          ),
                                    const SizedBox(height: 10),
                                    Text(
                                      'Присоединился: ${_formatDate(_userData!.createdAt)}',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                // Кнопка редактирования в правом верхнем углу
                                Positioned(
                                  top: 5,
                                  right: 5,
                                  child: IconButton(
                                    icon: Icon(
                                      _isEditing ? Icons.save : Icons.edit,
                                      size: 28,
                                      color: Colors.grey,
                                    ),
                                    onPressed: () {
                                      if (_isEditing) {
                                        // Если мы в режиме редактирования, сохраняем изменения
                                        _saveProfileChanges();
                                      } else {
                                        // Если не в режиме редактирования, включаем его
                                        setState(() {
                                          _isEditing = true;
                                        });
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        // История записей
                        const Text(
                          'История записей',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Column(
                          children: appointments.map((appointment) {
                            return Card(
                              margin: const EdgeInsets.only(bottom: 10),
                              child: ListTile(
                                leading: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: appointment['status'] == 'completed'
                                        ? Colors.green.withValues(alpha: 76.0)
                                        : Colors.purple.withValues(alpha: 76.0),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Center(
                                    child: Icon(
                                      appointment['status'] == 'completed'
                                          ? Icons.check_circle
                                          : Icons.calendar_today,
                                      color:
                                          appointment['status'] == 'completed'
                                              ? Colors.green
                                              : Colors.purple,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  appointment['serviceName'] as String,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        '${appointment['date']} в ${appointment['time']}'),
                                    const SizedBox(height: 5),
                                    Text(
                                      appointment['status'] == 'completed'
                                          ? 'Завершена'
                                          : 'Подтверждена',
                                      style: TextStyle(
                                        color:
                                            appointment['status'] == 'completed'
                                                ? Colors.green
                                                : Colors.purple,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                trailing: Icon(
                                  Icons.arrow_forward_ios,
                                  size: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 20),
                        // Настройки
                        const Text(
                          'Настройки',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Card(
                          elevation: 2,
                          child: Column(
                            children: [
                              ListTile(
                                leading: const Icon(Icons.language),
                                title: const Text('Язык'),
                                subtitle: const Text('Русский'),
                                trailing: const Icon(Icons.arrow_forward_ios),
                                onTap: () {
                                  // Открыть выбор языка
                                },
                              ),
                              const Divider(),
                              ListTile(
                                leading: const Icon(Icons.notifications),
                                title: const Text('Уведомления'),
                                trailing: Switch(
                                  value: true,
                                  onChanged: (value) {},
                                ),
                              ),
                              const Divider(),
                              ListTile(
                                leading: const Icon(Icons.help_outline),
                                title: const Text('Помощь'),
                                trailing: const Icon(Icons.arrow_forward_ios),
                                onTap: () {
                                  // Открыть помощь
                                },
                              ),
                              const Divider(),
                              ListTile(
                                leading: const Icon(Icons.logout),
                                title: const Text('Выйти'),
                                onTap: () {
                                  // Выход из аккаунта
                                  FirebaseAuth.instance.signOut();
                                  Navigator.pushNamedAndRemoveUntil(
                                    context,
                                    '/login',
                                    (route) => false,
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('Выход из аккаунта')),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
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

  // Метод для сохранения изменений профиля
  void _saveProfileChanges() async {
    if (_userData == null) return;

    try {
      // Обновляем данные пользователя в Firestore
      await FirestoreService.updateUser(
        uid: _userData!.uid,
        fullName: _editedFullName,
        phoneNumber: _editedPhoneNumber,
        // email не изменяем, так как по условию задачи не меняем
      );

      // Переключаем режим редактирования обратно
      setState(() {
        _isEditing = false;
      });

      // Показываем сообщение об успешном сохранении
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Профиль успешно обновлен!')),
      );
    } catch (e) {
      // Показываем сообщение об ошибке
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка при сохранении: $e')),
      );
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }
}
