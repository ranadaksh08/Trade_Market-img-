import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id;
  final String name;
  final double price;
  final String shortDescription;
  final String longDescription;

  // 🔥 MULTIPLE IMAGES
  final List<String> imageUrls;

  final String rarity;
  final String category;
  final String ownerId;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.shortDescription,
    required this.longDescription,
    required this.imageUrls,
    required this.rarity,
    required this.category,
    required this.ownerId,
  });

  // ===============================
  // 🔄 FROM FIRESTORE (Standard)
  // ===============================
  factory Product.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return Product(
      id: doc.id, // Uses the Document ID
      name: data['name'] ?? '',
      price: (data['price'] as num?)?.toDouble() ?? 0.0,
      shortDescription: data['shortDescription'] ?? '',
      longDescription: data['longDescription'] ?? '',
      imageUrls: List<String>.from(data['imageUrls'] ?? []),
      rarity: data['rarity'] ?? '',
      category: data['category'] ?? '',
      ownerId: data['ownerId'] ?? '',
    );
  }

  // ===============================
  // 🛠️ FROM MAP (For Favorites Fix)
  // ===============================
  // Allows passing a specific ID (like the original product ID) 
  // instead of using the document ID.
  factory Product.fromMap(String id, Map<String, dynamic> data) {
    return Product(
      id: id, 
      name: data['name'] ?? '',
      price: (data['price'] as num?)?.toDouble() ?? 0.0,
      shortDescription: data['shortDescription'] ?? '',
      longDescription: data['longDescription'] ?? '',
      imageUrls: List<String>.from(data['imageUrls'] ?? []),
      rarity: data['rarity'] ?? '',
      category: data['category'] ?? '',
      ownerId: data['ownerId'] ?? '',
    );
  }

  // ===============================
  // 🔼 TO FIRESTORE
  // ===============================
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'price': price,
      'shortDescription': shortDescription,
      'longDescription': longDescription,
      'imageUrls': imageUrls,
      'rarity': rarity,
      'category': category,
      'ownerId': ownerId,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}