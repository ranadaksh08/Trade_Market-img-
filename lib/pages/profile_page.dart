import 'package:agoraofolymus/components/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import '../models/shop.dart';
import '../components/my_product_tile2.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool showListed = true; // default tab

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    final shop = context.watch<Shop>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
  context.read<Shop>().fetchFavorites(user.uid);
   });


    final listedItems = shop.userItems(user.uid);
    final favoriteItems = shop.favorites; // will be empty for now

    return Scaffold(
      bottomNavigationBar: const BottomNavBar(
        currentIndex: 3,
        backgroundColor: Color(0xFF0E0F13),
      ),
      backgroundColor: const Color(0xFF0E0F13),
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

      body: Column(
        children: [
          const SizedBox(height: 24),

          // PROFILE ICON
          const CircleAvatar(
            radius: 55,
            backgroundColor: Color(0xFF1A1C23),
            child: Icon(
              Icons.person,
              size: 70,
              color: Color(0xFFC9A24D),
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
                    style: const TextStyle(color: Color(0xFFA0A0A0)),
                  ),
                ],
              );
            },
          ),

          const SizedBox(height: 24),

          // STATS
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _statColumn(
                  value: listedItems.length.toString(),
                  label: "Listed Items",
                ),
                _statColumn(
                  value: "",
                  label: "Rating",
                ),
              ],
            ),
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
                  onTap: () {
                    setState(() => showListed = true);
                  },
                ),
                _profileTab(
                  icon: Icons.favorite_border_outlined,
                  text: "Favorite",
                  active: !showListed,
                  onTap: () {
                    setState(() => showListed = false);
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // ✅ ONLY THIS SCROLLS
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
                          return MyProductTile2(
                            product: listedItems[index],
                          );
                        },
                      )
                : favoriteItems.isEmpty
                    ? const Center(
                        child: Text(
                          "No favorites yet",
                          style: TextStyle(color: Color(0xFFA0A0A0)),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: favoriteItems.length,
                        itemBuilder: (context, index) {
                          return MyProductTile2(
                            product: favoriteItems[index],
                          );
                        },
                    ),
                  ),
                ],
              ),
            );
          }

                Widget _statColumn({
                  required String value,
                  required String label,
                }) {
                  return Column(
                    children: [
                      Text(
                        value,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFC9A24D),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        label,
                        style: const TextStyle(
                          color: Color(0xFFA0A0A0),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  );
                }

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
                            color: active ? Colors.white : const Color(0xFF6F6F6F),
                          ),
                        ),
                      ],
                    ),
                  );
                }
              }
