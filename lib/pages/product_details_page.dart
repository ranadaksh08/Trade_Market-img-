import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import '../components/category_rarity_badges.dart';
import '../models/product.dart';
import '../models/shop.dart';
import 'seller_profile_page.dart';
import 'chat_page.dart';

class ProductDetailPage extends StatelessWidget {
  final Product product;

  const ProductDetailPage({
    super.key,
    required this.product,
  });

  // 🔥 IMAGE ORDER: 2 → 1 → 4 → 3
  static const List<String> imageAssets = [
    'lib/images/solidwater.png',
    'lib/images/flowwater.png',
    'lib/images/waterpour.png',
    'lib/images/goldenvessel.png',
  ];

  Future<void> _openChat(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChatPage(chatId: product.id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBody: true,
      extendBodyBehindAppBar: true,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.white),
      ),

      // ================= FIXED BOTTOM ACTION BAR =================
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          decoration: BoxDecoration(
            color: Colors.black,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.8),
                blurRadius: 12,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.chat, color: Colors.white),
                onPressed: () => _openChat(context),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    // BUY NOW logic later
                  },
                  child: const Text(
                    'Buy Now',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      // ================= SCROLLABLE CONTENT =================
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            color: Colors.black,
            child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ================= IMAGE CAROUSEL =================
                    SizedBox(
                      height: 320,
                      child: Stack(
                        children: [
                          PageView.builder(
                            itemCount: imageAssets.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: ShaderMask(
                                    shaderCallback: (Rect bounds) {
                                      return const RadialGradient(
                                        center: Alignment.center,
                                        radius: 5,
                                        colors: [
                                          Color.fromARGB(
                                              255, 248, 248, 248),
                                          Color.fromARGB(0, 0, 0, 0),
                                        ],
                                      ).createShader(bounds);
                                    },
                                    blendMode: BlendMode.dstIn,
                                    child: Image.asset(
                                      imageAssets[index],
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),

                          // ❤️ FAVORITE BUTTON
                          Positioned(
                            top: 16,
                            right: 24,
                            child: Consumer<Shop>(
                              builder: (context, shop, _) {
                                final user = FirebaseAuth
                                    .instance.currentUser;
                                final isFav =
                                    shop.isFavorite(product.id);

                                return IconButton(
                                  icon: Icon(
                                    isFav
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: isFav
                                        ? Colors.red
                                        : Colors.white,
                                  ),
                                  onPressed: user == null
                                      ? null
                                      : () {
                                          isFav
                                              ? shop
                                                  .removeFromFavorites(
                                                      product,
                                                      user.uid)
                                              : shop
                                                  .addToFavorites(
                                                      product,
                                                      user.uid);
                                        },
                                );
                              },
                            ),
                          ),

                          // 💰 PRICE BADGE
                          Positioned(
                            bottom: 20,
                            right: 24,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.6),
                                borderRadius:
                                    BorderRadius.circular(12),
                              ),
                              child: Text(
                                '₹${product.price}',
                                style: const TextStyle(
                                  color: Colors.greenAccent,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ================= PRODUCT INFO =================
                    Padding(
                      padding:
                          const EdgeInsets.fromLTRB(16, 0, 16, 120),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.center,
                        children: [
                          Text(
                            product.name,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 12),

                          CategoryRarityBadges(
                            category: product.category,
                            rarity: product.rarity,
                          ),

                          const SizedBox(height: 20),

                          const Text(
                            'LEGEND',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              
                            ),
                          ),

                          const SizedBox(height: 8),

                          Text(
                            product.longDescription,
                            style: const TextStyle(
                              color: Colors.white70,
                              height: 1.4,
                            ),
                          ),

                          const SizedBox(height: 20),

                          // ================= SELLER ROW =================
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      SellerProfilePage(
                                    sellerId:
                                        product.ownerId,
                                  ),
                                ),
                              );
                            },
                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                const CircleAvatar(
                                  radius: 22,
                                  backgroundColor:
                                      Colors.white12,
                                  child: Icon(Icons.person,
                                      color: Colors.white),
                                ),
                                const SizedBox(width: 12),
                                const Text(
                                  'View Profile >',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}