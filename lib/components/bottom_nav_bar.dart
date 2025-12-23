import 'package:agoraofolymus/pages/additem_page.dart';
import 'package:agoraofolymus/pages/inbox_page.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

import '../pages/marketplace_page.dart';
import '../pages/additem_page.dart';
import '../pages/profile_page.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Color backgroundColor;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.backgroundColor,
  });

  void _onTap(BuildContext context, int index) {
    if (index == currentIndex) return;

    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MarketplacePage()),
        );
        break;

      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const AdditemPage()),
        );
        break;

      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const InboxPage()),
        );
        break;

      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const ProfilePage()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      index: currentIndex,
      backgroundColor: backgroundColor,
      color: const Color(0xFFC9A24D),
      animationDuration: const Duration(milliseconds: 10000),
      items: const [
        Icon(Icons.home, color: Colors.black),
        Icon(Icons.add, color: Colors.black),
        Icon(Icons.message, color: Colors.black),
        Icon(Icons.person, color: Colors.black),
      ],
      onTap: (index) => _onTap(context, index),
    );
  }
}
