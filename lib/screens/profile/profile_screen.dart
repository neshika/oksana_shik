// lib/screens/profile/profile_screen.dart
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Пример данных пользователя (в реальном приложении будут из Firebase)
    final userData = {
      'fullName': 'Иван Иванов',
      'email': 'ivan.ivanov@example.com',
      'phoneNumber': '+7 (999) 123-45-67',
      'joinDate': '01.01.2024',
    };

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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Профиль'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Профиль пользователя
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.purple,
                      child: Icon(
                        Icons.person,
                        size: 60,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      userData['fullName'] as String,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      userData['email'] as String,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      userData['phoneNumber'] as String,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Присоединился: ${userData['joinDate']}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
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
                            ? Colors.green.withOpacity(0.2)
                            : Colors.purple.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Icon(
                          appointment['status'] == 'completed'
                              ? Icons.check_circle
                              : Icons.calendar_today,
                          color: appointment['status'] == 'completed'
                              ? Colors.green
                              : Colors.purple,
                        ),
                      ),
                    ),
                    title: Text(
                      appointment['serviceName'] as String,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${appointment['date']} в ${appointment['time']}'),
                        const SizedBox(height: 5),
                        Text(
                          appointment['status'] == 'completed'
                              ? 'Завершена'
                              : 'Подтверждена',
                          style: TextStyle(
                            color: appointment['status'] == 'completed'
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
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Выход из аккаунта')),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
