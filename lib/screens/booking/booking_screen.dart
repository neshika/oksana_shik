// lib/screens/booking/booking_screen.dart

// Импортируем необходимые библиотеки
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Для работы с Timestamp
import 'package:firebase_auth/firebase_auth.dart'; // Для получения текущего пользователя
import 'package:oksana_shik/models/category_model.dart'; // Модель категории
import 'package:oksana_shik/models/service_model.dart'; // Модель услуги
import 'package:oksana_shik/models/schedule_model.dart'; // Модель расписания
import 'package:oksana_shik/services/firestore_service.dart'; // Сервис для работы с Firestore

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
    // Проверяем, что все необходимые данные выбраны
    if (_selectedServiceId == null ||
        _selectedDate == null ||
        _selectedTimeSlot == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Пожалуйста, выберите услугу, дату и время.')),
      );
      return;
    }

    // Получаем ID текущего пользователя
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка: пользователь не авторизован.')),
      );
      return;
    }

    // Показываем индикатор прогресса
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
      // 1. Повторно загружаем расписание для проверки актуальности данных
      await _loadSchedule(_selectedDate!);
      await Future.delayed(
          Duration(milliseconds: 500)); // Небольшая задержка для имитации

      // 2. Проверяем доступность слота
      bool isSlotAvailable = _currentSchedule != null &&
          !_currentSchedule!.isDayOff &&
          _currentSchedule!.availableSlots[_selectedTimeSlot!] == true;

      if (!isSlotAvailable) {
        Navigator.of(context).pop(); // Закрываем диалог прогресса
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Выбранное время больше недоступно. Пожалуйста, выберите другое.')),
        );
        return; // Прерываем процесс записи
      }

      // 3. Создаем запись в Firestore
      // Создаем Map для нового документа в коллекции 'appointments'
      Map<String, dynamic> appointmentData = {
        'userId': user.uid,
        'serviceId': _selectedServiceId,
        'date': Timestamp.fromDate(_selectedDate!),
        'timeSlot': _selectedTimeSlot,
        'status': 'pending', // Начальный статус
        'createdAt': Timestamp.now(),
        // Можно добавить другие поля, например, информацию об услуге на момент записи
      };

      DocumentReference newAppointmentRef = await FirebaseFirestore.instance
          .collection('appointments')
          .add(appointmentData);

      // 4. Обновляем расписание, делая слот недоступным
      // Обновляем конкретное поле в документе расписания
      await FirebaseFirestore.instance
          .collection('schedules')
          .doc(_currentSchedule!.date) // Используем дату как ID документа
          .update({
        'availableSlots.${_selectedTimeSlot}': false,
      });

      Navigator.of(context).pop(); // Закрываем диалог прогресса

      // Показываем сообщение об успехе и, возможно, переходим на другой экран
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Запись успешно создана!')),
      );
      // Можно закрыть экран или перейти на экран подтверждения
      Navigator.of(context).pop(); // Закрываем экран записи
    } catch (e) {
      Navigator.of(context).pop(); // Закрываем диалог прогресса
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
