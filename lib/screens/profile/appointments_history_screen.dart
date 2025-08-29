// lib/screens/profile/appointments_history_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:oksana_shik/utils/theme.dart';
import 'package:oksana_shik/services/firestore_service.dart';
import 'package:oksana_shik/models/appointment_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AppointmentsHistoryScreen extends StatefulWidget {
  const AppointmentsHistoryScreen({super.key});

  @override
  State<AppointmentsHistoryScreen> createState() =>
      _AppointmentsHistoryScreenState();
}

class _AppointmentsHistoryScreenState extends State<AppointmentsHistoryScreen> {
  List<Appointment> _appointments = [];
  bool _isLoading = true;
  String? _error;
  StreamSubscription<List<Appointment>>? _appointmentsSubscription;

  @override
  void initState() {
    super.initState();
    _loadAppointments();
  }

  @override
  void dispose() {
    _appointmentsSubscription?.cancel();
    super.dispose();
  }

  void _loadAppointments() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _isLoading = true;
        _error = null;
      });
      _appointmentsSubscription =
          FirestoreService.getUserAppointmentsStream(user.uid).listen(
        (appointments) {
          setState(() {
            _appointments = appointments;
            _isLoading = false;
          });
        },
        onError: (error) {
          setState(() {
            _isLoading = false;
            _error = 'Ошибка загрузки записей: $error';
          });
        },
      );
    } else {
      setState(() {
        _isLoading = false;
        _error = 'Пользователь не авторизован';
      });
    }
  }

  // Функция для форматирования даты
  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }

  // Функция для форматирования времени
  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('История записей'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: AppTheme.backgroundColor,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error, size: 48, color: Colors.red),
                      const SizedBox(height: 16),
                      Text(_error!,
                          style:
                              const TextStyle(color: Colors.red, fontSize: 16)),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadAppointments,
                        child: const Text('Повторить попытку'),
                      ),
                    ],
                  ),
                )
              : _appointments.isEmpty
                  ? const Center(
                      child: Text(
                        'Нет записей',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _appointments.length,
                      itemBuilder: (context, index) {
                        final appointment = _appointments[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          elevation: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Название услуги
                                Row(
                                  children: [
                                    Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: appointment.status == 'completed'
                                            ? Colors.green
                                                .withValues(alpha: 76.0)
                                            : Colors.purple
                                                .withValues(alpha: 76.0),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Center(
                                        child: Icon(
                                          appointment.status == 'completed'
                                              ? Icons.check_circle
                                              : Icons.calendar_today,
                                          color:
                                              appointment.status == 'completed'
                                                  ? Colors.green
                                                  : Colors.purple,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        // ТЕПЕРЬ БЕЗ ПРОВЕРОК НА NULL, так как поля обязательные
                                        appointment.serviceName['ru'] ??
                                            appointment.serviceName['en'] ??
                                            'Неизвестная услуга',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                // Дата и время
                                Row(
                                  children: [
                                    const Icon(Icons.calendar_today,
                                        size: 16, color: Colors.grey),
                                    const SizedBox(width: 8),
                                    Text(
                                      // ТЕПЕРЬ БЕЗ ПРОВЕРОК НА NULL
                                      '${_formatDate(appointment.date)} в ${_formatTime(appointment.startTime)}',
                                      style: const TextStyle(
                                          fontSize: 14, color: Colors.grey),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                // Статус записи
                                Row(
                                  children: [
                                    Icon(
                                      appointment.status == 'completed'
                                          ? Icons.check
                                          : Icons.timelapse,
                                      size: 16,
                                      color: appointment.status == 'completed'
                                          ? Colors.green
                                          : Colors.purple,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      // ТЕПЕРЬ БЕЗ ПРОВЕРОК НА NULL
                                      appointment.status == 'completed'
                                          ? 'Завершена'
                                          : 'Подтверждена',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: appointment.status == 'completed'
                                            ? Colors.green
                                            : Colors.purple,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                // Информация о пользователе
                                Row(
                                  children: [
                                    const Icon(Icons.person,
                                        size: 16, color: Colors.grey),
                                    const SizedBox(width: 8),
                                    Text(
                                      // ТЕПЕРЬ БЕЗ ПРОВЕРОК НА NULL
                                      'Запись от: ${appointment.userName}',
                                      style: const TextStyle(
                                          fontSize: 14, color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
    );
  }
}
