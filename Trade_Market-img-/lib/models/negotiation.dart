import 'package:cloud_firestore/cloud_firestore.dart';

class Negotiation {
  final String id;
  final String productId;
  final String buyerId;
  final String sellerId;
  final String chatId;
  final String lastOfferBy;
  final String status; // pending | negotiating | accepted | rejected | completed
  final double? lastOffer;
  final DateTime createdAt;

  Negotiation({
    required this.id,
    required this.productId,
    required this.buyerId,
    required this.sellerId,
    required this.lastOfferBy,
    required this.chatId,
    required this.status,
    this.lastOffer,
    required this.createdAt,
  });

  factory Negotiation.fromFirestore(String id, Map<String, dynamic> data) {
    return Negotiation(
      id: id,
      productId: data['productId'],
      buyerId: data['buyerId'],
      sellerId: data['sellerId'],
      chatId: data['chatId'],
      status: data['status'],
      lastOffer: (data['lastOffer'] as num?)?.toDouble(),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      lastOfferBy: data['lastOfferBy'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'buyerId': buyerId,
      'sellerId': sellerId,
      'chatId': chatId,
      'status': status,
      'lastOffer': lastOffer,
      'createdAt': createdAt,
      'lastOfferBy': lastOfferBy,
    };
  }
}
