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

    // 🔥 Fetch products from Firestore once
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
  title: const Text("Marketplace"),
  actions: [
    IconButton(
      icon: const Icon(Icons.message),
      onPressed: () {
        Navigator.pushNamed(context, '/inbox_page');
      },
    ),
  ],
),

      drawer: const MyDrawer(),
      body: products.isEmpty
          ? const Center(child: Text("No items available"))
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
    );
  }
}
