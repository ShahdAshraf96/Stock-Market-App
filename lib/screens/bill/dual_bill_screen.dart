import 'package:flutter/material.dart';
import 'widgets/bill_item_widget.dart';
import 'package:stock_market_app/models/stock_model.dart';

class DualBillScreen extends StatelessWidget {
  const DualBillScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Example data
    final buyTransactions = [
      Stock(ticker: 'AAPL', company: 'Apple Inc.', price: 172.34, change: 1.2, volume: 100),
      Stock(ticker: 'MSFT', company: 'Microsoft Corp.', price: 310.10, change: -2.3, volume: 70),
    ];

    final sellTransactions = [
      Stock(ticker: 'GOOGL', company: 'Alphabet Inc.', price: 2845.12, change: -1.5, volume: 50),
      Stock(ticker: 'TSLA', company: 'Tesla Inc.', price: 650.25, change: 3.1, volume: 30),
    ];

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
            ListView.builder(
              itemCount: buyTransactions.length,
              itemBuilder: (context, index) => BillItemWidget(
                stock: buyTransactions[index],
                isBuy: true,
                customerName: 'John Doe',
                customerId: 'CUST123',
              ),
            ),
            ListView.builder(
              itemCount: sellTransactions.length,
              itemBuilder: (context, index) => BillItemWidget(
                stock: sellTransactions[index],
                isBuy: false,
                customerName: 'John Doe',
                customerId: 'CUST123',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
