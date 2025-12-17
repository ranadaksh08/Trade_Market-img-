import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Profile"),
      ),

      
      body: Center(
        child: Column(
          children: [
            Icon(
              Icons.person,
              size: 250),

            Text(
              "Anik_Iron_Biharboy69",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 25),
            Divider(),

            const SizedBox(height: 25),

            Padding(
              padding: const EdgeInsets.only(left: 25),
              child: Row(
                children: [
                  Icon(Icons.inventory_2_outlined),
                  Text(
                    "  Listed Items"
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.only(left: 25),
              child: Row(
                children: [
                  Icon(Icons.shopping_cart),
                  Text(
                    "  Cart"
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            Padding(
              padding: const EdgeInsets.only(left: 25),
              child: Row(
                children: [
                  Icon(Icons.settings),
                  Text(
                    "  Account Settings"
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}