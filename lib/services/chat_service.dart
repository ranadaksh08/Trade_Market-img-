import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatService {
  static Future<String> getOrCreateChatId(
    String currentUserId,
    String otherUserId,
  ) async {
    final users = [currentUserId, otherUserId]..sort();
    final chatId = users.join('_');

    final chatRef =
        FirebaseFirestore.instance.collection('chats').doc(chatId);

    final chatDoc = await chatRef.get();

    if (!chatDoc.exists) {
      await chatRef.set({
        'participants': users,
        'lastMessage': '',
        'lastMessageSenderId': '',
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }

    return chatId;
  }

    static Future<void> sendSystemMessage(
    String chatId,
    String message,
  ) async {
    final chatRef =
        FirebaseFirestore.instance.collection('chats').doc(chatId);

    await chatRef.collection('messages').add({
      'senderId': 'system',
      'text': message,
      'timestamp': FieldValue.serverTimestamp(),
    });

    await chatRef.update({
      'lastMessage': message,
      'lastMessageSenderId': 'system',
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  static Future<void> sendNegotiationMessage({
  required String chatId,
  required String negotiationId,
  required String message,
}) async {
  final chatRef =
      FirebaseFirestore.instance.collection('chats').doc(chatId);

  await chatRef.collection('messages').add({
    'senderId': FirebaseAuth.instance.currentUser!.uid,
    'text': message,
    'type': 'negotiation',
    'negotiationId': negotiationId,
    'timestamp': FieldValue.serverTimestamp(),
  });

  await chatRef.update({
    'lastMessage': message,
    'lastMessageSenderId': FirebaseAuth.instance.currentUser!.uid,
    'updatedAt': FieldValue.serverTimestamp(),
  });
}



}
