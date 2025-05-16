import 'package:flutter/material.dart';
import '../../../core/services/eodhd_api_service.dart';
import '../../../models/eodhd_stock_model.dart';

class StockSelectorScreen extends StatefulWidget {
  const StockSelectorScreen({super.key});

  @override
  State<StockSelectorScreen> createState() => _StockSelectorScreenState();
}

class _StockSelectorScreenState extends State<StockSelectorScreen> {
  List<EodhdStock> _stocks = [];
  List<EodhdStock> _filtered = [];
  bool _loading = true;

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadStocks();
    _searchController.addListener(_filter);
  }

  void _loadStocks() async {
    try {
      final stocks = await EodhdApiService.fetchEgyptStocks();
      setState(() {
        _stocks = stocks;
        _filtered = stocks;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error loading stocks: $e")));
    }
  }

  void _filter() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filtered = _stocks.where((s) {
        return s.name.toLowerCase().contains(query) || s.code.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Select a Stock")),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Search by name or code',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filtered.length,
              itemBuilder: (context, index) {
                final stock = _filtered[index];
                return ListTile(
                  title: Text(stock.name),
                  subtitle: Text(stock.code),
                  onTap: () => Navigator.pop(context, stock),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
