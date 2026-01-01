import 'package:agoraofolymus/components/soft_page_motion.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import '../components/my_product_tile2.dart';
import '../models/shop.dart';
import '../models/product.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool showListed = true;

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    final shop = context.watch<Shop>();

    // Fetch favorites safely
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<Shop>().fetchFavorites(user.uid);
    });

    final List<Product> listedItems = shop.userItems(user.uid);
    final List<Product> favoriteItems = shop.favorites;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: const Color(0xFF0E0F13),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "My Profile",
          style: TextStyle(color: Color(0xFFC9A24D)),
        ),
        iconTheme: const IconThemeData(color: Color(0xFFC9A24D)),
      ),

      body: SoftPageMotion(
        child: Stack(
          children: [
            // 🔹 BACKGROUND
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
              child: Column(
                children: [
                  const SizedBox(height: 24),

                  // PROFILE IMAGE
                  Container(
                    width: 110,
                    height: 110,
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

                  const SizedBox(height: 16),

                  // USER INFO
                  FutureBuilder<DocumentSnapshot>(
                    future: FirebaseFirestore.instance
                        .collection('users')
                        .doc(user.uid)
                        .get(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return const SizedBox();
                      final data =
                          snapshot.data!.data() as Map<String, dynamic>;

                      return Column(
                        children: [
                          Text(
                            data['username'] ?? "Unknown User",
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            data['email'] ?? "",
                            style: const TextStyle(
                              color: Color(0xFFA0A0A0),
                            ),
                          ),
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 24),
                  const Divider(color: Color(0xFF2A2A2A)),
                  const SizedBox(height: 12),

                  // TABS
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _profileTab(
                          icon: Icons.inventory_2_outlined,
                          text: "Listed Items",
                          active: showListed,
                          onTap: () => setState(() => showListed = true),
                        ),
                        _profileTab(
                          icon: Icons.favorite_border_outlined,
                          text: "Favorites",
                          active: !showListed,
                          onTap: () => setState(() => showListed = false),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // LIST SECTION (WITH ANIMATION)
                  Expanded(
                    child: showListed
                        ? listedItems.isEmpty
                            ? const Center(
                                child: Text(
                                  "No items listed",
                                  style: TextStyle(color: Color(0xFFA0A0A0)),
                                ),
                              )
                            : ListView.builder(
                                padding: const EdgeInsets.all(16),
                                itemCount: listedItems.length,
                                itemBuilder: (context, index) {
                                  final product = listedItems[index];

                                  return TweenAnimationBuilder<double>(
                                    tween: Tween(begin: 0, end: 1),
                                    duration: Duration(
                                        milliseconds: 200 + (index * 30)),
                                    curve: Curves.easeOutCubic,
                                    builder: (context, value, child) {
                                      return Opacity(
                                        opacity: value,
                                        child: Transform.translate(
                                          offset:
                                              Offset(0, 12 * (1 - value)),
                                          child: child,
                                        ),
                                      );
                                    },
                                    child: MyProductTile2(
                                      product: product,
                                      onDelete: () async {
                                        final confirm =
                                            await showDialog<bool>(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title:
                                                const Text("Delete Item"),
                                            content: const Text(
                                              "Are you sure you want to remove this item?",
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.pop(
                                                        context, false),
                                                child:
                                                    const Text("Cancel"),
                                              ),
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.pop(
                                                        context, true),
                                                child:
                                                    const Text("Delete"),
                                              ),
                                            ],
                                          ),
                                        );

                                        if (confirm == true) {
                                          context
                                              .read<Shop>()
                                              .removeProduct(product);
                                        }
                                      },
                                    ),
                                  );
                                },
                              )
                        : favoriteItems.isEmpty
                            ? const Center(
                                child: Text(
                                  "No favorites yet",
                                  style:
                                      TextStyle(color: Color(0xFFA0A0A0)),
                                ),
                              )
                            : ListView.builder(
                                padding: const EdgeInsets.all(16),
                                itemCount: favoriteItems.length,
                                itemBuilder: (context, index) {
                                  return TweenAnimationBuilder<double>(
                                    tween: Tween(begin: 0, end: 1),
                                    duration: Duration(
                                        milliseconds: 200 + (index * 30)),
                                    curve: Curves.easeOutCubic,
                                    builder: (context, value, child) {
                                      return Opacity(
                                        opacity: value,
                                        child: Transform.translate(
                                          offset:
                                              Offset(0, 12 * (1 - value)),
                                          child: child,
                                        ),
                                      );
                                    },
                                    child: MyProductTile2(
                                      product: favoriteItems[index],
                                    ),
                                  );
                                },
                              ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // HELPERS
  Widget _profileTab({
    required IconData icon,
    required String text,
    required bool active,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(
            icon,
            color: active
                ? const Color(0xFFC9A24D)
                : const Color(0xFF6F6F6F),
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              color: active
                  ? Colors.white
                  : const Color(0xFF6F6F6F),
            ),
          ),
        ],
      ),
    );
  }
}
