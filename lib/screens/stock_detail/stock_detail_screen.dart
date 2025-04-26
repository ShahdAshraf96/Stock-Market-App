import 'package:flutter/material.dart';
import 'package:stock_market/models/stock_model.dart';

class StockDetailScreen extends StatelessWidget {
  final Stock stock;

  const StockDetailScreen({super.key, required this.stock});

  @override
  Widget build(BuildContext context) {
    final isPositive = stock.change >= 0;

    return Scaffold(
      appBar: AppBar(
        title: Text(stock.ticker),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(stock.company,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text("Current Price: \$${stock.price.toStringAsFixed(2)}",
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text(
              "Change: ${stock.change.toStringAsFixed(2)}",
              style: TextStyle(
                fontSize: 18,
                color: isPositive ? Colors.green : Colors.red,
              ),
            ),
            const SizedBox(height: 10),
            Text("Volume: ${stock.volume}",
                style: const TextStyle(fontSize: 18)),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                // You can navigate to Buy/Sell screen from here
              },
              style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
              child: const Text("Trade This Stock"),
            )
          ],
        ),
      ),
    );
  }
}
