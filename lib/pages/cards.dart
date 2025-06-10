import 'package:macaron_qr/models/menu.dart';
import 'package:macaron_qr/pages/itemCard.dart';
import 'package:flutter/material.dart';

class Cards extends StatefulWidget {
  Cards(this.list,{super.key});

  List<Menu> list;

  @override
  State<Cards> createState() => _CardsState();
}

class _CardsState extends State<Cards> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 370,
      width: double.infinity,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          for(int i=0;i<widget.list.length;i++)ItemCard(widget.list[i]),
        ],
      ),
    );
  }
}