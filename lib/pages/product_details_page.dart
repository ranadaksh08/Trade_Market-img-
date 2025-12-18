import 'package:flutter/material.dart';
import '../models/product.dart';
import 'seller_profile_page.dart';

class ProductDetailPage extends StatelessWidget {
  final Product product;

  const ProductDetailPage({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🖼 Product Image
            Container(
              height: 220,
              width: double.infinity,
              color: Colors.grey[300],
              child: product.imagePath.isEmpty
                  ? const Icon(Icons.image, size: 100)
                  : Image.asset(
                      product.imagePath,
                      fit: BoxFit.cover,
                    ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🏷 Name
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // 💰 Price
                  Text(
                    "₹${product.price}",
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.green,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // 🧩 Category & Rarity
                  Row(
                    children: [
                      Chip(label: Text(product.category)),
                      const SizedBox(width: 8),
                      Chip(label: Text(product.rarity)),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // 📄 Short Description
                  const Text(
                    "Description",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(product.longDescription),

                  const SizedBox(height: 30),

                  // 🔥 Seller Profile Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SellerProfilePage(
                              sellerId: product.ownerId,
                            ),
                          ),
                        );
                      },
                      child: const Text("Seller Profile"),
                    ),
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
