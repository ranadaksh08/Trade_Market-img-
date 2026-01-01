import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../components/negotiation_action_bar.dart';
import '../models/negotiation.dart';

class ChatPage extends StatefulWidget {
  final String chatId;

  const ChatPage({
    super.key,
    required this.chatId,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController messageController = TextEditingController();
  final String uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  Future<String> _getOtherUsername() async {
    final chatDoc = await FirebaseFirestore.instance
        .collection('chats')
        .doc(widget.chatId)
        .get();

    final data = chatDoc.data();
    if (data == null) return "Chat";

    final List participants = data['participants'] ?? [];
    final otherUserId =
        participants.firstWhere((id) => id != uid, orElse: () => null);

    if (otherUserId == null) return "Chat";

    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(otherUserId)
        .get();

    return userDoc.data()?['username'] ?? "Chat";
  }

  Future<void> sendMessage() async {
    final text = messageController.text.trim();
    if (text.isEmpty) return;

    messageController.clear();

    final chatRef =
        FirebaseFirestore.instance.collection('chats').doc(widget.chatId);

    await chatRef.collection('messages').add({
      'senderId': uid,
      'text': text,
      'type': 'text', // Standard text message
      'timestamp': FieldValue.serverTimestamp(),
    });

    await chatRef.update({
      'lastMessage': text,
      'lastMessageSenderId': uid,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E0F13),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0E0F13),
        elevation: 0,
        centerTitle: true,
        title: FutureBuilder<String>(
          future: _getOtherUsername(),
          builder: (context, snapshot) {
            return Text(
              snapshot.data ?? "Chat",
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
      ),
      body: Column(
        children: [
          // 🔹 1. NEGOTIATION ACTION BAR STREAM
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('negotiations')
                .where('chatId', isEqualTo: widget.chatId)
                .orderBy('createdAt', descending: true)
                .limit(1)
                .snapshots(),
            builder: (context, snapshot) {
              // ⚠️ IMPORTANT: If buttons don't show, CHECK DEBUG CONSOLE for Index Link!
              
              if (snapshot.hasError) {
                 print("Negotiation Error: ${snapshot.error}");
                 return const SizedBox.shrink(); 
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const SizedBox.shrink();
              }

              final negotiationData = snapshot.data!.docs.first;
              final negotiation = Negotiation.fromFirestore(
                negotiationData.id,
                negotiationData.data() as Map<String, dynamic>,
              );

              return NegotiationActionBar(
                negotiation: negotiation,
                chatId: widget.chatId,
                onUpdated: () {
                  // Stream handles updates automatically
                },
              );
            },
          ),

          // 🔹 2. MESSAGES LIST
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF0E0F13),
                    Color(0xFF1A1C23),
                  ],
                ),
              ),
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('chats')
                    .doc(widget.chatId)
                    .collection('messages')
                    .orderBy('timestamp', descending: false)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 12),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final data = snapshot.data!.docs[index].data()
                          as Map<String, dynamic>;

                      final bool isMe = data['senderId'] == uid;
                      final String type = data['type'] ?? 'text';

                      // 🛠️ FIX FLAW 1: If it's a negotiation message, CENTER IT.
                      if (type == 'negotiation') {
                        return Center(
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 12),
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16),
                            decoration: BoxDecoration(
                              color: Colors.orange.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: Colors.orange.shade700, width: 1),
                            ),
                            child: Text(
                              data['text'], // e.g., "Counter offer: ₹500"
                              style: TextStyle(
                                color: Colors.orange.shade300,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      }

                      // 🟢 STANDARD TEXT MESSAGE
                      return Align(
                        alignment: isMe
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 14),
                          decoration: BoxDecoration(
                            color: isMe
                                ? const Color(0xFFC9A24D)
                                : const Color(0xFF2A2D36),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            data['text'],
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),

          // 🔹 3. INPUT BAR
          SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: const BoxDecoration(
                color: Color(0xFF1A1C23),
                border: Border(top: BorderSide(color: Color(0xFF2A2D36))),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: "Type a message...",
                        hintStyle: TextStyle(color: Color(0xFFA0A0A0)),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    color: const Color(0xFFC9A24D),
                    onPressed: sendMessage,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}