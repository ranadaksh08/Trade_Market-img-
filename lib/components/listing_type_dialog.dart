import 'package:flutter/material.dart';

enum ListingType { marketplace, auction }

class ListingTypeDialog extends StatelessWidget {
  final ListingType? selectedType;
  final ValueChanged<ListingType> onSelected;

  const ListingTypeDialog({
    Key? key,
    this.selectedType,
    required this.onSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Choose Listing Type',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _optionTile(
            context,
            title: 'Marketplace',
            subtitle: 'Sell at a fixed price',
            icon: Icons.storefront,
            type: ListingType.marketplace,
          ),
          const SizedBox(height: 8),
          _optionTile(
            context,
            title: 'Auction',
            subtitle: 'Let users bid on your item',
            icon: Icons.gavel,
            type: ListingType.auction,
          ),
        ],
      ),
    );
  }

  Widget _optionTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required ListingType type,
  }) {
    final bool isSelected = selectedType == type;

    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () {
        onSelected(type);
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? Theme.of(context).primaryColor : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 2),
                  Text(subtitle, style: TextStyle(color: Colors.grey.shade600)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
