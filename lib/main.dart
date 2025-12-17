import 'package:agoraofolymus/models/shop.dart';
import 'package:agoraofolymus/pages/addItem_page.dart';
import 'package:agoraofolymus/pages/cart_page.dart';
import 'package:agoraofolymus/pages/login_page.dart';
import 'package:agoraofolymus/pages/marketplace_page.dart';
import 'package:agoraofolymus/pages/profile_page.dart';
import 'package:agoraofolymus/pages/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => Shop(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WelcomePage(),
      routes: {
        '/profile_page' : (context) => ProfilePage(),
        '/additem_page' : (context) => AdditemPage(),
        '/marketplace_page' : (context) => MarketplacePage(),
        '/cart_page' : (context) => CartPage(),
        '/welcome_page' : (context) => WelcomePage(),
        '/login_page' : (context) => LoginPage(),

      },
    );
  }
}
