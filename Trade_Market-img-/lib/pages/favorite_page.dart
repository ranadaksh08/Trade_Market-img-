import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import '../models/shop.dart';
import '../components/my_product_tile2.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  @override
  void initState() {
    super.initState();

    final user = FirebaseAuth.instance.currentUser!;
    Future.microtask(() {
      context.read<Shop>().fetchFavorites(user.uid);
    });
  }

  @override
  Widget build(BuildContext context) {
    final shop = context.watch<Shop>();
    final favorites = shop.favorites;

    return Scaffold(
      backgroundColor: const Color(0xFF0E0F13),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0E0F13),
        elevation: 0,
        title: const Text(
          "Favorites",
          style: TextStyle(color: Color(0xFFC9A24D)),
        ),
        iconTheme: const IconThemeData(
          color: Color(0xFFC9A24D),
        ),
      ),
      body: favorites.isEmpty
          ? const Center(
              child: Text(
                "No favorite items",
                style: TextStyle(color: Color(0xFFA0A0A0)),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                return MyProductTile2(
                  product: favorites[index],
                );
              },
            ),
    );
  }
}
