import 'package:flutter/foundation.dart';
import 'package:macaron_qr/models/user.dart' as app_user;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  app_user.User? _user;
  bool _isLoading = false;

  AuthProvider() {
    _auth.authStateChanges().listen((User? user) {
      if (user != null) {
        _user = app_user.User(
          id: user.uid,
          email: user.email ?? '',
          name: user.displayName ?? '',
        );
      } else {
        _user = null;
      }
      notifyListeners();
    });
  }

  app_user.User? get user => _user;
  bool get isAuthenticated => _user != null;
  bool get isLoading => _isLoading;

  Future<void> login(String email, String password) async {
    try {
      _isLoading = true;
      notifyListeners();
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      print('Login error: $e');
      if (e is FirebaseAuthException) {
        throw e.message ?? 'Ошибка входа';
      }
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> register(String email, String password, String name) async {
    try {
      _isLoading = true;
      notifyListeners();
      
      print('Starting registration for email: $email');
      
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      print('User created successfully: ${userCredential.user?.uid}');

      if (userCredential.user != null) {
        print('Creating user document in Firestore');
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'name': name,
          'email': email,
          'createdAt': FieldValue.serverTimestamp(),
        });
        print('User document created successfully');
      }
    } catch (e) {
      print('Registration error: $e');
      if (e is FirebaseAuthException) {
        print('Firebase Auth Error Code: ${e.code}');
        print('Firebase Auth Error Message: ${e.message}');
        throw e.message ?? 'Ошибка регистрации';
      }
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    try {
      _isLoading = true;
      notifyListeners();
      await _auth.signOut();
    } catch (e) {
      print('Logout error: $e');
      if (e is FirebaseAuthException) {
        throw e.message ?? 'Ошибка выхода';
      }
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
