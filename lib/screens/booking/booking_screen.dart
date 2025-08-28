// lib/screens/booking/booking_screen.dart

// Импортируем необходимые библиотеки
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Для работы с Timestamp
import 'package:firebase_auth/firebase_auth.dart'; // Для получения текущего пользователя
import 'package:oksana_shik/models/category_model.dart'; // Модель категории
import 'package:oksana_shik/models/service_model.dart'; // Модель услуги
import 'package:oksana_shik/models/schedule_model.dart'; // Модель расписания
import 'package:oksana_shik/services/firestore_service.dart';
import 'package:oksana_shik/models/user_model.dart'
    as user_model; // Используем алиас

// Определяем виджет BookingScreen как StatefulWidget, потому что он будет иметь изменяющееся состояние
// (например, выбранная категория, выбранная услуга, выбранная дата)
class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

// Состояние виджета BookingScreen
class _BookingScreenState extends State<BookingScreen> {
  // --- Переменные состояния ---
  List<Category> _categories = []; // Список для хранения категорий
  List<Service> _services = []; // Список для хранения услуг
  String? _selectedCategoryId; // ID выбранной категории
  String? _selectedServiceId; // ID выбранной услуги
  DateTime? _selectedDate; // Выбранная дата
  Schedule? _currentSchedule; // Объект расписания для выбранной даты
  String? _selectedTimeSlot; // Выбранное время
  bool _isLoadingCategories = true; // Флаг загрузки категорий
  bool _isLoadingServices = false; // Флаг загрузки услуг
  bool _isLoadingSchedule = false; // Флаг загрузки расписания

  // --- Методы жизненного цикла ---
  @override
  void initState() {
    super.initState();
    _loadCategories(); // При инициализации экрана загружаем категории
  }

  // --- Методы для загрузки данных ---

  // Метод для загрузки категорий из Firestore
  Future<void> _loadCategories() async {
    setState(() {
      _isLoadingCategories = true; // Показываем индикатор загрузки
    });
    try {
      // Вызываем метод из нашего сервиса FirestoreService
      List<Category> categories = await FirestoreService.getActiveCategories();
      setState(() {
        _categories = categories;
        _isLoadingCategories = false;
        // Автоматически выбираем первую категорию, если она есть
        if (_categories.isNotEmpty) {
          _selectedCategoryId = _categories.first.categoryId;
          _loadServices(
              _selectedCategoryId!); // Загружаем услуги для первой категории
        }
      });
    } catch (e) {
      print("Ошибка загрузки категорий: $e");
      setState(() {
        _isLoadingCategories = false;
      });
      // Здесь можно показать SnackBar с сообщением об ошибке
    }
  }

  // Метод для загрузки услуг по ID категории
  Future<void> _loadServices(String categoryId) async {
    setState(() {
      _isLoadingServices = true; // Показываем индикатор загрузки услуг
      _services = []; // Очищаем список услуг перед загрузкой новых
      _selectedServiceId = null; // Сбрасываем выбранную услугу
      _selectedDate = null; // Сбрасываем выбранную дату
      _currentSchedule = null; // Сбрасываем расписание
      _selectedTimeSlot = null; // Сбрасываем выбранное время
    });
    try {
      List<Service> services =
          await FirestoreService.getActiveServicesByCategory(categoryId);
      setState(() {
        _services = services;
        _isLoadingServices = false;
      });
    } catch (e) {
      print("Ошибка загрузки услуг: $e");
      setState(() {
        _isLoadingServices = false;
      });
      // Здесь можно показать SnackBar с сообщением об ошибке
    }
  }

  // Метод для загрузки расписания по дате
  Future<void> _loadSchedule(DateTime date) async {
    setState(() {
      _isLoadingSchedule = true; // Показываем индикатор загрузки расписания
      _currentSchedule = null; // Сбрасываем предыдущее расписание
      _selectedTimeSlot = null; // Сбрасываем выбранное время при смене даты
    });
    try {
      Schedule? schedule = await FirestoreService.getScheduleByDate(date);
      setState(() {
        _currentSchedule = schedule;
        _isLoadingSchedule = false;
      });
    } catch (e) {
      print("Ошибка загрузки расписания: $e");
      setState(() {
        _isLoadingSchedule = false;
      });
      // Здесь можно показать SnackBar с сообщением об ошибке
    }
  }

  // --- Методы для обработки взаимодействия пользователя ---

  // Метод для выбора категории
  void _onCategorySelected(String categoryId) {
    setState(() {
      _selectedCategoryId = categoryId;
      // При смене категории перезагружаем список услуг
      _loadServices(categoryId);
    });
  }

  // Метод для выбора услуги
  void _onServiceSelected(String serviceId) {
    setState(() {
      _selectedServiceId = serviceId;
    });
  }

  // Метод для выбора даты через DatePicker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(), // Нельзя выбрать прошедшую дату
      lastDate: DateTime.now()
          .add(Duration(days: 365)), // Ограничиваем выбор на год вперед
      locale: Locale('ru', 'RU'), // Устанавливаем русскую локаль для календаря
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        // При выборе даты загружаем соответствующее расписание
        _loadSchedule(picked);
      });
    }
  }

  // Метод для выбора временного слота
  void _onTimeSlotSelected(String timeSlot) {
    setState(() {
      _selectedTimeSlot = timeSlot;
    });
  }

// Метод для обработки нажатия кнопки "Записаться"
  Future<void> _bookAppointment() async {
    // 1. Проверка: Убедимся, что пользователь выбрал услугу, дату и время.
    if (_selectedServiceId == null ||
        _selectedDate == null ||
        _selectedTimeSlot == null) {
      // Если что-то не выбрано, показываем сообщение и прерываем выполнение.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Пожалуйста, выберите услугу, дату и время.')),
      );
      return;
    }

    // 2. Получение данных пользователя: Нужно знать, кто записывается.
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // Если пользователь каким-то образом не авторизован, сообщаем об ошибке.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка: пользователь не авторизован.')),
      );
      return;
    }

    // 3. Получение данных выбранной услуги: Нам понадобится информация об услуге.
    final Service? selectedService =
        await FirestoreService.getServiceById(_selectedServiceId!);
    if (selectedService == null) {
      // Если услуга не найдена (например, была удалена), сообщаем об ошибке.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Выбранная услуга не найдена.')),
      );
      return;
    }

    // 4. Получение данных пользователя из Firestore: Нам нужно его имя.
    final user_model.User? currentUserData =
        await FirestoreService.getUserById(user.uid);
    if (currentUserData == null) {
      // Если профиль пользователя не найден, сообщаем об ошибке.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Информация о пользователе не найдена.')),
      );
      return;
    }

    // 5. Показываем индикатор прогресса, чтобы пользователь понимал, что идет процесс.
    showDialog(
      context: context,
      barrierDismissible: false, // Запрещаем закрытие диалога тапом вне его
      builder: (BuildContext context) {
        return AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text("Создание записи..."),
            ],
          ),
        );
      },
    );

    try {
      // 6. Загружаем актуальное расписание для выбранной даты.
      // Это важно, чтобы убедиться, что слот все еще доступен.
      Schedule? currentSchedule =
          await FirestoreService.getScheduleByDate(_selectedDate!);

      // 6.1. Проверка существования расписания
      if (currentSchedule == null) {
        Navigator.of(context).pop(); // Закрываем диалог прогресса
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Расписание на выбранную дату отсутствует. Пожалуйста, выберите другую дату.')),
        );
        return; // Прерываем процесс записи
      }

      // 6.2. Проверяем, является ли день выходным
      if (currentSchedule.isDayOff) {
        Navigator.of(context).pop(); // Закрываем диалог прогресса
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Выбранная дата является выходным днем. Пожалуйста, выберите другую дату.')),
        );
        return; // Прерываем процесс записи
      }

      // 6.3. Проверяем доступность конкретного временного слота
      bool isSlotAvailable =
          currentSchedule.availableSlots[_selectedTimeSlot!] ??
              false; // Если ключа нет, считаем недоступным

      if (!isSlotAvailable) {
        Navigator.of(context).pop(); // Закрываем диалог прогресса
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Выбранное время больше недоступно. Пожалуйста, выберите другое.')),
        );
        return; // Прерываем процесс записи
      }

      // 7. Подготовка данных для создания записи
      // 7.1. Рассчитываем время начала и окончания на основе выбранного слота и продолжительности услуги
      // Предполагается, что _selectedTimeSlot это строка в формате "HH:mm"
      List<String> timeParts = _selectedTimeSlot!.split(':');
      int startHour = int.parse(timeParts[0]);
      int startMinute = int.parse(timeParts[1]);

      DateTime appointmentStartDate = DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
        startHour,
        startMinute,
      );
      DateTime appointmentEndDate = appointmentStartDate.add(Duration(
          minutes: selectedService.duration)); // Добавляем продолжительность

      // 7.2. Создаем Map для нового документа в коллекции 'appointments'
      // Используем структуру, совместимую с FirestoreService.createAppointment
      Map<String, dynamic> appointmentData = {
        'appointmentId': '', // Будет установлен при добавлении в Firestore
        'userId': user.uid,
        'userName': currentUserData.fullName ??
            'Пользователь', // Имя из профиля пользователя
        'serviceId': _selectedServiceId,
        'serviceName': selectedService.title, // Название услуги
        'date': Timestamp.fromDate(_selectedDate!),
        'startTime': Timestamp.fromDate(appointmentStartDate),
        'endTime': Timestamp.fromDate(appointmentEndDate),
        'status': 'pending', // Начальный статус "ожидание"
        'createdAt': Timestamp.now(),
        // Можно добавить другие поля, например, информацию об услуге на момент записи
      };

      // 8. Создаем запись в Firestore
      // Используем add(), чтобы Firestore сам сгенерировал ID документа
      DocumentReference newAppointmentRef =
          await FirebaseFirestore.instance.collection('appointments').add(
                appointmentData
                  ..remove('appointmentId'), // Удаляем пустой appointmentId
              );
      // Обновляем appointmentData с реальным ID для последующего использования, если нужно
      appointmentData['appointmentId'] = newAppointmentRef.id;

      // 9. Обновляем расписание, делая слот недоступным
      // Важно: используем правильное имя коллекции 'schedule' и формат ID даты
      String scheduleDocId =
          '${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}';

      await FirebaseFirestore.instance
          .collection(
              'schedule') // Используем 'schedule' (единственное число), как в FirestoreService
          .doc(
              scheduleDocId) // Используем строковый ID, сформированный по правилам FirestoreService
          .update({
        'availableSlots.${_selectedTimeSlot}': false,
      });

      Navigator.of(context).pop(); // Закрываем диалог прогресса

      // 10. Показываем сообщение об успехе
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Запись успешно создана!')),
      );
      // Можно закрыть экран или перейти на экран подтверждения
      Navigator.of(context).pop(); // Закрываем экран записи
    } catch (e) {
      Navigator.of(context).pop(); // Закрываем диалог прогресса в случае ошибки
      print("Ошибка при создании записи: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка при создании записи: ${e.toString()}')),
      );
    }
  }
  // --- Методы построения UI ---

  // Метод для построения виджета списка категорий
  Widget _buildCategoryList() {
    if (_isLoadingCategories) {
      return Center(child: CircularProgressIndicator());
    }
    if (_categories.isEmpty) {
      return Center(child: Text('Категории не найдены'));
    }
    return SizedBox(
      height: 50, // Фиксированная высота для строки категорий
      child: ListView.builder(
        scrollDirection: Axis.horizontal, // Горизонтальная прокрутка
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          Category category = _categories[index];
          bool isSelected = category.categoryId == _selectedCategoryId;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: ChoiceChip(
              label: Text(category.name['ru'] ?? 'Без названия'),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  _onCategorySelected(category.categoryId);
                }
              },
              selectedColor: Theme.of(context).primaryColor,
              backgroundColor: Colors.grey[300],
            ),
          );
        },
      ),
    );
  }

  // Метод для построения виджета списка услуг
  Widget _buildServiceList() {
    if (_isLoadingServices) {
      return Center(child: CircularProgressIndicator());
    }
    if (_services.isEmpty) {
      return Center(child: Text('Услуги не найдены'));
    }
    return Expanded(
      // Используем Expanded, чтобы список услуг занимал оставшееся пространство
      child: ListView.builder(
        itemCount: _services.length,
        itemBuilder: (context, index) {
          Service service = _services[index];
          bool isSelected = service.serviceId == _selectedServiceId;
          return Card(
            elevation: 2,
            margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            color: isSelected
                ? Theme.of(context).primaryColor.withOpacity(0.2)
                : null,
            child: ListTile(
              title: Text(service.title['ru'] ?? 'Без названия'),
              subtitle: Text(service.description['ru'] ?? ''),
              trailing: Text('${service.price.toStringAsFixed(2)} руб.'),
              onTap: () => _onServiceSelected(service.serviceId),
              selected: isSelected,
              selectedTileColor:
                  Theme.of(context).primaryColor.withOpacity(0.1),
            ),
          );
        },
      ),
    );
  }

  // Метод для построения виджета выбора даты
  Widget _buildDateSelector() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Text('Дата: ', style: TextStyle(fontWeight: FontWeight.bold)),
          Expanded(
            // Expanded позволяет кнопке растянуться
            child: ElevatedButton(
              onPressed: () => _selectDate(context),
              child: Text(
                _selectedDate == null
                    ? 'Выберите дату'
                    : '${_selectedDate!.day}.${_selectedDate!.month}.${_selectedDate!.year}',
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Метод для построения виджета выбора времени
  Widget _buildTimeSlotSelector() {
    if (_selectedDate == null) {
      return Container(); // Если дата не выбрана, ничего не показываем
    }

    if (_isLoadingSchedule) {
      return Center(child: CircularProgressIndicator());
    }

    if (_currentSchedule == null) {
      // Если расписание не найдено, возможно, это выходной или ошибка
      // В реальном приложении логика может быть сложнее
      if (_selectedDate != null) {
        // Проверим, не является ли это будущей датой без расписания
        // Для простоты предположим, что если нет документа, то день рабочий по умолчанию
        // или нужно создать логику "по умолчанию". Пока просто сообщение.
        return Center(child: Text('Информация о расписании отсутствует.'));
      }
      return Container();
    }

    if (_currentSchedule!.isDayOff) {
      return Center(child: Text('В этот день салон не работает.'));
    }

    if (_currentSchedule!.availableSlots.isEmpty) {
      return Center(child: Text('На эту дату нет доступного времени.'));
    }

    // Создаем список доступных временных слотов
    List<Widget> timeSlotWidgets = [];
    _currentSchedule!.availableSlots.forEach((time, isAvailable) {
      timeSlotWidgets.add(
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: ChoiceChip(
            label: Text(time),
            selected: _selectedTimeSlot == time,
            onSelected: isAvailable
                ? (selected) {
                    if (selected) _onTimeSlotSelected(time);
                  }
                : null, // Если слот недоступен, onSelected = null делает его неактивным
            selectedColor: Colors.green,
            disabledColor: Colors.grey[300], // Цвет для недоступных слотов
            backgroundColor: Colors.grey[200],
          ),
        ),
      );
    });

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Wrap(
        // Wrap автоматически переносит элементы на новую строку
        alignment: WrapAlignment.center, // Центрируем элементы в строке
        children: timeSlotWidgets,
      ),
    );
  }

  // Метод для построения кнопки "Записаться"
  Widget _buildBookButton() {
    bool isEnabled = _selectedServiceId != null &&
        _selectedDate != null &&
        _selectedTimeSlot != null &&
        _currentSchedule != null &&
        !_currentSchedule!.isDayOff &&
        _currentSchedule!.availableSlots[_selectedTimeSlot!] == true;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton(
        onPressed: isEnabled
            ? _bookAppointment
            : null, // Кнопка активна только если все выбрано
        child: Text('Записаться'),
        style: ElevatedButton.styleFrom(
          minimumSize:
              Size(double.infinity, 50), // Кнопка растягивается на всю ширину
        ),
      ),
    );
  }

  // --- Основной метод построения экрана ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Запись на услугу'),
        // Добавляем кнопку "Назад" в AppBar
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Список категорий
          _buildCategoryList(),
          SizedBox(height: 10),
          // 2. Список услуг (занимает оставшееся пространство)
          _buildServiceList(),
          // 3. Выбор даты
          _buildDateSelector(),
          // 4. Выбор времени
          _buildTimeSlotSelector(),
          // 5. Кнопка "Записаться"
          _buildBookButton(),
        ],
      ),
    );
  }
}
