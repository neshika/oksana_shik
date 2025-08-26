// lib/services/appointment_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:oksana_shik/models/appointment_model.dart'; // Модель записи

class AppointmentService {
  final CollectionReference _appointmentsCollection =
      FirebaseFirestore.instance.collection('appointments');

  // 1. CREATE - Создать новую запись
  Future<void> createAppointment(Appointment appointment) async {
    try {
      await _appointmentsCollection
          .doc(appointment.appointmentId) // Используем ID из модели
          .set(appointment.toJson());
    } catch (e) {
      // TODO: Обработка ошибок (например, логирование или выброс кастомного исключения)
      print('Ошибка при создании записи: $e');
      rethrow;
    }
  }

  // 2. READ (GET) - Получить запись по ID
  Future<Appointment?> getAppointment(String appointmentId) async {
    try {
      DocumentSnapshot docSnapshot =
          await _appointmentsCollection.doc(appointmentId).get();

      if (docSnapshot.exists) {
        return Appointment.fromJson(docSnapshot.data() as Map<String, dynamic>);
      } else {
        return null; // Запись не найдена
      }
    } catch (e) {
      // TODO: Обработка ошибок
      print('Ошибка при получении записи: $e');
      rethrow;
    }
  }

  // 3. UPDATE - Обновить запись
  Future<void> updateAppointment(Appointment appointment) async {
    try {
      await _appointmentsCollection
          .doc(appointment.appointmentId)
          .update(appointment.toJson());
    } catch (e) {
      // TODO: Обработка ошибок (например, проверка, существует ли документ)
      print('Ошибка при обновлении записи: $e');
      rethrow;
    }
  }

  // 4. DELETE - Удалить запись
  Future<void> deleteAppointment(String appointmentId) async {
    try {
      await _appointmentsCollection.doc(appointmentId).delete();
    } catch (e) {
      // TODO: Обработка ошибок (например, проверка, существует ли документ)
      print('Ошибка при удалении записи: $e');
      rethrow;
    }
  }

  // 2. Получение всех записей без фильтра
  Stream<List<Appointment>> getAllAppointmentsStream() {
    try {
      return _appointmentsCollection
          .orderBy('createdAt', descending: true) // Сортировка по дате создания
          .snapshots()
          .map((QuerySnapshot querySnapshot) {
        return querySnapshot.docs.map((doc) {
          return Appointment.fromJson(doc.data() as Map<String, dynamic>);
        }).toList();
      });
    } catch (e) {
      // TODO: Обработка ошибок
      print('Ошибка при получении всех записей: $e');
      rethrow;
    }
  }

  // Альтернатива: Получение всех записей как Future (однократное получение)
  Future<List<Appointment>> getAllAppointmentsOnce() async {
    try {
      QuerySnapshot querySnapshot = await _appointmentsCollection
          .orderBy('createdAt', descending: true)
          .get();
      return querySnapshot.docs.map((doc) {
        return Appointment.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      print('Ошибка при однократном получении всех записей: $e');
      rethrow;
    }
  }

  // 3. Получение записей по ID пользователя
  Stream<List<Appointment>> getAppointmentsByUserIdStream(String userId) {
    try {
      return _appointmentsCollection
          .where('userId', isEqualTo: userId)
          //  .orderBy('date') // Сортировка по дате встречи
          //  .orderBy('startTime') // Затем по времени начала
          .snapshots()
          .map((QuerySnapshot querySnapshot) {
        return querySnapshot.docs.map((doc) {
          return Appointment.fromJson(doc.data() as Map<String, dynamic>);
        }).toList();
      });
    } catch (e) {
      print('Ошибка при получении записей по userId: $e');
      rethrow;
    }
  }

  // 3. Получение записей по дате (например, все записи на конкретный день)
  // В Firestore удобнее фильтровать по диапазону дат (начало и конец дня)
  Stream<List<Appointment>> getAppointmentsByDateStream(DateTime date) {
    try {
      // Создаем начало и конец дня для фильтрации
      DateTime startOfDay = DateTime(date.year, date.month, date.day);
      DateTime endOfDay =
          DateTime(date.year, date.month, date.day, 23, 59, 59, 999);

      return _appointmentsCollection
          .where('date', isGreaterThanOrEqualTo: startOfDay)
          .where('date', isLessThan: endOfDay)
          //.orderBy('date')
          // .orderBy('startTime')
          .snapshots()
          .map((QuerySnapshot querySnapshot) {
        return querySnapshot.docs.map((doc) {
          return Appointment.fromJson(doc.data() as Map<String, dynamic>);
        }).toList();
      });
    } catch (e) {
      print('Ошибка при получении записей по дате: $e');
      rethrow;
    }
  }

  // 3. Комбинированный фильтр: записи по пользователю и дате
  Stream<List<Appointment>> getAppointmentsByUserAndDateStream(
      String userId, DateTime date) {
    try {
      DateTime startOfDay = DateTime(date.year, date.month, date.day);
      DateTime endOfDay =
          DateTime(date.year, date.month, date.day, 23, 59, 59, 999);

      return _appointmentsCollection
          .where('userId', isEqualTo: userId)
          .where('date', isGreaterThanOrEqualTo: startOfDay)
          .where('date', isLessThan: endOfDay)
          // .orderBy('date')
          //  .orderBy('startTime')
          .snapshots()
          .map((QuerySnapshot querySnapshot) {
        return querySnapshot.docs.map((doc) {
          return Appointment.fromJson(doc.data() as Map<String, dynamic>);
        }).toList();
      });
    } catch (e) {
      print('Ошибка при получении записей по userId и дате: $e');
      rethrow;
    }
  }

  // Дополнительно: Получение записей по статусу
  Stream<List<Appointment>> getAppointmentsByStatusStream(String status) {
    try {
      return _appointmentsCollection
          .where('status', isEqualTo: status)
          .orderBy('date')
          //.orderBy('startTime')
          .snapshots()
          .map((QuerySnapshot querySnapshot) {
        return querySnapshot.docs.map((doc) {
          return Appointment.fromJson(doc.data() as Map<String, dynamic>);
        }).toList();
      });
    } catch (e) {
      print('Ошибка при получении записей по статусу: $e');
      rethrow;
    }
  }

  // НОВЫЙ МЕТОД: Получение записей по ID пользователя и статусу
  Stream<List<Appointment>> getAppointmentsByUserIdAndStatusStream(
      String userId, String status) {
    try {
      return _appointmentsCollection
          .where('userId', isEqualTo: userId)
          .where('status', isEqualTo: status) // Фильтр по статусу
          // .orderBy('date') // Можно добавить сортировку, если нужно
          // .orderBy('startTime')
          .snapshots()
          .map((QuerySnapshot querySnapshot) {
        return querySnapshot.docs.map((doc) {
          return Appointment.fromJson(doc.data() as Map<String, dynamic>);
        }).toList();
      });
    } catch (e) {
      print('Ошибка при получении записей по userId и статусу: $e');
      rethrow;
    }
  }
}
