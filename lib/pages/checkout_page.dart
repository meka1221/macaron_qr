import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:macaron_qr/models/cart_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:macaron_qr/models/auth_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  String _selectedPaymentMethod = 'Картой курьеру';
  String _deliveryType = 'delivery';
  String? _selectedCafe;

  final List<Map<String, String>> cafes = [
    {'name': 'Кофейня на Боконбаева',
      'address': 'Бокн 183'},
    {'name': 'Лавка на Джале',
      'address': 'Тыналиева 1/3'},
    {'name': 'Кофейня на Чуй',
      'address': 'Чуй 1/2'},
    {'name': 'Кофейня на Ала-Тоо',
      'address': 'Ала-Тоо 3'},
    {'name': 'Кофейня на Манаса',
      'address': 'Манаса 50'},
    {'name': 'Лавка на Asia Mall',
      'address': 'пр.Манаса 50'},
  ];

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _submitOrder() async {
    if (!_formKey.currentState!.validate()) return;
    final cart = context.read<CartProvider>();
    final auth = context.read<AuthProvider>();
    if (!auth.isAuthenticated || auth.user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Пожалуйста, войдите в аккаунт для оформления заказа'), backgroundColor: Colors.red),
      );
      return;
    }
    try {
      // Сохраняем заказ в Firestore
      final orderData = {
        'userId': auth.user!.id,
        'items': cart.items.map((item) => {
          'title': item.product.title,
          'price': item.product.price,
          'quantity': item.quantity,
        }).toList(),
        'total': cart.totalAmount,
        'deliveryType': _deliveryType,
        'address': _deliveryType == 'delivery' ? _addressController.text : null,
        'cafe': _deliveryType == 'pickup' ? _selectedCafe : null,
        'paymentMethod': _selectedPaymentMethod,
        'createdAt': FieldValue.serverTimestamp(),
      };
      await FirebaseFirestore.instance.collection('orders').add(orderData);
      // Начисляем бонусы (5% от суммы заказа)
      final bonus = (cart.totalAmount * 0.05).round();
      final userRef = FirebaseFirestore.instance.collection('users').doc(auth.user!.id);
      await userRef.update({
        'points': FieldValue.increment(bonus),
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Заказ успешно оформлен! Бонусы начислены: $bonus'),
          backgroundColor: const Color.fromRGBO(209, 120, 66, 1),
        ),
      );
      cart.clear();
      Navigator.of(context).popUntil((route) => route.isFirst);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка при оформлении заказа: $e'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      backgroundColor: const Color.fromRGBO(33, 35, 37, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(33, 35, 37, 1),
        title: const Text(
          'Оформление заказа',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Способ получения',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Card(
                color: const Color.fromRGBO(45, 47, 49, 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    RadioListTile<String>(
                      title: const Text('Доставка', style: TextStyle(color: Colors.white)),
                      value: 'delivery',
                      groupValue: _deliveryType,
                      onChanged: (value) {
                        setState(() {
                          _deliveryType = value!;
                        });
                      },
                      activeColor: const Color.fromRGBO(209, 120, 66, 1),
                    ),
                    RadioListTile<String>(
                      title: const Text('В кофейне', style: TextStyle(color: Colors.white)),
                      value: 'pickup',
                      groupValue: _deliveryType,
                      onChanged: (value) {
                        setState(() {
                          _deliveryType = value!;
                        });
                      },
                      activeColor: const Color.fromRGBO(209, 120, 66, 1),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              if (_deliveryType == 'delivery') ...[
                const Text(
                  'Адрес доставки',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _addressController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Введите адрес доставки',
                    hintStyle: const TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: const Color.fromRGBO(45, 47, 49, 1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (value) {
                    if (_deliveryType == 'delivery' && (value == null || value.isEmpty)) {
                      return 'Пожалуйста, введите адрес доставки';
                    }
                    return null;
                  },
                ),
              ] else ...[
                const Text(
                  'Выберите кофейню',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedCafe,
                  dropdownColor: const Color.fromRGBO(45, 47, 49, 1),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color.fromRGBO(45, 47, 49, 1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  hint: const Text('Выберите кофейню', style: TextStyle(color: Colors.grey)),
                  items: cafes.map((cafe) => DropdownMenuItem<String>(
                    value: cafe['name'],
                    child: Text('${cafe['name']} — ${cafe['address']}', style: const TextStyle(color: Colors.white)),
                  )).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCafe = value;
                    });
                  },
                  validator: (value) {
                    if (_deliveryType == 'pickup' && (value == null || value.isEmpty)) {
                      return 'Пожалуйста, выберите кофейню';
                    }
                    return null;
                  },
                ),
              ],
              const SizedBox(height: 24),
              const Text(
                'Способ оплаты',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Card(
                color: const Color.fromRGBO(45, 47, 49, 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    RadioListTile<String>(
                      title: const Text(
                        'Картой',
                        style: TextStyle(color: Colors.white),
                      ),
                      value: 'Картой',
                      groupValue: _selectedPaymentMethod,
                      onChanged: (value) {
                        setState(() {
                          _selectedPaymentMethod = value!;
                        });
                      },
                      activeColor: const Color.fromRGBO(209, 120, 66, 1),
                    ),
                    RadioListTile<String>(
                      title: const Text(
                        'Наличными',
                        style: TextStyle(color: Colors.white),
                      ),
                      value: 'Наличными',
                      groupValue: _selectedPaymentMethod,
                      onChanged: (value) {
                        setState(() {
                          _selectedPaymentMethod = value!;
                        });
                      },
                      activeColor: const Color.fromRGBO(209, 120, 66, 1),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Ваш заказ',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Card(
                color: const Color.fromRGBO(45, 47, 49, 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      ...cart.items.map((item) {
                        final price = double.tryParse(item.product.price ?? '0') ?? 0.0;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${item.product.title ?? 'Без названия'} x${item.quantity}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                '${(price * item.quantity).toStringAsFixed(2)} сом',
                                style: const TextStyle(
                                  color: Color.fromRGBO(209, 120, 66, 1),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                      const Divider(color: Colors.grey),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Итого:',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${cart.totalAmount.toStringAsFixed(2)} сом',
                            style: const TextStyle(
                              color: Color.fromRGBO(209, 120, 66, 1),
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitOrder,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(209, 120, 66, 1),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Подтвердить заказ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UserQrPage extends StatelessWidget {
  const UserQrPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;
    final qrData = user?.id ?? 'no-user';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ваш QR-код'),
        centerTitle: true,
      ),
      body: Center(
        child: user == null
            ? const Text('Войдите в аккаунт')
            : QrImageView(
          data: qrData,
          version: QrVersions.auto,
          size: 250.0,
        ),
      ),
    );
  }
} 