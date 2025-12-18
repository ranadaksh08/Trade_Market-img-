import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import '../models/shop.dart';
import '../models/product.dart';
import 'product_details_page.dart';

class SellerProfilePage extends StatelessWidget {
  final String sellerId;

  const SellerProfilePage({
    super.key,
    required this.sellerId,
  });

  @override
  Widget build(BuildContext context) {
    final shop = context.watch<Shop>();
    final List<Product> sellerItems = shop.userItems(sellerId);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Seller Profile"),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(sellerId)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text("Seller not found"));
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔹 Seller Info
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data['username'] ?? 'Unknown Seller',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      data['email'] ?? '',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),

              const Divider(),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "Other items by this seller",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // 🔹 Seller Items
              Expanded(
                child: sellerItems.isEmpty
                    ? const Center(child: Text("No items listed"))
                    : ListView.builder(
                        itemCount: sellerItems.length,
                        itemBuilder: (context, index) {
                          final product = sellerItems[index];
                          return ListTile(
                            title: Text(product.name),
                            subtitle: Text(product.shortDescription),
                            trailing: Text(
                              "₹${product.price}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      ProductDetailPage(product: product),
                                ),
                              );
                            },
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
