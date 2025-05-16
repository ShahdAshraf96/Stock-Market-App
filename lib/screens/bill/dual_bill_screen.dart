import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stock_market_app/models/stock_model.dart';
import 'widgets/bill_item_widget.dart';

class DualBillScreen extends StatelessWidget {
  const DualBillScreen({super.key});

  Stream<QuerySnapshot<Map<String, dynamic>>> _invoiceStream(String uid, bool isBuy) {
    return FirebaseFirestore.instance
        .collection('invoices')
        .where('customerId', isEqualTo: uid)
        .where('isBuy', isEqualTo: isBuy)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) {
      return const Scaffold(
        body: Center(child: Text("User not logged in")),
      );
    }

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Transaction Bills'),
          bottom: const TabBar(tabs: [
            Tab(text: "Buy Bills"),
            Tab(text: "Sell Bills"),
          ]),
        ),
        body: TabBarView(
          children: [
            _buildBillList(uid: uid, isBuy: true),
            _buildBillList(uid: uid, isBuy: false),
          ],
        ),
      ),
    );
  }

  Widget _buildBillList({required String uid, required bool isBuy}) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: _invoiceStream(uid, isBuy),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("No invoices found."));
        }

        final docs = snapshot.data!.docs;

        return ListView.builder(
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final data = docs[index].data();
            final stock = Stock.fromJson(data['stock']);
            final customerName = data['customerName'] ?? 'Unknown';
            final customerId = data['customerId'] ?? '';

            return BillItemWidget(
              stock: stock,
              isBuy: isBuy,
              customerName: customerName,
              customerId: customerId,
              quantity: data['quantity'] ?? 0,
              finalAmount: (data['finalAmount'] ?? 0).toDouble(),
              fees: Map<String, dynamic>.from(data['fees'] ?? {}),
              timestamp: (data['timestamp'] as Timestamp).toDate(),
            );

          },
        );
      },
    );
  }
}
