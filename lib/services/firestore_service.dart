import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:oksana_shik/models/user_model.dart';

class FirestoreService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
  static Future<User?> getUserById(String uid) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return User.fromMap(doc.data() as Map<String, dynamic>, uid);
      }
      return null;
    } catch (e) {
      print('Ошибка при получении пользователя: $e');
      return null;
    }
  }
}
