import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// ADD THESE IMPORTS
import 'package:provider/provider.dart';
import '../models/shop.dart';
import '../models/product.dart';
import 'seller_profile_page.dart';
import 'chat_page.dart';

class ProductDetailPage extends StatelessWidget {
  final Product product;

  const ProductDetailPage({
    super.key,
    required this.product,
  });

  Future<void> _openChat(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final buyerId = user.uid;
    final sellerId = product.ownerId;

    final query = await FirebaseFirestore.instance
        .collection('chats')
        .where('buyerId', isEqualTo: buyerId)
        .where('sellerId', isEqualTo: sellerId)
        .where('productId', isEqualTo: product.id)
        .limit(1)
        .get();

    String chatId;

    if (query.docs.isNotEmpty) {
      chatId = query.docs.first.id;
    } else {
      final doc =
          await FirebaseFirestore.instance.collection('chats').add({
        'buyerId': buyerId,
        'sellerId': sellerId,
        'productId': product.id,
        'participants': [buyerId, sellerId],
        'lastMessage': '',
        'lastUpdated': FieldValue.serverTimestamp(),
      });

      chatId = doc.id;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChatPage(chatId: chatId),
      ),
    );
  }

  // ⭐ ADD TO FAVORITES
  Future<void> _addToFavorites(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('favorites')
        .doc(product.id)
        .set(product.toFirestore());

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Added to favorites")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // IMAGE
            Container(
              height: 220,
              width: double.infinity,
              color: Colors.grey[300],
              child: product.imagePath.isEmpty
                  ? const Icon(Icons.image, size: 100)
                  : Image.asset(product.imagePath, fit: BoxFit.cover),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    "₹${product.price}",
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.green,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Chip(label: Text(product.category)),
                      const SizedBox(width: 8),
                      Chip(label: Text(product.rarity)),
                    ],
                  ),

                  const SizedBox(height: 16),

                  const Text(
                    "Description",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(product.longDescription),

                  const SizedBox(height: 30),

                  // SELLER PROFILE
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SellerProfilePage(
                              sellerId: product.ownerId,
                            ),
                          ),
                        );
                      },
                      child: const Text("Seller Profile"),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // 💬 Message Seller Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _openChat(context),
                      child: const Text("Message Seller"),
                    ),
                  ),


                  const SizedBox(height: 12),

                  // ⭐ FAVORITE TOGGLE BUTTON
                  SizedBox(
                    width: double.infinity,
                    child: Consumer<Shop>(
                      builder: (context, shop, _) {
                        final user = FirebaseAuth.instance.currentUser!;
                        final isFav = shop.isFavorite(product.id);

                        return OutlinedButton.icon(
                          icon: Icon(
                            isFav ? Icons.favorite : Icons.favorite_border,
                            color: isFav ? Colors.red : null,
                          ),
                          label: Text(
                            isFav ? "Remove from Favorites" : "Add to Favorites",
                          ),
                          onPressed: () async {
                            if (isFav) {
                              await shop.removeFromFavorites(product, user.uid);
                            } else {
                              await shop.addToFavorites(product, user.uid);
                            }
                          },
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
}
