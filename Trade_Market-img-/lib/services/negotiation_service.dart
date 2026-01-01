import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/negotiation.dart';
class NegotiationService {
  static final _db = FirebaseFirestore.instance;

  static Future<String> createNegotiation({
    required String productId,
    required String buyerId,
    required String sellerId,
    required String chatId, 
    required double initialOffer,
  }) async {
    final doc = await _db.collection('negotiations').add({
      'productId': productId,
      'buyerId': buyerId,
      'sellerId': sellerId,
      'chatId': chatId,
      'status': 'pending',
      'lastOffer': initialOffer,
      'lastOfferBy': buyerId,
      'createdAt': FieldValue.serverTimestamp(),
    });

    return doc.id;
  }

  static Future<void> acceptNegotiation(String id) async {
  await _db.collection('negotiations').doc(id).update({
    'status': 'accepted',
  });
  }

  static Future<void> rejectNegotiation(String id) async {
    await _db.collection('negotiations').doc(id).update({
      'status': 'rejected',
    });
  }

  static Future<void> counterOffer({
    required String negotiationId,
    required double newOffer,
    required String currentUserId,
  }) async {
    await _db.collection('negotiations').doc(negotiationId).update({
      'status': 'negotiating',
      'lastOffer': newOffer,
      'lastOfferBy': currentUserId,
    });
  }

}
