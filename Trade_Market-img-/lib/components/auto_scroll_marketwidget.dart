import 'dart:async';
import 'package:flutter/material.dart';

class AutoScrollMarket extends StatefulWidget {
  const AutoScrollMarket({super.key});

  @override
  State<AutoScrollMarket> createState() => _AutoScrollMarketState();
}

class _AutoScrollMarketState extends State<AutoScrollMarket> {
  final PageController _controller =
      PageController(viewportFraction: 0.85);

  late Timer _timer;
  int _currentIndex = 0;

  final List<IconData> icons = [
    Icons.gavel,
    Icons.shield,
    Icons.local_drink,
    Icons.auto_awesome,
  ];

  final List<String> labels = [
    "Weapons",
    "Armor",
    "Potions",
    "Artifacts",
  ];

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!_controller.hasClients) return;

      _currentIndex++;

      _controller.animateToPage(
        _currentIndex,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );

      // 🔁 Jump back seamlessly
      if (_currentIndex == icons.length) {
        Future.delayed(const Duration(milliseconds: 650), () {
          if (_controller.hasClients) {
            _controller.jumpToPage(0);
            _currentIndex = 0;
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: PageView.builder(
        controller: _controller,
        itemCount: icons.length + 1, // 👈 duplicate first
        itemBuilder: (context, index) {
          final actualIndex = index == icons.length ? 0 : index;

          return _marketCard(
            icon: icons[actualIndex],
            label: labels[actualIndex],
          );
        },
      ),
    );
  }

  Widget _marketCard({
    required IconData icon,
    required String label,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
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
              color: Colors.black.withOpacity(0.4),
              blurRadius: 10,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: const Color(0xFFC9A24D)),
            const SizedBox(height: 12),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
