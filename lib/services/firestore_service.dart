// Импорты необходимых библиотек и моделей
import 'package:cloud_firestore/cloud_firestore.dart'; // Библиотека для работы с Firebase Firestore
import 'package:oksana_shik/models/schedule_model.dart'; // Модель расписания
import 'package:oksana_shik/models/user_model.dart'
    as user_model; // Модель пользователя с алиасом для избежания конфликта имён
import 'package:oksana_shik/models/service_model.dart'; // Модель услуги
import 'package:oksana_shik/models/category_model.dart'; // Модель категории
import 'package:oksana_shik/models/appointment_model.dart'; // Модель записи

// Класс, отвечающий за взаимодействие с базой данных Firestore
class FirestoreService {
  // Статический экземпляр Firestore для работы с базой данных
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  ////////////////////////////////////////////////// Пользователь
  // Метод создания нового пользователя в базе данных
  static Future<void> createUser({
    required String uid, // Уникальный идентификатор пользователя
    required String email, // Email пользователя
    required String fullName, // Полное имя пользователя
    required String phoneNumber, // Номер телефона пользователя
  }) async {
    try {
      // Добавляем документ в коллекцию 'users' с ID равным uid
      await _firestore.collection('users').doc(uid).set({
        'uid': uid, // Уникальный ID
        'email': email, // Email
        'fullName': fullName, // Полное имя
        'phoneNumber': phoneNumber, // Номер телефона
        'createdAt':
            FieldValue.serverTimestamp(), // Время создания записи (с сервера)
      });
      print('Пользователь успешно создан!'); // Вывод успешного сообщения
    } catch (e) {
      print('Ошибка при создании пользователя: $e'); // Вывод ошибки
      rethrow; // Переброс исключения
    }
  }

  // Метод получения информации о пользователе по его UID
  static Future<user_model.User?> getUserById(String uid) async {
    try {
      // Получаем документ из коллекции 'users' по указанному UID
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        // Если документ существует, преобразуем его в объект User
        return user_model.User.fromMap(doc.data() as Map<String, dynamic>, uid);
      }
      return null; // Возвращаем null, если пользователя нет
    } catch (e) {
      print('Ошибка при получении пользователя: $e'); // Вывод ошибки
      return null; // Возвращаем null в случае ошибки
    }
  }

  // Метод получения потока данных пользователя (реальное время обновления)
  static Stream<user_model.User?> getUserStreamById(String uid) {
    // Возвращаем поток изменений документа пользователя
    return _firestore.collection('users').doc(uid).snapshots().map((doc) {
      if (doc.exists) {
        // Преобразуем документ в объект User при каждом изменении
        return user_model.User.fromMap(doc.data() as Map<String, dynamic>, uid);
      }
      return null; // Возвращаем null, если документ не существует
    });
  }

  // Метод обновления данных пользователя
  static Future<void> updateUser({
    required String uid, // UID пользователя
    required String fullName, // Новое полное имя
    required String phoneNumber, // Новый номер телефона
  }) async {
    try {
      // Обновляем существующий документ пользователя
      await _firestore.collection('users').doc(uid).update({
        'fullName': fullName, // Обновляем имя
        'phoneNumber': phoneNumber, // Обновляем телефон
        'updatedAt': FieldValue
            .serverTimestamp(), // Устанавливаем время последнего обновления
      });
      print('Профиль успешно обновлен!'); // Вывод успешного сообщения
    } catch (e) {
      print('Ошибка при обновлении профиля: $e'); // Вывод ошибки
      rethrow; // Переброс исключения
    }
  }

  ////////////////////////////////////////////////// Категория
  // Метод создания новой категории
  static Future<void> createCategory({
    required String categoryId, // Уникальный ID категории
    required Map<String, String> name, // Название категории (на разных языках)
    required int order, // Порядковый номер для сортировки
    required bool isActive, // Активна ли категория
  }) async {
    try {
      // Добавляем документ в коллекцию 'categories'
      await _firestore.collection('categories').doc(categoryId).set({
        'categoryId': categoryId, // ID категории
        'name': name, // Название категории
        'order': order, // Порядок сортировки
        'isActive': isActive, // Статус активности
        'createdAt': FieldValue.serverTimestamp(), // Время создания
        'updatedAt':
            FieldValue.serverTimestamp(), // Время последнего обновления
      });
      print('Категория успешно создана!'); // Вывод успешного сообщения
    } catch (e) {
      print('Ошибка при создании категории: $e'); // Вывод ошибки
      rethrow; // Переброс исключения
    }
  }

  // Метод получения категории по ID
  static Future<Category?> getCategoryById(String categoryId) async {
    try {
      // Получаем документ из коллекции 'categories'
      DocumentSnapshot doc =
          await _firestore.collection('categories').doc(categoryId).get();
      if (doc.exists) {
        // Преобразуем документ в объект Category
        return Category.fromMap(doc.data() as Map<String, dynamic>, categoryId);
      }
      return null; // Возвращаем null, если категории нет
    } catch (e) {
      print('Ошибка при получении категории: $e'); // Вывод ошибки
      return null; // Возвращаем null в случае ошибки
    }
  }

  // Метод получения всех категорий (для админки или отладки)
  static Stream<QuerySnapshot> getAllCategories() {
    // Возвращаем поток всех документов из коллекции 'categories'
    return _firestore.collection('categories').snapshots();
  }

  ////////////////////////////////////////////////// Услуги
  // Метод создания новой услуги
  static Future<void> createService({
    required String serviceId, // Уникальный ID услуги
    required Map<String, String> title, // Название услуги (на разных языках)
    required Map<String, String> description, // Описание услуги
    required double price, // Цена услуги
    required int duration, // Продолжительность в минутах
    required String category, // ID категории услуги
    required bool isActive, // Активна ли услуга
  }) async {
    try {
      // Добавляем документ в коллекцию 'services'
      await _firestore.collection('services').doc(serviceId).set({
        'serviceId': serviceId, // ID услуги
        'title': title, // Название услуги
        'description': description, // Описание услуги
        'price': price, // Цена
        'duration': duration, // Продолжительность
        'category': category, // ID категории
        'isActive': isActive, // Статус активности
        'createdAt': FieldValue.serverTimestamp(), // Время создания
        'updatedAt':
            FieldValue.serverTimestamp(), // Время последнего обновления
      });
      print('Услуга успешно создана!'); // Вывод успешного сообщения
    } catch (e) {
      print('Ошибка при создании услуги: $e'); // Вывод ошибки
      rethrow; // Переброс исключения
    }
  }

  // Метод получения всех активных услуг
  static Stream<QuerySnapshot> getActiveServices() {
    // Возвращаем поток активных услуг
    return _firestore
        .collection('services')
        .where('isActive', isEqualTo: true) // Фильтр по активности
        .snapshots(); // Поток изменений
  }

  // Метод получения услуг по категории
  static Stream<QuerySnapshot> getServicesByCategory(String categoryId) {
    // Возвращаем поток услуг определенной категории
    return _firestore
        .collection('services')
        .where('category', isEqualTo: categoryId) // Фильтр по категории
        .where('isActive', isEqualTo: true) // Фильтр по активности
        .snapshots(); // Поток изменений
  }

  // Метод получения услуги по ID
  static Future<Service?> getServiceById(String serviceId) async {
    try {
      // Получаем документ из коллекции 'services'
      DocumentSnapshot doc =
          await _firestore.collection('services').doc(serviceId).get();
      if (doc.exists) {
        // Преобразуем документ в объект Service
        return Service.fromMap(doc.data() as Map<String, dynamic>, serviceId);
      }
      return null; // Возвращаем null, если услуги нет
    } catch (e) {
      print('Ошибка при получении услуги: $e'); // Вывод ошибки
      return null; // Возвращаем null в случае ошибки
    }
  }

  // Метод получения всех услуг (для админки или отладки)
  static Stream<QuerySnapshot> getAllServices() {
    // Возвращаем поток всех документов из коллекции 'services'
    return _firestore.collection('services').snapshots();
  }

  ////////////////////////////////////////////////// Записи
  // Метод создания записи о записи (запись клиента на услугу)
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

  // Метод получения всех записей (без фильтрации)
  static Stream<List<Appointment>> getAllAppointmentsStream() {
    return FirebaseFirestore.instance
        .collection('appointments')
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              final data = doc.data();
              // Создаем новый Map, включая ID документа
              final dataWithId = Map<String, dynamic>.from(data)
                ..['id'] = doc.id;
              // Преобразуем новую карту в объект Appointment
              return Appointment.fromJson(dataWithId);
            }).toList());
  }

  // Метод получения записей пользователя по UID
  static Stream<List<Appointment>> getUserAppointmentsStream(String userId) {
    return FirebaseFirestore.instance
        .collection('appointments')
        .where('userId', isEqualTo: userId)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              final data = doc.data();
              // Создаем новый Map, включая ID документа
              final dataWithId = Map<String, dynamic>.from(data)
                ..['id'] = doc.id;
              // Преобразуем новую карту в объект Appointment
              return Appointment.fromJson(dataWithId);
            }).toList());
  }

  ////////////////////////////////////////////////// Расписание
  // Метод создания расписания на день
  static Future<void> createSchedule({
    required DateTime date, // Дата расписания
    required Map<String, String> workingHours, // Рабочие часы
    required bool isDayOff, // Является ли день выходным
    required Map<String, bool> availableSlots, // Доступные временные слоты
  }) async {
    try {
      // Формируем уникальный ID для документа (формат YYYY-MM-DD)
      String dateId =
          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

      // Добавляем документ в коллекцию 'schedule'
      await _firestore.collection('schedule').doc(dateId).set({
        'date': Timestamp.fromDate(date), // Дата в формате Timestamp
        'workingHours': workingHours, // Рабочие часы
        'isDayOff': isDayOff, // Признак выходного дня
        'availableSlots': availableSlots, // Доступные временные слоты
      });
      print('Расписание успешно создано!'); // Вывод успешного сообщения
    } catch (e) {
      print('Ошибка при создании расписания: $e'); // Вывод ошибки
      rethrow; // Переброс исключения
    }
  }

  // Метод получения расписания на несколько дней
  static Stream<QuerySnapshot> getScheduleRange(
      DateTime startDate, DateTime endDate) {
    // Возвращаем поток документов в диапазоне дат
    return _firestore
        .collection('schedule')
        .where('date',
            isGreaterThanOrEqualTo:
                Timestamp.fromDate(startDate)) // Начальная дата
        .where('date',
            isLessThanOrEqualTo: Timestamp.fromDate(endDate)) // Конечная дата
        .snapshots(); // Поток изменений
  }

/////////////////////////////////////////////////// booking
// Метод для получения списка активных категорий, отсортированных по полю order
  static Future<List<Category>> getActiveCategories() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('categories')
          .where('isActive', isEqualTo: true)
          // .orderBy('order')
          .get();

      return snapshot.docs.map((doc) {
        return Category.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      print("Ошибка получения категорий: $e");
      return []; // Или выбросить исключение
    }
  }

// Метод для получения списка активных услуг, отфильтрованных по categoryId
  static Future<List<Service>> getActiveServicesByCategory(
      String categoryId) async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('services')
          .where('isActive', isEqualTo: true)
          .where('category', isEqualTo: categoryId)
          .get();

      return snapshot.docs.map((doc) {
        return Service.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      print("Ошибка получения услуг: $e");
      return []; // Или выбросить исключение
    }
  }

  // Метод получения расписания на определенную дату
  static Future<Schedule?> getScheduleByDate(DateTime date) async {
    try {
      // Формируем ID даты для поиска
      String dateId =
          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

      // Получаем документ из коллекции 'schedule'
      DocumentSnapshot doc =
          await _firestore.collection('schedule').doc(dateId).get();
      if (doc.exists) {
        // Преобразуем документ в объект Schedule
        return Schedule.fromJson(doc.data() as Map<String, dynamic>);
      }
      return null; // Возвращаем null, если расписания нет
    } catch (e) {
      print('Ошибка при получении расписания: $e'); // Вывод ошибки
      return null; // Возвращаем null в случае ошибки
    }
  }
}

/// Создает расписание на один конкретный день с жестко заданными параметрами.
/// Используется внутри generateScheduleForPeriod.
Future<void> _createScheduleForDay(DateTime date) async {
  try {
    // Определяем, выходной ли это день (суббота - 6, воскресенье - 7)
    bool isDayOff =
        (date.weekday == DateTime.saturday || date.weekday == DateTime.sunday);

    // Форматируем дату как строку для ID документа и поля date
    String formattedDate =
        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

    // Подготавливаем данные для записи
    Map<String, dynamic> scheduleData;

    if (isDayOff) {
      // Если выходной, создаем соответствующую запись
      scheduleData = {
        'date': Timestamp.fromDate(
            date), // Храним как строку, как в модели Schedule
        'workingHours': {'start': '00:00', 'end': '00:00'},
        'isDayOff': true,
        'availableSlots': {},
      };
    } else {
      // Если рабочий день, создаем с конкретными слотами
      scheduleData = {
        'date': Timestamp.fromDate(date),
        'workingHours': {'start': '09:00', 'end': '19:00'},
        'isDayOff': false,
        'availableSlots': {
          '09:00': true,
          '09:30': true,
          '10:00': true,
          '10:30': false, // Занято
          '11:00': true,
          '11:30': true,
          '12:00': true,
          '12:30': false, // Занято
          '13:00': true,
          '13:30': true,
          '14:00': true,
          '14:30': true,
          '15:00': true,
          '15:30': true,
          '16:00': true,
          '16:30': true,
          '17:00': true,
          '17:30': true,
          '18:00': true,
          '18:30': true
        },
      };
    }

    // Записываем данные в Firestore, используя отформатированную дату как ID документа
    await FirebaseFirestore.instance
        .collection('schedule')
        .doc(formattedDate)
        .set(scheduleData);

    print("Расписание для $formattedDate создано.");
  } catch (e) {
    print("Ошибка при создании расписания для ${date.toIso8601String()}: $e");
    rethrow; // Пробрасываем ошибку для обработки выше
  }
}

/// Генерирует расписание на период от startDate до endDate (включительно).

Future<void> generateScheduleForPeriod({
  required DateTime startDate,
  required DateTime endDate,
}) async {
  try {
    // Нормализуем даты до начала дня
    DateTime start = DateTime(startDate.year, startDate.month, startDate.day);
    DateTime end = DateTime(endDate.year, endDate.month, endDate.day);

    if (start.isAfter(end)) {
      throw Exception("Начальная дата должна быть меньше или равна конечной.");
    }

    // Используем WriteBatch для эффективности (до 500 операций)
    WriteBatch batch = FirebaseFirestore.instance.batch();
    int batchCounter = 0;
    int totalProcessed = 0;
    CollectionReference schedulesRef =
        FirebaseFirestore.instance.collection('schedule');

    DateTime currentDate = start;

    while (!currentDate.isAfter(end)) {
      // Для генерации по периоду мы используем _createScheduleForDay для каждой даты
      // Но так как batch.set требует Map, мы должны подготовить данные аналогично

      // Определяем, выходной ли это день
      bool isDayOff = (currentDate.weekday == DateTime.saturday ||
          currentDate.weekday == DateTime.sunday);
      String formattedDate =
          '${currentDate.year}-${currentDate.month.toString().padLeft(2, '0')}-${currentDate.day.toString().padLeft(2, '0')}';

      Map<String, dynamic> scheduleData;

      if (isDayOff) {
        scheduleData = {
          'date': Timestamp.fromDate(currentDate),
          'workingHours': {'start': '00:00', 'end': '00:00'},
          'isDayOff': true,
          'availableSlots': {},
        };
      } else {
        scheduleData = {
          'date': Timestamp.fromDate(currentDate),
          'workingHours': {'start': '09:00', 'end': '19:00'},
          'isDayOff': false,
          'availableSlots': {
            '09:00': true,
            '09:30': true,
            '10:00': true,
            '10:30': false, // Занято
            '11:00': true,
            '11:30': true,
            '12:00': true,
            '12:30': false, // Занято
            '13:00': true,
            '13:30': true,
            '14:00': true,
            '14:30': true,
            '15:00': true,
            '15:30': true,
            '16:00': true,
            '16:30': true,
            '17:00': true,
            '17:30': true,
            '18:00': true,
            '18:30': true
          },
        };
      }

      DocumentReference docRef = schedulesRef.doc(formattedDate);
      batch.set(docRef, scheduleData);

      batchCounter++;
      totalProcessed++;

      // Отправляем батч каждые 500 операций
      if (batchCounter == 500) {
        print("Отправка батча ($totalProcessed записей)...");
        await batch.commit();
        batch = FirebaseFirestore.instance.batch(); // Создаем новый батч
        batchCounter = 0;
      }

      currentDate = currentDate.add(const Duration(days: 1));
    }

    // Отправляем оставшиеся операции
    if (batchCounter > 0) {
      print("Отправка финального батча ($batchCounter записей)...");
      await batch.commit();
    }

    print(
        "Генерация расписания завершена. Период: с $start по $end. Всего дней: $totalProcessed");
  } catch (e) {
    print("Ошибка при генерации расписания на период: $e");
    rethrow;
  }
}
