// lib/screens/services/service_filter.dart
import 'package:flutter/material.dart';

class ServiceFilter extends StatefulWidget {
  const ServiceFilter({super.key});

  @override
  State<ServiceFilter> createState() => _ServiceFilterState();
}

class _ServiceFilterState extends State<ServiceFilter> {
  // Список категорий для фильтрации
  final List<String> categories = [
    'Все',
    'Стрижка',
    'Окрашивание',
    'Укладка',
    'Бритье'
  ];
  String selectedCategory = 'Все';

  // Список цен для фильтрации
  final List<String> priceRanges = [
    'Все',
    'До 1000',
    '1000-3000',
    'Более 3000'
  ];
  String selectedPriceRange = 'Все';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      height: 300,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Фильтры',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),

          // Фильтр по категориям
          const Text(
            'Категория:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: categories.map((category) {
              return FilterChip(
                label: Text(category),
                selected: selectedCategory == category,
                onSelected: (selected) {
                  setState(() {
                    selectedCategory = category;
                  });
                },
              );
            }).toList(),
          ),

          const SizedBox(height: 20),

          // Фильтр по цене
          const Text(
            'Цена:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: priceRanges.map((range) {
              return FilterChip(
                label: Text(range),
                selected: selectedPriceRange == range,
                onSelected: (selected) {
                  setState(() {
                    selectedPriceRange = range;
                  });
                },
              );
            }).toList(),
          ),

          const SizedBox(height: 20),

          // Кнопки действий
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  // Сбросить фильтры
                  setState(() {
                    selectedCategory = 'Все';
                    selectedPriceRange = 'Все';
                  });
                },
                child: const Text('Сбросить'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Применить фильтры
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(
                            'Применены фильтры: $selectedCategory, $selectedPriceRange')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                ),
                child: const Text('Применить'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
