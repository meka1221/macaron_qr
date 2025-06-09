import 'package:flutter/foundation.dart';
import 'package:macaron_qr/models/user.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  bool _isAuthenticated = false;

  User? get user => _user;
  bool get isAuthenticated => _isAuthenticated;

  Future<bool> login(String email, String password) async {
    // Здесь будет логика аутентификации
    // Пока используем заглушку
    if (email == 'test@test.com' && password == 'password') {
      _user = User(
        id: '1',
        email: email,
        name: 'Test User',
      );
      _isAuthenticated = true;
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> register(String email, String password, String name) async {
    // Здесь будет логика регистрации
    // Пока используем заглушку
    _user = User(
      id: '1',
      email: email,
      name: name,
    );
    _isAuthenticated = true;
    notifyListeners();
    return true;
  }

  void logout() {
    _user = null;
    _isAuthenticated = false;
    notifyListeners();
  }
}