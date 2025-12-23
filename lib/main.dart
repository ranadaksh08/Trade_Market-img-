import 'package:agoraofolymus/models/shop.dart';
import 'package:agoraofolymus/pages/addItem_page.dart';
import 'package:agoraofolymus/pages/favorite_page.dart';
import 'package:agoraofolymus/pages/inbox_page.dart';
import 'package:agoraofolymus/pages/login_page.dart';
import 'package:agoraofolymus/pages/marketplace_page.dart';
import 'package:agoraofolymus/pages/profile_page.dart';
import 'package:agoraofolymus/pages/welcome_page.dart';
import 'package:agoraofolymus/pages/your_listed_item_page.dart';
import 'package:agoraofolymus/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

 runApp(
  MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => Shop()),
      ChangeNotifierProvider(create: (_) => UserProvider()),
    ],
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

      // ✅ START PAGE
      home: const WelcomePage(),

      // ✅ ALL NAMED ROUTES
      routes: {
        '/welcome_page': (context) => const WelcomePage(),
        '/login_page': (context) => const LoginPage(),
        '/marketplace_page': (context) => const MarketplacePage(),
        '/profile_page': (context) => const ProfilePage(),
        '/favorite_page': (context) => const FavoritePage(),
        '/additem_page': (context) => const AdditemPage(), 
        '/your_listed_item_page': (context) => const YourListedItemsPage(),
        '/inbox_page': (context) => const InboxPage(),

      },
    );
  }
}
