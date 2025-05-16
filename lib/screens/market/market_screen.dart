import 'package:flutter/material.dart';
import 'package:stock_market_app/screens/drawer.dart';
import 'package:stock_market_app/screens/market/services/stock_services.dart';

class StockHomePage extends StatefulWidget {
  const StockHomePage({super.key});

  @override
  State<StockHomePage> createState() => _StockHomePageState();
}

class _StockHomePageState extends State<StockHomePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Future<List<Map<String, String>>> _futureGainers;
  late Future<List<Map<String, String>>> _futureLosers;
  final StockService _stockService = StockService();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _futureGainers = _stockService.fetchTopGainers();
    _futureLosers = _stockService.fetchTopLosers();
  }

  void _refreshData() {
    setState(() {
      _futureGainers = _stockService.fetchTopGainers();
      _futureLosers = _stockService.fetchTopLosers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Stock"),
        centerTitle: true,
        backgroundColor: const Color(0xFF9966CC),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshData,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Wins'),
            Tab(text: 'Losses'),
          ],
          indicatorColor: Colors.cyanAccent,
          labelStyle: const TextStyle(fontSize: 16),
        ),
      ),
      drawer: AppDrawer(),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildStockGrid(_futureGainers, Colors.greenAccent),
          _buildStockGrid(_futureLosers, Colors.redAccent),
        ],
      ),
    );
  }

  Widget _buildStockGrid(Future<List<Map<String, String>>> future, Color color) {
    return FutureBuilder<List<Map<String, String>>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('There are no stocks available.'));
        }

        final stocks = snapshot.data!;
        return GridView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: stocks.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemBuilder: (context, index) {
            final stock = stocks[index];
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
              decoration: BoxDecoration(
                border: Border.all(color: color, width: 1.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    stock["change"]!,
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    stock["symbol"]!,
                    style: const TextStyle(
                      color: Colors.cyanAccent,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    stock["price"]!,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    stock["diff"]!,
                    style: const TextStyle(fontSize: 13),
                  ),
                  Text(
                    stock["vol"]!,
                    style: const TextStyle(fontSize: 10),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
