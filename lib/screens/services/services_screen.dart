// lib/screens/services/services_screen.dart
import 'package:flutter/material.dart';
import 'package:oksana_shik/screens/services/service_filter.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Пример данных услуг (в реальном приложении будут из Firebase)
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
      {
        'id': '4',
        'title': 'Бритье',
        'description': 'Качественное бритье лица и шеи',
        'price': 1200,
        'duration': 25,
        'category': 'Бритье',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Услуги'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {
              // Открыть фильтр
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return ServiceFilter();
                },
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: services.length,
        itemBuilder: (context, index) {
          final service = services[index];
          return Card(
            margin: const EdgeInsets.all(10),
            child: ListTile(
              title: Text(service['title'] as String),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(service['description'] as String),
                  const SizedBox(height: 5),
                  Text(
                    '${service['price']} руб. (${service['duration']} мин)',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.purple,
                    ),
                  ),
                ],
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Обработка выбора услуги
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text('Выбрана услуга: ${service['title']}')),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
