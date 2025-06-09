import 'package:flutter/material.dart';
import 'package:macaron_qr/models/menu.dart';
import 'package:macaron_qr/pages/cards.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Menu> _filteredList = [];
  List<Menu> _currentCategoryList = Menu.Cappuccino;
  String _selectedCategory = 'Cappuccino';

  final List<Map<String, dynamic>> categories = [
    {'name': 'Cappuccino', 'list': Menu.Cappuccino},
    {'name': 'Hot Coffee', 'list': Menu.hotCoffee},
    {'name': 'Latte', 'list': Menu.latte},
    {'name': 'Cold Coffee', 'list': Menu.coldCoffee},
  ];

  @override
  void initState() {
    super.initState();
    _filteredList = _currentCategoryList;
  }

  void _filterProducts(String query) {
    setState(() {
      _filteredList = _currentCategoryList
          .where((item) =>
      item.name.toLowerCase().contains(query.toLowerCase()) ||
          item.description!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _selectCategory(String category) {
    setState(() {
      _selectedCategory = category;
      _currentCategoryList = categories
          .firstWhere((cat) => cat['name'] == category)['list'] as List<Menu>;
      _filteredList = _currentCategoryList;
      _searchController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(33, 35, 37, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(33, 35, 37, 1),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Container(
          decoration: BoxDecoration(
            color: const Color.fromRGBO(51, 54, 57, 1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextField(
            controller: _searchController,
            onChanged: _filterProducts,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              border: InputBorder.none,
              prefixIcon: Icon(Icons.search, color: Color.fromRGBO(151, 154, 157, 1)),
              hintText: 'Search products...',
              hintStyle: TextStyle(
                color: Color.fromRGBO(151, 154, 157, 1),
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            height: 50,
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index]['name'] as String;
                final isSelected = category == _selectedCategory;
                return GestureDetector(
                  onTap: () => _selectCategory(category),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color.fromRGBO(209, 120, 66, 1)
                          : const Color.fromRGBO(51, 54, 57, 1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      category,
                      style: TextStyle(
                        color: isSelected ? Colors.white : const Color.fromRGBO(151, 154, 157, 1),
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: _filteredList.isEmpty
                ? const Center(
              child: Text(
                'No products found',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            )
                : Cards(_filteredList),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}