import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stock_market_app/models/stock_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:stock_market_app/models/account_statement_model.dart';



class AccountStatementScreen extends StatelessWidget {
  const AccountStatementScreen({super.key});


  Stream<List<AccountStatement>> getUserStatements() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    return FirebaseFirestore.instance
        .collection('account_statements')
        .where('userId', isEqualTo: uid)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => AccountStatement.fromJson(doc.data())).toList());
  }



  Future<double> getOpeningBalance() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    print("Current user UID for balance: $uid");
    if (uid == null) {
      print("No user is logged in.");
      return 0.0;
    }

    print("🔍 Fetching opening balance for UID: $uid");

    final doc = await FirebaseFirestore.instance
        .collection('account_balances')
        .doc(uid)
        .get();

    if (doc.exists) {
      final data = doc.data();
      print("Opening balance doc: $data");

      if (data != null && data.containsKey('openingBalance')) {
        return (data['openingBalance'] as num).toDouble();
      }
    }

    print(" Opening balance not found for user $uid");
    return 0.0;
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Account Statement")),
      body: FutureBuilder<double>(
        future: getOpeningBalance(),
        builder: (context, balanceSnapshot) {
          if (balanceSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final openingBalance = balanceSnapshot.data ?? 0.0;

          return Column(
            children: [
              Card(
                margin: const EdgeInsets.all(12),
                child: ListTile(
                  leading: const Icon(Icons.account_balance_wallet),
                  title: const Text("Opening Balance"),
                  subtitle: Text("\$${openingBalance.toStringAsFixed(2)}"),
                ),
              ),
              Expanded(
                child: StreamBuilder<List<AccountStatement>>(
                  stream: getUserStatements(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text("No transactions found."));
                    }

                    final transactions = snapshot.data!;

                    double totalBuys = 0.0;
                    double totalSells = 0.0;

                    for (final txn in transactions) {
                      final value = txn.stock.price * txn.quantity;
                      if (txn.isBuy) {
                        totalBuys += value;
                      } else {
                        totalSells += value;
                      }
                    }

                    final endingBalance = openingBalance - totalBuys + totalSells;

                    // 🔄 Update Firestore with the new ending balance
                    final uid = FirebaseAuth.instance.currentUser?.uid;
                    if (uid != null) {
                      FirebaseFirestore.instance
                          .collection('account_balances')
                          .doc(uid)
                          .set({
                        'endingBalance': endingBalance,
                      }, SetOptions(merge: true)); // merge so openingBalance isn't overwritten
                    }

                    return Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            itemCount: transactions.length,
                            itemBuilder: (context, index) {
                              final txn = transactions[index];
                              final total = txn.stock.price * txn.quantity;
                              final dateStr = DateFormat('yyyy-MM-dd HH:mm').format(txn.date);

                              return Card(
                                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                child: ListTile(
                                  leading: Icon(
                                    txn.isBuy ? Icons.call_received : Icons.call_made,
                                    color: txn.isBuy ? Colors.green : Colors.red,
                                  ),
                                  title: Text("${txn.stock.company} (${txn.stock.ticker})"),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("${txn.isBuy ? "Bought" : "Sold"} ${txn.quantity} @ \$${txn.stock.price.toStringAsFixed(2)}"),
                                      Text("Total: \$${total.toStringAsFixed(2)}"),
                                      Text("Date: $dateStr"),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        Card(
                          margin: const EdgeInsets.all(12),
                          color: Colors.teal[50],
                          child: ListTile(
                            leading: const Icon(Icons.account_balance),
                            title: const Text("Ending Balance"),
                            subtitle: Text("\$${endingBalance.toStringAsFixed(2)}"),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          );

        },
      ),
    );
  }

}