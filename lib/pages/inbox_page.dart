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
      appBar: AppBar(
        title: const Text("Inbox"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('chats')
            .where('participants', arrayContains: currentUid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No conversations yet"));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final chatDoc = snapshot.data!.docs[index];
              final chatData =
                  chatDoc.data() as Map<String, dynamic>;

              // 🔍 Find the other user
              final List participants =
                  chatData['participants'] ?? [];
              final otherUserId =
                  participants.firstWhere((id) => id != currentUid);

              // 🔔 Highlight if last message not sent by me
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
                    final userData =
                        userSnapshot.data!.data()
                            as Map<String, dynamic>;
                    username =
                        userData['username'] ?? "User";
                  }

                  return Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: isNew
                          ? Colors.blue.shade50
                          : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: const CircleAvatar(
                        child: Icon(Icons.person),
                      ),
                      title: Text(
                        username,
                        style: TextStyle(
                          fontWeight: isNew
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                ChatPage(chatId: chatDoc.id),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
