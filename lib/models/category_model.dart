// lib/models/category_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class Category {
  final String categoryId;
  final Map<String, String> name;
  final int order;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? updatedAt;

  Category({
    required this.categoryId,
    required this.name,
    required this.order,
    this.isActive = true,
    required this.createdAt,
    this.updatedAt,
  });

  factory Category.fromMap(Map<String, dynamic> map, String categoryId) {
    return Category(
      categoryId: categoryId,
      name: {'ru': map['name']['ru'] ?? '', 'en': map['name']['en'] ?? ''},
      order: map['order'] ?? 0,
      isActive: map['isActive'] ?? true,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      updatedAt: map['updatedAt'] != null
          ? (map['updatedAt'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'categoryId': categoryId,
      'name': name,
      'order': order,
      'isActive': isActive,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
    };
  }
}
