import 'package:flutter/material.dart';

class MyListTile extends StatelessWidget {
  final String text;
  final IconData icon;
  final void Function()? onTap;

  const MyListTile({
    super.key,
    required this.icon,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon, // ✅ YOUR ICON IS BACK
        color: const Color(0xFFB0B3BA), // Ash Grey
      ),
      title: Text(
        text,
        style: const TextStyle(
          fontSize: 16.0,
          color: Color(0xFFB0B3BA), // Ash Grey
        ),
      ),
      onTap: onTap,
    );
  }
}
