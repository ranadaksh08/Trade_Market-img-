import 'package:agoraofolymus/components/main_shell.dart';
import 'package:agoraofolymus/models/shop.dart';
import 'package:agoraofolymus/pages/favorite_page.dart';
import 'package:agoraofolymus/pages/login_page.dart';
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
      theme: ThemeData(
      scaffoldBackgroundColor: const Color(0xFF0E0F13), 
      canvasColor: const Color(0xFF0E0F13),
    ),
      debugShowCheckedModeBanner: false,

      // ✅ Welcome/Login flow
      home: const WelcomePage(),

      routes: {
        '/welcome_page': (_) => const WelcomePage(),
        '/login_page': (_) => const LoginPage(),

        // ✅ MAIN APP (bottom nav lives here)
        '/main': (_) => const MainShell(),

        // ✅ NON-TAB pages
        '/favorite_page': (_) => const FavoritePage(),
        '/your_listed_item_page': (_) => const YourListedItemsPage(),
      },
    );
  }
}
