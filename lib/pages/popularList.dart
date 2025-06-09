import 'package:macaron_qr/pages/details_Page.dart';
import 'package:macaron_qr/models/menu.dart';
import 'package:flutter/material.dart';

class PopularItem extends StatefulWidget {
  PopularItem(this.item,{super.key});
  Menu item;

  @override
  State<PopularItem> createState() => _PopularItemState();
}

class _PopularItemState extends State<PopularItem> {
  @override
  Widget build(BuildContext context) {
    return

      Column(
          children:[
            const SizedBox(height: 10,),
            Container(
              margin: const EdgeInsets.all(10),
              width: 400,
              height: 100,

              decoration: BoxDecoration(
                  color: const Color.fromRGBO(33, 35, 37, 1),
                  borderRadius: BorderRadius.circular(20),

                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2), // Shadow color
                      spreadRadius: 5, // Spread radius
                      blurRadius: 7, // Blur radius
                      offset: const Offset(0, 3), // Offset in x and y directions
                    ),
                  ]
              ),
              child:InkWell(
                onTap: (){
                  Navigator.push(context,MaterialPageRoute(builder: (context)=>
                      DetailsPage(widget.item)));

                },
                child:
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 120,
                        height: 150,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            image: DecorationImage(image:AssetImage(widget.item.image!,),fit: BoxFit.contain)
                        ),
                      ),
                      Column(
                        children: [
                          const SizedBox(height: 10,),
                          Text(widget.item.category!,style:const TextStyle(color: Color.fromRGBO(213, 122, 67, 1),fontSize: 20),),
                          const SizedBox(height: 10,),
                          Container(
                            width: 200,
                            child: Text(widget.item.description!,style:const TextStyle(fontSize: 10,color: Colors.white),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          )




                        ],
                      ),

                      Column(

                        children: [
                          const SizedBox(height: 10,),
                          Container(
                            margin:const  EdgeInsets.only(right: 10),
                            child: Text('\$'+widget.item.price!,style:const TextStyle(color:  Color.fromRGBO(213, 122, 67, 1),fontSize: 18),),

                          ),




                          const SizedBox(height: 10,),
                          Container(
                            width: 35,
                            height: 35,
                            margin:const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: const Color.fromRGBO(209, 120, 66, 1),
                            ),
                            child: TextButton(child: const Text('+',style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),),onPressed: (){},),
                          ),
                        ],
                      )


                    ]),

              ),
            )









          ]

      );
  }
}