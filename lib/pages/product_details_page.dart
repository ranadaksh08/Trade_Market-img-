import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:agoraofolymus/services/chat_service.dart';
import '../models/product.dart';
import '../models/shop.dart';
import '../components/category_rarity_badges.dart';
import 'seller_profile_page.dart';
import 'chat_page.dart';
import '../components/offer_sheet.dart';
import '../services/negotiation_service.dart';
import '../services/chat_service.dart';


class ProductDetailPage extends StatefulWidget {
  final Product product;

  const ProductDetailPage({
    super.key,
    required this.product,
  });

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  Future<void> _openChat(BuildContext context) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return;

  final chatId = await ChatService.getOrCreateChatId(
    user.uid,
    widget.product.ownerId, // seller ID
  );

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => ChatPage(chatId: chatId),
    ),
  );
}


  @override
  Widget build(BuildContext context) {
    final images = widget.product.imageUrls;
    final shop = context.watch<Shop>();
    

    final isFavorite = shop.isFavorite(widget.product.id);

    return Scaffold(
      backgroundColor: Colors.black,
      extendBody: true,
      extendBodyBehindAppBar: true,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.white),
      ),

      // ================= BOTTOM ACTION BAR =================
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
                  onPressed: () async {
                  final currentUser = FirebaseAuth.instance.currentUser!;
                  // 1️⃣ Show offer input sheet
                  final offer = await showModalBottomSheet<double>(
                    context: context,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    builder: (_) => OfferSheet(
                      initialPrice: widget.product.price,
                    ),
                  );

                  if (offer == null) return;

                  final user = FirebaseAuth.instance.currentUser;
                  if (user == null) return;

                  // 2️⃣ Create or get chat
                  final chatId = await ChatService.getOrCreateChatId(
                    user.uid,
                    widget.product.ownerId,
                  );

                  // 3️⃣ CREATE NEGOTIATION
                  // 👇 You must add "String negotiationId =" here!
                  String negotiationId = await NegotiationService.createNegotiation(
                    productId: widget.product.id,
                    buyerId: currentUser.uid,
                    sellerId: widget.product.ownerId,
                    chatId: chatId,
                    initialOffer: offer,
                  );

                  // 4️⃣ Send NEGOTIATION message
                  // 👇 Now you can pass that "negotiationId" variable here without errors
                  await ChatService.sendNegotiationMessage(
                    chatId: chatId,
                    negotiationId: negotiationId,
                    message: "💬 Offer sent: ₹$offer",
                  );

                  // 5️⃣ Navigate to chat
                  if (!mounted) return;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChatPage(chatId: chatId),
                    ),
                  );
                },


                  child: const Text(
                    'Request to Buy',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      // ================= PAGE CONTENT =================
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ================= IMAGE CAROUSEL =================
              Stack(
                children: [
                  SizedBox(
                    height: 280,
                    child: PageView.builder(
                      itemCount: images.isNotEmpty ? images.length : 1,
                      itemBuilder: (context, index) {
                        if (images.isEmpty) {
                          return const Center(
                            child: Icon(
                              Icons.image_not_supported,
                              color: Colors.white54,
                              size: 80,
                            ),
                          );
                        }

                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              color: Colors.black,
                              width: double.infinity,
                              child: FittedBox(
                                fit: BoxFit.contain,
                                child: Image.network(
                                  images[index],
                                  loadingBuilder:
                                      (context, child, progress) {
                                    if (progress == null) return child;
                                    return const SizedBox(
                                      height: 200,
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          color: Colors.white70,
                                          strokeWidth: 2,
                                        ),
                                      ),
                                    );
                                  },
                                  errorBuilder:
                                      (context, error, stackTrace) {
                                    return const SizedBox(
                                      height: 200,
                                      child: Center(
                                        child: Icon(
                                          Icons.broken_image,
                                          color: Colors.white54,
                                          size: 60,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // ❤️ FAVORITE BUTTON
                  Positioned(
                      top: 16,
                      right: 24,
                      child: Consumer<Shop>(
                        builder: (context, shop, _) {
                          final isFav = shop.isFavorite(widget.product.id);

                          return GestureDetector(
                            onTap: () {
                              shop.toggleFavorite(widget.product);
                            },
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 200),
                              transitionBuilder: (child, animation) =>
                                  ScaleTransition(scale: animation, child: child),
                              child: Icon(
                                isFav ? Icons.favorite : Icons.favorite_border,
                                key: ValueKey(isFav),
                                color: isFav ? Colors.redAccent : Colors.white,
                                size: 28,
                              ),
                            ),
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
                                '₹${widget.product.price}',
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

              const SizedBox(height: 24),

              // ================= PRODUCT INFO =================
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      widget.product.name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 12),

                    CategoryRarityBadges(
                      category: widget.product.category,
                      rarity: widget.product.rarity,
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
                      widget.product.longDescription,
                      style: const TextStyle(
                        color: Colors.white70,
                        height: 1.4,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ================= SELLER INFO =================
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SellerProfilePage(
                              sellerId: widget.product.ownerId,
                            ),
                          ),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          CircleAvatar(
                            radius: 22,
                            backgroundColor: Colors.white12,
                            child:
                                Icon(Icons.person, color: Colors.white),
                          ),
                          SizedBox(width: 12),
                          Text(
                            'View Profile',
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
  }
}
