import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  final String category;
  final IconData icon;

  const CategoryCard({
    super.key,
    required this.category,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 17, 18, 22),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: const Color(0xFFC9A24D),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 6,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: const Color(0xFFC9A24D),
              size: 22,
            ),
            const SizedBox(width: 8),
            Text(
              category,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 14,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
