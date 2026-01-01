import 'package:agoraofolymus/components/main_shell.dart';
import 'package:agoraofolymus/pages/login_page.dart';
import 'package:agoraofolymus/pages/marketplace_page.dart';
import 'package:agoraofolymus/providers/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool _userLoaded = false;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // 🔄 waiting for Firebase
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // ✅ user logged in
        if (snapshot.hasData) {
          // 👇 load Firestore user ONCE
          if (!_userLoaded) {
            _userLoaded = true;
            Future.microtask(() {
              context.read<UserProvider>().loadUser();
            });
          }

          return const MainShell();
        }

        // ❌ user not logged in
        _userLoaded = false;
        return const LoginPage();
      },
    );
  }
}
