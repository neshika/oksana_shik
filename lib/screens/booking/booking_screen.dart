// lib/screens/booking/booking_screen.dart
import 'package:flutter/material.dart';

class BookingScreen extends StatelessWidget {
  const BookingScreen({Key? key}) : super(key: key);

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
        title: const Text('Запись на услугу'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
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
            const SizedBox(height: 15),
            Container(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: services.length,
                itemBuilder: (context, index) {
                  final service = services[index];
                  return Card(
                    margin: const EdgeInsets.only(right: 15),
                    child: InkWell(
                      onTap: () {
                        // Обработка выбора услуги
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content:
                                  Text('Выбрана услуга: ${service['title']}')),
                        );
                      },
                      child: Container(
                        width: 150,
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              service['title'] as String,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              service['description'] as String,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              '${service['price']} руб.',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.purple,
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

            // Выбор даты
            const Text(
              'Выберите дату',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            Container(
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
            Container(
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
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white,
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
