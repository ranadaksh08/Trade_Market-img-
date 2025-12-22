import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'product.dart';

class Shop extends ChangeNotifier {
  final List<Product> _marketplace = [];
  final List<Product> _favorites = [];

  List<Product> get marketplace => _marketplace;
  List<Product> get favorites => _favorites;

  final CollectionReference _productsRef =
      FirebaseFirestore.instance.collection('products');

  final CollectionReference _favoritesRef =
      FirebaseFirestore.instance.collection('favorites');

  // ===========================
  // 🔥 MARKETPLACE
  // ===========================

  Future<void> fetchMarketplace() async {
    final snapshot = await _productsRef.get();

    _marketplace.clear();
    for (var doc in snapshot.docs) {
      _marketplace.add(Product.fromFirestore(doc));
    }

    notifyListeners();
  }

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

  Future<void> removeProduct(Product product) async {
    await _productsRef.doc(product.id).delete();
    _marketplace.removeWhere((p) => p.id == product.id);
    notifyListeners();
  }

  List<Product> userItems(String userId) {
    return _marketplace
        .where((product) => product.ownerId == userId)
        .toList();
  }

  // ===========================
  // ❤️ FAVORITES
  // ===========================

  Future<void> fetchFavorites(String userId) async {
    final snapshot =
        await _favoritesRef.where('userId', isEqualTo: userId).get();

    _favorites.clear();
    for (var doc in snapshot.docs) {
      _favorites.add(Product.fromFirestore(doc));
    }

    notifyListeners();
  }

  bool isFavorite(String productId) {
    return _favorites.any((p) => p.id == productId);
  }

  Future<void> addToFavorites(Product product, String userId) async {
    final existing = await _favoritesRef
        .where('userId', isEqualTo: userId)
        .where('id', isEqualTo: product.id)
        .get();

    if (existing.docs.isNotEmpty) return;

    await _favoritesRef.add({
      ...product.toFirestore(),
      'id': product.id,
      'userId': userId,
    });

    _favorites.add(product);
    notifyListeners();
  }

  Future<void> removeFromFavorites(Product product, String userId) async {
    final snapshot = await _favoritesRef
        .where('userId', isEqualTo: userId)
        .where('id', isEqualTo: product.id)
        .get();

    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }

    _favorites.removeWhere((p) => p.id == product.id);
    notifyListeners();
  }
}
