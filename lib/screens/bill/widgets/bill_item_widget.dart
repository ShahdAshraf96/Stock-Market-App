import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:stock_market_app/models/stock_model.dart';
import '../bill_view_screen.dart';

class BillItemWidget extends StatelessWidget {
  final Stock stock;
  final bool isBuy;
  final String customerName;
  final String customerId;

  const BillItemWidget({
    super.key,
    required this.stock,
    required this.isBuy,
    required this.customerName,
    required this.customerId,
  });

  @override
  Widget build(BuildContext context) {
    final total = stock.price * stock.volume;
    const brokerFee = 0.005;// kol 1000 3la 5
    const exchangeFee = 0.00001;// exchange stock fee
    const fraFee = 0.00001;// finance regular authority fee
    final totalFees = total * (brokerFee + exchangeFee + fraFee);
    final finalAmount = isBuy ? total + totalFees : total - totalFees;
    final now = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("${stock.company} (${stock.ticker})",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text("Customer: $customerName"),
            Text("ID: $customerId"),
            Text("Quantity: ${stock.volume}"),
            Text("Price per Share: \$${stock.price.toStringAsFixed(2)}"),
            Text("Base Total: \$${total.toStringAsFixed(2)}"),
            const SizedBox(height: 8),
            Text("Brokerage Fee: \$${(total * brokerFee).toStringAsFixed(2)}"),
            Text("Exchange Fee: \$${(total * exchangeFee).toStringAsFixed(2)}"),
            Text("FRA Fee: \$${(total * fraFee).toStringAsFixed(2)}"),
            const Divider(height: 20),
            Text(
              isBuy
                  ? "Final Amount Paid: \$${finalAmount.toStringAsFixed(2)}"
                  : "Final Amount Received: \$${finalAmount.toStringAsFixed(2)}",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text("Date: $now", style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BillViewScreen(
                          stock: stock,
                          isBuy: isBuy,
                          customerName: customerName,
                          customerId: customerId,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.receipt),
                  label: const Text("View Bill"),
                ),
                ElevatedButton.icon(
                  onPressed: () => _downloadPdf(context, totalFees, finalAmount),
                  icon: const Icon(Icons.picture_as_pdf),
                  label: const Text("Download PDF"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _downloadPdf(BuildContext context, double fees, double finalAmount) async {
    final pdf = pw.Document();
    final base = stock.price * stock.volume;
    final timestamp = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('SMART BROKERS Inc.', style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 12),
            pw.Text("Customer: $customerName"),
            pw.Text("ID: $customerId"),
            pw.Text("Date: $timestamp"),
            pw.SizedBox(height: 10),
            pw.Text(isBuy ? "📥 BUY BILL" : "📤 SELL BILL", style: pw.TextStyle(fontSize: 16)),
            pw.Text("Stock: ${stock.company} (${stock.ticker})"),
            pw.Text("Quantity: ${stock.volume}"),
            pw.Text("Price per Share: \$${stock.price.toStringAsFixed(2)}"),
            pw.Text("Base Total: \$${base.toStringAsFixed(2)}"),
            pw.Text("Total Fees: \$${fees.toStringAsFixed(2)}"),
            pw.Divider(),
            pw.Text(
              isBuy
                  ? "Final Paid: \$${finalAmount.toStringAsFixed(2)}"
                  : "Final Received: \$${finalAmount.toStringAsFixed(2)}",
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
          ],
        ),
      ),
    );

    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
    Navigator.pop(context); // Go back after download
  }
}
