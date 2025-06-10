import 'package:flutter/material.dart';

class TitleW extends StatelessWidget {
  const TitleW({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        SizedBox(width: 20,),
        Text(
          'Find The best\ndessert for you',
          style: TextStyle(
              fontSize: 35,
              fontWeight: FontWeight.bold,
              color: Colors.white
          ),
        )
      ],
    );
  }
}