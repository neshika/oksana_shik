import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:oksana_shik/models/schedule_model.dart';
import 'package:oksana_shik/models/user_model.dart' as user_model;
import 'package:oksana_shik/models/service_model.dart';
import 'package:oksana_shik/models/category_model.dart';
import 'package:oksana_shik/models/appointment_model.dart';

class FirestoreService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  ////////////////////////////////////////////////// Пользователь
  // Создание нового пользователя
  static Future<void> createUser({
    required String uid,
    required String email,
    required String fullName,
    required String phoneNumber,
  }) async {
    try {
      await _firestore.collection('users').doc(uid).set({
        'uid': uid,
        'email': email,
        'fullName': fullName,
        'phoneNumber': phoneNumber,
        'createdAt': FieldValue.serverTimestamp(),
      });
      print('Пользователь успешно создан!');
    } catch (e) {
      print('Ошибка при создании пользователя: $e');
      rethrow;
    }
  }

  // Получение пользователя по UID
  static Future<user_model.User?> getUserById(String uid) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return user_model.User.fromMap(doc.data() as Map<String, dynamic>, uid);
      }
      return null;
    } catch (e) {
      print('Ошибка при получении пользователя: $e');
      return null;
    }
  }

  // Получение потока данных пользователя по UID
  static Stream<user_model.User?> getUserStreamById(String uid) {
    return _firestore.collection('users').doc(uid).snapshots().map((doc) {
      if (doc.exists) {
        return user_model.User.fromMap(doc.data() as Map<String, dynamic>, uid);
      }
      return null;
    });
  }

// Обновление данных пользователя по UID
  static Future<void> updateUser({
    required String uid,
    required String fullName,
    required String phoneNumber,
  }) async {
    try {
      await _firestore.collection('users').doc(uid).update({
        'fullName': fullName,
        'phoneNumber': phoneNumber,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      print('Профиль успешно обновлен!');
    } catch (e) {
      print('Ошибка при обновлении профиля: $e');
      rethrow;
    }
  }

////////////////////////////////////////////////// Категория
  // Создание категории
  static Future<void> createCategory({
    required String categoryId,
    required Map<String, String> name,
    required int order,
    required bool isActive,
  }) async {
    try {
      await _firestore.collection('categories').doc(categoryId).set({
        'categoryId': categoryId,
        'name': name,
        'order': order,
        'isActive': isActive,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      print('Категория успешно создана!');
    } catch (e) {
      print('Ошибка при создании категории: $e');
      rethrow;
    }
  }

  // Получение всех активных категорий
  static Stream<QuerySnapshot> getActiveCategories() {
    return _firestore
        .collection('categories')
        .where('isActive', isEqualTo: true)
        .orderBy('order')
        .snapshots();
  }

  // Получение категории по ID
  static Future<Category?> getCategoryById(String categoryId) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('categories').doc(categoryId).get();
      if (doc.exists) {
        return Category.fromMap(doc.data() as Map<String, dynamic>, categoryId);
      }
      return null;
    } catch (e) {
      print('Ошибка при получении категории: $e');
      return null;
    }
  }

  // Получение всех категорий (для админки или отладки)
  static Stream<QuerySnapshot> getAllCategories() {
    return _firestore.collection('categories').snapshots();
  }

////////////////////////////////////////////////// Услуги
  // Создание услуги
  static Future<void> createService({
    required String serviceId,
    required Map<String, String> title,
    required Map<String, String> description,
    required double price,
    required int duration,
    required String category,
    required bool isActive,
  }) async {
    try {
      await _firestore.collection('services').doc(serviceId).set({
        'serviceId': serviceId,
        'title': title,
        'description': description,
        'price': price,
        'duration': duration,
        'category': category,
        'isActive': isActive,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      print('Услуга успешно создана!');
    } catch (e) {
      print('Ошибка при создании услуги: $e');
      rethrow;
    }
  }

  // Получение всех активных услуг
  static Stream<QuerySnapshot> getActiveServices() {
    return _firestore
        .collection('services')
        .where('isActive', isEqualTo: true)
        .snapshots();
  }

  // Получение услуг по категории
  static Stream<QuerySnapshot> getServicesByCategory(String categoryId) {
    return _firestore
        .collection('services')
        .where('category', isEqualTo: categoryId)
        .where('isActive', isEqualTo: true)
        .snapshots();
  }

  // Получение услуги по ID
  static Future<Service?> getServiceById(String serviceId) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('services').doc(serviceId).get();
      if (doc.exists) {
        return Service.fromMap(doc.data() as Map<String, dynamic>, serviceId);
      }
      return null;
    } catch (e) {
      print('Ошибка при получении услуги: $e');
      return null;
    }
  }

  // Получение всех услуг (для админки или отладки)
  static Stream<QuerySnapshot> getAllServices() {
    return _firestore.collection('services').snapshots();
  }

  ////////////////////////////////////////////////// Записи
  // Создание записи о записи
  static Future<void> createAppointment({
    required String appointmentId,
    required String userId,
    required String userName,
    required String serviceId,
    required Map<String, String> serviceName,
    required DateTime date,
    required DateTime startTime,
    required DateTime endTime,
    required String status,
  }) async {
    try {
      await _firestore.collection('appointments').doc(appointmentId).set({
        'appointmentId': appointmentId,
        'userId': userId,
        'userName': userName,
        'serviceId': serviceId,
        'serviceName': serviceName,
        'date': Timestamp.fromDate(date),
        'startTime': Timestamp.fromDate(startTime),
        'endTime': Timestamp.fromDate(endTime),
        'status': status,
        'createdAt': FieldValue.serverTimestamp(),
      });
      print('Запись успешно создана!');
    } catch (e) {
      print('Ошибка при создании записи: $e');
      rethrow;
    }
  }

// Метод для получения записей пользователя по UID
  static Stream<List<Appointment>> getUserAppointmentsStream(String userId) {
    return FirebaseFirestore.instance
        .collection('appointments')
        .where('userId', isEqualTo: userId)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              return Appointment.fromJson(doc.data()..['id'] = doc.id);
            }).toList());
  }

////////////////////////////////////////////////// Расписание
// Создание расписания
  static Future<void> createSchedule({
    required DateTime date,
    required Map<String, String> workingHours,
    required bool isDayOff,
    required Map<String, bool> availableSlots,
  }) async {
    try {
      // Формируем уникальный ID для документа (дата в формате YYYY-MM-DD)
      String dateId =
          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

      await _firestore.collection('schedule').doc(dateId).set({
        'date': Timestamp.fromDate(date),
        'workingHours': workingHours,
        'isDayOff': isDayOff,
        'availableSlots': availableSlots,
      });
      print('Расписание успешно создано!');
    } catch (e) {
      print('Ошибка при создании расписания: $e');
      rethrow;
    }
  }

// Получение расписания на определенную дату
  static Future<Schedule?> getScheduleByDate(DateTime date) async {
    try {
      String dateId =
          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      DocumentSnapshot doc =
          await _firestore.collection('schedule').doc(dateId).get();
      if (doc.exists) {
        return Schedule.fromJson(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print('Ошибка при получении расписания: $e');
      return null;
    }
  }

// Получение расписания на несколько дней
  static Stream<QuerySnapshot> getScheduleRange(
      DateTime startDate, DateTime endDate) {
    return _firestore
        .collection('schedule')
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
        .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endDate))
        .snapshots();
  }
}
