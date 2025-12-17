import 'package:agoraofolymus/components/my_list_tile.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.grey[300],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
                      //drawer header : logo
          
          DrawerHeader(
            child: Center(
              child: Icon(
                Icons.favorite,
                size: 72,
                ),
              ),
            ),
          const SizedBox(height: 25),

          //Profile tile
          MyListTile(
            icon: Icons.person_2, 
            text: "My Profile", 
            onTap: (){
              //pop drawer
              Navigator.pop(context);

              //go to my profile
              Navigator.pushNamed(context, '/profile_page');
            }),

          //shop tile
          MyListTile(
            icon: Icons.shop, 
            text: "Shop", 
            onTap: (){}),

          //cart tile
          MyListTile(
            icon: Icons.shopping_cart_checkout, 
            text: "My Cart", 
            onTap: (){
              //pop drawer first 
              Navigator.pop(context);

              //go to cart page
              Navigator.pushNamed(context, '/cart_page');
            }),

          //Your Listed Item
          MyListTile(
            icon: Icons.inventory, 
            text: "Your Listed Items", 
            onTap: (){}),

             //Your Listed Item
            MyListTile(
            icon: Icons.add, 
            text: "Add own Item", 
            onTap: (){
              //pop drawer
              Navigator.pop(context);
              
              //go to add item page
              Navigator.pushNamed(context, '/additem_page');
            }),

            
            ],
          ),
          //exit
          MyListTile(
            icon: Icons.logout_outlined, 
            text: "LogOut", 
            onTap: (){}),

        ],
      ),
    );
  }
}