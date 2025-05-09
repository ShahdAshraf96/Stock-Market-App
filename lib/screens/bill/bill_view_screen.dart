import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
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
            Text("Stock: ${widget.stock.company} (${widget.stock.ticker})", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text("Customer: ${widget.customerName}"),
            Text("ID: ${widget.customerId}"),
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
            const Spacer(),
            ElevatedButton.icon(
              icon: const Icon(Icons.picture_as_pdf),
              label: const Text("Download PDF"),
              onPressed: () => _downloadPdf(context, totalFees, finalAmount, now),
              style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _downloadPdf(BuildContext context, double fees, double finalAmount, String timestamp) async {
    final pdf = pw.Document();
    final base = widget.stock.price * widget.stock.volume;

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('SMART BROKERS Inc.', style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 12),
            pw.Text("Customer: ${widget.customerName}"),
            pw.Text("ID: ${widget.customerId}"),
            pw.Text("Date: $timestamp"),
            pw.SizedBox(height: 10),
            pw.Text(widget.isBuy ? "📥 BUY BILL" : "📤 SELL BILL", style: pw.TextStyle(fontSize: 16)),
            pw.Text("Stock: ${widget.stock.company} (${widget.stock.ticker})"),
            pw.Text("Quantity: ${widget.stock.volume}"),
            pw.Text("Price per Share: \$${widget.stock.price.toStringAsFixed(2)}"),
            pw.Text("Base Total: \$${base.toStringAsFixed(2)}"),
            pw.Text("Total Fees: \$${fees.toStringAsFixed(2)}"),
            pw.Divider(),
            pw.Text(
              widget.isBuy
                  ? "Final Paid: \$${finalAmount.toStringAsFixed(2)}"
                  : "Final Received: \$${finalAmount.toStringAsFixed(2)}",
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
          ],
        ),
      ),
    );

    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
    );

    if (context.mounted) {
      Navigator.pop(context);
    }
  }
}
