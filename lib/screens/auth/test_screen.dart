// lib/screens/auth/test_screen.dart
import 'package:flutter/material.dart';
import 'package:oksana_shik/utils/theme.dart';
import 'package:oksana_shik/services/firestore_service.dart';

class TestScreen extends StatelessWidget {
  const TestScreen({super.key});

  // Функция для создания коллекции users в Firestore
  void createUsersCollection(BuildContext context) async {
    try {
      // Создаем тестового пользователя (для демонстрации)
      await FirestoreService.createUser(
        uid: 'test_user', // Уникальный ID пользователя
        email: 'test@example.com',
        fullName: 'Тестовый Пользователь',
        phoneNumber: '+71234567890',
      );
      // Показываем сообщение об успешном создании
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Коллекция users создана!')),
      );
    } catch (e) {
      // Показываем сообщение об ошибке
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка: $e')),
      );
    }
  }

  // Функция для создания коллекции categories
  void createCategoriesCollection(BuildContext context) async {
    try {
      // Создаем тестовую категорию
      await FirestoreService.createCategory(
        categoryId: 'female_001',
        name: {'ru': 'Женская', 'en': 'Female'},
        order: 1,
        isActive: true,
      );
      // Показываем сообщение об успешном создании
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Коллекция categories создана!')),
      );
    } catch (e) {
      // Показываем сообщение об ошибке
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка: $e')),
      );
    }
  }

  // Функция для создания коллекции services
  void createServicesCollection(BuildContext context) async {
    try {
      // Создаем тестовый сервис
      await FirestoreService.createService(
        serviceId: 'svc_test_001',
        title: {'ru': 'Стрижка', 'en': 'haircut'},
        description: {
          'ru': 'Стрижка женская короткий волос',
          'en': 'Women\'s haircut short hair'
        },
        price: 1000,
        duration: 60,
        category: 'female_001', // Ссылка на созданную категорию
        isActive: true,
      );
      // Показываем сообщение об успешном создании
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Коллекция services создана!')),
      );
    } catch (e) {
      // Показываем сообщение об ошибке
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка: $e')),
      );
    }
  }

// Функция для создания коллекции записей
  void createAppointmentsCollection(BuildContext context) async {
    try {
      // Сначала проверим, что пользователь и услуга существуют
      // Создаем записи
      await FirestoreService.createAppointment(
        appointmentId: 'apt_001',
        userId: 'test_user_001', // Убедись, что такой пользователь существует
        userName: 'Тестовый Пользователь',
        serviceId: 'svc_w_001', // Убедись, что такая услуга существует
        serviceName: {
          'ru': 'Стрижка женская короткий',
          'en': 'Women\'s Short Haircut'
        },
        date: DateTime(2025, 8, 15),
        startTime: DateTime(2025, 8, 15, 10, 0),
        endTime: DateTime(2025, 8, 15, 11, 0),
        status: 'confirmed',
      );

      // Создаем еще одну запись
      await FirestoreService.createAppointment(
        appointmentId: 'apt_002',
        userId: 'test_user_001',
        userName: 'Тестовый Пользователь',
        serviceId: 'svc_m_001',
        serviceName: {
          'ru': 'Стрижка мужская короткий',
          'en': 'Men\'s Short Haircut'
        },
        date: DateTime(2025, 8, 20),
        startTime: DateTime(2025, 8, 20, 14, 30),
        endTime: DateTime(2025, 8, 20, 15, 30),
        status: 'confirmed',
      );

      // Показываем сообщение об успешном создании
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Коллекция appointments создана!')),
      );
    } catch (e) {
      // Показываем сообщение об ошибке
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка: $e')),
      );
    }
  }

// Функция для создания коллекции Schedule
  void createScheduleCollection(BuildContext context) async {
    try {
      // Создаем расписание на несколько дней
      await FirestoreService.createSchedule(
          date: DateTime(2025, 8, 15), // Сегодня
          workingHours: {'start': '09:00', 'end': '19:00'},
          isDayOff: false,
          availableSlots: {
            '09:00': true,
            '09:30': true,
            '10:00': true,
            '10:30': false,
            '11:00': true,
            '11:30': true,
            '12:00': true,
            '12:30': false,
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
          });

      await FirestoreService.createSchedule(
          date: DateTime(2025, 8, 16), // Завтра
          workingHours: {'start': '09:00', 'end': '19:00'},
          isDayOff: false,
          availableSlots: {
            '09:00': true,
            '09:30': true,
            '10:00': true,
            '10:30': true,
            '11:00': true,
            '11:30': true,
            '12:00': true,
            '12:30': true,
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
          });

      // Создаем выходной день
      await FirestoreService.createSchedule(
          date: DateTime(2025, 8, 23), // Выходной
          workingHours: {'start': '00:00', 'end': '00:00'},
          isDayOff: true,
          availableSlots: {});

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Коллекция schedule создана!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка: $e')),
      );
    }
  }

//создание данных для таблиц
  void createTestData(BuildContext context) async {
    try {
      // Сначала создаем категории
      await FirestoreService.createCategory(
        categoryId: 'cat_female_001',
        name: {'ru': 'Женские стрижки', 'en': 'Women\'s Haircuts'},
        order: 1,
        isActive: true,
      );
      await FirestoreService.createCategory(
        categoryId: 'cat_male_002',
        name: {'ru': 'Мужские стрижки', 'en': 'Men\'s Haircuts'},
        order: 2,
        isActive: true,
      );
      await FirestoreService.createCategory(
        categoryId: 'cat_coloring_003',
        name: {'ru': 'Окрашивание', 'en': 'Coloring'},
        order: 3,
        isActive: true,
      );
      await FirestoreService.createCategory(
        categoryId: 'cat_styling_004',
        name: {'ru': 'Укладки', 'en': 'Styling'},
        order: 4,
        isActive: true,
      );
      // Создаем множество услуг
      List<Map<String, dynamic>> services = [
        // Женские стрижки
        {
          'serviceId': 'svc_w_001',
          'title': {
            'ru': 'Стрижка женская короткий',
            'en': 'Women\'s Short Haircut'
          },
          'description': {
            'ru': 'Качественная стрижка коротких волос',
            'en': 'Quality haircut for short hair'
          },
          'price': 1500.0,
          'duration': 45,
          'category': 'cat_female_001',
          'isActive': true,
        },
        {
          'serviceId': 'svc_w_002',
          'title': {
            'ru': 'Стрижка женская средний',
            'en': 'Women\'s Medium Haircut'
          },
          'description': {
            'ru': 'Стрижка средних волос',
            'en': 'Medium length hair cut'
          },
          'price': 2000.0,
          'duration': 60,
          'category': 'cat_female_001',
          'isActive': true,
        },
        {
          'serviceId': 'svc_w_003',
          'title': {
            'ru': 'Стрижка женская длинный',
            'en': 'Women\'s Long Haircut'
          },
          'description': {
            'ru': 'Стрижка длинных волос',
            'en': 'Long hair haircut'
          },
          'price': 2500.0,
          'duration': 75,
          'category': 'cat_female_001',
          'isActive': true,
        },

        // Мужские стрижки
        {
          'serviceId': 'svc_m_001',
          'title': {
            'ru': 'Стрижка мужская короткий',
            'en': 'Men\'s Short Haircut'
          },
          'description': {
            'ru': 'Качественная мужская стрижка',
            'en': 'Quality men\'s haircut'
          },
          'price': 1200.0,
          'duration': 30,
          'category': 'cat_male_002',
          'isActive': true,
        },
        {
          'serviceId': 'svc_m_002',
          'title': {
            'ru': 'Стрижка мужская средний',
            'en': 'Men\'s Medium Haircut'
          },
          'description': {
            'ru': 'Мужская стрижка средней длины',
            'en': 'Medium length men\'s haircut'
          },
          'price': 1800.0,
          'duration': 45,
          'category': 'cat_male_002',
          'isActive': true,
        },

        // Окрашивание
        {
          'serviceId': 'svc_c_001',
          'title': {
            'ru': 'Окрашивание короткие волосы',
            'en': 'Coloring Short Hair'
          },
          'description': {
            'ru': 'Полное окрашивание коротких волос',
            'en': 'Full coloring for short hair'
          },
          'price': 3500.0,
          'duration': 90,
          'category': 'cat_coloring_003',
          'isActive': true,
        },
        {
          'serviceId': 'svc_c_002',
          'title': {
            'ru': 'Окрашивание средние волосы',
            'en': 'Coloring Medium Hair'
          },
          'description': {
            'ru': 'Окрашивание средних волос',
            'en': 'Coloring medium length hair'
          },
          'price': 4500.0,
          'duration': 120,
          'category': 'cat_coloring_003',
          'isActive': true,
        },
        {
          'serviceId': 'svc_c_003',
          'title': {
            'ru': 'Окрашивание длинные волосы',
            'en': 'Coloring Long Hair'
          },
          'description': {
            'ru': 'Окрашивание длинных волос',
            'en': 'Coloring long hair'
          },
          'price': 5500.0,
          'duration': 150,
          'category': 'cat_coloring_003',
          'isActive': true,
        },

        // Укладки
        {
          'serviceId': 'svc_s_001',
          'title': {'ru': 'Укладка вечерняя', 'en': 'Evening Styling'},
          'description': {
            'ru': 'Профессиональная вечерняя укладка',
            'en': 'Professional evening styling'
          },
          'price': 2000.0,
          'duration': 45,
          'category': 'cat_styling_004',
          'isActive': true,
        },
        {
          'serviceId': 'svc_s_002',
          'title': {'ru': 'Укладка повседневная', 'en': 'Daily Styling'},
          'description': {
            'ru': 'Повседневная укладка для ежедневного ношения',
            'en': 'Daily styling for everyday wear'
          },
          'price': 1500.0,
          'duration': 30,
          'category': 'cat_styling_004',
          'isActive': true,
        },
      ];

      // Создаем все услуги
      for (var service in services) {
        await FirestoreService.createService(
          serviceId: service['serviceId'],
          title: service['title'],
          description: service['description'],
          price: service['price'],
          duration: service['duration'],
          category: service['category'],
          isActive: service['isActive'],
        );
      }

      // Создаем тестовых пользователей
      await FirestoreService.createUser(
        uid: 'user_test_001',
        email: 'ivan@example.com',
        fullName: 'Иван Петров',
        phoneNumber: '+79991234567',
      );

      await FirestoreService.createUser(
        uid: 'user_test_002',
        email: 'maria@example.com',
        fullName: 'Мария Сидорова',
        phoneNumber: '+79991234568',
      );

      //создаем записи клиентов
      List<Map<String, dynamic>> appointments = [
        {
          'appointmentId': 'apt_001',
          'userId': '1wCj8dGDBGPQb2Di7vihPmrHxfs1',
          'userName': 'Nika',
          'serviceId': 'svc_w_001',
          'serviceName': {
            'ru': 'Стрижка женская короткий',
            'en': 'Women\'s Short Haircut'
          },
          'date': DateTime(2025, 8, 15),
          'startTime': DateTime(2025, 8, 15, 10, 0),
          'endTime': DateTime(2025, 8, 15, 11, 0),
          'status': 'confirmed',
        },
        {
          'appointmentId': 'apt_002',
          'userId': '1wCj8dGDBGPQb2Di7vihPmrHxfs1',
          'userName': 'Nika',
          'serviceId': 'svc_m_001',
          'serviceName': {
            'ru': 'Стрижка мужская короткий',
            'en': 'Men\'s Short Haircut'
          },
          'date': DateTime(2025, 8, 20),
          'startTime': DateTime(2025, 8, 20, 14, 30),
          'endTime': DateTime(2025, 8, 20, 15, 30),
          'status': 'confirmed',
        },
        {
          'appointmentId': 'apt_003',
          'userId': '1wCj8dGDBGPQb2Di7vihPmrHxfs1',
          'userName': 'Nika',
          'serviceId': 'svc_c_001',
          'serviceName': {
            'ru': 'Окрашивание короткие волосы',
            'en': 'Coloring Short Hair'
          },
          'date': DateTime(2025, 8, 25),
          'startTime': DateTime(2025, 8, 25, 11, 0),
          'endTime': DateTime(2025, 8, 25, 12, 30),
          'status': 'completed',
        },
      ];

      //Создаем все записи
      for (var appointment in appointments) {
        await FirestoreService.createAppointment(
          appointmentId: appointment['appointmentId'],
          userId: appointment['userId'],
          userName: appointment['userName'],
          serviceId: appointment['serviceId'],
          serviceName: appointment['serviceName'],
          date: appointment['date'],
          startTime: appointment['startTime'],
          endTime: appointment['endTime'],
          status: appointment['status'],
        );
      }

      // Показываем сообщение об успешном создании
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('База данных успешно наполнена!')),
      );
    } catch (e) {
      // Показываем сообщение об ошибке
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка при создании данных: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Тест базы данных'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: AppTheme.backgroundColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Здесь можно тестировать создание таблиц базы данных',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // кнопки коллекций
              const SizedBox(height: 10),
              const Text(
                'Коллекции',
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              // Кнопка для создания коллекции users
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () => createUsersCollection(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, // Синий цвет
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Создать коллекцию users'),
                ),
              ),
              const SizedBox(height: 20),
              // Кнопка для создания коллекции categories
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () => createCategoriesCollection(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green, // Зеленый цвет
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Создать коллекцию categories'),
                ),
              ),
              const SizedBox(height: 20),
              // Кнопка для создания коллекции services
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () => createServicesCollection(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange, // Оранжевый цвет
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Создать коллекцию services'),
                ),
              ),
              const SizedBox(height: 20),
              //Кнопка для создания коллекции Appointment
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () => createAppointmentsCollection(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow[400], // Желтый цвет
                    foregroundColor: Colors.grey,
                  ),
                  child: const Text('Создать коллекцию appointments'),
                ),
              ),
              const SizedBox(height: 10),
              // Кнопка для создания коллекции schedule
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () => createScheduleCollection(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown, // Коричневый цвет
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Создать коллекцию schedule'),
                ),
              ),
//кнопки данных
              const SizedBox(height: 50),
              const Text(
                'Данные',
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              // Наполяем базу данных
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () => createTestData(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple, // Фиолетовый цвет
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Наполнить базу данных'),
                ),
              ),
              const SizedBox(height: 20),
              // Кнопка для перехода обратно
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    // Возвращаемся на экран входа
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey, // Серый цвет
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Назад к входу'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
