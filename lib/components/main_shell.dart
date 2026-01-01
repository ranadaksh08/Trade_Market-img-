import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

import '../pages/marketplace_page.dart';
import '../pages/additem_page.dart';
import '../pages/inbox_page.dart';
import '../pages/auction_page.dart';
import '../pages/profile_page.dart';

class MainShell extends StatefulWidget {
  final int initialIndex;

  const MainShell({super.key, this.initialIndex = 0});

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
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 1000),
        switchInCurve: Curves.easeOutExpo,
        switchOutCurve: Curves.easeInExpo,

        transitionBuilder: (child, animation) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.025),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            ),
          );
        },
        child: KeyedSubtree(
          key: ValueKey(_currentIndex),
          child: _pages[_currentIndex],
        ),
      ),

      bottomNavigationBar: CurvedNavigationBar(
        index: _currentIndex,
        backgroundColor: const Color(0xFF1A1C23),
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
          setState(() => _currentIndex = index);
        },
      ),
    );
  }
}
