import 'package:agoraofolymus/components/my_list_tile.dart';
import 'package:agoraofolymus/pages/welcome_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
              const DrawerHeader(
                child: Center(
                  child: Icon(
                    Icons.favorite,
                    size: 72,
                  ),
                ),
              ),

              const SizedBox(height: 25),

              MyListTile(
                icon: Icons.person_2,
                text: "My Profile",
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/profile_page');
                },
              ),

              MyListTile(
                icon: Icons.shop,
                text: "Shop",
                onTap: () {},
              ),

              MyListTile(
                icon: Icons.shopping_cart_checkout,
                text: "My Cart",
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/cart_page');
                },
              ),

              MyListTile(
                icon: Icons.inventory,
                text: "Your Listed Items",
                onTap: () {},
              ),

              MyListTile(
                icon: Icons.add,
                text: "Add own Item",
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/additem_page');
                },
              ),
            ],
          ),

          // ✅ LOGOUT — FIXED
          MyListTile(
            icon: Icons.logout_outlined,
            text: "Log Out",
            onTap: () async {
              Navigator.pop(context); // close drawer

              await FirebaseAuth.instance.signOut();

              // 🔒 clear navigation stack and go to WelcomePage
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (_) => const WelcomePage(),
                ),
                (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}
