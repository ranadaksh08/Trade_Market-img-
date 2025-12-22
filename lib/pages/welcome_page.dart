import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0E0F13), // Obsidian Black
              Color(0xFF1A1C23), // Charcoal
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(flex: 2),

              // 🏛️ APP TITLE
              Column(
                children: const [
                  Text(
                    "AGORA",
                    style: TextStyle(
                      fontSize: 42,
                      letterSpacing: 6,
                      color: Color(0xFFC9A24D), // Olympian Gold
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    "OF",
                    style: TextStyle(
                      fontSize: 20,
                      letterSpacing: 4,
                      color: Color(0xFFC9A24D),
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    "OLYMPUS",
                    style: TextStyle(
                      fontSize: 42,
                      letterSpacing: 6,
                      color: Color(0xFFC9A24D),
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // ✨ TAGLINE
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  "A divine marketplace where legends trade artifacts.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFFA0A0A0), // Ash Grey
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
              ),

              const Spacer(flex: 3),

              // 🔱 FEATURE HINTS
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: const [
                    _FeatureHint(icon: Icons.gavel, label: "Trade"),
                    _FeatureHint(
                        icon: Icons.chat_bubble_outline, label: "Chat"),
                    _FeatureHint(
                        icon: Icons.verified_user_outlined, label: "Trusted"),
                  ],
                ),
              ),

              const Spacer(flex: 2),

              // 🔥 PRIMARY CTA
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/login_page');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFC9A24D),
                      foregroundColor: const Color(0xFF0E0F13),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 4,
                    ),
                    child: const Text(
                      "ENTER THE AGORA",
                      style: TextStyle(
                        letterSpacing: 2,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 14),

              const Spacer(),

              // 🪶 FOOTER
              const Padding(
                padding: EdgeInsets.only(bottom: 16),
                child: Text(
                  "Powered by the Agora",
                  style: TextStyle(
                    color: Color(0xFF6F6F6F),
                    fontSize: 11,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 🔹 FEATURE HINT WIDGET
class _FeatureHint extends StatelessWidget {
  final IconData icon;
  final String label;

  const _FeatureHint({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          color: Colors.white70,
          size: 26,
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }
}
