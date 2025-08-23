// lib/screens/booking/calendar_widget.dart
import 'package:flutter/material.dart';

class CalendarWidget extends StatelessWidget {
  const CalendarWidget({Key? key});

  @override
  Widget build(BuildContext context) {
    // Фейковые данные для календаря (в реальном приложении будут из Firebase)
    final List<Map<String, dynamic>> calendarDays = [
      {'date': '15', 'dayOfWeek': 'Пн', 'isAvailable': true, 'isToday': false},
      {'date': '16', 'dayOfWeek': 'Вт', 'isAvailable': true, 'isToday': false},
      {'date': '17', 'dayOfWeek': 'Ср', 'isAvailable': false, 'isToday': false},
      {'date': '18', 'dayOfWeek': 'Чт', 'isAvailable': true, 'isToday': false},
      {'date': '19', 'dayOfWeek': 'Пт', 'isAvailable': true, 'isToday': false},
      {'date': '20', 'dayOfWeek': 'Сб', 'isAvailable': false, 'isToday': false},
      {'date': '21', 'dayOfWeek': 'Вс', 'isAvailable': true, 'isToday': true},
      {'date': '22', 'dayOfWeek': 'Пн', 'isAvailable': true, 'isToday': false},
      {'date': '23', 'dayOfWeek': 'Вт', 'isAvailable': true, 'isToday': false},
      {'date': '24', 'dayOfWeek': 'Ср', 'isAvailable': false, 'isToday': false},
      {'date': '25', 'dayOfWeek': 'Чт', 'isAvailable': true, 'isToday': false},
      {'date': '26', 'dayOfWeek': 'Пт', 'isAvailable': true, 'isToday': false},
      {'date': '27', 'dayOfWeek': 'Сб', 'isAvailable': true, 'isToday': false},
      {'date': '28', 'dayOfWeek': 'Вс', 'isAvailable': false, 'isToday': false},
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Выберите дату',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),
          Container(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: calendarDays.length,
              itemBuilder: (context, index) {
                final day = calendarDays[index];
                return Container(
                  margin: const EdgeInsets.only(right: 10),
                  child: Column(
                    children: [
                      Text(
                        day['dayOfWeek'] as String,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: day['isToday'] == true
                              ? Colors.purple
                              : day['isAvailable'] == true
                                  ? Colors.white
                                  : Colors.grey[200],
                          border: Border.all(
                            color: day['isToday'] == true
                                ? Colors.purple
                                : day['isAvailable'] == true
                                    ? Colors.grey
                                    : Colors.grey[300]!,
                          ),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Center(
                          child: Text(
                            day['date'] as String,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: day['isToday'] == true
                                  ? Colors.white
                                  : day['isAvailable'] == true
                                      ? Colors.black
                                      : Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
