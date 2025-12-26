import 'package:flutter/material.dart';
import '../models/product.dart';
import '../pages/product_details_page.dart';

class MyProductTile extends StatelessWidget {
  final Product product;

  const MyProductTile({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductDetailPage(product: product),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1A1C23),
              Color(0xFF0E0F13),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.9),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [

            // 🖼 IMAGE
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: product.imagePath.isNotEmpty
                    ? Image.network(
                        product.imagePath,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        color: const Color.fromARGB(255, 0, 0, 0),
                        child: Center(
                          child: Image.asset(
                            'lib/images/solidwater.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
              ),
            ),

            // 📄 CONTENT
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 6, 10),
              child: SizedBox(
                width: double.infinity, // ✅ forces left alignment
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    // 🏷 NAME
                    Text(
                      product.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),

                    const SizedBox(height: 4),

                    // 📝 SHORT DESCRIPTION
                    Text(
                      product.shortDescription,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),

                    const SizedBox(height: 6),

                    // 💰 PRICE
                    Text(
                      "₹${product.price}",
                      style: const TextStyle(
                        color: Color(0xFFC9A24D),
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
