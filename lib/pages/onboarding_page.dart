import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:macaron_qr/pages/home.dart';
import 'package:macaron_qr/widgets/loading_animation.dart';
import 'package:lottie/lottie.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _isLoading = false;

  final List<OnboardingItem> _items = [
    OnboardingItem(
      image: 'assets/images/главная.jpg',
      title: 'Maкаронная',
      description: 'Добро пожаловать в Macaronnaya!',
    ),
    OnboardingItem(
      lottie: 'assets/animations/Animation.limonad.json',
      title: 'Быстрый заказ',
      description: 'Выбирайте из широкого ассортимента макарон, десертов и кофе',
    ),
    OnboardingItem(
      lottie: 'assets/animations/Animation.curasan.json',
      title: 'Избранное',
      description: 'Сохраняйте любимые позиции в избранное для быстрого доступа',
    ),
  ];

  Future<void> _completeOnboarding() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('has_seen_onboarding', true);
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const Home()),
        );
      }
    } catch (e) {
      print('Error completing onboarding: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(33, 35, 37, 1),
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: _items.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              return _buildPage(_items[index], index);
            },
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _items.length,
                      (index) => _buildDot(index),
                    ),
                  ),
                  SizedBox(
                    height: 60,
                    width: 60,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : () {
                        if (_currentPage < _items.length - 1) {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        } else {
                          _completeOnboarding();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(209, 120, 66, 1),
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(15),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                              size: 40,
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black54,
              child: const LoadingAnimation(),
            ),
        ],
      ),
    );
  }

  Widget _buildPage(OnboardingItem item, int index) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildImage(item),
          const SizedBox(height: 40),
          _buildTextContent(item),
        ],
      ),
    );
  }

  Widget _buildTextContent(OnboardingItem item) {
    return Column(
      children: [
        Text(
          item.title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        Text(
          item.description,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 20,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildImage(OnboardingItem item) {
    if (item.lottie != null) {
      return SizedBox(
        height: 300,
        child: Lottie.asset(
          item.lottie!,
          fit: BoxFit.contain,
        ),
      );
    } else if (item.image != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.asset(
          item.image!,
          height: 300,
          fit: BoxFit.cover,
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget _buildDot(int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _currentPage == index
            ? const Color.fromRGBO(209, 120, 66, 1)
            : Colors.grey,
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

class OnboardingItem {
  final String? image;
  final String? lottie;
  final String title;
  final String description;
  OnboardingItem({this.image, this.lottie, required this.title, required this.description});
} 