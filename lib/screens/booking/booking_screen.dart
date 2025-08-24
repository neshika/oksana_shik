// lib/screens/booking/booking_screen.dart
import 'package:flutter/material.dart';
import 'package:oksana_shik/utils/theme.dart';

class BookingScreen extends StatelessWidget {
  const BookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Фейковые данные услуг (в реальном приложении будут из Firebase)
    final List<Map<String, dynamic>> services = [
      {
        'id': '1',
        'title': 'Стрижка',
        'description': 'Классическая стрижка мужская или женская',
        'price': 1500,
        'duration': 30,
        'category': 'Стрижка',
      },
      {
        'id': '2',
        'title': 'Окрашивание',
        'description':
            'Окрашивание волос с использованием профессиональных красок',
        'price': 3500,
        'duration': 90,
        'category': 'Окрашивание',
      },
      {
        'id': '3',
        'title': 'Укладка',
        'description': 'Профессиональная укладка для любого случая',
        'price': 800,
        'duration': 20,
        'category': 'Укладка',
      },
    ];

    // Фейковые данные времени (в реальном приложении будут из Firebase)
    final List<Map<String, dynamic>> timeSlots = [
      {'time': '10:00', 'available': true},
      {'time': '11:00', 'available': false},
      {'time': '12:00', 'available': true},
      {'time': '13:00', 'available': true},
      {'time': '14:00', 'available': false},
      {'time': '15:00', 'available': true},
      {'time': '16:00', 'available': true},
      {'time': '17:00', 'available': false},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Запись на услугу /booking'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: AppTheme.backgroundColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Выбор услуги
            const Text(
              'Выберите услугу',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            // Отступ вертикальный высотой 15 пикселей между элементами
            const SizedBox(height: 15),

// Контейнер высотой 200 пикселей для отображения горизонтального списка услуг
            SizedBox(
              height: 200,
              child: ListView.builder(
                // Установка горизонтальной прокрутки списка
                scrollDirection: Axis.horizontal,

                // Количество элементов в списке (равно количеству услуг)
                itemCount: services.length,

                // Функция для создания каждого элемента списка услуг
                itemBuilder: (context, index) {
                  // Получаем текущую услугу по индексу из списка services
                  final service = services[index];

                  // Создаем карточку для отображения информации об услуге
                  return Card(
                    // Отступ справа между карточками для визуального разделения
                    margin: const EdgeInsets.only(right: 15),

                    // Обертка для обработки нажатия на карточку
                    child: InkWell(
                      // Обработка события нажатия на услугу
                      onTap: () {
                        // Отображение всплывающего уведомления о выборе услуги
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            // Текст уведомления с названием выбранной услуги
                            content:
                                Text('Выбрана услуга: ${service['title']}'),
                          ),
                        );
                      },

                      // Внутренний контент карточки с отступами
                      child: Padding(
                        // Внутренние отступы вокруг содержимого карточки
                        padding: const EdgeInsets.all(10),

                        // Контейнер фиксированной ширины для ограничения размера карточки
                        child: SizedBox(
                          width: 150, // Ширина карточки 150 пикселей

                          // Вертикальная колонка с элементами услуги
                          child: Column(
                            // Выравнивание элементов по левому краю
                            crossAxisAlignment: CrossAxisAlignment.start,

                            // Дочерние элементы колонки
                            children: [
                              // Название услуги с жирным шрифтом
                              Text(
                                service['title'] as String,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              // Отступ вертикальный высотой 5 пикселей между заголовком и описанием
                              const SizedBox(height: 5),

                              // Описание услуги с маленьким размером шрифта и серым цветом
                              Text(
                                service['description'] as String,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),

                              // Отступ вертикальный высотой 10 пикселей между описанием и ценой
                              const SizedBox(height: 10),

                              // Цена услуги с жирным шрифтом и основным цветом темы
                              Text(
                                '${service['price']} руб.',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            // Выбор даты
            const Text(
              'Выберите дату',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 7,
                itemBuilder: (context, index) {
                  final day = DateTime.now().add(Duration(days: index));
                  final formattedDate = '${day.day}.${day.month}';
                  final dayOfWeek = [
                    'Пн',
                    'Вт',
                    'Ср',
                    'Чт',
                    'Пт',
                    'Сб',
                    'Вс'
                  ][day.weekday - 1];

                  return Card(
                    margin: const EdgeInsets.only(right: 10),
                    child: InkWell(
                      onTap: () {
                        // Обработка выбора даты
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('Выбрана дата: $formattedDate')),
                        );
                      },
                      child: Container(
                        width: 80,
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Text(
                              dayOfWeek,
                              style: const TextStyle(
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              formattedDate,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            // Выбор времени
            const Text(
              'Выберите время',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            SizedBox(
              height: 150,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: timeSlots.length,
                itemBuilder: (context, index) {
                  final slot = timeSlots[index];
                  return Card(
                    color: slot['available'] == true
                        ? Colors.white
                        : Colors.grey[300],
                    child: InkWell(
                      onTap: slot['available'] == true
                          ? () {
                              // Обработка выбора времени
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content:
                                        Text('Выбрано время: ${slot['time']}')),
                              );
                            }
                          : null,
                      child: Center(
                        child: Text(
                          slot['time'] as String,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: slot['available'] == true
                                ? Colors.black
                                : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 30),

            // Кнопка подтверждения
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  // Обработка подтверждения записи
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Запись подтверждена!')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: AppTheme.backgroundColor,
                ),
                child: const Text('Подтвердить запись'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
