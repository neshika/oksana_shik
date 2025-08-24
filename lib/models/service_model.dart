import 'package:cloud_firestore/cloud_firestore.dart';

// lib/models/service_model.dart
class Service {
  final String serviceId;
  final Map<String, String> title;
  final Map<String, String> description;
  final double price;
  final int duration;
  final String category;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? updatedAt;

  Service({
    required this.serviceId,
    required this.title,
    required this.description,
    required this.price,
    required this.duration,
    required this.category,
    this.isActive = true,
    required this.createdAt,
    this.updatedAt,
  });

  factory Service.fromMap(Map<String, dynamic> map, String serviceId) {
    return Service(
      serviceId: serviceId,
      title: {'ru': map['title']['ru'] ?? '', 'en': map['title']['en'] ?? ''},
      description: {
        'ru': map['description']['ru'] ?? '',
        'en': map['description']['en'] ?? ''
      },
      price: map['price']?.toDouble() ?? 0.0,
      duration: map['duration'] ?? 0,
      category: map['category'] ?? '',
      isActive: map['isActive'] ?? true,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      updatedAt: map['updatedAt'] != null
          ? (map['updatedAt'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'serviceId': serviceId,
      'title': title,
      'description': description,
      'price': price,
      'duration': duration,
      'category': category,
      'isActive': isActive,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
    };
  }
}
