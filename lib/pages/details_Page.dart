import 'package:macaron_qr/pages/home.dart';
import 'package:macaron_qr/models/menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:macaron_qr/models/cart_provider.dart';

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
  int _quantity = 1;

  List<Map<String, String>> _cafes = [
    {'name': 'Кофейня на Боконбаева', 'address': 'Бокн 1'},
    {'name': 'Лавка на Джале', 'address': 'Тыналиева 1/3'},
    {'name': 'Кофейня на Чуй', 'address': 'Чуй 1/2'},
    {'name': 'Кофейня на Ала-Тоо', 'address': 'Ала-Тоо 3'},
    {'name': 'Кофейня на Манаса', 'address': 'Манаса 50'},
    {'name': 'Лавка на Asia Mall', 'address': 'пр.Манаса 50'},
  ];

  void updateCafes(List<Map<String, String>> newCafes) {
    setState(() {
      _cafes = newCafes;
    });
  }

  void _incrementQuantity() {
    setState(() {
      _quantity++;
    });
  }

  void _decrementQuantity() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
      });
    }
  }

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
          builder: (context, setDialogState) {
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
                        setDialogState(() {
                          _deliveryType = value!;
                          _selectedCafe = null;
                        });
                      },
                      activeColor: const Color.fromRGBO(209, 120, 66, 1),
                    ),
                    if (_deliveryType == 'pickup')
                      Container(
                        constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height * 0.4,
                        ),
                        child: SingleChildScrollView(
                          child: Padding(
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
                                StatefulBuilder(
                                  builder: (context, setCafeState) {
                                    return Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: _cafes.map((cafe) => RadioListTile<String>(
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
                                          setCafeState(() {
                                            _selectedCafe = value;
                                          });
                                        },
                                        activeColor: const Color.fromRGBO(209, 120, 66, 1),
                                      )).toList(),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
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
                        setDialogState(() {
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
                      Navigator.pushNamed(context, '/cart');
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
          final selectedCafe = _cafes.firstWhere((cafe) => cafe['name'] == _selectedCafe);
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
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/cart',
                  (route) => false,
                );
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

  void _showCartDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromRGBO(33, 35, 37, 1),
          title: const Text(
            'Товар добавлен в корзину',
            style: TextStyle(color: Colors.white),
          ),
          content: const Text(
            'Что хотите сделать дальше?',
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Закрываем диалог
              },
              child: const Text(
                'Продолжить покупки',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Закрываем диалог
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/cart',
                  (route) => false,
                );
              },
              child: const Text(
                'Перейти в корзину',
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
                      children: widget.item.sizes!.keys.map((size) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: ChoiceChip(
                            label: Text(
                              size,
                              style: TextStyle(
                                color: _selectedSize == size ? Colors.white : Colors.grey,
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
                            backgroundColor: const Color.fromRGBO(45, 47, 49, 1),
                            selectedColor: const Color.fromRGBO(209, 120, 66, 1),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                  const SizedBox(height: 20),
                  const Text(
                    'Количество',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(45, 47, 49, 1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove, color: Colors.white),
                              onPressed: _decrementQuantity,
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                '$_quantity',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add, color: Colors.white),
                              onPressed: _incrementQuantity,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          '${int.parse(_currentPrice) * _quantity} сом',
                          style: const TextStyle(
                            color: Color.fromRGBO(209, 120, 66, 1),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${_currentPrice} сом',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Consumer<CartProvider>(
                        builder: (context, cart, child) {
                          return ElevatedButton(
                            onPressed: () {
                              for (var i = 0; i < _quantity; i++) {
                                cart.addItem(widget.item);
                              }
                              _showCartDialog();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromRGBO(209, 120, 66, 1),
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: const Text(
                              'В корзину',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        },
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