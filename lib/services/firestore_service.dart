import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:oksana_shik/models/user_model.dart' as UserModel;
import 'package:oksana_shik/models/service_model.dart';
import 'package:oksana_shik/models/category_model.dart';

class FirestoreService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /************************************** Пользователь*/
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
  static Future<UserModel.User?> getUserById(String uid) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return UserModel.User.fromMap(doc.data() as Map<String, dynamic>, uid);
      }
      return null;
    } catch (e) {
      print('Ошибка при получении пользователя: $e');
      return null;
    }
  }

  // Получение потока данных пользователя по UID
  static Stream<UserModel.User?> getUserStreamById(String uid) {
    return _firestore.collection('users').doc(uid).snapshots().map((doc) {
      if (doc.exists) {
        return UserModel.User.fromMap(doc.data() as Map<String, dynamic>, uid);
      }
      return null;
    });
  }

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

/************************************** Категория*/
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

/************************************** Услуга*/
  // Создание услуги
  static Future<void> createService({
    required String serviceId,
    required Map<String, String> title,
    required Map<String, String> description,
    required double price,
    required int duration,
    required String category,
    required bool isActive,
    String? imageUrl,
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
        'imageUrl': imageUrl,
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
}
