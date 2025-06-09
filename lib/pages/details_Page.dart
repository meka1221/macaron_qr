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
  String _selectedSize = 'Small';
  String _deliveryType = 'pickup';
  String? _selectedCafe;
  final _addressController = TextEditingController();

  final List<Map<String, String>> cafes = [
    {'name': 'Кофейня на Невском', 'address': 'Невский пр. 1'},
    {'name': 'Кофейня на Лиговском', 'address': 'Лиговский пр. 30'},
    {'name': 'Кофейня на Московском', 'address': 'Московский пр. 50'},
  ];

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
      backgroundColor: Color.fromRGBO(33, 35, 37, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(33, 35, 37, 1),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      height: 300,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(widget.item.image!),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.5,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //The title

                          Padding(
                            padding: const EdgeInsets.all(15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.item.category!,
                                  style: const TextStyle(
                                    color: Color.fromRGBO(213, 122, 67, 1),
                                    fontSize: 30,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                const SizedBox(height: 10),

                                //The star

                                Row(
                                  children: [
                                    const Icon(Icons.star, color: Colors.amber),
                                    Text(
                                      widget.item.rating!,
                                      style: const TextStyle(
                                        color: Color.fromRGBO(33, 35, 37, 1),
                                        fontSize: 15,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),

                                //The description

                                const Text(
                                  'Description',
                                  style: TextStyle(
                                    color: Color.fromRGBO(33, 35, 37, 1),
                                    fontSize: 18,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  widget.item.description!,
                                  style: const TextStyle(
                                    color: Color.fromRGBO(33, 35, 37, 0.8),
                                    fontSize: 13,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),

                                const SizedBox(height: 10),
                                const Text(
                                  'Size',
                                  style: TextStyle(
                                    color: Color.fromRGBO(33, 35, 37, 1),
                                    fontSize: 18,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Row(
                                  children: [
                                    Container(
                                      width: 120,
                                      height: 40,
                                      margin: const EdgeInsets.only(right: 10),
                                      decoration: BoxDecoration(
                                        color: _selectedSize == 'Small' 
                                            ? const Color.fromRGBO(209, 120, 66, 1)
                                            : const Color.fromRGBO(33, 35, 37, 1),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: TextButton(
                                        onPressed: () {
                                          setState(() {
                                            _selectedSize = 'Small';
                                          });
                                        },
                                        child: Text(
                                          'Small',
                                          style: TextStyle(
                                            color: _selectedSize == 'Small' 
                                                ? Colors.white
                                                : Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 120,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: _selectedSize == 'Large'
                                            ? const Color.fromRGBO(209, 120, 66, 1)
                                            : const Color.fromRGBO(33, 35, 37, 1),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: TextButton(
                                        onPressed: () {
                                          setState(() {
                                            _selectedSize = 'Large';
                                          });
                                        },
                                        child: Text(
                                          'Large',
                                          style: TextStyle(
                                            color: _selectedSize == 'Large'
                                                ? Colors.white
                                                : Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          // Buy button
                          Padding(
                            padding: const EdgeInsets.all(15),
                            child: Container(
                              width: double.infinity,
                              height: 50,
                              decoration: BoxDecoration(
                                color: const Color.fromRGBO(209, 120, 66, 1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: TextButton(
                                onPressed: _showOrderConfirmation,
                                child: const Text(
                                  'Купить',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
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