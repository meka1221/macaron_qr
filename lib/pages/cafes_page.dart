import 'package:flutter/material.dart';

class CafesPage extends StatelessWidget {
  final List<Map<String, String>> cafes = const [
    {'name': 'Кофейня на Боконбаева', 'address': 'Бокн 1'},
    {'name': 'Лавка на Джале', 'address': 'Тыналиева 1/3'},
    {'name': 'Кофейня на Чуй', 'address': 'Чуй 1/2'},
    {'name': 'Кофейня на Ала-Тоо', 'address': 'Ала-Тоо 3'},
    {'name': 'Кофейня на Манаса', 'address': 'Манаса 50'},
    {'name': 'Лавка на Asia Mall', 'address': 'пр.Манаса 50'},
  ];

  const CafesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(33, 35, 37, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(33, 35, 37, 1),
        title: const Text('Список кофеен', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: cafes.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final cafe = cafes[index];
          return Card(
            color: const Color.fromRGBO(45, 47, 49, 1),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: const Icon(Icons.local_cafe, color: Color.fromRGBO(209, 120, 66, 1)),
              title: Text(cafe['name']!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              subtitle: Text(cafe['address']!, style: const TextStyle(color: Colors.grey)),
            ),
          );
        },
      ),
    );
  }
} 