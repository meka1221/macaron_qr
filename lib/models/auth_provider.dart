import 'package:flutter/foundation.dart';
import 'package:macaron_qr/models/user.dart' as app_user;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:firebase_database/firebase_database.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  app_user.User? _user;
  bool _isLoading = false;
  StreamSubscription<DocumentSnapshot>? _userDocSubscription;

  AuthProvider() {
    _auth.authStateChanges().listen((User? firebaseUser) async {
      _userDocSubscription?.cancel();
      _userDocSubscription = null;

      if (firebaseUser != null) {
        try {
          final doc = await _firestore.collection('users').doc(firebaseUser.uid).get();
          if (doc.exists) {
            final data = doc.data()!;
            _user = app_user.User(
              id: firebaseUser.uid,
              email: firebaseUser.email ?? '',
              name: data['name'] ?? firebaseUser.displayName ?? '',
              points: data['points'] ?? 0,
              avatarUrl: data['avatarUrl'],
            );
          } else {
            _user = app_user.User(
              id: firebaseUser.uid,
              email: firebaseUser.email ?? '',
              name: firebaseUser.displayName ?? '',
              points: 0,
            );
            await _firestore.collection('users').doc(firebaseUser.uid).set(_user!.toJson());
          }
        } catch (e) {
          print('Error loading user data: $e');
          _user = null;
        }
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
      print('Starting registration process...');

      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      print('User created with ID: ${userCredential.user?.uid}');

      if (userCredential.user != null) {
        final newUser = app_user.User(
          id: userCredential.user!.uid,
          email: email,
          name: name,
          points: 0,
        );

        // Firestore
        await _firestore.collection('users').doc(newUser.id).set({
          'id': newUser.id,
          'email': newUser.email,
          'name': newUser.name,
          'points': newUser.points,
          'createdAt': FieldValue.serverTimestamp(),
        });

        // Realtime Database
        final databaseRef = FirebaseDatabase.instance.ref();
        await databaseRef.child('users').child(newUser.id).set({
          'id': newUser.id,
          'email': newUser.email,
          'name': newUser.name,
          'points': newUser.points,
        });

        await userCredential.user!.updateDisplayName(name);

        _user = newUser;

        _userDocSubscription?.cancel();
        _userDocSubscription = _firestore
            .collection('users')
            .doc(newUser.id)
            .snapshots()
            .listen((doc) {
          if (doc.exists) {
            final data = doc.data()!;
            _user = app_user.User(
              id: newUser.id,
              email: newUser.email,
              name: data['name'] ?? name,
              points: data['points'] ?? 0,
              avatarUrl: data['avatarUrl'],
            );
            notifyListeners();
          }
        });
      }
    } catch (e) {
      print('Registration error: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> uploadAvatar(File imageFile) async {
    if (_user == null) return;

    try {
      _isLoading = true;
      notifyListeners();

      final ref = FirebaseStorage.instance
          .ref()
          .child('users')
          .child(_user!.id)
          .child('avatar.jpg');

      await ref.putFile(imageFile);
      final downloadUrl = await ref.getDownloadURL();

      await _firestore.collection('users').doc(_user!.id).update({
        'avatarUrl': downloadUrl,
      });

      _user = _user!.copyWith(avatarUrl: downloadUrl);
      notifyListeners();
    } catch (e) {
      print('Error uploading avatar: $e');
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
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _userDocSubscription?.cancel();
    super.dispose();
  }
}
