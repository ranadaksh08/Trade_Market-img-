import 'package:flutter/material.dart';

class CategoryRarityBadges extends StatelessWidget {
  final String category;
  final String rarity;

  const CategoryRarityBadges({
    super.key,
    required this.category,
    required this.rarity,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _Badge(
          text: category,
          icon: _categoryIcon(category),
          color: Colors.white,
          glowColor: Colors.white24,
        ),
        const SizedBox(width: 10),
        _Badge(
          text: rarity,
          icon: _rarityIcon(rarity),
          color: _rarityColor(rarity),
          glowColor: _rarityColor(rarity),
        ),
      ],
    );
  }

  // ---------------- ICON HELPERS ----------------

  IconData _categoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'weapon':
        return Icons.flash_on;
      case 'potion':
        return Icons.science;
      case 'artifact':
        return Icons.auto_awesome;
      case 'armour':
        return Icons.shield;
      default:
        return Icons.category;
    }
  }

  IconData _rarityIcon(String rarity) {
    switch (rarity.toLowerCase()) {
      case 'common':
        return Icons.circle;
      case 'rare':
        return Icons.star_border;
      case 'legendary':
        return Icons.star;
      case 'mythical':
        return Icons.whatshot;
      default:
        return Icons.help_outline;
    }
  }

  Color _rarityColor(String rarity) {
    switch (rarity.toLowerCase()) {
      case 'common':
        return Colors.grey;
      case 'rare':
        return Colors.blueAccent;
      case 'legendary':
        return Colors.orangeAccent;
      case 'mythical':
        return Colors.purpleAccent;
      default:
        return Colors.white;
    }
  }
}

// ---------------- SINGLE BADGE ----------------

class _Badge extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color color;
  final Color glowColor;

  const _Badge({
    required this.text,
    required this.icon,
    required this.color,
    required this.glowColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withOpacity(0.6),
        ),
        boxShadow: [
          BoxShadow(
            color: glowColor.withOpacity(0.5),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      
      child: Row(
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 13,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.4,
            ),
          ),
        ],
      ),
    );
  }
}