import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'product.dart';

class Shop extends ChangeNotifier {
  final List<Product> _marketplace = [];

  List<Product> get marketplace => _marketplace;

  final CollectionReference _productsRef =
      FirebaseFirestore.instance.collection('products');

  /// 🔥 Fetch all products from Firestore
  Future<void> fetchMarketplace() async {
    final snapshot = await _productsRef.get();

    _marketplace.clear();
    for (var doc in snapshot.docs) {
      _marketplace.add(Product.fromFirestore(doc));
    }

    notifyListeners();
  }

  /// 🔥 Add product (Firestore + local state)
  Future<void> addProduct(Product product) async {
    final docRef = await _productsRef.add(product.toFirestore());

    _marketplace.add(
      Product(
        id: docRef.id,
        name: product.name,
        price: product.price,
        shortDescription: product.shortDescription,
        longDescription: product.longDescription,
        imagePath: product.imagePath,
        rarity: product.rarity,
        category: product.category,
        ownerId: product.ownerId,
      ),
    );

    notifyListeners();
  }

  /// 🔥 Remove product (owner only – UI enforced)
  Future<void> removeProduct(Product product) async {
    await _productsRef.doc(product.id).delete();
    _marketplace.removeWhere((p) => p.id == product.id);
    notifyListeners();
  }

  /// 🔥 Get items by specific user (seller / owner)
  List<Product> userItems(String userId) {
    return _marketplace
        .where((product) => product.ownerId == userId)
        .toList();
  }

  /// 🔥 Get products by category (future use)
  List<Product> productsByCategory(String category) {
    return _marketplace
        .where((product) => product.category == category)
        .toList();
  }
}
