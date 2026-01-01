import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/negotiation.dart';
import '../services/negotiation_service.dart';
import '../services/chat_service.dart';
import 'counter_offer_dialog.dart';

class NegotiationActionBar extends StatelessWidget {
  final Negotiation negotiation;
  final String chatId;
  final VoidCallback onUpdated;

  const NegotiationActionBar({
    super.key,
    required this.negotiation,
    required this.chatId,
    required this.onUpdated,
  });

  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;

    // 1. Check if the negotiation is actually active
    final isActive = negotiation.status == 'pending' || negotiation.status == 'negotiating';
    
    // 2. LOGIC FIX: It is my turn if I am NOT the person who made the last offer.
    // (Ensure your Negotiation model has the 'lastOfferBy' field added!)
    final isMyTurn = negotiation.lastOfferBy != currentUserId;

    // 3. Only show buttons if active AND it's my turn
    if (!isActive || !isMyTurn) {
      // Optional: You could return a textual status here like "Waiting for response..."
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blueGrey.shade900,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // Dynamic text based on status
          Text(
            negotiation.status == 'pending' 
               ? "New Offer Received" 
               : "Counter Offer Received",
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // ✅ ACCEPT
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                onPressed: () async {
                  await NegotiationService.acceptNegotiation(negotiation.id);

                  await ChatService.sendNegotiationMessage(
                    chatId: chatId,
                    negotiationId: negotiation.id,
                    message: "✅ Offer accepted",
                  );
                  onUpdated();
                },
                child: const Text("Accept"),
              ),

              // 🔁 COUNTER
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                onPressed: () async {
                  final newOffer = await showDialog<double>(
                    context: context,
                    builder: (_) => CounterOfferDialog(
                      currentOffer: negotiation.lastOffer ?? 0,
                    ),
                  );

                  if (newOffer != null && currentUserId != null) {
                    // 4. ACTION FIX: Pass currentUserId so we know who countered
                    await NegotiationService.counterOffer(
                      negotiationId: negotiation.id,
                      newOffer: newOffer,
                      currentUserId: currentUserId, // <--- NEW PARAMETER
                    );

                    await ChatService.sendNegotiationMessage(
                      chatId: chatId,
                      negotiationId: negotiation.id,
                      message: "💬 Counter offer: ₹$newOffer",
                    );
                    onUpdated();
                  }
                },
                child: const Text("Counter"),
              ),

              // ❌ REJECT
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () async {
                  await NegotiationService.rejectNegotiation(negotiation.id);

                  await ChatService.sendNegotiationMessage(
                    chatId: chatId,
                    negotiationId: negotiation.id,
                    message: "❌ Offer rejected",
                  );
                  onUpdated();
                },
                child: const Text("Reject"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}