import 'package:agoraofolymus/components/my_button.dart';
import 'package:agoraofolymus/components/my_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'auth_page.dart';
import 'registration_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void signUserIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // ✅ AuthPage handles routing
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const AuthPage()),
        (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? "Login failed")),
      );
    }
  }

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
              Color(0xFF0E0F13), // Obsidian
              Color(0xFF1A1C23), // Charcoal
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 30),

                  // 🏛️ TITLE
                  const Text(
                    "AGORA OF OLYMPUS",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 26,
                      letterSpacing: 4,
                      color: Color(0xFFC9A24D),
                      fontWeight: FontWeight.w300,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    "Enter the divine marketplace",
                    style: TextStyle(
                      color: Color(0xFFA0A0A0),
                      fontSize: 13,
                    ),
                  ),

                  const SizedBox(height: 40),

                  // 🧾 LOGIN CARD
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    padding: const EdgeInsets.symmetric(
                      vertical: 30,
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1C23),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color(0xFFC9A24D).withOpacity(0.25),
                      ),
                    ),
                    child: Column(
                      children: [
                        MyTextfield(
                          controller: emailController,
                          hintText: "Email",
                          obscureText: false,
                        ),
                        const SizedBox(height: 16),
                        MyTextfield(
                          controller: passwordController,
                          hintText: "Password",
                          obscureText: true,
                        ),
                        const SizedBox(height: 24),
                        MyButton(
                          onTap: signUserIn,
                          child: const Center(
                            child: Text(
                              "SIGN IN",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // 🔁 REGISTER
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Not registered? ",
                        style: TextStyle(color: Colors.white70),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const RegisterPage(),
                            ),
                          );
                        },
                        child: const Text(
                          "Register now",
                          style: TextStyle(
                            color: Color(0xFFC9A24D),
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1,
                            shadows: [
                              Shadow(
                                blurRadius: 10,
                                color: Color(0x66C9A24D),
                                offset: Offset(0, 0),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
