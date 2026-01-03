import 'package:agoraofolymus/components/auto_scroll_marketwidget.dart';
import 'package:agoraofolymus/components/bottom_nav_bar.dart';
import 'package:agoraofolymus/components/main_shell.dart';
import 'package:agoraofolymus/components/soft_page_motion.dart';
import 'package:agoraofolymus/util/category_card.dart';
import 'package:agoraofolymus/util/searchbar_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:agoraofolymus/providers/user_provider.dart';

import '../models/shop.dart';
import '../components/my_product_tile.dart';

class MarketplacePage extends StatefulWidget {
  const MarketplacePage({super.key});

  @override
  State<MarketplacePage> createState() => _MarketplacePageState();
}

class _MarketplacePageState extends State<MarketplacePage> {

  @override
  void initState() {
    super.initState();

    // ✅ Load favorites ONCE when page opens
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      Future.microtask(() {
        context.read<Shop>().fetchFavorites(user.uid);
      });
    }

    // ✅ Load marketplace
    Future.microtask(() {
      context.read<Shop>().fetchMarketplace();
    });
  }

  @override
  Widget build(BuildContext context) {
    final shop = context.watch<Shop>();
    final products = shop.marketplace;
    final appUser = context.watch<UserProvider>().user;

    return Scaffold(
      body: SoftPageMotion(
        child: Stack(
          children: [
            // 🌌 BACKGROUND
            Container(
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
            ),
        
            SafeArea(
              child: CustomScrollView(
                slivers: [
                  // 👋 HEADER
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Γεια,',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                appUser?.username ?? '',
                                style: const TextStyle(
                                  color: Color(0xFFC9A24D),
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
        
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const MainShell(initialIndex: 4),
                                ),
                              );
        
                            },
                            child: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(0xFFC9A24D),
                                  width: 2,
                                ),
                              ),
                              child: ClipOval(
                                child: Image.asset(
                                  'lib/images/zeus_profile.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
        
                  const SliverToBoxAdapter(child: SizedBox(height: 25)),
        
                  // 🔥 AUTO SCROLL
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: AutoScrollMarket(),
                    ),
                  ),
        
                  const SliverToBoxAdapter(child: SizedBox(height: 25)),

                  // 📂 HORIZONTAL CATEGORIES
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: 50, 
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 10), 
                          children: [
                            CategoryCard(category: 'Armor', icon: Icons.shield),
                            CategoryCard(category: 'Weapons', icon: Icons.gavel),
                            CategoryCard(category: 'Potions', icon: Icons.biotech),
                            CategoryCard(category: 'Artifact', icon: Icons.auto_awesome),
                            
                          ],
                        ),
                      ),
                    ),

                    const SliverToBoxAdapter(child: SizedBox(height: 25)),
        
                  // 🔍 SEARCH BAR
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const SearchbarCard(),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1A1C23),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: const Color(0x33C9A24D),
                            ),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.search,
                                  color: Color(0xFFC9A24D)),
                              SizedBox(width: 10),
                              Text(
                                "Search items...",
                                style: TextStyle(
                                  color: Color(0xFFA0A0A0),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
        
                  const SliverToBoxAdapter(child: SizedBox(height: 20)),
        
                  // 🛒 PRODUCTS GRID
                  if (products.isEmpty)
                    const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.only(top: 120),
                        child: Center(
                          child: Text(
                            "No items available",
                            style:
                                TextStyle(color: Color(0xFFA0A0A0)),
                          ),
                        ),
                      ),
                    )
                  else
                    SliverPadding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 25),
                      sliver: SliverGrid(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            return TweenAnimationBuilder<double>(
                              tween: Tween(begin: 0, end: 1),
                              duration: Duration(milliseconds: 200 + (index * 30)),
                              curve: Curves.easeOutCubic,
                              builder: (context, value, child) {
                                return Opacity(
                                  opacity: value,
                                  child: Transform.translate(
                                    offset: Offset(0, 12 * (1 - value)),
                                    child: child,
                                  ),
                                );
                              },
                              child: MyProductTile(
                                product: products[index],
                              ),
                            );

                          },
                          childCount: products.length,
                        ),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.75,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                      ),
                    ),
        
                  const SliverToBoxAdapter(child: SizedBox(height: 100)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
