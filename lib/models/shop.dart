import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  /// Fetch all products (latest first)
  Future<void> fetchMarketplace() async {
    final snapshot = await _productsRef
        .orderBy('createdAt', descending: true)
        .get();

    _marketplace
      ..clear()
      ..addAll(snapshot.docs.map(Product.fromFirestore));

    notifyListeners();
  }

  /// Add new product
  Future<void> addProduct(Product product) async {
    final docRef = await _productsRef.add({
      ...product.toFirestore(),
      'createdAt': FieldValue.serverTimestamp(),
    });

    // Create local object with the new real ID
    final newProduct = Product(
      id: docRef.id,
      name: product.name,
      price: product.price,
      shortDescription: product.shortDescription,
      longDescription: product.longDescription,
      imageUrls: product.imageUrls,
      rarity: product.rarity,
      category: product.category,
      ownerId: product.ownerId,
    );

    _marketplace.insert(0, newProduct);
    notifyListeners();
  }

  /// Delete product
  Future<void> removeProduct(Product product) async {
    await _productsRef.doc(product.id).delete();
    _marketplace.removeWhere((p) => p.id == product.id);
    notifyListeners();
  }

  /// Get products created by user
  List<Product> userItems(String userId) {
    return _marketplace
        .where((product) => product.ownerId == userId)
        .toList();
  }

  // ===========================
  // ❤️ FAVORITES
  // ===========================

  /// Fetch favorites for logged-in user
  Future<void> fetchFavorites(String userId) async {
    final snapshot = await _favoritesRef
        .where('userId', isEqualTo: userId)
        .get();

    _favorites.clear();

    for (var doc in snapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;
      
      // ✅ FIX: Use the original Product ID stored in the data field
      // instead of the favorite document ID.
      // We rely on 'id' existing in the data map.
      if (data.containsKey('id')) {
        _favorites.add(Product.fromMap(data['id'], data));
      }
    }

    notifyListeners();
  }

  /// Check if product is favorited
  bool isFavorite(String productId) {
    return _favorites.any((p) => p.id == productId);
  }

  /// Add to favorites
  Future<void> addToFavorites(Product product, String userId) async {
    // Check if already exists to prevent duplicates
    final existing = await _favoritesRef
        .where('userId', isEqualTo: userId)
        .where('id', isEqualTo: product.id)
        .get();

    if (existing.docs.isNotEmpty) return;

    await _favoritesRef.add({
      ...product.toFirestore(),
      'id': product.id, // Saving the original Product ID
      'userId': userId,
    });
    
    // We already updated UI optimistically in toggleFavorite,
    // so we don't strict need to add to _favorites here again 
    // unless you want to be extra safe.
  }

  /// Remove from favorites
  Future<void> removeFromFavorites(Product product, String userId) async {
    final snapshot = await _favoritesRef
        .where('userId', isEqualTo: userId)
        .where('id', isEqualTo: product.id)
        .get();

    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }
    
    // UI updated optimistically in toggleFavorite
  }

  // ===========================
  // ❤️ TOGGLE FAVORITE
  // ===========================
  Future<void> toggleFavorite(Product product) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final alreadyFavorite = isFavorite(product.id);

    // ✅ 1. Update UI immediately (Optimistic Update)
    if (alreadyFavorite) {
      _favorites.removeWhere((p) => p.id == product.id);
    } else {
      _favorites.add(product);
    }
    notifyListeners();

    // ✅ 2. Sync with Firestore in background
    try {
      if (alreadyFavorite) {
        await removeFromFavorites(product, user.uid);
      } else {
        await addToFavorites(product, user.uid);
      }
    } catch (e) {
      // Rollback if failed
      if (alreadyFavorite) {
        _favorites.add(product);
      } else {
        _favorites.removeWhere((p) => p.id == product.id);
      }
      notifyListeners();
      debugPrint("Error toggling favorite: $e");
    }
  }
}