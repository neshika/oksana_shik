// lib/screens/profile/components/settings_widget.dart
import 'package:flutter/material.dart';

class SettingsWidget extends StatelessWidget {
  final VoidCallback onLogoutPressed; // Функция для обработки выхода
  final VoidCallback
      onViewAppointmentsPressed; // Функция для перехода к истории записей

  const SettingsWidget({
    super.key,
    required this.onLogoutPressed,
    required this.onViewAppointmentsPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
                leading:
                    const Icon(Icons.history), // Изменили иконку на историю
                title: const Text(
                    'История записей'), // Изменили текст на "История записей"
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: onViewAppointmentsPressed, // Переход к истории записей
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Выйти'),
                onTap: onLogoutPressed, // Вызов функции выхода
              ),
            ],
          ),
        ),
      ],
    );
  }
}
