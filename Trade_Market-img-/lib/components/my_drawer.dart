import 'package:agoraofolymus/components/my_list_tile.dart';
import 'package:agoraofolymus/pages/addItem_page.dart';
import 'package:agoraofolymus/pages/favorite_page.dart';
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
      backgroundColor: const Color(0xFF12141A),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // -------- TOP SECTION --------
          Column(
            children: [
              const DrawerHeader(
                child: Center(
                  child: Icon(
                    Icons.favorite,
                    size: 72,
                    color: Color(0xFFB0B3BA),
                  ),
                ),
              ),

              const SizedBox(height: 25),

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

              MyListTile(
                icon: Icons.shop,
                text: "Shop",
                onTap: () {
                  Navigator.pop(context);
                },
              ),

              MyListTile(
                icon: Icons.shopping_cart_checkout,
                text: "Favorites",
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const FavoritePage(),
                    ),
                  );
                },
              ),

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

          // -------- LOGOUT --------
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 25),
            child: MyListTile(
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
          ),
        ],
      ),
    );
  }
}
