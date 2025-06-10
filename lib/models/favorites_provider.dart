import 'package:flutter/foundation.dart';
import 'package:macaron_qr/models/menu.dart';
import 'package:macaron_qr/models/auth_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FavoritesProvider with ChangeNotifier {
  final List<Menu> _favorites = [];
  final AuthProvider _authProvider;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isLoading = false;

  FavoritesProvider(this._authProvider) {
    if (_authProvider.isAuthenticated) {
      _loadFavorites();
    }
  }

  List<Menu> get favorites => _favorites;
  bool get isLoading => _isLoading;

  Future<void> _loadFavorites() async {
    if (!_authProvider.isAuthenticated) return;

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
          data['title'] ?? '',
          data['price'] ?? '',
          data['image'] ?? '',
          data['description'] ?? '',
          data['rating'] ?? '',
        ));
      }
    } catch (e) {
      print('Error loading favorites: $e');
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
    if (!_authProvider.isAuthenticated) {
      throw Exception('Необходимо войти в систему для добавления в избранное');
    }

    _isLoading = true;
    notifyListeners();

    try {
      final userFavoritesRef = _firestore
          .collection('users')
          .doc(_authProvider.user!.id)
          .collection('favorites');

      if (isFavorite(item)) {
        // Remove from favorites
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
        // Add to favorites
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
      throw Exception('Ошибка при обновлении избранного: ${e.toString()}');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}