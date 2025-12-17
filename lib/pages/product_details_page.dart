import 'package:agoraofolymus/models/product.dart';
import 'package:flutter/material.dart';

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
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              Container(
                height: 220,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: product.imagePath.isEmpty
                    ? const Icon(Icons.image, size: 100)
                    : Image.asset(
                        product.imagePath,
                        fit: BoxFit.cover,
                      ),
              ),

              const SizedBox(height: 16),

              // Name
              Text(
                product.name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 6),

              // Price
              Text(
                "\$${product.price}",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),

              const SizedBox(height: 10),

              // Category & Rarity
              Row(
                children: [
                  Chip(label: Text(product.category)),
                  const SizedBox(width: 8),
                  Chip(label: Text(product.rarity)),
                ],
              ),

              const SizedBox(height: 20),

              // Short Description
              const Text(
                "Quick Overview",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                product.shortDescription,
                style: const TextStyle(fontSize: 14),
              ),

              const SizedBox(height: 20),

              // Long Description
              const Text(
                "Detailed Description",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                product.longDescription,
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
