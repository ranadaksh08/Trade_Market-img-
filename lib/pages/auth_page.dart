import 'package:agoraofolymus/pages/login_page.dart';
import 'package:agoraofolymus/pages/marketplace_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // 🔄 waiting for Firebase to decide
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // ✅ user logged in
        if (snapshot.hasData) {
          return MarketplacePage();
        }

        // ❌ user not logged in
        return LoginPage();
      },
    );
  }
}
