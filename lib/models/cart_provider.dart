import 'package:flutter/foundation.dart';
import 'package:macaron_qr/models/menu.dart';

class CartItem {
  final Menu product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});
}

class CartProvider with ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => [..._items];

  int get itemCount => _items.length;

  double get totalAmount {
    return _items.fold(0.0, (sum, item) {
      final price = double.tryParse(item.product.price ?? '0') ?? 0.0;
      return sum + (price * item.quantity);
    });
  }

  void addItem(Menu product) {
    final existingIndex = _items.indexWhere((item) => item.product.title == product.title);
    if (existingIndex >= 0) {
      _items[existingIndex].quantity++;
    } else {
      _items.add(CartItem(product: product));
    }
    notifyListeners();
  }

  void removeItem(String productTitle) {
    _items.removeWhere((item) => item.product.title == productTitle);
    notifyListeners();
  }

  void updateQuantity(String productTitle, int quantity) {
    final index = _items.indexWhere((item) => item.product.title == productTitle);
    if (index >= 0) {
      if (quantity > 0) {
        _items[index].quantity = quantity;
      } else {
        _items.removeAt(index);
      }
      notifyListeners();
    }
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
} 