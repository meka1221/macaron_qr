import 'package:flutter/material.dart';
import 'package:macaron_qr/pages/onboarding_page.dart';
import 'package:provider/provider.dart';
import 'package:macaron_qr/models/auth_provider.dart';
import 'package:macaron_qr/models/favorites_provider.dart';
import 'package:macaron_qr/models/cart_provider.dart';
import 'package:macaron_qr/pages/home.dart';
import 'package:macaron_qr/pages/login_page.dart';
import 'package:macaron_qr/pages/register_page.dart';
import 'package:macaron_qr/pages/favorites_page.dart';
import 'package:macaron_qr/pages/cart_page.dart';
import 'package:macaron_qr/pages/checkout_page.dart';
import 'package:macaron_qr/pages/cafes_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:macaron_qr/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();


  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final prefs = await SharedPreferences.getInstance();
  final hasSeenOnboarding = prefs.getBool('has_seen_onboarding') ?? false;

  print('Onboarding state: ${hasSeenOnboarding ? 'Seen' : 'Not seen'}');

  runApp(MyApp(hasSeenOnboarding: hasSeenOnboarding));
}

class MyApp extends StatelessWidget {
  final bool hasSeenOnboarding;

  const MyApp({super.key, required this.hasSeenOnboarding});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [

        ChangeNotifierProvider(create: (_) => AuthProvider()),



        ChangeNotifierProvider(
          create: (context) {

            return FavoritesProvider(context.read<AuthProvider>());
          },
        ),


        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],

      child: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Macaronnaya',
            theme: ThemeData(
              primaryColor: const Color.fromRGBO(209, 120, 66, 1),
              scaffoldBackgroundColor: const Color.fromRGBO(33, 35, 37, 1),
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color.fromRGBO(209, 120, 66, 1),
                brightness: Brightness.dark,
              ),
              textTheme: const TextTheme(
                bodyLarge: TextStyle(color: Colors.white),
                bodyMedium: TextStyle(color: Colors.white),
                titleLarge: TextStyle(color: Colors.white),
              ),
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            routes: {
              '/': (context) => hasSeenOnboarding
                  ? (authProvider.isAuthenticated ? const Home() : const LoginPage())
                  : const OnboardingPage(),
              '/home': (context) => const Home(),
              '/login': (context) => const LoginPage(),
              '/register': (context) => const RegisterPage(),
              '/favorites': (context) => const FavoritesPage(),
              '/cart': (context) => const CartPage(),
              '/checkout': (context) => const CheckoutPage(),
              '/cafes': (context) => const CafesPage(),
            },
          );
        },
      ),
    );
  }
}