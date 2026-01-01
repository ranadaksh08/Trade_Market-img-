import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

import '../pages/marketplace_page.dart';
import '../pages/additem_page.dart';
import '../pages/inbox_page.dart';
import '../pages/auction_page.dart';
import '../pages/profile_page.dart';

class MainShell extends StatefulWidget {
  /// Which tab should be opened first
  /// 0 = Marketplace
  /// 1 = Add Item
  /// 2 = Inbox
  /// 3 = Auction
  /// 4 = Profile
  final int initialIndex;

  const MainShell({
    super.key,
    this.initialIndex = 0,
  });

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  late int _currentIndex;

  final List<Widget> _pages = const [
    MarketplacePage(),
    AdditemPage(),
    InboxPage(),
    AuctionPage(),
    ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: CurvedNavigationBar(
        index: _currentIndex,
        backgroundColor: Color(0xFF1A1C23),
        color: const Color(0xFFC9A24D),
        animationDuration: const Duration(milliseconds: 350),
        items: const [
          Icon(Icons.home, color: Colors.black),
          Icon(Icons.add, color: Colors.black),
          Icon(Icons.message, color: Colors.black),
          Icon(Icons.gavel, color: Colors.black),
          Icon(Icons.person, color: Colors.black),
        ],
        onTap: (index) {
          if (index == _currentIndex) return;
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
