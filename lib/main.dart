import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:macaron_qr/models/auth_provider.dart';
import 'package:macaron_qr/models/favorites_provider.dart';
import 'package:macaron_qr/pages/home.dart';
import 'package:macaron_qr/pages/onboarding_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProxyProvider<AuthProvider, FavoritesProvider>(
          create: (context) => FavoritesProvider(context.read<AuthProvider>()),
          update: (context, authProvider, previous) =>
              FavoritesProvider(authProvider),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Coffee Shop',
        theme: ThemeData(
          primaryColor: const Color.fromRGBO(209, 120, 66, 1),
          scaffoldBackgroundColor: const Color.fromRGBO(33, 35, 37, 1),
          colorScheme: ColorScheme.dark(
            primary: const Color.fromRGBO(209, 120, 66, 1),
            secondary: Colors.white,
            background: const Color.fromRGBO(33, 35, 37, 1),
          ),
          textTheme: const TextTheme(
            bodyLarge: TextStyle(color: Colors.white),
            bodyMedium: TextStyle(color: Colors.white),
            titleLarge: TextStyle(color: Colors.white),
          ),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: hasSeenOnboarding ? const Home() : const OnboardingPage(),
      ),
    );
  }
}