import 'package:flutter/material.dart';
import 'package:macaron_qr/pages/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingItem> _items = [
    OnboardingItem(
      title: 'Добро пожаловать в Macaronnaya!',
      description: 'Ваши любимые десерты всего в нескольких шагах от вас. Мы предлагаем широкий выбор макарон, мадленов, круассанов и чизкейков.',
      image: 'assets/images/curasan.jpg',
    ),
    OnboardingItem(
      title: 'Большой выбор десертов',
      description: 'Макароны, мадлены, круассаны, чизкейки и ароматный кофе - выбирайте то, что вам по душе. Все десерты готовятся из отборных ингредиентов.',
      image: 'assets/images/1.jpg',
    ),
    OnboardingItem(
      title: 'Удобный заказ',
      description: 'Закажите любимые десерты с доставкой или заберите их в нашей кондитерской. Быстрая доставка и удобная оплата.',
      image: 'assets/images/2.jpg',
    ),
    OnboardingItem(
      title: 'Сохраняйте избранное',
      description: 'Создайте аккаунт, чтобы сохранять любимые десерты и быстро заказывать их снова. Получайте бонусы за каждый заказ!',
      image: 'assets/images/curasan.jpg',
    ),
  ];

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_seen_onboarding', true);
    
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const Home(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(33, 35, 37, 1),
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: _completeOnboarding,
                child: const Text(
                  'Пропустить',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _items.length,
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                itemBuilder: (context, index) {
                  return _buildPage(_items[index], index);
                },
              ),
            ),
            Padding(
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
                      onPressed: () {
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
                      child: const Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(OnboardingItem item, int index) {
    final bool isTextOnTop = index.isOdd;
    
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (isTextOnTop) ...[
            _buildTextContent(item),
            const Spacer(),
            _buildImage(item),
          ] else ...[
            _buildImage(item),
            const Spacer(),
            _buildTextContent(item),
          ],
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
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        Text(
          item.description,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildImage(OnboardingItem item) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Image.asset(
        item.image,
        height: 300,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    );
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
  final String image;
  final String title;
  final String description;

  OnboardingItem({
    required this.image,
    required this.title,
    required this.description,
  });
} 