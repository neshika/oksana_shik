// lib/models/appointment_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class Appointment {
  final String appointmentId;
  final String userId;
  final String userName;
  final String serviceId;
  final Map<String, String> serviceName;
  final DateTime date;
  final DateTime startTime;
  final DateTime endTime;
  final String status;
  final DateTime createdAt;

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

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      appointmentId: json['appointmentId'],
      userId: json['userId'],
      userName: json['userName'],
      serviceId: json['serviceId'],
      serviceName: {
        'ru': json['serviceName']['ru'] ?? '',
        'en': json['serviceName']['en'] ?? ''
      },
      date: (json['date'] as Timestamp).toDate(),
      startTime: (json['startTime'] as Timestamp).toDate(),
      endTime: (json['endTime'] as Timestamp).toDate(),
      status: json['status'] ?? 'pending',
      createdAt: (json['createdAt'] as Timestamp).toDate(),
    );
  }

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
