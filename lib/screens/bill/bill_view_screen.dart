import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stock_market_app/models/stock_model.dart';

class BillViewScreen extends StatefulWidget {
  final Stock stock;
  final bool isBuy;
  final String customerName;
  final String customerId;

  const BillViewScreen({
    super.key,
    required this.stock,
    required this.isBuy,
    required this.customerName,
    required this.customerId,
  });

  @override
  State<BillViewScreen> createState() => _BillViewScreenState();
}

class _BillViewScreenState extends State<BillViewScreen> {
  @override
  Widget build(BuildContext context) {
    final total = widget.stock.price * widget.stock.volume;
    const brokerFee = 0.005;
    const exchangeFee = 0.002;
    const fraFee = 0.001;
    final totalFees = total * (brokerFee + exchangeFee + fraFee);
    final finalAmount = widget.isBuy ? total + totalFees : total - totalFees;
    final now = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.isBuy ? "Buy" : "Sell"} Bill"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Stock: ${widget.stock.company}",
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),/*Text("Stock: ${widget.stock.company} (${widget.stock.ticker})",
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),*/
            const SizedBox(height: 10),
            const Divider(height: 30),
            Text("Quantity: ${widget.stock.volume}"),
            Text("Price per Share: \$${widget.stock.price.toStringAsFixed(2)}"),
            Text("Base Total: \$${total.toStringAsFixed(2)}"),
            const SizedBox(height: 10),
            Text("Brokerage Fee: \$${(total * brokerFee).toStringAsFixed(2)}"),
            Text("Exchange Fee: \$${(total * exchangeFee).toStringAsFixed(2)}"),
            Text("FRA Fee: \$${(total * fraFee).toStringAsFixed(2)}"),
            const Divider(height: 30),
            Text(
              widget.isBuy
                  ? "Final Amount Paid: \$${finalAmount.toStringAsFixed(2)}"
                  : "Final Amount Received: \$${finalAmount.toStringAsFixed(2)}",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Text("Date: $now", style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
