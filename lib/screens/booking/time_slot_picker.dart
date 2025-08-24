// lib/screens/booking/time_slot_picker.dart
import 'package:flutter/material.dart';

class TimeSlotPicker extends StatelessWidget {
  const TimeSlotPicker({super.key});

  @override
  Widget build(BuildContext context) {
    // Фейковые данные временных слотов (в реальном приложении будут из Firebase)
    final List<Map<String, dynamic>> timeSlots = [
      {'time': '10:00', 'isAvailable': true},
      {'time': '10:30', 'isAvailable': true},
      {'time': '11:00', 'isAvailable': false},
      {'time': '11:30', 'isAvailable': true},
      {'time': '12:00', 'isAvailable': true},
      {'time': '12:30', 'isAvailable': false},
      {'time': '13:00', 'isAvailable': true},
      {'time': '13:30', 'isAvailable': true},
      {'time': '14:00', 'isAvailable': false},
      {'time': '14:30', 'isAvailable': true},
      {'time': '15:00', 'isAvailable': true},
      {'time': '15:30', 'isAvailable': true},
      {'time': '16:00', 'isAvailable': true},
      {'time': '16:30', 'isAvailable': false},
      {'time': '17:00', 'isAvailable': true},
      {'time': '17:30', 'isAvailable': true},
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Выберите время',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),
          SizedBox(
            height: 200,
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
                  color: slot['isAvailable'] == true
                      ? Colors.white
                      : Colors.grey[300],
                  elevation: 2,
                  child: InkWell(
                    onTap: slot['isAvailable'] == true
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
                          fontSize: 14,
                          color: slot['isAvailable'] == true
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
        ],
      ),
    );
  }
}
