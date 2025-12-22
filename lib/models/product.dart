import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id; // Firestore document ID
  final String name;
  final double price;
  final String shortDescription;
  final String longDescription;
  final String imagePath;
  final String rarity;
  final String category;
  final String ownerId; // seller / owner uid

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.shortDescription,
    required this.longDescription,
    required this.imagePath,
    required this.rarity,
    required this.category,
    required this.ownerId,
  });

  // 🔥 Create Product from Firestore document
  factory Product.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return Product(
      id: data['id'] ?? doc.id,
      name: data['name'] ?? '',
      price: (data['price'] as num?)?.toDouble() ?? 0.0,
      shortDescription: data['shortDescription'] ?? '',
      longDescription: data['longDescription'] ?? '',
      imagePath: data['imagePath'] ?? '',
      rarity: data['rarity'] ?? '',
      category: data['category'] ?? '',
      ownerId: data['ownerId'] ?? '',
    );
  }

  // 🔥 Convert Product to Firestore map
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'price': price,
      'shortDescription': shortDescription,
      'longDescription': longDescription,
      'imagePath': imagePath,
      'rarity': rarity,
      'category': category,
      'ownerId': ownerId,
      'createdAt': FieldValue.serverTimestamp(), // optional but useful
    };
  }
}
