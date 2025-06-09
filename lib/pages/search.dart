import 'package:flutter/material.dart';

class SearchBox extends StatefulWidget {
  const SearchBox({super.key});

  @override
  State<SearchBox> createState() => _SearchBoxState();
}

class _SearchBoxState extends State<SearchBox> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin:const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(51, 54, 57, 1),
        borderRadius: BorderRadius.circular(10),

      ),
      child:const TextField(
        decoration: InputDecoration(
            border: InputBorder.none,
            prefixIcon: Icon(Icons.search,color: Color.fromRGBO(151, 154, 157, 1) ,),
            hintText: 'Find Your Coffee...',
            hintStyle: TextStyle(
              color:  Color.fromRGBO(151, 154, 157, 1),
              fontWeight: FontWeight.normal,
            )

        ),

      ),
    );
  }
}