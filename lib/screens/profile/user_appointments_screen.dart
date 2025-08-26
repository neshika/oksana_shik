// lib/screens/user_appointments_screen.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:oksana_shik/models/appointment_model.dart';
import 'package:oksana_shik/services/appointment_service.dart';

/// Экран для отображения записей текущего авторизованного пользователя.
/// Можно отфильтровать по статусу.
class UserAppointmentsScreen extends StatelessWidget {
  // Получаем экземпляр сервиса через конструктор
  final AppointmentService appointmentService;
  // НОВЫЙ ПАРАМЕТР: опциональный фильтр по статусу
  final String? statusFilter;
  // Опциональный заголовок для AppBar
  final String? title;

  const UserAppointmentsScreen({
    super.key,
    required this.appointmentService,
    this.statusFilter, // Делаем параметр необязательным
    this.title, // Делаем заголовок необязательным
  });

  @override
  Widget build(BuildContext context) {
    // Получаем ID текущего пользователя из Firebase Authentication
    final String? currentUserId = FirebaseAuth.instance.currentUser?.uid;

    // Проверка: если пользователь не авторизован, показываем сообщение
    if (currentUserId == null) {
      return Scaffold(
        appBar: AppBar(
            title: Text(title ??
                'Мои записи')), // Используем кастомный заголовок или по умолчанию
        body: const Center(
          child: Text(
            'Пожалуйста, войдите в систему, чтобы увидеть свои записи.',
            style: TextStyle(fontSize: 16),
          ),
        ),
      );
    }

    // Выбираем стрим в зависимости от наличия фильтра статуса
    Stream<List<Appointment>> stream;
    if (statusFilter != null && statusFilter!.isNotEmpty) {
      stream = appointmentService.getAppointmentsByUserIdAndStatusStream(
          currentUserId, statusFilter!);
    } else {
      stream = appointmentService.getAppointmentsByUserIdStream(currentUserId);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(title ??
            'Мои записи'), // Используем кастомный заголовок или по умолчанию
      ),
      body: StreamBuilder<List<Appointment>>(
        // Используем выбранный стрим
        stream: stream,
        builder: (context, snapshot) {
          // Обработка состояния ошибки
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 48),
                  const SizedBox(height: 10),
                  Text(
                    'Ошибка загрузки записей: ${snapshot.error}',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      // Перестроит StreamBuilder, что может помочь при временных ошибках
                    },
                    child: const Text('Повторить'),
                  ),
                ],
              ),
            );
          }

          // Обработка состояния загрузки
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          // Данные получены
          List<Appointment> appointments = snapshot.data!;

          // Проверка на пустой список
          if (appointments.isEmpty) {
            String emptyMessage;
            if (statusFilter?.toLowerCase() == 'confirmed') {
              emptyMessage = 'У вас нет подтвержденных записей.';
            } else if (statusFilter?.toLowerCase() == 'pending') {
              emptyMessage = 'У вас нет ожидающих подтверждения записей.';
            } else if (statusFilter?.toLowerCase() == 'cancelled') {
              emptyMessage = 'У вас нет отмененных записей.';
            } else if (statusFilter?.toLowerCase() == 'completed') {
              emptyMessage = 'У вас нет завершенных записей.';
            } else {
              emptyMessage = 'У вас пока нет записей.';
            }
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.calendar_today,
                      size: 48, color: Colors.grey),
                  const SizedBox(height: 10),
                  Text(
                    emptyMessage, // Используем динамическое сообщение
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          // Отображение списка записей
          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: appointments.length,
            itemBuilder: (context, index) {
              Appointment appointment = appointments[index];
              // Форматирование даты и времени для отображения
              String formattedDate =
                  "${appointment.date.day.toString().padLeft(2, '0')}.${appointment.date.month.toString().padLeft(2, '0')}.${appointment.date.year}";
              String formattedTime =
                  "${appointment.startTime.hour.toString().padLeft(2, '0')}:${appointment.startTime.minute.toString().padLeft(2, '0')} - ${appointment.endTime.hour.toString().padLeft(2, '0')}:${appointment.endTime.minute.toString().padLeft(2, '0')}";

              // Определение цвета и текста статуса (можно оставить как есть)
              Color statusColor = Colors.grey;
              String statusText = 'Неизвестно';
              switch (appointment.status.toLowerCase()) {
                case 'pending':
                  statusColor = Colors.orange;
                  statusText = 'Ожидает';
                  break;
                case 'confirmed':
                  statusColor = Colors.green;
                  statusText = 'Подтверждена';
                  break;
                case 'cancelled':
                  statusColor = Colors.red;
                  statusText = 'Отменена';
                  break;
                case 'completed':
                  statusColor = Colors.blue;
                  statusText = 'Завершена';
                  break;
              }

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 4.0),
                elevation: 2.0,
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12.0),
                  title: Text(
                    appointment.serviceName['ru'] ??
                        appointment.serviceName['en'] ??
                        'Без названия',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text('Дата: $formattedDate'),
                      Text('Время: $formattedTime'),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: statusColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            statusText,
                            style: TextStyle(color: statusColor, fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
