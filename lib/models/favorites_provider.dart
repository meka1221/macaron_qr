import 'package:flutter/foundation.dart';
import 'package:macaron_qr/models/menu.dart';
import 'package:macaron_qr/models/auth_provider.dart';

class FavoritesProvider with ChangeNotifier {
  final List<Menu> _favorites = [];
  final AuthProvider _authProvider;

  FavoritesProvider(this._authProvider);

  List<Menu> get favorites => _favorites;

  bool isFavorite(Menu item) {
    if (!_authProvider.isAuthenticated) return false;
    return _favorites.any((favorite) =>
      favorite.name == item.name &&
      favorite.price == item.price &&
      favorite.image == item.image
    );
  }

  void toggleFavorite(Menu item) {
    if (!_authProvider.isAuthenticated) {
      throw Exception('Необходимо войти в систему для добавления в избранное');
    }
    
    if (isFavorite(item)) {
      _favorites.removeWhere((favorite) =>
        favorite.name == item.name &&
        favorite.price == item.price &&
        favorite.image == item.image
      );
    } else {
      _favorites.add(item);
    }
    notifyListeners();
  }
}