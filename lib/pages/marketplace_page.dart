import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Color(0xFFC9A24D),
        ),
        title: const Text(
          "Marketplace",
          style: TextStyle(
            color: Color(0xFFC9A24D),
          ),
        ),
        backgroundColor: const Color(0xFF0E0F13),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.message,
              color: Color(0xFFC9A24D),
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/inbox_page');
            },
          ),
        ],
      ),

      // ORIGINAL DRAWER
      drawer: const MyDrawer(),

      body: Container(
        width: double.infinity,
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
        child: products.isEmpty
            ? const Center(
                child: Text(
                  "No items available",
                  style: TextStyle(color: Color(0xFFB0B3BA)),
                ),
              )
            : GridView.builder(
                padding: const EdgeInsets.all(12),
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  return MyProductTile(product: products[index]);
                },
              ),
      ),
    );
  }
}
