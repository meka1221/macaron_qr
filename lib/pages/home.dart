// lib/pages/home.dart

import 'package:macaron_qr/models/menu.dart';
import 'package:macaron_qr/pages/cards.dart';
import 'package:macaron_qr/pages/name.dart';
import 'package:macaron_qr/pages/popularList.dart';
import 'package:macaron_qr/pages/search.dart';
import 'package:macaron_qr/pages/title.dart';
import 'package:macaron_qr/pages/search_page.dart';
import 'package:macaron_qr/pages/favorites_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:macaron_qr/models/auth_provider.dart';
import 'package:macaron_qr/pages/login_page.dart';
import 'package:macaron_qr/pages/register_page.dart';
import 'package:lottie/lottie.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Menu> list = Menu.Macarons;
  bool TextColor = false;

  List coffeeType = [
    ['Macarons', true],
    ['Madlens', false],
    ['Croissants', false],
    ['Cheesecakes', false],
    ['Coffee', false],
  ];

  void coffeeTypeSelected(int index) {

    setState(() {
      for (int i = 0; i < coffeeType.length; i++) {
        coffeeType[i][1] = false;
      }

      coffeeType[index][1] = true;
      if (coffeeType[index][0] == 'Macarons') {
        list = Menu.Macarons;
      } else if (coffeeType[index][0] == 'Madlens') {
        list = Menu.Madlens;
      } else if (coffeeType[index][0] == 'Croissants') {
        list = Menu.Croissants;
      } else if (coffeeType[index][0] == 'Cheesecakes') {
        list = Menu.Cheesecakes;
      } else if (coffeeType[index][0] == 'Coffee') {
        list = Menu.Coffee;
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(33, 35, 37, 1),
      appBar: appBar(),
      drawer: Drawer(
        backgroundColor: const Color.fromRGBO(33, 35, 37, 1),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color.fromRGBO(209, 120, 66, 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Consumer<AuthProvider>(
                    builder: (context, authProvider, _) {
                      final user = authProvider.user;
                      return CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.white,
                        backgroundImage: user?.avatarUrl != null ? NetworkImage(user!.avatarUrl!) : null,
                        child: user?.avatarUrl == null
                            ? Icon(Icons.person, size: 30, color: const Color.fromRGBO(209, 120, 66, 1))
                            : null,
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  Consumer<AuthProvider>(
                    builder: (context, authProvider, _) {
                      print('Building user name widget. isAuthenticated: ${authProvider.isAuthenticated}, user: ${authProvider.user?.name}');
                      final userName = authProvider.isAuthenticated && authProvider.user != null
                          ? authProvider.user!.name
                          : 'Гость';
                      print('Displaying user name: $userName');
                      return Text(
                        userName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),

                  Consumer<AuthProvider>(
                    builder: (context, authProvider, _) {
                      if (authProvider.isAuthenticated && authProvider.user != null) {
                        print('Building points widget. Points: ${authProvider.user?.points}');
                        return Text(
                          'Баллы: ${authProvider.user!.points}',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ],
              ),
            ),
            Consumer<AuthProvider>(
              builder: (context, authProvider, _) {
                if (authProvider.isAuthenticated) {
                  return Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.favorite, color: Colors.white),
                        title: const Text(
                          'Избранное',
                          style: TextStyle(color: Colors.white),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, '/favorites');
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.person, color: Colors.white),
                        title: const Text(
                          'Профиль',
                          style: TextStyle(color: Colors.white),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          // TODO: Navigate to profile page
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.coffee, color: Colors.white),
                        title: const Text(
                          'Список кофеен',
                          style: TextStyle(color: Colors.white),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, '/cafes');
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.logout, color: Colors.white),
                        title: const Text(
                          'Выйти',
                          style: TextStyle(color: Colors.white),
                        ),
                        onTap: () {
                          authProvider.logout();
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.login, color: Colors.white),
                        title: const Text(
                          'Войти',
                          style: TextStyle(color: Colors.white),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const LoginPage()),
                          );
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.app_registration, color: Colors.white),
                        title: const Text(
                          'Регистрация',
                          style: TextStyle(color: Colors.white),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const RegisterPage()),
                          );
                        },
                      ),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color.fromRGBO(33, 35, 37, 1),
        unselectedItemColor: Colors.white,
        selectedItemColor: const Color.fromRGBO(209, 120, 66, 1),
        elevation: 0.0,
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SearchPage()),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const FavoritesPage()),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(CupertinoIcons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(CupertinoIcons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(CupertinoIcons.heart), label: 'Favorite'),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30),
            const TitleW(),
            const SizedBox(height: 10),
            // Кнопка QR-кода
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Container(
                width: double.infinity,
                height: 150,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(33, 35, 37, 1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Lottie.asset(
                  'assets/animations/qrCode.json',
                  fit: BoxFit.contain,
                  repeat: true,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: coffeeType.length,
                itemBuilder: (context, index) {
                  return Name(
                    coffeeType: coffeeType[index][0],
                    isSelected: coffeeType[index][1],
                    onTap: () {
                      coffeeTypeSelected(index);
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            Cards(list),
            const SizedBox(height: 5),
            const Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text(
                  'Popular',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            for (int i = 0; i < Menu.popularList.length; i++) PopularItem(Menu.popularList[i]),
            const SizedBox(height: 10),
            const Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text(
                  'Drinks',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 5),
            Cards(Menu.Drinks), // The drinks list
          ],
        ),
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      backgroundColor: const Color.fromRGBO(33, 35, 37, 1),
      elevation: 0.0,
      title: const Text(
        'Macaronnaya',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.shopping_cart, color: Colors.white),
          onPressed: () {
            Navigator.pushNamed(context, '/cart');
          },
        ),
      ],
    );
  }
}