import 'package:flutter/material.dart';
import '../models/product.dart';
import '../pages/product_details_page.dart';

class MyProductTile2 extends StatelessWidget {
  final Product product;

  const MyProductTile2({
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
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1C23), // Charcoal Night
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: const Color(0x33C9A24D), // Gold @ 20%
          ),
        ),
        child: Row(
          children: [
            // IMAGE PLACEHOLDER
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: const Color(0xFF0E0F13),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.image,
                color: Color(0xFFC9A24D),
                size: 36,
              ),
            ),

            const SizedBox(width: 14),

            // PRODUCT INFO
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    product.shortDescription,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFFA0A0A0),
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    "₹${product.price}",
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6FCF97), // Emerald Green
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
