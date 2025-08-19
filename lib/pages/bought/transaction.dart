import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:studyswap/services/coins_manager.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TransactionPage extends StatelessWidget {
  final String noteId;
  final String sellerId;
  final String title;
  final String subject;
  final int price;

  const TransactionPage({
    super.key,
    required this.noteId,
    required this.sellerId,
    required this.title,
    required this.price,
    required this.subject,
  });

  @override
  Widget build(BuildContext context) {
    final buyerUserId = FirebaseAuth.instance.currentUser?.uid;
    final coinsManager = CoinsManager();

    Widget infoRow(String label, String value) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 24),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 18,
              ),
              textAlign: TextAlign.left,
            ),
          ),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirm Purchase'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            infoRow('Title:', title),
            const SizedBox(height: 16),
            Divider(),
            const SizedBox(height: 16),

            infoRow('Subject:', subject),
            const SizedBox(height: 16),
            Divider(),
            const SizedBox(height: 16),

            infoRow('Note ID:', noteId),
            const SizedBox(height: 16),
            Divider(),
            const Spacer(),

            Divider(),
            const SizedBox(height: 16),
            infoRow('Price:', '$price coins'),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (buyerUserId == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('User not signed in. Please login first.')),
                        );
                        return;
                      }

                      coinsManager.transferCoins(buyerUserId, sellerId, price);

                      final docRef = FirebaseFirestore.instance.collection('Users').doc(buyerUserId).collection("Bought").doc(noteId);

                      final noteUrl = Supabase.instance.client.storage
                          .from('notes')
                          .getPublicUrl("$sellerId/$noteId");

                      docRef.set({
                        "note_id": noteId,
                        "seller_id": sellerId,
                        "title": title,
                        "subject": subject,
                        "price": price,
                        "note_url": noteUrl,
                      });

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Note successfully bought!')),
                      );
                      Navigator.of(context).pop();
                    },
                    child: const Text('Confirm Purchase'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
