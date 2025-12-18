import 'package:agoraofolymus/components/my_list_tile.dart';
import 'package:agoraofolymus/pages/addItem_page.dart';
import 'package:agoraofolymus/pages/cart_page.dart';
import 'package:agoraofolymus/pages/profile_page.dart';
import 'package:agoraofolymus/pages/welcome_page.dart';
import 'package:agoraofolymus/pages/your_listed_item_page.dart';
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
          // ---------------- TOP SECTION ----------------
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

              // Profile
              MyListTile(
                icon: Icons.person_2,
                text: "My Profile",
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ProfilePage(),
                    ),
                  );
                },
              ),

              // Shop / Marketplace
              MyListTile(
                icon: Icons.shop,
                text: "Shop",
                onTap: () {
                  Navigator.pop(context);
                },
              ),

              // Cart
              MyListTile(
                icon: Icons.shopping_cart_checkout,
                text: "My Cart",
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const CartPage(),
                    ),
                  );
                },
              ),

              // 🔥 YOUR LISTED ITEMS (NEW FEATURE)
              MyListTile(
                icon: Icons.inventory,
                text: "Your Listed Items",
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const YourListedItemsPage(),
                    ),
                  );
                },
              ),

              // Add own item
              MyListTile(
                icon: Icons.add,
                text: "Add own Item",
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AdditemPage(),
                    ),
                  );
                },
              ),
            ],
          ),

          // ---------------- LOGOUT SECTION ----------------
          MyListTile(
            icon: Icons.logout_outlined,
            text: "Log Out",
            onTap: () async {
              Navigator.pop(context);

              await FirebaseAuth.instance.signOut();

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
