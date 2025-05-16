import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stock_market_app/models/stock_model.dart';

class BillItemWidget extends StatelessWidget {
  final Stock stock;
  final bool isBuy;
  final String customerName;
  final String customerId;
  final int quantity;
  final double finalAmount;
  final Map<String, dynamic> fees;
  final DateTime timestamp;

  const BillItemWidget({
    super.key,
    required this.stock,
    required this.isBuy,
    required this.customerName,
    required this.customerId,
    required this.quantity,
    required this.finalAmount,
    required this.fees,
    required this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    final total = stock.price * quantity;
    final broker = (fees['broker'] ?? 0.0) * total;
    final exchange = (fees['exchange'] ?? 0.0) * total;
    final fra = (fees['fra'] ?? 0.0) * total;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("${stock.company}",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text("Quantity: $quantity"),
            Text("Price per Share: \$${stock.price.toStringAsFixed(2)}"),
            Text("Base Total: \$${total.toStringAsFixed(2)}"),
            const SizedBox(height: 8),
            Text("Brokerage Fee: \$${broker.toStringAsFixed(2)}"),
            Text("Exchange Fee: \$${exchange.toStringAsFixed(2)}"),
            Text("FRA Fee: \$${fra.toStringAsFixed(2)}"),
            const Divider(height: 20),
            Text(
              isBuy
                  ? "Final Amount Paid: \$${finalAmount.toStringAsFixed(2)}"
                  : "Final Amount Received: \$${finalAmount.toStringAsFixed(2)}",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text("Date: ${DateFormat.yMd().add_jm().format(timestamp)}",
                style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
