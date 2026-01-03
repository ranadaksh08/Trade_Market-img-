import 'package:agoraofolymus/components/bottom_nav_bar.dart';
import 'package:flutter/material.dart';

class AuctionPage extends StatelessWidget {
  const AuctionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Extend the body behind the navigation bar for a seamless look
      extendBody: true,
      
      // Using a Container to apply the Gradient
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0E0F13), 
              Color(0xFF1A1C23),
            ],
          ),
        ),
        child: const SafeArea(
          child: Center(
            child: Text(
              "Auction Content Goes Here",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}