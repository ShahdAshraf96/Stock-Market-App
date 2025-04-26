import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stock_market/models/stock_model.dart';

class Transaction {
  final Stock stock;
  final bool isBuy;
  final int quantity;
  final DateTime date;

  Transaction({
    required this.stock,
    required this.isBuy,
    required this.quantity,
    required this.date,
  });
}

class AccountStatementScreen extends StatelessWidget {
  const AccountStatementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Transaction> transactions = [
      Transaction(
        stock: Stock(ticker: "AAPL", company: "Apple Inc.", price: 172.34, change: 0.5, volume: 0),
        isBuy: true,
        quantity: 10,
        date: DateTime.now().subtract(const Duration(days: 1)),
      ),
      Transaction(
        stock: Stock(ticker: "GOOGL", company: "Alphabet", price: 2800, change: -3.5, volume: 0),
        isBuy: false,
        quantity: 4,
        date: DateTime.now().subtract(const Duration(days: 2)),
      ),
      Transaction(
        stock: Stock(ticker: "TSLA", company: "Tesla", price: 700.50, change: 1.2, volume: 0),
        isBuy: true,
        quantity: 3,
        date: DateTime.now().subtract(const Duration(days: 4)),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Account Statement"),
      ),
      body: ListView.builder(
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
    );
  }
}
