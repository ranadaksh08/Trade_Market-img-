import 'package:agoraofolymus/components/bottom_nav_bar.dart';
import 'package:agoraofolymus/util/category_card.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:agoraofolymus/providers/user_provider.dart';

import '../models/shop.dart';
import '../components/my_drawer.dart';
import '../components/my_product_tile.dart';

class MarketplacePage extends StatefulWidget {
  const MarketplacePage({super.key});

  @override
  State<MarketplacePage> createState() => _MarketplacePageState();
}

class _MarketplacePageState extends State<MarketplacePage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<Shop>().fetchMarketplace();
    });
  }

  @override
  Widget build(BuildContext context) {
    final shop = context.watch<Shop>();
    final products = shop.marketplace;

    final appUser = context.watch<UserProvider>().user;

    return Scaffold(
    bottomNavigationBar: const BottomNavBar( 
      currentIndex: 0, 
      backgroundColor: Color(0xFF1A1C23), 
    ),
      body: Stack(
        children: [
      // 🔹 Background layer
      Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0E0F13),
              Color(0xFF1A1C23),
            ],
          ),
        ),
      ),

     SafeArea(
  child: CustomScrollView(
    slivers: [

      // 👋 HEADER
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Γεια,',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    appUser?.username ?? '',
                    style: const TextStyle(
                      color: Color(0xFFC9A24D),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const Icon(Icons.person, color: Colors.white),
            ],
          ),
        ),
      ),

      const SliverToBoxAdapter(child: SizedBox(height: 25)),

      // 🟨 CARD
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Container(
            height: 180,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
            ),
          ),
        ),
      ),

      const SliverToBoxAdapter(child: SizedBox(height: 25)),

      // 🔍 SEARCH
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: const TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                border: InputBorder.none,
                hintText: "Search",
              ),
            ),
          ),
        ),
      ),

      const SliverToBoxAdapter(child: SizedBox(height: 20)),

      // 🏷 CATEGORIES
      SliverToBoxAdapter(
        child: SizedBox(
          height: 60,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 25),
            children: const [
              CategoryCard(),
              CategoryCard(),
              CategoryCard(),
              CategoryCard(),
            ],
          ),
        ),
      ),

      const SliverToBoxAdapter(child: SizedBox(height: 20)),

      // 🛒 PRODUCT GRID (KEY PART)
      SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        sliver: SliverGrid(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return MyProductTile(product: products[index]);
            },
            childCount: products.length,
          ),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.75,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
        ),
      ),

      const SliverToBoxAdapter(child: SizedBox(height: 100)),
    ],
  ),
),

],       
      ),
    );
  }
} 
