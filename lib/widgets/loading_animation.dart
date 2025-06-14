import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoadingAnimation extends StatelessWidget {
  final double size;
  final Color? color;

  const LoadingAnimation({
    super.key,
    this.size = 200,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.asset(
        'assets/animations/order_success.json',
        width: size,
        height: size,
        fit: BoxFit.contain,
      ),
    );
  }
} 