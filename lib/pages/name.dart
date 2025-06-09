import 'package:flutter/material.dart';

class Name extends StatelessWidget {
  final String coffeeType;
  final bool isSelected;
  final VoidCallback onTap;
  Name(
      {required this.coffeeType,
        required this.isSelected,
        required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
          padding: EdgeInsets.only(left: 25),
          child: Container(
            margin: EdgeInsets.only(bottom: 17),
            decoration: BoxDecoration(
                border: Border(
                  // To change the color of the line
                    bottom: BorderSide(
                        color: isSelected
                            ? const Color.fromRGBO(213, 122, 67, 1)
                            : Color.fromRGBO(33, 35, 37, 1),
                        width: 0.6))),
            child: Text(
              coffeeType,
              style: TextStyle(
                color: isSelected
                    ? const Color.fromRGBO(213, 122, 67, 1)
                    : Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.normal,
              ),
            ),
          )),
    );
  }
}
