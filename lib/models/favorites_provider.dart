import 'package:flutter/foundation.dart';
import 'package:macaron_qr/models/menu.dart';
import 'package:macaron_qr/models/auth_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class FavoritesProvider with ChangeNotifier {
  final List<Menu> _favorites = [];
  final AuthProvider _authProvider;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isLoading = false;
  bool _isDisposed = false;

  FavoritesProvider(this._authProvider) {

    _authProvider.addListener(_onAuthChange);

    _onAuthChange();
  }

  List<Menu> get favorites => _favorites;
  bool get isLoading => _isLoading;

  @override
  void notifyListeners() {
    if (!_isDisposed) {
      super.notifyListeners();
    }
  }


  void _onAuthChange() {
    if (_isDisposed) return;

    if (_authProvider.isAuthenticated && _authProvider.user != null) {

      _loadFavorites();
    } else {

      _favorites.clear();
      notifyListeners();
    }
  }

  Future<void> _loadFavorites() async {
    if (_isDisposed) return;
    if (!_authProvider.isAuthenticated || _authProvider.user == null) {
      _favorites.clear();
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(_authProvider.user!.id)
          .collection('favorites')
          .get();

      _favorites.clear();
      for (var doc in snapshot.docs) {
        final data = doc.data();
        _favorites.add(Menu(
          data['title'] as String? ?? '',
          data['price'] as String? ?? '',
          data['image'] as String? ?? '',
          data['description'] as String? ?? '',
          data['rating'] as String? ?? '',
        ));
      }
    } catch (e) {
      print('Error loading favorites: $e');
      _favorites.clear();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


  bool isFavorite(Menu item) {
    if (!_authProvider.isAuthenticated) return false;
    return _favorites.any((favorite) =>
    favorite.title == item.title &&
        favorite.price == item.price &&
        favorite.image == item.image
    );
  }


  Future<void> toggleFavorite(Menu item) async {
    if (_isDisposed) return;
    if (!_authProvider.isAuthenticated) {
      throw Exception('Для управления избранным необходимо войти в систему.');
    }

    _isLoading = true;
    notifyListeners();

    try {
      final userFavoritesRef = _firestore
          .collection('users')
          .doc(_authProvider.user!.id)
          .collection('favorites');

      if (isFavorite(item)) {

        final querySnapshot = await userFavoritesRef
            .where('title', isEqualTo: item.title)
            .where('price', isEqualTo: item.price)
            .where('image', isEqualTo: item.image)
            .get();

        for (var doc in querySnapshot.docs) {
          await doc.reference.delete();
        }


        _favorites.removeWhere((favorite) =>
        favorite.title == item.title &&
            favorite.price == item.price &&
            favorite.image == item.image
        );
      } else {

        await userFavoritesRef.add({
          'title': item.title,
          'price': item.price,
          'image': item.image,
          'description': item.description,
          'rating': item.rating,
          'addedAt': FieldValue.serverTimestamp(),
        });


        _favorites.add(item);
      }
    } catch (e) {
      print('Error toggling favorite: $e');
      throw Exception('Ошибка при обновлении избранного: ${e.toString()}');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    _authProvider.removeListener(_onAuthChange);
    super.dispose();
  }
}