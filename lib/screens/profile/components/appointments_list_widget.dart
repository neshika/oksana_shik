// lib/screens/profile/components/appointments_list_widget.dart
import 'package:flutter/material.dart';
import 'package:oksana_shik/utils/theme.dart';

class AppointmentsListWidget extends StatelessWidget {
  final List<Map<String, dynamic>> appointments;

  const AppointmentsListWidget({
    super.key,
    required this.appointments,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
                        ? AppTheme.subColorGreen.withValues(alpha: 76.0)
                        : AppTheme.subColorPurple.withValues(alpha: 76.0),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Icon(
                      appointment['status'] == 'completed'
                          ? Icons.check_circle
                          : Icons.calendar_today,
                      color: appointment['status'] == 'completed'
                          ? AppTheme.subColorGreen
                          : AppTheme.subColorPurple,
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
                            ? AppTheme.subColorGreen
                            : AppTheme.subColorPurple,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: AppTheme.subColorGrey,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
