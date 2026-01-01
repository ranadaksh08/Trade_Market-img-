import 'package:agoraofolymus/components/bottom_nav_bar.dart';
import 'package:agoraofolymus/components/soft_page_motion.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'chat_page.dart';

class InboxPage extends StatelessWidget {
  const InboxPage({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUid = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      backgroundColor: const Color(0xFF0E0F13),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF0E0F13),
        title: const Text(
          "Inbox",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),

      body: SoftPageMotion(
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
              .where('participants', arrayContains: currentUid)
              .snapshots(),
        
        
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFFC9A24D),
                  ),
                );
              }
        
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Text(
                    "No conversations yet",
                    style: TextStyle(
                      color: Color(0xFFA0A0A0),
                      fontSize: 16,
                    ),
                  ),
                );
              }
        
              return ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 12),
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final chatDoc = snapshot.data!.docs[index];
                  final chatData =
                      chatDoc.data() as Map<String, dynamic>;
        
                  final List participants = chatData['participants'] ?? [];
                  String? otherUserId;
        
                  for (final id in participants) {
                    if (id != currentUid) {
                      otherUserId = id;
                      break;
                    }
                  }
        
                  if (otherUserId == null) {
                    return const SizedBox();
                  }
        
                  final bool isNew =
                      chatData['lastMessageSenderId'] != null &&
                      chatData['lastMessageSenderId'] != currentUid;
        
                  return FutureBuilder<DocumentSnapshot>(
                    future: FirebaseFirestore.instance
                        .collection('users')
                        .doc(otherUserId)
                        .get(),
                    builder: (context, userSnapshot) {
                      String username = "User";
        
                      if (userSnapshot.hasData &&
                          userSnapshot.data!.exists) {
                        final data = userSnapshot.data!.data()
                            as Map<String, dynamic>;
                        username = data['username'] ?? "User";
                      }
        
                      return TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0, end: 1),
                        duration: Duration(milliseconds: 180 + (index * 25)),
                        curve: Curves.easeOutCubic,
                        builder: (context, value, child) {
                          return Opacity(
                            opacity: value,
                            child: Transform.translate(
                              offset: Offset(0, 10 * (1 - value)),
                              child: child,
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ChatPage(chatId: chatDoc.id),
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: isNew
                                    ? const Color(0xFF1F2933)
                                    : const Color(0xFF1A1C23),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: isNew
                                      ? const Color(0xFFC9A24D)
                                      : Colors.transparent,
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  const CircleAvatar(
                                    radius: 22,
                                    backgroundColor: Color(0xFF2A2D36),
                                    child: Icon(Icons.person, color: Colors.white70),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          username,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight:
                                                isNew ? FontWeight.bold : FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          isNew ? "New message" : "Tap to continue chat",
                                          style: const TextStyle(
                                            color: Color(0xFFA0A0A0),
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (isNew)
                                    Container(
                                      width: 10,
                                      height: 10,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFFC9A24D),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );

                    },
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
