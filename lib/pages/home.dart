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

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List<Menu>list=Menu.Cappuccino; // The list that will show after we click to the item in the list

  bool TextColor=false; // To change the color of the text if we click to the button


  List coffeeType=[

    ['Cappuccino',true,],
    ['Hot Coffee',false,],
    ['Latte',false,],
    ['Cold Coffee',false,],
  ];


  void coffeeTypeSelected (int index){  // To change the list after the click

    setState(() {
      for(int i=0;i<coffeeType.length;i++){
        coffeeType[i][1]=false;
      }

      coffeeType[index][1]=true;
      if(coffeeType[index][0]=='Cappuccino')list=Menu.Cappuccino;
      else if(coffeeType[index][0]=='Hot Coffee')list=Menu.hotCoffee;
      else if(coffeeType[index][0]=='Latte')list=Menu.latte;
      else if(coffeeType[index][0]=='Cold Coffee')list=Menu.coldCoffee;
    });


  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: const Color.fromRGBO(33, 35, 37, 1),//change the background color

      appBar:appBar(),

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
                  Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.white, width: 2),
                      image: const DecorationImage(
                        image: AssetImage('images/man.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Consumer<AuthProvider>(
                    builder: (context, authProvider, _) {
                      return Text(
                        authProvider.isAuthenticated 
                            ? authProvider.user?.name ?? 'User'
                            : 'Гость',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      );
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const FavoritesPage()),
                          );
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

      body:SingleChildScrollView(

        child:Column(
          children: [
            const SizedBox(height: 30,),
            const TitleW(),
            const SizedBox(height: 10,),
            const SearchBox(),
            Container(
              width: double.infinity,
              height: 40,
              child:ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount:coffeeType.length,
                  itemBuilder: (context, index) {
                    return Name(
                      coffeeType: coffeeType[index][0],
                      isSelected: coffeeType[index][1],
                      onTap: (){
                        coffeeTypeSelected(index);
                      },

                    );
                  }

              ),

            ),
            const SizedBox(height: 10,),
            Cards(list),

            const SizedBox(height: 5,),

            const Align(

                alignment: Alignment.topLeft,

                child:Padding(
                  padding: EdgeInsets.only(left: 10),
                  child:Text('Popular',style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),) ,)

            ),

            for(int i=0;i<Menu.popularList.length;i++)PopularItem(Menu.popularList[i]),

            const SizedBox(height: 10,),

            const Align(

                alignment: Alignment.topLeft,

                child:Padding(

                  padding: EdgeInsets.only(left: 10),

                  child:Text('Sweets',
                    style:TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    )
                    ,)
                  ,)
            ),
            const SizedBox(height:5),
            Cards(Menu.cakes),




          ],
        ),
      ),


    );
  }


  AppBar appBar()  { // App Bar function that return AppBar
    return AppBar(
      backgroundColor: const Color.fromRGBO(33, 35, 37, 1),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu, color: Color.fromRGBO(151, 154, 157, 1)),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
          ),
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: const Color.fromRGBO(82, 85, 90, 1), width: 2),
              color: Colors.white,
              image: const DecorationImage(
                image: AssetImage('images/man.jpg'),
                fit: BoxFit.cover
              )
            ),
          )
        ]
      ),
    );
  }
}