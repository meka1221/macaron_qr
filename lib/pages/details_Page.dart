import 'package:macaron_qr/pages/home.dart';
import 'package:macaron_qr/models/menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DetailsPage extends StatefulWidget {
  DetailsPage(this.item,{super.key});
  Menu item;

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  String _selectedSize = 'Большой';
  String _deliveryType = 'pickup';
  String? _selectedCafe;
  final _addressController = TextEditingController();

  final List<Map<String, String>> cafes = [
    {'name': 'Кофейня на Невском', 'address': 'Невский пр. 1'},
    {'name': 'Кофейня на Лиговском', 'address': 'Лиговский пр. 30'},
    {'name': 'Кофейня на Московском', 'address': 'Московский пр. 50'},
  ];

  String get _currentPrice {
    if (widget.item.sizes != null) {
      return widget.item.sizes![_selectedSize] ?? widget.item.price!;
    }
    return widget.item.price!;
  }

  void _showOrderConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: const Color.fromRGBO(33, 35, 37, 1),
              title: const Text(
                'Выберите способ получения',
                style: TextStyle(color: Colors.white),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    RadioListTile<String>(
                      title: const Text(
                        'Самовывоз',
                        style: TextStyle(color: Colors.white),
                      ),
                      value: 'pickup',
                      groupValue: _deliveryType,
                      onChanged: (value) {
                        setState(() {
                          _deliveryType = value!;
                          _selectedCafe = null;
                        });
                      },
                      activeColor: const Color.fromRGBO(209, 120, 66, 1),
                    ),
                    if (_deliveryType == 'pickup')
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Выберите кофейню:',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 8),
                            ...cafes.map((cafe) => RadioListTile<String>(
                              title: Text(
                                cafe['name']!,
                                style: const TextStyle(color: Colors.white),
                              ),
                              subtitle: Text(
                                cafe['address']!,
                                style: const TextStyle(color: Colors.grey),
                              ),
                              value: cafe['name']!,
                              groupValue: _selectedCafe,
                              onChanged: (value) {
                                setState(() {
                                  _selectedCafe = value;
                                });
                              },
                              activeColor: const Color.fromRGBO(209, 120, 66, 1),
                            )).toList(),
                          ],
                        ),
                      ),
                    RadioListTile<String>(
                      title: const Text(
                        'Доставка',
                        style: TextStyle(color: Colors.white),
                      ),
                      value: 'delivery',
                      groupValue: _deliveryType,
                      onChanged: (value) {
                        setState(() {
                          _deliveryType = value!;
                          _selectedCafe = null;
                        });
                      },
                      activeColor: const Color.fromRGBO(209, 120, 66, 1),
                    ),
                    if (_deliveryType == 'delivery')
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: TextField(
                          controller: _addressController,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            hintText: 'Введите адрес доставки',
                            hintStyle: TextStyle(color: Colors.grey),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color.fromRGBO(209, 120, 66, 1)),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Отмена',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    if ((_deliveryType == 'pickup' && _selectedCafe != null) ||
                        (_deliveryType == 'delivery' && _addressController.text.isNotEmpty)) {
                      Navigator.of(context).pop();
                      _showOrderAccepted();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Пожалуйста, заполните все необходимые поля'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  child: const Text(
                    'Подтвердить',
                    style: TextStyle(color: Color.fromRGBO(209, 120, 66, 1)),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showOrderAccepted() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String message;
        if (_deliveryType == 'pickup') {
          final selectedCafe = cafes.firstWhere((cafe) => cafe['name'] == _selectedCafe);
          message = 'Ожидайте ваш заказ в кофейне:\n${selectedCafe['name']}\n${selectedCafe['address']}';
        } else {
          message = 'Заказ будет доставлен по адресу:\n${_addressController.text}';
        }

        return AlertDialog(
          backgroundColor: const Color.fromRGBO(33, 35, 37, 1),
          title: const Text(
            'Заказ принят!',
            style: TextStyle(color: Colors.white),
          ),
          content: Text(
            message,
            style: const TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // Возврат на предыдущий экран
              },
              child: const Text(
                'OK',
                style: TextStyle(color: Color.fromRGBO(209, 120, 66, 1)),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(33, 35, 37, 1),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 300,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(widget.item.image!),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 40,
                  left: 20,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.item.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.item.description!,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (widget.item.sizes != null) ...[
                    const Text(
                      'Размер',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        for (var size in widget.item.sizes!.keys)
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: ChoiceChip(
                              label: Text(
                                size,
                                style: TextStyle(
                                  color: _selectedSize == size
                                      ? Colors.white
                                      : Colors.grey,
                                ),
                              ),
                              selected: _selectedSize == size,
                              onSelected: (selected) {
                                if (selected) {
                                  setState(() {
                                    _selectedSize = size;
                                  });
                                }
                              },
                              backgroundColor: const Color.fromRGBO(51, 54, 57, 1),
                              selectedColor: const Color.fromRGBO(209, 120, 66, 1),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '$_currentPrice сом',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: _showOrderConfirmation,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromRGBO(209, 120, 66, 1),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 15,
                          ),
                        ),
                        child: const Text(
                          'Добавить в корзину',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }
}