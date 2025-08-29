// lib/models/appointment_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class Appointment {
  final String appointmentId; // ID записи
  final String userId; // UID пользователя
  final String userName; // Имя пользователя
  final String serviceId; // ID услуги
  final Map<String, String> serviceName; // Название услуги (на разных языках)
  final DateTime date; // Дата записи
  final DateTime startTime; // Время начала
  final DateTime endTime; // Время окончания
  final String status; // Статус записи
  final DateTime createdAt; // Время создания записи

  Appointment({
    required this.appointmentId,
    required this.userId,
    required this.userName,
    required this.serviceId,
    required this.serviceName,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.status,
    required this.createdAt,
  });

  /// Создает объект Appointment из Map данных Firestore.
  /// Обеспечивает, что все поля будут ненулевыми.
  factory Appointment.fromJson(Map<String, dynamic> json) {
    // Обработка serviceName: если null или не Map, создаем пустой Map с дефолтными значениями
    Map<String, String> serviceNameMap;
    final dynamic serviceNameData = json['serviceName'];
    if (serviceNameData is Map<String, dynamic>) {
      // Преобразуем dynamic значения в String, заменяя null на пустую строку
      serviceNameMap = serviceNameData
          .map((key, value) => MapEntry(key, value?.toString() ?? ''));
    } else {
      // Если serviceName отсутствует или некорректный, используем значения по умолчанию
      serviceNameMap = {'ru': 'Неизвестная услуга', 'en': 'Unknown service'};
    }

    return Appointment(
      appointmentId: json['id'] ??
          json['appointmentId'] ??
          '', // Используем 'id' из Firestore или 'appointmentId' из данных
      userId:
          json['userId'] ?? '', // Если userId null, используем пустую строку
      userName: json['userName'] ??
          'Неизвестный пользователь', // Если userName null, используем значение по умолчанию
      serviceId: json['serviceId'] ??
          '', // Если serviceId null, используем пустую строку
      serviceName: serviceNameMap, // Используем обработанную карту
      date: json['date'] != null
          ? (json['date'] as Timestamp).toDate()
          : DateTime.now(), // Если date null, используем текущую дату
      startTime: json['startTime'] != null
          ? (json['startTime'] as Timestamp).toDate()
          : DateTime.now(), // Если startTime null, используем текущую дату
      endTime: json['endTime'] != null
          ? (json['endTime'] as Timestamp).toDate()
          : DateTime.now().add(Duration(
              hours: 1)), // Если endTime null, используем startTime + 1 час
      status:
          json['status'] ?? 'pending', // Если status null, используем 'unknown'
      createdAt: json['createdAt'] != null
          ? (json['createdAt'] as Timestamp).toDate()
          : DateTime.now(), // Если createdAt null, используем текущую дату
    );
  }

  /// Преобразует объект Appointment в Map для сохранения в Firestore.
  Map<String, dynamic> toJson() {
    return {
      'appointmentId': appointmentId,
      'userId': userId,
      'userName': userName,
      'serviceId': serviceId,
      'serviceName': serviceName,
      'date': Timestamp.fromDate(date),
      'startTime': Timestamp.fromDate(startTime),
      'endTime': Timestamp.fromDate(endTime),
      'status': status,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
