import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/shop.dart';
import '../components/my_product_tile.dart';

class SearchbarCard extends StatefulWidget {
  const SearchbarCard({super.key});

  @override
  State<SearchbarCard> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchbarCard> {
  final TextEditingController searchController = TextEditingController();
  String query = "";

  @override
  Widget build(BuildContext context) {
    final shop = context.watch<Shop>();

    final results = shop.marketplace.where((product) {
      return product.name.toLowerCase().contains(query.toLowerCase()) ||
          product.category.toLowerCase().contains(query.toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFF0E0F13),

      appBar: AppBar(
        backgroundColor: const Color(0xFF0E0F13),
        elevation: 0,
        title: TextField(
          controller: searchController,
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: "Search items...",
            hintStyle: TextStyle(color: Color(0xFFA0A0A0)),
            border: InputBorder.none,
          ),
          onChanged: (value) {
            setState(() => query = value);
          },
        ),
      ),

      body: results.isEmpty
          ? const Center(
              child: Text(
                "No results found",
                style: TextStyle(color: Color(0xFFA0A0A0)),
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(20),
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: results.length,
              itemBuilder: (context, index) {
                return MyProductTile(product: results[index]);
              },
            ),
    );
  }
}
