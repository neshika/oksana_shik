// lib/models/schedule_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class Schedule {
  final String date; // Используем строку для удобства работы с датой
  final Map<String, String> workingHours; // Начало и конец рабочего дня
  final bool isDayOff;
  final Map<String, bool> availableSlots;

  Schedule({
    required this.date,
    required this.workingHours,
    required this.isDayOff,
    required this.availableSlots,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      date: _formatDate(json['date'] as Timestamp),
      workingHours: {
        'start': json['workingHours']['start'] ?? '09:00',
        'end': json['workingHours']['end'] ?? '19:00'
      },
      isDayOff: json['isDayOff'] ?? false,
      availableSlots: _parseAvailableSlots(json['availableSlots']),
    );
  }

  static String _formatDate(Timestamp timestamp) {
    final date = timestamp.toDate();
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  static Map<String, bool> _parseAvailableSlots(dynamic slots) {
    if (slots == null) return {};
    if (slots is Map<String, dynamic>) {
      return slots.map((key, value) => MapEntry(key, value as bool));
    }
    return {};
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'workingHours': workingHours,
      'isDayOff': isDayOff,
      'availableSlots': availableSlots,
    };
  }
}
