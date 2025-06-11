import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:macaron_qr/models/favorites_provider.dart';
import 'package:macaron_qr/models/menu.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(33, 35, 37, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(33, 35, 37, 1),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Избранное',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Consumer<FavoritesProvider>(
        builder: (context, favoritesProvider, child) {

          if (favoritesProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Color.fromRGBO(209, 120, 66, 1)),
            );
          }


          if (favoritesProvider.favorites.isEmpty) {
            return const Center(
              child: Text(
                'Пока нет избранных товаров.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            );
          }


          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: favoritesProvider.favorites.length,
            itemBuilder: (context, index) {
              final item = favoritesProvider.favorites[index];
              return Card(
                color: const Color.fromRGBO(51, 54, 57, 1),
                margin: const EdgeInsets.only(bottom: 16),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),

                    child: item.image != null && item.image!.startsWith('http')
                        ? Image.network(
                      item.image!,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.broken_image, size: 60, color: Colors.grey),
                    )
                        : Image.asset(
                      item.image!,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.error_outline, size: 60, color: Colors.grey),
                    ),
                  ),
                  title: Text(
                    item.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    '${item.price} сом',
                    style: const TextStyle(
                      color: Color.fromRGBO(209, 120, 66, 1),
                      fontSize: 14,
                    ),
                  ),
                  trailing: IconButton(
                    icon: const Icon(
                      Icons.favorite,
                      color: Color.fromRGBO(209, 120, 66, 1),
                    ),
                    onPressed: () {

                      favoritesProvider.toggleFavorite(item).then((_) {

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(favoritesProvider.isFavorite(item)
                                ? 'Товар добавлен в избранное!'
                                : 'Товар удален из избранного!'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }).catchError((error) {

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Ошибка: ${error.toString()}'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      });
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}